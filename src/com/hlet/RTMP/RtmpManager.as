package com.hlet.RTMP 
{
	import com.hlet.UrlManager;
	
    public class RtmpManager extends Object
    {
		static var RM:RTMPMain;		
		static var isListen:*=false;		
		public static var listenUrlManager:UrlManager;		
		public static var talkUrlManager:UrlManager;		
		public static var listenerServerId:*;		
		public static var listenerServerPort:*;		
		public static var talkServerId:*;		
		public static var talkServerPort:*;
		
        public function RtmpManager()
        {
            super();
            return;
        }

        public static function setReciverSeek(arg1:*):int
        {
            return RM.setReciverSeek(arg1);
        }

        public static function setReciverSeek1(arg1:*):int
        {
            return RM.setReciverSeek1(arg1);
        }

        public static function getReciverTime():Number
        {
            return RM.getReciverTime();
        }

        public static function getTalkBufferLength():Number
        {
            return RM.getTalkBufferLength();
        }

        public static function setTalkSeek(arg1:*):int
        {
            return RM.setTalkSeek(arg1);
        }

        public static function setTalkSeek1(arg1:*):int
        {
            return RM.setTalkSeek1(arg1);
        }

        public static function getTalkTime():Number
        {
            return RM.getTalkTime();
        }

        
        {
            RM = new RTMPMain();
            isListen = false;
        }

        public static function startListen(arg1:String):*
        {
            RM.startListen(arg1);
            return;
        }

        public static function stopListen():*
        {
            if (listenUrlManager != null) 
            {
                listenUrlManager.Stop();
            }
            listenerServerId = -1;
            listenerServerPort = -1;
            RM.stopListen();
            return;
        }

        public static function getListenState():*
        {
            return RM.getListenState();
        }

        public static function getTalkbackState():int
        {
            return RM.getTalkbackState();
        }

        public static function setListenParam(arg1:int):int
        {
            return RM.setListenParam(arg1);
        }

        public static function setTalkParam(arg1:int):int
        {
            return RM.setTalkParam(arg1);
        }

        public static function setTalkMaxParam(arg1:int):int
        {
            return RM.setTalkMaxParam(arg1);
        }

        public static function startTalk(arg1:String, arg2:String):int
        {
            var loc1:*="http" + arg2.substring(4);
            var loc2:*=RM.startTalk(arg2, "");
            if (loc2 == 0) 
            {
                RM.startRecive(loc1);
            }
            return loc2;
        }

        public static function stopTalkback():*
        {
            if (talkUrlManager != null) 
            {
                talkUrlManager.Stop();
            }
            talkServerId = -1;
            (talkServerPort - 1);
            RM.stopTalkback();
            RM.stopRecive();
            return;
        }

        public static function reStartListen():*
        {
            listenUrlManager.getUrl1();
            return;
        }

        public static function reStartTalk():*
        {
            talkUrlManager.getUrl1();
            return;
        }

        public static function getListenBufferLength():Number
        {
            return RM.getListenBufferLength();
        }

        public static function setListenSeek(arg1:*):int
        {
            return RM.setListenSeek(arg1);
        }

        public static function setListenSeek1(arg1:*):int
        {
            return RM.setListenSeek1(arg1);
        }

        public static function getListenTime():Number
        {
            return RM.getListenTime();
        }

        public static function getReciverBufferLength():Number
        {
            return RM.getReciverBufferLength();
        }
    }
}
