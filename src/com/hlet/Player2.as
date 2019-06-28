package com.hlet
{
	import com.hlet.event.PlayerEvent;
	
	import flash.display.MovieClip;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	[SWF(backgroundColor="#000000")]
	public class Player2 extends flash.display.MovieClip
	{
		public var id:int;
		public var ispaus:Boolean;		
		public var isfull:Boolean;		
		public var iswait:Boolean;		
		public var flvstat:int;		
		public var flvurl:String="";		
		public var param:String="";		
		private var vodBorder:Border;		
		private var vodLogo:Logo;		
		public var Rect:RECT;		
		
		public var videoConnection:flash.net.NetConnection;		
		public var videoStream:flash.net.NetStream;		
		public var video:flash.media.Video;		
		private var metaListener:Object;		
		
		
		
		public function Player2()
		{
			this.video = new flash.media.Video();
			this.videoConnection = new flash.net.NetConnection();
			this.videoConnection.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
			//this.videoConnection.removeEventListener(flash.events.NetStatusEvent.NET_STATUS, arguments.callee);
			this.videoConnection.addEventListener(flash.events.NetStatusEvent.NET_STATUS, this.netStatusHandler);
			
			var x= this.videoConnection.hasEventListener(NetStatusEvent.NET_STATUS);
			var y=this.videoConnection.willTrigger(NetStatusEvent.NET_STATUS);
			
			this.videoConnection.client=this;
			this.videoConnection.connect("rtmp://10.20.129.54:1935/111");
			
			this.videoConnection.maxPeerConnections = 100;

			
			
			this.vodLogo = new Logo();
			//this.vodLogo.x = this.video.x;
			//this.vodLogo.y = this.video.y;
			addChild(this.vodLogo);
			
			this.vodBorder = new Border();
			addChildAt(this.vodBorder, 0);
		}
		
		function mistake(arg1:flash.events.IOErrorEvent):void
		{
//			this.ispaus = true;
//			this.ldinfo.visible = false;
//			this.msg.showMsg("connectError");
			this.Play();
			flash.external.ExternalInterface.call("onVideoMsg", "" + this.id + "", "videoerror");
			return;
		}
		public function onBWDone():void
		{
			trace("onBWDone");
			return;
		}
		function onMetaData(arg1:Object):void
		{
			//video.width = video.videoWidth; 
			//video.height = video.videoHeight; 
			//this._duration = arg1.duration;
			//dispatchEvent(new PlayerEvent("alltime"));
			return;
		}
		private function netStatusHandler(event:NetStatusEvent):void
		{
			trace("event.info.level: " + event.info.level + "\n", "event.info.code: " + event.info.code);
			switch (event.info.code)
			{
				case "NetConnection.Connect.Success":
					//doVideo(nc);
								this.videoStream = new flash.net.NetStream(this.videoConnection);
								this.videoStream.bufferTime = 10;
								this.videoStream.addEventListener(flash.events.NetStatusEvent.NET_STATUS, this.netStatusHandler);
								this.videoStream.addEventListener(flash.events.AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
								this.videoStream.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.mistake);
								this.video.attachNetStream(this.videoStream);
								addChild(this.video);
								this.metaListener = new Object();
								this.metaListener.onMetaData = this.onMetaData;
								this.videoStream.client = this.metaListener;
					break;
				case "NetConnection.Connect.Failed":
					break;
				case "NetConnection.Connect.Rejected":
					break;
				case "NetStream.Play.Stop":
					break;
				case "NetStream.Play.StreamNotFound":
					break;
			}
		}
		function securityErrorHandler(arg1:flash.events.SecurityErrorEvent):void
		{
			trace("SecurityErrorEvent" + arg1);
//			this.ldinfo.visible = false;
//			this.msg.showMsg("connectError");
			this.Play();
			flash.external.ExternalInterface.call("onVideoMsg", "" + this.id + "", "neterror");
			return;
		}
		
		function asyncErrorHandler(arg1:flash.events.AsyncErrorEvent):void
		{
			trace("AsyncErrorEvent" + arg1);
//			this.ldinfo.visible = false;
//			this.msg.showMsg("connectError");
			this.Play();
			flash.external.ExternalInterface.call("onVideoMsg", "" + this.id + "", "neterror");
			return;
		}
		public function Play():void
		{
			this.playFLV("1080");

			return;
			/*
			this.serverIP = "";
			this.serverPort = "";
			this.serverId = -1;
			if (this.urlManager == null) 
			{
			this.playFLV(this.flvurl);
			this.timer.start();
			}
			else 
			{
			this.showLoading();
			this.urlManager.getUrl1();
			this.urlManager.retry = true;
			}
			this.dbClickMC.Hide();
			this.playbtn.visible = false;
			flash.external.ExternalInterface.call("onVideoMsg", "" + this.id + "", "play");
			return;
			*/
		}
		public function playFLV(arg1:String):void
		{
			this.videoStream.play(arg1);
		}
		
		
		public function Paus():void
		{
//			if (this.iswait) 
//			{
//				return;
//			}
//			if (this.ispaus == false) 
//			{
//				this.videoStream.togglePause();
//				this.ispaus = true;
//			}
//			this.playbtn.visible = true;
//			flash.external.ExternalInterface.call("onVideoMsg", "" + this.id + "", "paus");
//			return;
		}
		public function Stop():void
		{
//			if (this.iswait) 
//			{
//				return;
//			}
//			this.hideLoading();
//			if (this.urlManager != null) 
//			{
//				this.urlManager.Stop();
//			}
//			this.serverId = -1;
//			this.serverPort = "";
//			this.videoStream.close();
//			this._duration = 0;
//			this.dbClickMC.Show();
//			this.playbtn.visible = true;
//			this.iswait = true;
//			this.ispaus = true;
//			if (this.isfull) 
//			{
//				this.vodBorder.stat = Border.waitfull;
//			}
//			this.vodBorder.updateBG();
//			this.timer.stop();
//			this.CtrlPan.showInfo();
//			this.removeEventListener(flash.events.Event.ENTER_FRAME, this.refreshBuffer);
//			this.ldinfo.visible = false;
//			this.msg.showMsg("");
//			this.msg.visible = false;
//			this.disvol();
//			this.CtrlPan.btnSound.disable();
//			this.CtrlPan.btnPlay.onStop();
//			this.CtrlPan.btnPlay.enable();
//			this.CtrlPan.btnCap.disable();
//			//this.CtrlPan.btncamer.disable();
//			flash.external.ExternalInterface.call("onVideoMsg", "" + this.id + "", "stop");
			return;
		}
		public function setRect(arg1:RECT):void
		{
//			this.video.x = arg1.rx;
//			this.video.y = arg1.ry;
//			this.video.width = arg1.rw;
//			this.video.height = arg1.rh;
//			this.Rect = arg1;
//			this.vodBorder.setRect(this.Rect);
//			this.ldinfo.setRect(this.Rect);
//			this.ldinfo.visible = false;
//			this.msg.setRect(this.Rect);
//			this.msg.visible = true;
//			if (this.iswait) 
//			{
//				this.msg.showMsg("waiting");
//			}
//			this.CtrlPan.setRect(this.Rect);
//			this.CtrlPan.reSize();
//			this.vodLogo.setRect(this.Rect);
//			this.vodLogo.reSize();
//			this.playbtn.setRect(this.Rect);
//			this.playbtn.reSize();
//			this.dbClickMC.setRect(this.Rect);
//			this.dbClickMC.reSize();
			return;
		}
		
		public function updatePic(arg1:Config):void
		{
			//this.vodLogo.updatePic(arg1);
			//this.vodBorder.updatePic(arg1);
			return;
		}
		
		public function gotoPos(arg1:Number):void
		{

		}
		
		public function showBorder():void
		{
//			if (!this.isfull) 
//			{
//				if (this.iswait) 
//				{
//					this.vodBorder.stat = Border.waitsel;
//				}
//				else 
//				{
//					this.vodBorder.stat = Border.sel;
//				}
//				this.vodBorder.updateBG();
//			}
			return;
		}
		
		public function hideBorder():void
		{
//			if (this.iswait) 
//			{
//				this.vodBorder.stat = Border.wait;
//			}
//			else 
//			{
//				this.vodBorder.stat = Border.norm;
//			}
//			this.vodBorder.updateBG();
			return;
		}
		
		public function setVolume(arg1:Number):void
		{
//			this.vol = arg1;
//			var loc1:*=new flash.media.SoundTransform();
//			loc1.volume = this.vol;
//			this.videoStream.soundTransform = loc1;
			return;
		}
		
		public function disvol():void
		{
//			this.vol1 = this.vol;
//			this.vol = 0;
//			var loc1:*=new flash.media.SoundTransform();
//			loc1.volume = this.vol;
//			this.videoStream.soundTransform = loc1;
//			this.isvol = false;
//			this.CtrlPan.btnSound.silent();
//			flash.external.ExternalInterface.call("onVideoMsg", "" + this.id + "", "silent");
			return;
		}
		
		public function ablevol():void
		{
//			var loc2:*;
//			this.vol1 = loc2 = 1;
//			this.vol = loc2;
//			var loc1:*=new flash.media.SoundTransform();
//			loc1.volume = this.vol;
//			this.videoStream.soundTransform = loc1;
//			this.isvol = true;
//			this.CtrlPan.btnSound.sound();
//			flash.external.ExternalInterface.call("onVideoMsg", "" + this.id + "", "sound");
			return;
		}
		
	}
}