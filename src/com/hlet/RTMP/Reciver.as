package com.hlet.RTMP 
{
    import flash.display.Sprite;
    import flash.events.AsyncErrorEvent;
    import flash.events.IOErrorEvent;
    import flash.events.NetStatusEvent;
    import flash.events.SecurityErrorEvent;
    import flash.external.ExternalInterface;
    import flash.media.Video;
    import flash.net.NetConnection;
    import flash.net.NetStream;
    
    public class Reciver extends flash.display.Sprite
    {
        public function Reciver(arg1:String)
        {
            this.netConnect2 = new flash.net.NetConnection();
            this.video = new flash.media.Video();
            super();
            this.url = arg1;
            this.netConnect2.addEventListener(flash.events.NetStatusEvent.NET_STATUS, this.netConnectHandler2);
            this.netConnect2.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            this.netConnect2.addEventListener(flash.events.NetStatusEvent.NET_STATUS, this.nstat);
            this.netConnect2.maxPeerConnections = 100;
            this.netConnect2.connect(null);
            this.receiveStream = new flash.net.NetStream(this.netConnect2);
            this.receiveStream.bufferTime = 10;
            this.receiveStream.addEventListener(flash.events.NetStatusEvent.NET_STATUS, this.nstat);
            this.receiveStream.addEventListener(flash.events.AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
            this.receiveStream.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.mistake);
            this.metaListener = new Object();
            this.metaListener.onMetaData = this.onMetaData;
            this.receiveStream.client = this.metaListener;
            this.receiveStream.play(arg1);
            this.video.attachNetStream(this.receiveStream);
            trace("Listen " + arg1);
            return;
        }

        function onMetaData(arg1:Object):void
        {
            var loc1:*=arg1.duration;
            return;
        }

        function securityErrorHandler(arg1:flash.events.SecurityErrorEvent):void
        {
            this.state = 1;
            this.Play();
            flash.external.ExternalInterface.call("onTtxVideoMsg", "0", "reciveNetError");
            return;
        }

        function netConnectHandler2(arg1:flash.events.NetStatusEvent):void
        {
            var loc1:*=arg1.info.code;
            switch (loc1) 
            {
                case "NetConnection.Connect.Success":
                {
                    flash.external.ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "startRecive");
                    break;
                }
                case "NetConnection.Connect.Closed":
                {
                    flash.external.ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "reciveNetError");
                    break;
                }
            }
            return;
        }

        function netmistake(arg1:flash.events.AsyncErrorEvent):void
        {
            this.state = 1;
            this.Play();
            flash.external.ExternalInterface.call("onTtxVideoMsg", "0", "reciveError");
            return;
        }

        function mistake(arg1:flash.events.IOErrorEvent):void
        {
            this.state = 1;
            this.Play();
            flash.external.ExternalInterface.call("onTtxVideoMsg", "0", "reciveError");
            return;
        }

        function asyncErrorHandler(arg1:flash.events.AsyncErrorEvent):void
        {
            this.Play();
            flash.external.ExternalInterface.call("onTtxVideoMsg", "0", "reciveError");
            return;
        }

        function nstat(arg1:flash.events.NetStatusEvent):void
        {
            trace("reciver " + arg1.info.code);
            var loc1:*=arg1.info.code;
            switch (loc1) 
            {
                case "NetStream.Buffer.Empty":
                {
                    flash.external.ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "loadRecive");
                    this.state = 1;
                    break;
                }
                case "NetStream.Buffer.Full":
                {
                    flash.external.ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "playRecive");
                    this.state = 0;
                    break;
                }
                case "NetStream.Play.Failed":
                {
                    flash.external.ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "reciveFaild");
                    this.Play();
                    this.state = 1;
                    break;
                }
                case "NetStream.Play.StreamNotFound":
                {
                    flash.external.ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "reciveStreamNotFound");
                    this.state = 1;
                    break;
                }
                case "NetStream.Play.Stop":
                {
                    this.Play();
                    this.state = 1;
                    flash.external.ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "reciveStreamStop");
                    break;
                }
                case "NetConnection.Connect.Closed":
                {
                    flash.external.ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "reciveNetError");
                    break;
                }
            }
            return;
        }

        public function setTalkParam(arg1:int):*
        {
            this.receiveStream.bufferTime = arg1;
            return;
        }

        function initRec():*
        {
            var cc:*;
            var onmd:Function;

            var loc1:*;
            onmd = null;
            onmd = function (arg1:Object):void
            {
                return;
            }
            cc = new Object();
            cc.onMetaData = onmd;
            trace(this.flvname);
            this.receiveStream = new flash.net.NetStream(this.netConnect2);
            this.receiveStream.client = cc;
            this.receiveStream.play(this.flvname);
            this.video.attachNetStream(this.receiveStream);
            return;
        }

        public function Stop():*
        {
            this.receiveStream.close();
            this.netConnect2.close();
            this.netConnect2.removeEventListener(flash.events.NetStatusEvent.NET_STATUS, this.netConnectHandler2);
            this.netConnect2.removeEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            this.netConnect2.removeEventListener(flash.events.NetStatusEvent.NET_STATUS, this.nstat);
            this.receiveStream.removeEventListener(flash.events.NetStatusEvent.NET_STATUS, this.nstat);
            this.receiveStream.removeEventListener(flash.events.AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
            this.receiveStream.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, this.mistake);
            this.netConnect2 = null;
            this.receiveStream = null;
            this.video.clear();
            this.video = null;
            return;
        }

        public function Play():*
        {
            RtmpManager.reStartTalk();
            return;
        }

        public function getBufferLength():*
        {
            return this.receiveStream.bufferLength;
        }

        public function Seek(arg1:Number):int
        {
            this.receiveStream.seek(this.receiveStream.time + arg1);
            return 0;
        }

        public function Seek1(arg1:Number):int
        {
            this.receiveStream.seek(arg1);
            return 0;
        }

        public function getTime():Number
        {
            return this.receiveStream.time;
        }

        var netConnect2:flash.net.NetConnection;

        var receiveStream:flash.net.NetStream;

        var video:*;

        var metaListener:Object;

        var videoWidth:int;

        var videoHeight:int;

        var url:String;

        var flvname:String;

        public var state:int=1;
    }
}
