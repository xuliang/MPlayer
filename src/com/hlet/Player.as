package com.hlet
{
	import com.adobe.images.PNGEncoder;
	import com.hlet.btn.VideoButton;
	import com.hlet.event.PlayEvent;
	import com.hlet.event.PlayerEvent;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Matrix;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.FileReference;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	[SWF(backgroundColor="#000000")]
	public class Player extends flash.display.MovieClip
	{		
		public var videoConnection:flash.net.NetConnection;		
		public var videoStream:flash.net.NetStream;		
		public var video:flash.media.Video;		
		private var metaListener:Object;		
		public var flvurl:String="";		
		public var Rect:RECT;		
		public var _duration:Number;		
		public var vol:Number;		
		public var vol1:Number;		
		public var ispaus:Boolean;		
		public var isfull:Boolean;		
		public var iswait:Boolean;		
		public var id:int;		
		public var playbtn:com.hlet.btn.VideoButton;		
		public var backStat:Boolean;		
		private var oldBytes:*=0;		
		private var vodBorder:Border;		
		private var ldinfo:Loading;		
		private var vodLogo:Logo;		
		private var msg:Info;		
		public var param:String="";		
		public var flvstat:int;		
		public var CtrlPan:VideoCtrl;		
		public var WH:*="full";		
		private var timer:flash.utils.Timer;		
		private var dbClickMC:ClickMC;		
		public var serverIP:String="";		
		public var serverPort:String="";		
		public var serverApp:String="";		
		public var serverId:int=-1;		
		public var Menu:Array;		
		public var urlParm:UrlParm;		
		public var urlManager:UrlManager;		
		public var isvol:Boolean;
		public var streamType:String="";
		private var bufferTime:Number;
		private var bufferTimeMax:Number;
		public var stopTime:Number=3;//*60*1000;//默认值3分钟
		private var stopNumber:Number=0;//临时计数器
		private var stopDisplayNumber=0;//自动停止按钮倒计时显示计数
		//private var stopTimer:flash.utils.Timer;//自动停止计时器
		private var stopTimeButton:TextField = new TextField();
		public function Player()
		{
			this.timer = new flash.utils.Timer(500);
			this.urlParm = new UrlParm();
			super();
			this.doubleClickEnabled = true;
			this.Menu = new Array();
			this.video = new flash.media.Video();
			addChild(this.video);
			//initConn();
			
			
			this.isvol = true;
			this.ispaus = true;
			this.isfull = false;
			this.iswait = true;
			var loc1:*;
			this.vol = loc1 = 1;
			this.vol1 = loc1;
			this.flvstat = 0;
			this._duration = 0;
			this.ldinfo = new Loading();
			this.vodLogo = new Logo();
			this.vodLogo.x = this.video.x;
			this.vodLogo.y = this.video.y;
			addChild(this.vodLogo);
			addChild(this.ldinfo);
			this.CtrlPan = new VideoCtrl();
			this.CtrlPan.addEventListener(PlayEvent.PLAY, this.onPlay);
			this.CtrlPan.addEventListener(PlayEvent.STOP, this.onStop);
			this.CtrlPan.addEventListener(PlayEvent.FULL, this.onFull);
			this.CtrlPan.addEventListener(PlayEvent.NORM, this.onNorm);
			this.CtrlPan.addEventListener(PlayEvent.SOUND, this.onSound);
			this.CtrlPan.addEventListener(PlayEvent.SILENT, this.onSilent);
			this.CtrlPan.addEventListener(PlayEvent.CAPTURE, this.onCapture);
			this.CtrlPan.addEventListener(PlayEvent.ONTALK, this.onTalk);
			this.CtrlPan.addEventListener(PlayEvent.OFFTALK, this.onTalk);
			this.CtrlPan.addEventListener(PlayEvent.ONCAMER, this.onCamer);
			this.CtrlPan.addEventListener(PlayEvent.OFFCAMER, this.onCamer);
			this.vodBorder = new Border();
			addChildAt(this.vodBorder, 0);
			this.msg = new Info();
			addChild(this.msg);
			this.timer.addEventListener(flash.events.TimerEvent.TIMER, this.onTimer);
			this.dbClickMC = new ClickMC();
			this.dbClickMC.visible = true;
			this.dbClickMC.addEventListener(flash.events.MouseEvent.DOUBLE_CLICK, this.dbclick);
			this.dbClickMC.addEventListener(flash.events.MouseEvent.CLICK, this.fclick);
			this.dbClickMC.addEventListener(flash.events.MouseEvent.RIGHT_CLICK, this.frightclick);
			addChild(this.dbClickMC);
			this.playbtn = new VideoButton();
			this.playbtn.addEventListener(PlayEvent.PLAY, this.onPlay);
			addChild(this.playbtn);
			addChild(this.CtrlPan);

			this.stopTimeButton.text="点击这里继续观看\n      (10s将关闭)";
			this.stopTimeButton.border=true;
			this.stopTimeButton.background=true;
			this.stopTimeButton.backgroundColor=0xBEBEBE;
			this.stopTimeButton.selectable=false;
			this.stopTimeButton.height=50;
			this.stopTimeButton.width=150;
			this.stopTimeButton.autoSize=flash.text.TextFieldAutoSize.CENTER ;
			this.stopTimeButton.visible=false;
			this.stopTimeButton.addEventListener(flash.events.MouseEvent.CLICK, this.stopTimeButtonClick);		
			addChild(this.stopTimeButton);
		}
		public function onBWDone():void
		{
			trace("onBWDone");
			return;
		}
		private function initConn():void
		{
//			flash.external.ExternalInterface.call("getFlashError",this.id+"-"+this.serverIP+"-"+this.serverPort+"-"+this.serverApp);
			if(this.videoConnection==null)
			{
			this.videoConnection = new flash.net.NetConnection();
			}
			this.videoConnection.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
			this.videoConnection.addEventListener(flash.events.NetStatusEvent.NET_STATUS, this.netStatusHandler);
			this.videoConnection.client=this;
			this.videoConnection.maxPeerConnections = 100;
			this.videoConnection.connect("rtmp://"+this.serverIP+":"+this.serverPort+"/"+this.serverApp);
		}
		public function playRTMP(channel:String,streamType:String):void
		{
//			flash.external.ExternalInterface.call("getFlashError", this.id+"-2");
//			flash.external.ExternalInterface.call("getFlashError",this.id+"-"+streamType+"-"+channel+"-"+this.serverIP+"-"+this.serverPort+"-"+this.serverApp);
			this.streamType=streamType;
			this.flvurl = channel;
			this.Play();
			//initConn();
		}

		function refreshBuffer(arg1:flash.events.Event):void
		{
			var loc1:*=Math.round(100 * this.videoStream.bufferLength / this.videoStream.bufferTime);
			if (loc1 > 100) 
			{
				loc1 = 100;
			}
			this.ldinfo.ldinfo.text = loc1 + "%";
			if (this.ispaus) 
			{
				this.ldinfo.visible = false;
			}
			return;
		}
		
		function securityErrorHandler(arg1:flash.events.SecurityErrorEvent):void
		{
			trace("SecurityErrorEvent" + arg1);
			this.ldinfo.visible = false;
			this.msg.showMsg("connectError");
			this.Play();
			flash.external.ExternalInterface.call("onVideoMsg", "" + this.id + "", "neterror");
			return;
		}
		
		function asyncErrorHandler(arg1:flash.events.AsyncErrorEvent):void
		{
			trace("AsyncErrorEvent" + arg1);
			this.ldinfo.visible = false;
			this.msg.showMsg("connectError");
			this.Play();
			flash.external.ExternalInterface.call("onVideoMsg", "" + this.id + "", "neterror");
			return;
		}
		
		public function showLoading():*
		{
			this.iswait = false;
			this.vodBorder.updateBG();
			this.CtrlPan.btnPlay.onPlay();
			this.CtrlPan.enable();
			return;
		}
		
		public function hideLoading():*
		{
			this.ldinfo.visible = false;
			this.playbtn.visible = true;
			this.CtrlPan.btnPlay.onPlay();
			return;
		}
		
		function netStatusHandler(arg1:flash.events.NetStatusEvent):void
		{
			
			//trace("nstat-Width:"+this.video.width+",Height:"+this.video.height+",Video Width:"+this.video.videoWidth+",Video Height:"+this.video.videoHeight);
			//trace("playVideo " + arg1.info.code);
			trace(new Date().toString()+"\t2Player ID:"+this.id+", event.info.level: " + arg1.info.level + "\n", "event.info.code: " + arg1.info.code);
//			if (this.iswait) 
//			{
//				return;
//			}
			var loc1:*=arg1.info.code;
			switch (loc1) 
			{
				case "NetConnection.Connect.Success":
//					flash.external.ExternalInterface.call("getFlashError", this.id+"-3");
					//doVideo(nc);
					this.videoStream = new flash.net.NetStream(this.videoConnection);
					this.videoStream.bufferTime = this.bufferTime;
					this.videoStream.bufferTimeMax = this.bufferTimeMax;
					this.videoStream.addEventListener(flash.events.NetStatusEvent.NET_STATUS, this.netStatusHandler);
					this.videoStream.addEventListener(flash.events.AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
					this.videoStream.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.mistake);
					this.video.attachNetStream(this.videoStream);
					//addChild(this.video);
					this.metaListener = new Object();
					this.metaListener.onMetaData = this.onMetaData;
					this.videoStream.client = this.metaListener;
					//this.Play();
					this.playFLV(this.flvurl);
					break;
				case "NetStream.Buffer.Empty":
				{
					this.addEventListener(flash.events.Event.ENTER_FRAME, this.refreshBuffer);
					break;
				}
				case "NetStream.Buffer.Full":
				{
					this.removeEventListener(flash.events.Event.ENTER_FRAME, this.refreshBuffer);
					this.ldinfo.visible = false;
					break;
				}
				//case "NetConnection.Connect.Closed":
				//case "NetStream.Video.DimensionChange":
				case "NetStream.Play.Failed":
				case "NetStream.Play.StreamNotFound":
				{
					this.Play();
//					initConn();
//					this.ispaus = true;
//					this.ldinfo.visible = false;
//					this.msg.showMsg("connectError");
//					this.Play();
					trace("retry");
					break;
				}
				case "NetStream.Play.Stop":
				{
					this.Stop();
					break;
				}
			}
			return;
		}
		
		function netmistake(arg1:flash.events.AsyncErrorEvent):void
		{
			this.ispaus = true;
			this.ldinfo.visible = false;
			this.msg.showMsg("connectError");
			this.Play();
			flash.external.ExternalInterface.call("onVideoMsg", "" + this.id + "", "videoerror");
			return;
		}
		
		function mistake(arg1:flash.events.IOErrorEvent):void
		{
			this.ispaus = true;
			this.ldinfo.visible = false;
			this.msg.showMsg("connectError");
			this.Play();
			flash.external.ExternalInterface.call("onVideoMsg", "" + this.id + "", "videoerror");
			return;
		}
		
		function dbclick(arg1:flash.events.MouseEvent):void
		{
			trace("dbclick");
			dispatchEvent(new PlayerEvent("pdoubleclick"));
			return;
		}
		private function stopTimeButtonClick(arg1:flash.events.MouseEvent):void
		{
			this.stopNumber=0;
			this.stopTimeButton.visible=false;
			this.stopDisplayNumber=0;
		}
		private function fclick(arg1:flash.events.MouseEvent):void
		{
			trace("fclick");
			if (this.isfull) 
			{
				return;
			}
			//trace("click player");
			dispatchEvent(new PlayerEvent("pclick"));
			return;
		}
		private function frightclick(arg1:flash.events.MouseEvent):void
		{
			trace("frightclick");
			if (this.isfull) 
			{
				return;
			}
			//trace("click player");
			dispatchEvent(new PlayerEvent("prightclick"));
			return;
		}
		public function setVideoTbarBgColor(arg1:String):void
		{
			this.CtrlPan.setColor(arg1);
			return;
		}
		
		function onMetaData(arg1:Object):void
		{
			//video.width = video.videoWidth; 
			//video.height = video.videoHeight; 
			this._duration = arg1.duration;
			dispatchEvent(new PlayerEvent("alltime"));
			return;
		}
		
		public function reSize():void
		{
			var loc1:*=undefined;
			var loc2:*=undefined;
			var loc3:*=undefined;
			if (this.isfull) 
			{
				this.setFull();
			}
			else 
			{
				if (this.WH != "full") 
				{
					loc1 = this.WH.split(":");
					loc2 = int(loc1[0]);
					loc3 = int(loc1[1]);
					if (this.Rect.rw / (this.Rect.rh - 30) >= loc2 / loc3) 
					{
						this.video.height = this.Rect.rh - 30;
						this.video.width = loc2 * this.video.height / loc3;
						this.video.x = this.Rect.rx + (this.Rect.rw - this.video.width) / 2;
						this.video.y = this.Rect.ry + (this.Rect.rh - this.video.height - 30) / 2;
					}
					else 
					{
						this.video.width = this.Rect.rw;
						this.video.height = loc3 * this.video.width / loc2;
						this.video.x = this.Rect.rx + (this.Rect.rw - this.video.width) / 2;
						this.video.y = this.Rect.ry + (this.Rect.rh - this.video.height - 30) / 2;
					}
				}
				else 
				{
					this.video.x = this.Rect.rx;
					this.video.y = this.Rect.ry;
					this.video.width = this.Rect.rw;
					this.video.height = this.Rect.rh - 30;
				}
				this.vodBorder.rsSize();
				this.msg.isfull = false;
				this.msg.reSize();
				this.CtrlPan.isFull = false;
				this.CtrlPan.reSize();
				this.vodLogo.isFull = false;
				this.vodLogo.reSize();
				this.ldinfo.isfull = false;
				this.ldinfo.reSize();
				this.playbtn.isFull = false;
				this.playbtn.setRect(this.Rect);
				this.playbtn.reSize();
				this.dbClickMC.isFull = false;
				this.dbClickMC.reSize();
			}
			return;
		}
		
		public function setRect(arg1:RECT):void
		{
			this.video.x = arg1.rx;
			this.video.y = arg1.ry;
			this.video.width = arg1.rw;
			this.video.height = arg1.rh;
			this.Rect = arg1;
			this.vodBorder.setRect(this.Rect);
			this.ldinfo.setRect(this.Rect);
			this.ldinfo.visible = false;
			this.msg.setRect(this.Rect);
			this.msg.visible = true;
			if (this.iswait) 
			{
				this.msg.showMsg("waiting");
			}
			this.CtrlPan.setRect(this.Rect);
			this.CtrlPan.reSize();
			this.vodLogo.setRect(this.Rect);
			this.vodLogo.reSize();
			this.playbtn.setRect(this.Rect);
			this.playbtn.reSize();
			this.dbClickMC.setRect(this.Rect);
			this.dbClickMC.reSize();
			return;
		}
		
		public function setLogoTxt(arg1:String, arg2:Number, arg3:int, arg4:int, arg5:int):void
		{
			this.vodLogo.setTxt(arg1, arg2, arg3, arg4, arg5);
			return;
		}
		
		public function showBorder():void
		{
			if (!this.isfull) 
			{
				if (this.iswait) 
				{
					this.vodBorder.stat = Border.waitsel;
				}
				else 
				{
					this.vodBorder.stat = Border.sel;
				}
				this.vodBorder.updateBG();
			}
			return;
		}
		
		public function hideBorder():void
		{
			if (this.iswait) 
			{
				this.vodBorder.stat = Border.wait;
			}
			else 
			{
				this.vodBorder.stat = Border.norm;
			}
			this.vodBorder.updateBG();
			return;
		}
		
		public function setVolume(arg1:Number):void
		{
			this.vol = arg1;
			var loc1:*=new flash.media.SoundTransform();
			loc1.volume = this.vol;
			this.videoStream.soundTransform = loc1;
			return;
		}
		
		public function disvol():void
		{
			this.vol1 = this.vol;
			this.vol = 0;
			var loc1:*=new flash.media.SoundTransform();
			loc1.volume = this.vol;
			if(this.isvol)
			{
			this.videoStream.soundTransform = loc1;
			this.isvol = false;
			this.CtrlPan.btnSound.silent();
			flash.external.ExternalInterface.call("onVideoMsg", "" + this.id + "", "silent");
			}

			return;
		}
		
		public function ablevol():void
		{
			var loc2:*;
			this.vol1 = loc2 = 1;
			this.vol = loc2;
			var loc1:*=new flash.media.SoundTransform();
			loc1.volume = this.vol;
			this.videoStream.soundTransform = loc1;
			this.isvol = true;
			this.CtrlPan.btnSound.sound();
			flash.external.ExternalInterface.call("onVideoMsg", "" + this.id + "", "sound");
			return;
		}
		
		public function Paus():void
		{
			if (this.iswait) 
			{
				return;
			}
			if (this.ispaus == false) 
			{
				this.videoStream.togglePause();
				this.ispaus = true;
			}
			this.playbtn.visible = true;
			flash.external.ExternalInterface.call("onVideoMsg", "" + this.id + "", "paus");
			return;
		}
		
		public function Play():void
		{
//			flash.external.ExternalInterface.call("getFlashError", this.id+"-4");
			//调用外部js方法下发推流指令
			flash.external.ExternalInterface.call("playVideoByFlash", this.id,this.streamType );
//			flash.external.ExternalInterface.call("getFlashError", this.id+"-5");
//		if(this.videoConnection.connected!=true)
//		{
	initConn();
//		}
			//this.serverIP = "";
			//this.serverPort = "";
			//this.serverId = -1;
//			if (this.urlManager == null) 
//			{
//				this.playFLV(this.flvurl);
//				this.timer.start();
//			}
//			else 
//			{
//				this.showLoading();
//				this.urlManager.getUrl1();
//				this.urlManager.retry = true;
//			}
//			this.disvol()
//			this.dbClickMC.Hide();
//			this.playbtn.visible = false;
			//flash.external.ExternalInterface.call("onVideoMsg", "" + this.id + "", "play");
			return;
			
		}
		
		public function Stop():void
		{
			if (this.iswait) 
			{
				return;
			}
			this.hideLoading();
			if (this.urlManager != null) 
			{
				this.urlManager.Stop();
			}
			//this.serverId = -1;
			//this.serverPort = "";
			this.videoConnection.close();
			this.videoStream.close();
			this._duration = 0;
			this.dbClickMC.Show();
			this.playbtn.visible = true;
			this.iswait = true;
			this.ispaus = true;
			if (this.isfull) 
			{
				this.vodBorder.stat = Border.waitfull;
			}
			this.vodBorder.updateBG();
			this.timer.stop();
			this.CtrlPan.showInfo();
			this.removeEventListener(flash.events.Event.ENTER_FRAME, this.refreshBuffer);
			this.ldinfo.visible = false;
			this.msg.showMsg("");
			this.msg.visible = false;
			this.disvol();
			this.CtrlPan.btnSound.disable();
			this.CtrlPan.btnPlay.onStop();
			this.CtrlPan.btnPlay.enable();
			this.CtrlPan.btnCap.disable();
			//this.CtrlPan.btncamer.disable();
			flash.external.ExternalInterface.call("onVideoMsg", "" + this.id + "", "stop");
			return;
		}
		
		public function getPos():Number
		{
			var loc1:*=this.videoStream.time;
			return loc1;
		}
		
		public function updateUiText(arg1:Language):void
		{
			this.ldinfo.loadingTxt.text = arg1.loading;
			this.msg.updateUiText(arg1);
			this.CtrlPan.updateUiText();
			return;
		}
		
		public function updatePic(arg1:Config):void
		{
			this.vodLogo.updatePic(arg1);
			this.vodBorder.updatePic(arg1);
			return;
		}
		
		public function setLogo(arg1:String, arg2:int, arg3:int):void
		{
			this.vodLogo.setLogo(arg1, arg2, arg3);
			return;
		}
		
		public function setVideoInfo(arg1:String):void
		{
			this.CtrlPan.info = arg1;
			this.CtrlPan.showInfo();
			return;
		}
		
		public function addMenu(arg1:String, arg2:String, arg3:int):int
		{
			var loc1:*=0;
			while (loc1 < this.Menu.length) 
			{
				if (this.Menu[loc1].menuId == arg1) 
				{
					return 5;
				}
				++loc1;
			}
			var loc2:*=new MenuItem(arg1, arg2, arg3, this.id);
			this.Menu.push(loc2);
			return 0;
		}
		
		public function delMenu(arg1:String):int
		{
			var loc1:*=0;
			while (loc1 < this.Menu.length) 
			{
				if (this.Menu[loc1].menuId == arg1) 
				{
					this.Menu[loc1].del();
					this.Menu.splice(loc1, 1);
					return 0;
				}
				++loc1;
			}
			return 5;
		}
		
		public function clearMenu():int
		{
			var loc1:*=0;
			while (loc1 < this.Menu.length) 
			{
				this.Menu[loc1].del();
				++loc1;
			}
			this.Menu = new Array();
			return 0;
		}
		
		public function reSet():*
		{
			this.removeEventListener(flash.events.Event.ENTER_FRAME, this.refreshBuffer);
			this.timer.stop();
			this.ldinfo.visible = false;
			this.CtrlPan.disable();
			this.playbtn.visible = false;
			if (this.urlManager != null) 
			{
				this.urlManager.Stop();
			}
			//this.serverId = -1;
			//this.serverPort = "";
			this.videoStream.close();
			this.video.clear();
			this.ispaus = false;
			this.isfull = false;
			this.iswait = true;
			var loc1:*;
			this.vol = loc1 = 1;
			this.vol1 = loc1;
			this.flvstat = 0;
			this._duration = 0;
			this.playbtn.visible = false;
			this.vodLogo.reSet();
			this.dbClickMC.Hide();
			this.CtrlPan.reSet();
			this.vodBorder.updateBG();
			return;
		}
		
		public function setToolBarVisible(arg1:int, arg2:Boolean):int
		{
			return this.CtrlPan.setToolBarVisible(arg1, arg2);
		}
		
		function onTalk(arg1:PlayEvent):*
		{
			flash.external.ExternalInterface.call("onToolbarClick", "" + this.id + "", "5");
			return;
		}
		
		function onTimer(arg1:flash.events.Event):*
		{
			/////////////////////////////////////////////////////////
			//自动停止计时器
			this.stopNumber++;
			if(stopNumber>this.stopTime*60*2)
			{
				this.stopTimeButton.x = this.Rect.rx+this.Rect.rw/2-this.stopTimeButton.width/2;
				this.stopTimeButton.y = this.Rect.ry+this.Rect.rh/2-this.stopTimeButton.height/2;
				this.stopTimeButton.visible=true;
				this.stopDisplayNumber=this.stopDisplayNumber+0.5;
				
				this.stopTimeButton.text="点击这里继续观看\n      ("+int(10-this.stopDisplayNumber)+"s将关闭)";;
				if(this.stopDisplayNumber==10)
				{
				this.stopNumber=0;
				this.stopTimeButton.visible=false;
				this.stopDisplayNumber=0;
				this.Stop();
				}
			}
			/////////////////////////////////////////////////////////
			//trace("playbackBytesPerSecond:"+this.videoStream.info.playbackBytesPerSecond);
			//trace("BufferLength:"+this.videoStream.bufferLength+"\tTime:"+this.videoStream.time+"\tcurrentFPS:"+this.videoStream.currentFPS);
			//var loc1:*=this.videoStream.bytesLoaded;
			//var loc2:*=(loc1 - this.oldBytes) / 512;
			var loc2:*=this.videoStream.info.playbackBytesPerSecond/1024;
			this.CtrlPan.setBps(loc2);
			//this.oldBytes = loc1;
			return;
		}
		
		public function setBufferTime(arg1:Number):void
		{
			//this.videoStream.bufferTime = arg1;
			this.bufferTime = arg1;
		}
		
		public function setBufferTimeMax(arg1:Number):void
		{
			//this.videoStream.bufferTimeMax = arg1;
			this.bufferTimeMax = arg1;
			return;
		}
		
		function onPlay(arg1:PlayEvent):void
		{
			trace("Player OnPaly,VideoButton");
			this.Play();
			return;
		}
		
		function onCapture(arg1:PlayEvent):*
		{
			var m:Matrix;
			var e:* = com.hlet.event.PlayEvent;
			dispatchEvent(new com.hlet.event.PlayEvent("norm"));
//			video.width = video.videoWidth; 
//			video.height = video.videoHeight; 
			trace("onCapture-Width:"+this.video.width+",Height:"+this.video.height+",Video Width:"+this.video.videoWidth+",Video Height:"+this.video.videoHeight);
			try
			{
				//固定了截图尺寸，不知道为什么无法根据this.video.videoWidth, this.video.videoHeight截图
				//var bmpd:* = new BitmapData(320, 240);
				//var bmpd:* = new BitmapData(352, 288);
				//var bmpd:* = new BitmapData(704, 576);
				var bmpd = new flash.display.BitmapData(this.video.videoWidth, this.video.videoHeight);
				m = new Matrix(this.video.videoWidth/320,0,0,this.video.videoHeight/240);
				//m.tx = this.video.x;
				//m.ty = this.video.y;
			
				bmpd.draw(this.video,m,null,null,null,true);
			}
			catch (e:Error)
			{
				ExternalInterface.call("onVideoMsg", "" + 0 + "", "PicSave-error" + e.message);
				return;
			}
			var imgByteArray:* = PNGEncoder.encode(bmpd);
			var FileRefe:* = new FileReference();
			ExternalInterface.call("onVideoMsg", "" + 0 + "", "PicSave");
			var date:* = new Date();
			var info:*;
			if (this.CtrlPan.info != "")
			{
				info = this.CtrlPan.info + "-";
			}
			var s:* = info + date.getFullYear() + "-" + date.getMonth() + "-" + date.getDate() + " " + date.getHours() + "-" + date.getMinutes() + "-" + date.getSeconds() + ".png";
			FileRefe.save(imgByteArray, s);
			return;
			/*
			try
			{
				var e:PlayEvent;
				var bmpd:flash.display.BitmapData;
				var vw:*;
				var vh:*;
				var imgByteArray:flash.utils.ByteArray;
				var FileRefe:flash.net.FileReference;
				var date:Date;
				var info:*;
				var s:*;
				
				var loc1:*;
				e = arg1;
				dispatchEvent(new PlayEvent("norm"));
				bmpd = new flash.display.BitmapData(this.video.videoWidth, this.video.videoHeight);
				trace("width=" + this.video.videoWidth + "  height=" + this.video.videoHeight);
				vw = this.video.width;
				vh = this.video.height;
			}
			catch (err:ArgumentError ) 
			{ 
				trace("video尺寸为0x0"); 
			} 
			*/
		}

		function onPause(arg1:PlayEvent):void
		{
			if (this.iswait) 
			{
				return;
			}
			this.Paus();
			return;
		}
		
		function onStop(arg1:PlayEvent):void
		{
			this.Stop();
			return;
		}
		
		function onFull(arg1:PlayEvent):void
		{
			dispatchEvent(new PlayEvent("full"));
			return;
		}
		
		function onNorm(arg1:PlayEvent):void
		{
			dispatchEvent(new PlayEvent("norm"));
			return;
		}
		
		public function gotoPos(arg1:Number):void
		{
			if (this._duration == 0) 
			{
				return;
			}
			this.videoStream.seek(arg1);
			return;
		}
		
		function onCamer(arg1:PlayEvent):*
		{
			flash.external.ExternalInterface.call("onToolbarClick", "" + this.id + "", "4");
			return;
		}
		
		function onSound(arg1:PlayEvent):void
		{
			//this.ablevol();
			if (this.iswait) 
			{
				return;
			}
			dispatchEvent(new PlayEvent("sound"));
			return;
		}
		
		function onSilent(arg1:PlayEvent):void
		{
			this.disvol();
			return;
		}
		
		function onMSover(arg1:flash.events.MouseEvent):void
		{
			this.CtrlPan.visible = true;
			return;
		}
		
		function onMSout(arg1:flash.events.MouseEvent):void
		{
			this.CtrlPan.visible = false;
			return;
		}

		
		public function playFLV(arg1:String):void
		{
//			flash.external.ExternalInterface.call("getFlashError", this.id+"-6");
			this.flvurl = arg1;
			trace("playVideo " + arg1);
			this._duration = 0;
			
			//var loc1:*="http://58.217.99.135:28080/crossdomain.xml";//
			var loc1:*=this.flvurl.substr(0, flvurl.indexOf("/",flvurl.indexOf("//")+2)) + "/crossdomain.xml";
			flash.system.Security.loadPolicyFile(loc1);
			this.iswait = false;
			this.ispaus = false;
			if (this.vodBorder.stat == Border.waitfull) 
			{
				this.vodBorder.stat = Border.full;
			}
			this.vodBorder.updateBG();
			this.msg.visible = false;
			this.video.clear();
			//trace("Width:"+this.video.width+"Height:"+this.video.height+"Video Width:"+this.video.videoWidth+"Video Height:"+this.video.videoHeight);
			this.videoStream.play(this.flvurl);
			
			this.addEventListener(flash.events.Event.ENTER_FRAME, this.refreshBuffer);
			this.timer.start();
			this.CtrlPan.btnPlay.onPlay();
			this.CtrlPan.enable();
			flash.external.ExternalInterface.call("onVideoMsg", "" + this.id + "", "start");
			this.playbtn.visible = false;
			this.dbClickMC.Hide();
			this.disvol()
			return;
		}
		
		public function setNorm():void
		{
			this.isfull = false;
			this.reSize();
			return;
		}
		
		public function setFull():void
		{
			trace("Player setFull()");
			var loc1:*=undefined;
			var loc2:*=undefined;
			var loc3:*=undefined;
			if (this.WH != "full") 
			{
				loc1 = this.WH.split(":");
				loc2 = int(loc1[0]);
				loc3 = int(loc1[1]);
				if (this.Rect.sw / (this.Rect.sh - 30) >= loc2 / loc3) 
				{
					this.video.height = this.Rect.sh - 30;
					this.video.width = loc2 * this.video.height / loc3;
					this.video.x = (550 - this.video.width) / 2;
					this.video.y = (400 - this.video.height) / 2 - 15;
				}
				else 
				{
					this.video.width = this.Rect.sw;
					this.video.height = loc3 * this.video.width / loc2;
					this.video.x = (550 - this.video.width) / 2;
					this.video.y = (400 - this.video.height) / 2 - 15;
				}
			}
			else 
			{
//				this.video.x = 275 - this.Rect.sw / 2;
//				this.video.y = 200 - this.Rect.sh / 2;
				this.video.x = 0;
				this.video.y = 0;
				this.video.width = this.Rect.sw;
				this.video.height = this.Rect.sh-30;
			}
			this.isfull = true;
			if (this.iswait) 
			{
				this.vodBorder.stat = Border.waitfull;
			}
			else 
			{
				this.vodBorder.stat = Border.full;
			}
			this.vodBorder.updateBG();
			this.msg.isfull = true;
			this.msg.reSize();
			this.CtrlPan.isFull = true;
			this.CtrlPan.reSize();
			this.vodLogo.isFull = true;
			this.vodLogo.reSize();
			this.ldinfo.isfull = true;
			this.ldinfo.reSize();
			this.playbtn.isFull = true;
			this.playbtn.reSize();
			this.dbClickMC.isFull = true;
			this.dbClickMC.reSize();
			flash.external.ExternalInterface.call("onVideoMsg", "" + this.id + "", "full");
			return;
		}
	}
}
