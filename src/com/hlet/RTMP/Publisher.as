package com.hlet.RTMP 
{
    import flash.display.Sprite;
    import flash.events.AsyncErrorEvent;
    import flash.events.IOErrorEvent;
    import flash.events.NetStatusEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.StatusEvent;
    import flash.external.ExternalInterface;
    import flash.media.Camera;
    import flash.media.Microphone;
    import flash.media.Video;
    import flash.net.NetConnection;
    import flash.net.NetStream;
    import flash.net.ObjectEncoding;
    
    public class Publisher extends flash.display.Sprite
    {
        public function Publisher(arg1:String, arg2:String, arg3:*=320, arg4:*=240)
        {
            super();
            this.server = arg1;
            this.flvname = arg2;
            this.videoWidth = arg3;
            this.videoHeight = arg4;
            trace("publish " + arg1);
            return;
        }

        function mistake(arg1:flash.events.IOErrorEvent):void
        {
            this.state = 1;
            this.Play();
            flash.external.ExternalInterface.call("onVideoMsg", "0", "uploadError");
            return;
        }

        function netConnectHandler2(arg1:flash.events.NetStatusEvent):void
        {
            var loc1:*=arg1.info.code;
            switch (loc1) 
            {
                case "NetConnection.Connect.Success":
                {
                    flash.external.ExternalInterface.call("onVideoMsg", "" + 0 + "", "uploadRecive");
                    break;
                }
                case "NetConnection.Connect.Closed":
                {
                    flash.external.ExternalInterface.call("onVideoMsg", "" + 0 + "", "uploadNetError");
                    break;
                }
            }
            return;
        }

        function netStatus(arg1:flash.events.NetStatusEvent):void
        {
            trace("publish " + arg1.info.code);
            var loc1:*=arg1.info.code;
            switch (loc1) 
            {
                case "NetConnection.Connect.Success":
                {
                    this.publish();
                    this.state = 0;
                    break;
                }
                case "NetStream.Buffer.Empty":
                {
                    flash.external.ExternalInterface.call("onVideoMsg", "" + 0 + "", "upload");
                    this.state = 0;
                    break;
                }
                case "NetStream.Buffer.Full":
                {
                    flash.external.ExternalInterface.call("onVideoMsg", "" + 0 + "", "uploadfull");
                    this.state = 1;
                    break;
                }
                case "NetStream.Play.Failed":
                {
                    flash.external.ExternalInterface.call("onVideoMsg", "" + 0 + "", "uploadFaild");
                    this.Play();
                    this.state = 1;
                    break;
                }
                case "NetStream.Play.Stop":
                {
                    this.Play();
                    this.state = 1;
                    flash.external.ExternalInterface.call("onVideoMsg", "" + 0 + "", "uploadFaild");
                    break;
                }
                case "NetConnection.Connect.Closed":
                case "NetConnection.Connect.Failed":
                {
                    this.Play();
                    this.state = 1;
                    flash.external.ExternalInterface.call("onVideoMsg", "" + 0 + "", "uploadNetClosed");
                    break;
                }
                case "NetStream.Play.StreamNotFound":
                {
                    RtmpManager.stopTalkback();
                    flash.external.ExternalInterface.call("onVideoMsg", "" + 0 + "", "uploadBusy");
                    break;
                }
            }
            return;
        }

        function Play():*
        {
            this.Stop();
            this.initConn();
            trace("upload retry");
            return;
        }

        function onResult(arg1:Object):void
        {
            return;
        }

        public function Stop():*
        {
            if (this._video != null) 
            {
                this._video.clear();
                this._video = null;
            }
            if (this._nc != null) 
            {
                this._nc.removeEventListener(flash.events.NetStatusEvent.NET_STATUS, this.netStatus);
                this._nc.removeEventListener(flash.events.AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
                this._nc.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, this.mistake);
                this._nc.close();
            }
            if (this._ns != null) 
            {
                this._ns.close();
                this._ns.removeEventListener(flash.events.NetStatusEvent.NET_STATUS, this.netStatus);
                this._ns.removeEventListener(flash.events.AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
                this._ns.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, this.mistake);
            }
            this._nc = null;
            this._ns = null;
            if (this._mic != null) 
            {
                this._mic.removeEventListener(flash.events.StatusEvent.STATUS, this.onMicStatus);
                this._mic = null;
            }
            if (this._cam != null) 
            {
                this._cam = null;
            }
            return;
        }

        function getInfor(arg1:Object):void
        {
            trace("Server returning Infor: " + arg1);
            return;
        }

        function onState(arg1:Object):void
        {
            trace("Connection result error: " + arg1);
            this.state = 1;
            return;
        }

        public function setTalkParam(arg1:int):*
        {
            this.buffer = arg1;
            if (this._ns != null) 
            {
                this._ns.bufferTime = arg1;
            }
            return;
        }

        public function setTalkMaxParam(arg1:int):*
        {
            this.bufferMax = arg1;
            if (this._ns != null) 
            {
                this._ns.bufferTimeMax = arg1;
            }
            return;
        }

        public function getBufferLength():*
        {
            return this._ns.bufferLength;
        }

        public function Seek(arg1:Number):int
        {
            this._ns.seek(this._ns.time + arg1);
            return 0;
        }

        public function Seek1(arg1:Number):int
        {
            this._ns.seek(arg1);
            return 0;
        }

        public function getTime():Number
        {
            return this._ns.time;
        }

        public function checkMic():int
        {
            var loc1:*;
            try 
            {
                this._mic = flash.media.Microphone.getEnhancedMicrophone();
                if (this._mic == null) 
                {
                    trace(" Enhanced  mic faild");
                    this._mic = flash.media.Microphone.getMicrophone();
                }
                if (this._mic == null) 
                {
                    trace(" all mic faild");
                    this.Stop();
                    return 1;
                }
                if (this._mic.muted) 
                {
                    flash.external.ExternalInterface.call("onVideoMsg", "" + 0 + "", "micDenied");
                    this.Stop();
                    return 2;
                }
                this._mic.setLoopBack(false);
                this._mic.setSilenceLevel(0);
                this._mic.enableVAD = true;
                this._mic.addEventListener(flash.events.StatusEvent.STATUS, this.onMicStatus);
                this._video = new flash.media.Video();
                this.createChildren();
                this.initConn();
                return 0;
            }
            catch (E:*)
            {
                return 1;
            }
            return 0;
        }

        function onMicStatus(arg1:flash.events.StatusEvent):void
        {
            if (arg1.code != "Microphone.Unmuted") 
            {
                if (arg1.code == "Microphone.Muted") 
                {
                    RtmpManager.stopTalkback();
                    flash.external.ExternalInterface.call("onVideoMsg", "" + 0 + "", "micDenied");
                }
            }
            return;
        }

        public function onBWCheck(arg1:*):void
        {
            return;
        }

        public function onBWDone(arg1:*):void
        {
            return;
        }

        function createChildren():void
        {
            if (this.showVideo) 
            {
                this._cam = flash.media.Camera.getCamera();
                if (this._cam != null) 
                {
                    this._cam.setQuality(144000, 85);
                    this._cam.setMode(this.videoWidth, this.videoHeight, 15);
                    this._cam.setKeyFrameInterval(60);
                    this._video.attachCamera(this._cam);
                    addChild(this._video);
                }
            }
            if (this.showAudio) 
            {
                if (this._mic == null) 
                {
                    flash.external.ExternalInterface.call("onVideoMsg", "" + 0 + "", "noMIC");
                    RtmpManager.stopTalkback();
                }
                else 
                {
                    this._mic.setSilenceLevel(0, -1);
                    this._mic.gain = 80;
                    this._mic.setLoopBack(false);
                }
            }
            return;
        }

        function initConn():void
        {
            this._nc = new flash.net.NetConnection();
            this._nc.addEventListener(flash.events.NetStatusEvent.NET_STATUS, this.netConnectHandler2);
            this._nc.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            this._nc.objectEncoding = flash.net.ObjectEncoding.AMF3;
            this._nc.client = this;
            this._nc.addEventListener(flash.events.NetStatusEvent.NET_STATUS, this.netStatus);
            this._nc.connect(this.server, true);
            return;
        }

        function publish():void
        {
            this._ns = new flash.net.NetStream(this._nc);
            this._ns.addEventListener(flash.events.AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
            this._ns.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.mistake);
            this._ns.bufferTimeMax = 0.1;
            this._ns.bufferTime = this.buffer;
            this._ns.addEventListener(flash.events.NetStatusEvent.NET_STATUS, this.netStatus);
            if (this.showVideo) 
            {
                this._ns.attachCamera(this._cam);
            }
            if (this.showAudio) 
            {
                this._ns.attachAudio(this._mic);
            }
            this._ns.publish(this.flvname, "live");
            return;
        }

        function securityErrorHandler(arg1:flash.events.SecurityErrorEvent):void
        {
            this.state = 1;
            this.Play();
            flash.external.ExternalInterface.call("onVideoMsg", "0", "uploadNetError");
            return;
        }

        function asyncErrorHandler(arg1:flash.events.AsyncErrorEvent):void
        {
            this.Play();
            flash.external.ExternalInterface.call("onVideoMsg", "0", "uploadError");
            return;
        }

        var _video:flash.media.Video;

        var _cam:flash.media.Camera;

        var _mic:flash.media.Microphone;

        var _nc:flash.net.NetConnection;

        var _ns:flash.net.NetStream;

        var videoWidth:int;

        var videoHeight:int;

        var server:String;

        var flvname:String;

        var showVideo:Boolean=false;

        var showAudio:Boolean=true;

        public var state:int=1;

        var buffer:*=1;

        var bufferMax:*=1;
    }
}
