package com.hlet.RTMP 
{
    import flash.display.Sprite;
    
    public class RTMPMain extends flash.display.Sprite
    {
        public function RTMPMain()
        {
            super();
            return;
        }

        public function setListenParam(arg1:int):int
        {
            this.bufferListen = arg1;
            if (this.listener != null) 
            {
                this.listener.setListenParam(arg1);
            }
            return 0;
        }

        public function setTalkParam(arg1:int):int
        {
            this.bufferTalk = arg1;
            if (this.publisher != null) 
            {
                this.publisher.setTalkParam(arg1);
                this.reciver.setTalkParam(arg1);
            }
            return 0;
        }

        public function setTalkMaxParam(arg1:int):int
        {
            this.bufferTalkMax = arg1;
            if (this.publisher != null) 
            {
                this.publisher.setTalkMaxParam(arg1);
            }
            return 0;
        }

        public function getListenState():*
        {
            if (this.listener == null) 
            {
                return 2;
            }
            return this.listener.state;
        }

        public function getTalkbackState():int
        {
            if (this.publisher == null) 
            {
                return 2;
            }
            var loc1:*=this.reciver.state;
            var loc2:*=this.publisher.state;
            var loc3:*=100 + loc1 * 10 + loc2;
            return loc3;
        }

        public function startListen(arg1:String, arg2:*="", arg3:*=320, arg4:*=240):*
        {
            if (this.listener != null) 
            {
                this.listener.Stop();
                this.listener = null;
            }
            this.listener = new Listener(arg1);
            this.listener.setListenParam(this.bufferListen);
            return;
        }

        public function startRecive(arg1:String, arg2:*="", arg3:*=320, arg4:*=240):*
        {
            if (this.reciver != null) 
            {
                this.reciver.Stop();
                this.reciver = null;
            }
            this.reciver = new Reciver(arg1);
            this.reciver.setTalkParam(this.bufferTalk);
            return;
        }

        public function stopListen():*
        {
            if (this.listener == null) 
            {
                return;
            }
            this.listener.Stop();
            this.listener = null;
            return;
        }

        public function stopRecive():*
        {
            if (this.reciver == null) 
            {
                return;
            }
            this.reciver.Stop();
            this.reciver = null;
            return;
        }

        public function stopTalkback():*
        {
            if (this.publisher == null) 
            {
                return;
            }
            this.publisher.Stop();
            this.publisher = null;
            return;
        }

        function startTalk(arg1:String, arg2:*=""):int
        {
            if (this.publisher != null) 
            {
                return 1;
            }
            this.publisher = new Publisher(arg1, arg2);
            var loc1:*=this.publisher.checkMic();
            if (loc1 == 1) 
            {
                this.publisher = null;
                return 2;
            }
            if (loc1 == 2) 
            {
                trace("mic denied");
                this.publisher = null;
                return 3;
            }
            this.publisher.setTalkParam(this.bufferTalk);
            return 0;
        }

        public function getListenBufferLength():Number
        {
            if (this.listener == null) 
            {
                return -1;
            }
            return this.listener.getBufferLength();
        }

        public function setListenSeek(arg1:*):int
        {
            if (this.listener == null) 
            {
                return 1;
            }
            return this.listener.Seek(arg1);
        }

        public function setListenSeek1(arg1:*):int
        {
            if (this.listener == null) 
            {
                return 1;
            }
            return this.listener.Seek1(arg1);
        }

        public function getListenTime():Number
        {
            if (this.listener == null) 
            {
                return -1;
            }
            return this.listener.getTime();
        }

        public function getReciverBufferLength():Number
        {
            if (this.reciver == null) 
            {
                return -1;
            }
            return this.reciver.getBufferLength();
        }

        public function setReciverSeek(arg1:*):int
        {
            if (this.reciver == null) 
            {
                return 1;
            }
            return this.reciver.Seek(arg1);
        }

        public function setReciverSeek1(arg1:*):int
        {
            if (this.reciver == null) 
            {
                return 1;
            }
            return this.reciver.Seek1(arg1);
        }

        public function getReciverTime():Number
        {
            if (this.reciver == null) 
            {
                return -1;
            }
            return this.reciver.getTime();
        }

        public function getTalkBufferLength():Number
        {
            if (this.publisher == null) 
            {
                return -1;
            }
            return this.publisher.getBufferLength();
        }

        public function setTalkSeek(arg1:*):int
        {
            if (this.publisher == null) 
            {
                return 1;
            }
            return this.publisher.Seek(arg1);
        }

        public function setTalkSeek1(arg1:*):int
        {
            if (this.publisher == null) 
            {
                return 1;
            }
            return this.publisher.Seek1(arg1);
        }

        public function getTalkTime():Number
        {
            if (this.publisher == null) 
            {
                return -1;
            }
            return this.publisher.getTime();
        }

        var publisher:Publisher;

        var listener:Listener;

        var reciver:Reciver;

        var bufferListen:*=10;

        var bufferTalk:*=1;

        var bufferTalkMax:*=1;
    }
}
