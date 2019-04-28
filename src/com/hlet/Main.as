package com.hlet
{
	import com.hlet.RTMP.RtmpManager;
	import com.hlet.event.ConfigEvent;
	import com.hlet.event.LangEvent;
	import com.hlet.event.PlayEvent;
	import com.hlet.event.PlayerEvent;
	import com.hlet.event.TimeEvent;
	import com.hlet.event.UrlEvent;
	import com.hlet.event.VolEvent;
	
	import flash.display.MovieClip;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.media.Microphone;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.Timer;
	import flash.display.StageAlign;
	
	public class Main extends flash.display.MovieClip
	{
		//public var tools:Tools;		
		private var num;		
		private var vod:Array;		
		private var rect:Array;		
		private var currVod:Player;		
		private var lang:Language;		
		private var serverIP:String="";		
		private var serverPort:String="";		
		private var cfg:Config;		
		private var version:*="20190304";		
		private var ver:*="1.0.0";		
		private var VerMenu:flash.ui.ContextMenuItem;		
		private var _contextMenu:flash.ui.ContextMenu;
		private var CopyRight:ContextMenuItem;
		private var _stageSizeTimer:Timer;
		
		public function Main()
		{
			_stageSizeTimer = new Timer(250);
			_stageSizeTimer.addEventListener(TimerEvent.TIMER, onStageSizeTimerTick);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(e:Event):void{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			_stageSizeTimer.start();
		}
		
		private function onStageSizeTimerTick(e:TimerEvent):void{
			if(stage.stageWidth > 0 && stage.stageHeight > 0){
				_stageSizeTimer.stop();
				_stageSizeTimer.removeEventListener(TimerEvent.TIMER, onStageSizeTimerTick);
				init();
			}
		}
		private function init():void{
			//this.tools=new Tools();
			this.vod = new Array();
			this.rect = new Array();
			this._contextMenu = new ContextMenu();
			this.VerMenu = new ContextMenuItem("MiraclePlayer " + this.ver + " " + this.version);
			var date:Date=new Date(); //获取时间  
			var year:int=date.fullYear; //获取年份  
			this.CopyRight = new ContextMenuItem("Copyright © "+year+" hlet.com. All right reserved.");
			this.VerMenu.separatorBefore = true;
			stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
			this.initEvent();
			this.initAPI();
			//this.tools.changeSize();
			RectManager.stage = stage;
			this.resizeVod();
		}
		
		private function initEvent():void
		{
			this.lang = new Language();
			this.lang.addEventListener(LangEvent.CHANGE, this.updateUiText);
			this.cfg = new Config();
			this.cfg.addEventListener(ConfigEvent.CHANGE, this.setPIC);
			Common.lang = this.lang;
			Common.cfg = this.cfg;
			stage.addEventListener(flash.events.Event.RESIZE, this.winSize);
			stage.addEventListener(flash.events.Event.MOUSE_LEAVE, this.msLeave);
			stage.addEventListener(flash.events.MouseEvent.MOUSE_OVER, this.msOver);
			stage.addEventListener(flash.events.MouseEvent.MOUSE_UP, this.stopdrag);
			//this.tools.addEventListener(TimeEvent.TIME, this.tim);
			//this.tools.addEventListener(VolEvent.VOL, this.fvol);
			//this.tools.addEventListener(PlayEvent.FULL, this.ffull);
			//this.tools.addEventListener(PlayEvent.NORM, this.fnorm);
			//this.tools.addEventListener(PlayEvent.PLAY, this.fplay);
			//this.tools.addEventListener(PlayEvent.PAUS, this.fpaus);
			//this.tools.addEventListener(PlayEvent.STOP, this.fstop);
			this._contextMenu.hideBuiltInItems();
			this.contextMenu = this._contextMenu;
			this._contextMenu.addEventListener(flash.events.ContextMenuEvent.MENU_SELECT, this.clickMenu);
			return;
		}
		
		private function initAPI():void
		{
			flash.external.ExternalInterface.addCallback("setLogoTxt", this.setLogoTxt);
			flash.external.ExternalInterface.addCallback("startVod", this.startVod);
			flash.external.ExternalInterface.addCallback("stopVideo", this.stopVideo);
			flash.external.ExternalInterface.addCallback("startVideo", this.startVideo);
			flash.external.ExternalInterface.addCallback("pauseVideo", this.pauseVideo);
			flash.external.ExternalInterface.addCallback("setWindowNum", this.setWindowNum);
			flash.external.ExternalInterface.addCallback("setServerInfo", this.setServerInfo);
			flash.external.ExternalInterface.addCallback("setVideoServer", this.setVideoServer);
			flash.external.ExternalInterface.addCallback("getVersion", this.getVersion);
			flash.external.ExternalInterface.addCallback("setVideoInfo", this.setVideoInfo);
			flash.external.ExternalInterface.addCallback("setVideoFrame", this.setVideoFrame);
			flash.external.ExternalInterface.addCallback("setBufferTime", this.setBufferTime);
			flash.external.ExternalInterface.addCallback("setBufferTimeMax", this.setBufferTimeMax);
			flash.external.ExternalInterface.addCallback("reSetVideo", this.reSetVideo);
			flash.external.ExternalInterface.addCallback("setVideoFocus", this.setVideoFocus);
			flash.external.ExternalInterface.addCallback("startListen", this.startListen);
			flash.external.ExternalInterface.addCallback("stopListen", this.stopListen);
			flash.external.ExternalInterface.addCallback("getListenState", this.getListenState);
			flash.external.ExternalInterface.addCallback("getTalkbackState", this.getTalkbackState);
			flash.external.ExternalInterface.addCallback("setListenParam", this.setListenParam);
			flash.external.ExternalInterface.addCallback("getListenBufferLength", this.getListenBufferLength);
			flash.external.ExternalInterface.addCallback("setListenSeek", this.setListenSeek);
			flash.external.ExternalInterface.addCallback("setListenSeek1", this.setListenSeek1);
			flash.external.ExternalInterface.addCallback("getListenTime", this.getListenTime);
			flash.external.ExternalInterface.addCallback("getReciverBufferLength", this.getReciverBufferLength);
			flash.external.ExternalInterface.addCallback("setReciverSeek", this.setReciverSeek);
			flash.external.ExternalInterface.addCallback("setReciverSeek1", this.setReciverSeek1);
			flash.external.ExternalInterface.addCallback("getReciverTime", this.getReciverTime);
			flash.external.ExternalInterface.addCallback("getTalkBufferLength", this.getTalkBufferLength);
			flash.external.ExternalInterface.addCallback("setTalkSeek", this.setTalkSeek);
			flash.external.ExternalInterface.addCallback("setTalkSeek1", this.setTalkSeek1);
			flash.external.ExternalInterface.addCallback("getTalkTime", this.getTalkTime);
			flash.external.ExternalInterface.addCallback("setTalkParam", this.setTalkParam);
			flash.external.ExternalInterface.addCallback("setTalkMaxParam", this.setTalkMaxParam);
			flash.external.ExternalInterface.addCallback("startTalkback", this.startTalkback);
			flash.external.ExternalInterface.addCallback("stopTalkback", this.stopTalkback);
			flash.external.ExternalInterface.addCallback("setVideoTbarBgColor", this.setVideoTbarBgColor);
			flash.external.ExternalInterface.addCallback("getVideoPlayTime", this.getVideoPlayTime);
			flash.external.ExternalInterface.addCallback("addVideoMenu", this.addVideoMenu);
			flash.external.ExternalInterface.addCallback("delVideoMenu", this.delVideoMenu);
			flash.external.ExternalInterface.addCallback("clearVideoMenu", this.clearVideoMenu);
			flash.external.ExternalInterface.addCallback("setToolBarVisible", this.setToolBarVisible);
			return;
		}
		public function setToolBarVisible(arg1:int, arg2:int, arg3:String):int
		{
			if (arg1 < 0) 
			{
				return 3;
			}
			if (this.num == 0) 
			{
				return 1;
			}
			if (arg1 >= this.num) 
			{
				return 2;
			}
			if (this.vod[arg1] == null) 
			{
				return 4;
			}
			var loc1:*=arg3 == "true";
			return this.vod[arg1].setToolBarVisible(arg2, loc1);
		}
		
		public function getListenBufferLength():Number
		{
			return RtmpManager.getListenBufferLength();
		}
		
		public function setListenSeek(arg1:Number):int
		{
			return RtmpManager.setListenSeek(arg1);
		}
		
		public function setListenSeek1(arg1:Number):int
		{
			return RtmpManager.setListenSeek1(arg1);
		}
		
		public function getListenTime():Number
		{
			return RtmpManager.getListenTime();
		}
		
		public function getReciverBufferLength():Number
		{
			return RtmpManager.getReciverBufferLength();
		}
		
		public function setReciverSeek(arg1:Number):int
		{
			return RtmpManager.setReciverSeek(arg1);
		}
		
		public function setReciverSeek1(arg1:Number):int
		{
			return RtmpManager.setReciverSeek1(arg1);
		}
		
		public function getReciverTime():Number
		{
			return RtmpManager.getReciverTime();
		}
		
		function fvol(arg1:VolEvent):void
		{
			this.currVod.setVolume(arg1.vol);
			return;
		}
		
		public function getTalkBufferLength():Number
		{
			return RtmpManager.getTalkBufferLength();
		}
		
		public function setTalkSeek(arg1:Number):int
		{
			return RtmpManager.setTalkSeek(arg1);
		}
		
		public function setTalkSeek1(arg1:Number):int
		{
			return RtmpManager.setTalkSeek1(arg1);
		}
		
		function ontimer(arg1:flash.events.TimerEvent):void
		{
			this.startVod(0, "", "90733", "0", "1", true, "121.197.0.50", "6605");
			return;
		}
		
		function winSize(arg1:flash.events.Event):void
		{
			//this.tools.changeSize();
			this.resizeVod();
			return;
		}
		
		function fplay(arg1:PlayEvent):void
		{
			var loc1:*=undefined;
			var loc2:*=undefined;
			if (this.currVod == null) 
			{
				return;
			}
			if (this.currVod.iswait && this.currVod.flvstat > 0) 
			{
				if (this.currVod.flvstat != 1) 
				{
					if (this.currVod.flvstat == 2) 
					{
						this.currVod.playFLV(this.currVod.flvurl);
						//this.tools.setVod(this.currVod);
					}
				}
				else 
				{
					loc1 = new Date();
					loc2 = "http://" + this.serverIP + ":" + this.serverPort + "/rtmp/" + loc1.getTime() + "/?" + this.currVod.param;
					this.currVod.playFLV(loc2);
					//this.tools.setVod(this.currVod);
				}
			}
			else 
			{
				this.currVod.Play();
			}
			return;
		}
		
		function fpaus(arg1:PlayEvent):void
		{
			if (this.currVod == null) 
			{
				return;
			}
			if (this.currVod.iswait) 
			{
				return;
			}
			this.currVod.Paus();
			return;
		}
		
		function ffull(arg1:PlayEvent):void
		{
			stage.displayState = flash.display.StageDisplayState.FULL_SCREEN;
			return;
		}
		
		function fnorm(arg1:PlayEvent):void
		{
			stage.displayState = flash.display.StageDisplayState.NORMAL;
			return;
		}
		
		public function getTalkTime():Number
		{
			return RtmpManager.getListenTime();
		}
		
		function tim(arg1:TimeEvent):void
		{
			this.currVod.gotoPos(arg1.tim);
			return;
		}
		
		function fstop(arg1:PlayEvent):void
		{
			if (this.currVod == null) 
			{
				return;
			}
			if (this.currVod.iswait) 
			{
				return;
			}
			this.currVod.Stop();
			//this.tools.setVod(this.currVod);
			return;
		}
		
		function stopdrag(arg1:flash.events.Event):void
		{
			//this.tools.stopdrag();
			return;
		}
		
		public function startTalkback(arg1:String, arg2:String, arg3:String, arg4:String="", arg5:String=""):int
		{
			var session:String;
			var devIdno:String;
			var channel:String;
			var server:String="";
			var port:String="";
			var sip:*;
			var sport:*;
			var urlParm:UrlParm;
			var um:UrlManager;
			var m:*;
			
			var loc1:*;
			m = undefined;
			session = arg1;
			devIdno = arg2;
			channel = arg3;
			server = arg4;
			port = arg5;
			sip = this.serverIP;
			sport = this.serverPort;
			if (server != "") 
			{
				sip = server;
			}
			if (port != "") 
			{
				sport = port;
			}
			if (sip == "" || sport == "") 
			{
				return 1;
			}
			if (!(RtmpManager.getTalkbackState() == 2) && !(RtmpManager.getTalkbackState() == 100)) 
			{
				return 4;
			}
			try 
			{
				m = flash.media.Microphone.getEnhancedMicrophone();
				if (m == null) 
				{
					m = flash.media.Microphone.getMicrophone();
				}
				if (!(m == null) && m.muted) 
				{
					return 3;
				}
			}
			catch (e:*)
			{
				trace(e);
				return 2;
			}
			urlParm = new UrlParm();
			urlParm.Channel = channel;
			urlParm.DevIdno = devIdno;
			urlParm.ServerIp = sip;
			urlParm.ServerPort = sport;
			urlParm.Session = session;
			urlParm.AvType = 3;
			urlParm.MediaType = 1;
			RtmpManager.talkServerId = -1;
			RtmpManager.talkServerPort = -1;
			um = null;
			if (RtmpManager.talkUrlManager != null) 
			{
				um = RtmpManager.talkUrlManager;
			}
			else 
			{
				um = new UrlManager(this.vod, sip);
				RtmpManager.talkUrlManager = um;
				um.addEventListener(UrlEvent.GETURL, function (arg1:*):*
				{
					var loc1:*=new Date();
					var loc2:*=arg1.um.Session + ",1," + arg1.um.DevIdno + "," + arg1.um.Channel + ",0,0,10";
					var loc3:*="rtmp://" + arg1.ServerIp + ":" + arg1.Port + "/rtmp/" + loc1.getTime() + "/?" + Base64.encode(loc2);
					stopListen();
					disAllSound();
					RtmpManager.talkServerId = arg1.ServerId;
					RtmpManager.talkServerPort = arg1.Port;
					RtmpManager.startTalk(devIdno, loc3);
					return;
				})
			}
			um.Stop();
			um.getUrl(urlParm);
			return 0;
		}
		
		function stopTalkback():*
		{
			RtmpManager.stopTalkback();
			return;
		}
		
		function msLeave(arg1:flash.events.Event):void
		{
			//this.tools.visible = false;
			return;
		}
		
		function msOver(arg1:flash.events.Event):void
		{
			//this.tools.visible = false;
			return;
		}
		
		public function getVersion():String
		{
			return this.version;
		}
		
		public function setServerInfo(arg1:String, arg2:String):int
		{
			this.serverIP = arg1;
			this.serverPort = arg2;
			return 0;
		}
		
		public function setVideoServer(arg1:int, arg2:String, arg3:String):int
		{
			if (arg1 < 0) 
			{
				return 3;
			}
			if (this.num == 0) 
			{
				return 1;
			}
			if (arg1 >= this.num) 
			{
				return 2;
			}
			if (this.vod[arg1] == null) 
			{
				return 4;
			}
			this.vod[arg1].serverIP = arg2;
			this.vod[arg1].serverPort = arg3;
			return 0;
		}
		
		public function setLogo(arg1:int, arg2:String, arg3:int, arg4:int):int
		{
			if (arg1 < 0) 
			{
				return 3;
			}
			if (this.num == 0) 
			{
				return 1;
			}
			if (arg1 >= this.num) 
			{
				return 2;
			}
			if (this.vod[arg1] == null) 
			{
				return 4;
			}
			this.vod[arg1].setLogo(arg2, arg3, arg4);
			return 0;
		}
		
		public function setLogoTxt(arg1:int, arg2:String, arg3:Number, arg4:int, arg5:int, arg6:int):int
		{
			if (arg1 < 0) 
			{
				return 3;
			}
			if (this.num == 0) 
			{
				return 1;
			}
			if (arg1 >= this.num) 
			{
				return 2;
			}
			if (this.vod[arg1] == null) 
			{
				return 4;
			}
			this.vod[arg1].setLogoTxt(arg2, arg3, arg4, arg5, arg6);
			return 0;
		}
		
		public function startListen(arg1:String, arg2:String, arg3:String, arg4:String="", arg5:String=""):int
		{
			var session:String;
			var devIdno:String;
			var channel:String;
			var server:String="";
			var port:String="";
			var sip:*;
			var sport:*;
			var urlParm:UrlParm;
			var um:UrlManager;
			
			var loc1:*;
			session = arg1;
			devIdno = arg2;
			channel = arg3;
			server = arg4;
			port = arg5;
			sip = this.serverIP;
			sport = this.serverPort;
			if (server != "") 
			{
				sip = server;
			}
			if (port != "") 
			{
				sport = port;
			}
			if (sip == "" || sport == "") 
			{
				return 1;
			}
			urlParm = new UrlParm();
			urlParm.Channel = channel;
			urlParm.DevIdno = devIdno;
			urlParm.ServerIp = sip;
			urlParm.ServerPort = sport;
			urlParm.Session = session;
			urlParm.AvType = 2;
			urlParm.MediaType = 1;
			RtmpManager.listenerServerId = -1;
			RtmpManager.listenerServerPort = -1;
			um = null;
			if (RtmpManager.listenUrlManager != null) 
			{
				um = RtmpManager.listenUrlManager;
			}
			else 
			{
				um = new UrlManager(this.vod, sip);
				RtmpManager.listenUrlManager = um;
				um.addEventListener(UrlEvent.GETURL, function (arg1:*):*
				{
					var loc1:*=new Date();
					var loc2:*=arg1.um.Session + ",1," + arg1.um.DevIdno + "," + arg1.um.Channel + ",0,0,2";
					var loc3:*="http://" + arg1.ServerIp + ":" + arg1.Port + "/rtmp/" + loc1.getTime() + "/?" + Base64.encode(loc2);
					RtmpManager.listenerServerId = arg1.ServerId;
					RtmpManager.listenerServerPort = arg1.Port;
					RtmpManager.startListen(loc3);
					flash.external.ExternalInterface.call("onDebug", loc3);
					disAllSound();
					stopTalkback();
					return;
				})
			}
			um.Stop();
			um.getUrl(urlParm);
			return 0;
		}
		
		function setListenParam(arg1:int):int
		{
			return RtmpManager.setListenParam(arg1);
		}
		
		function setTalkParam(arg1:int):int
		{
			return RtmpManager.setTalkParam(arg1);
		}
		
		function setTalkMaxParam(arg1:int):int
		{
			return RtmpManager.setTalkMaxParam(arg1);
		}
		
		function getListenState():*
		{
			return RtmpManager.getListenState();
		}
		
		function getTalkbackState():int
		{
			return RtmpManager.getTalkbackState();
		}
		
		public function setVideoTbarBgColor(arg1:int, arg2:String):int
		{
			if (arg1 < 0) 
			{
				return 3;
			}
			if (this.num == 0) 
			{
				return 1;
			}
			if (arg1 >= this.num) 
			{
				return 2;
			}
			if (this.vod[arg1] == null) 
			{
				return 4;
			}
			this.vod[arg1].setVideoTbarBgColor(arg2);
			return 0;
		}
		
		function getVideoPlayTime(arg1:int):int
		{
			if (arg1 < 0) 
			{
				return -1;
			}
			if (this.num == 0) 
			{
				return -2;
			}
			if (arg1 >= this.num) 
			{
				return -3;
			}
			if (this.vod[arg1] == null) 
			{
				return -4;
			}
			return int(this.vod[arg1].getPos());
		}
		
		public function clickMenu(arg1:flash.events.ContextMenuEvent):*
		{
			var loc4:*=undefined;
			trace("rend menu");
			var loc1:*=mouseX;
			var loc2:*=mouseY;
			trace("鼠标X" + loc1 + "鼠标Y" + loc2);
			var loc3:*=-1;
			loc4 = 0;
			while (loc4 < this.vod.length) 
			{
				if (this.vod[loc4].isfull || this.vod[loc4].visible && loc1 > this.vod[loc4].Rect.rx && loc1 < this.vod[loc4].Rect.rx + this.vod[loc4].Rect.rw && loc2 > this.vod[loc4].Rect.ry && loc2 < this.vod[loc4].Rect.ry + this.vod[loc4].Rect.rh) 
				{
					loc3 = loc4;
					break;
				}
				++loc4;
			}
			flash.external.ExternalInterface.call("onVideoBeforePopMenu", "" + loc3 + "");
			var loc5:*=null;
			if (loc3 != -1) 
			{
				loc5 = this.vod[loc3].Menu;
			}
			var loc6:*=new Array();
			if (loc5 != null) 
			{
				loc4 = 0;
				while (loc4 < loc5.length) 
				{
					loc6.push(loc5[loc4].item);
					++loc4;
				}
			}
			loc6.push(this.VerMenu);
			loc6.push(this.CopyRight);
			this._contextMenu.hideBuiltInItems();
			this._contextMenu.customItems = loc6;
			return;
		}
		
		public function addVideoMenu(arg1:int, arg2:String, arg3:String, arg4:int=0):int
		{
			if (arg1 < 0) 
			{
				return 3;
			}
			if (this.num == 0) 
			{
				return 1;
			}
			if (arg1 >= this.num) 
			{
				return 2;
			}
			if (this.vod[arg1] == null) 
			{
				return 4;
			}
			return this.vod[arg1].addMenu(arg2, arg3, arg4);
		}
		
		public function delVideoMenu(arg1:int, arg2:String):int
		{
			if (arg1 < 0) 
			{
				return 3;
			}
			if (this.num == 0) 
			{
				return 1;
			}
			if (arg1 >= this.num) 
			{
				return 2;
			}
			if (this.vod[arg1] == null) 
			{
				return 4;
			}
			return this.vod[arg1].delMenu(arg2);
		}
		
		public function clearVideoMenu(arg1:int):int
		{
			if (arg1 < 0) 
			{
				return 3;
			}
			if (this.num == 0) 
			{
				return 1;
			}
			if (arg1 >= this.num) 
			{
				return 2;
			}
			if (this.vod[arg1] == null) 
			{
				return 4;
			}
			return this.vod[arg1].clearMenu();
		}
		
		public function stopListen():*
		{
			RtmpManager.stopListen();
			flash.external.ExternalInterface.call("onVideoMsg", "" + 0 + "", "stopListen");
			return;
		}
		
		public function startVod(arg1:int, arg2:String, arg3:String, arg4:String, arg5:String, arg6:Boolean, arg7:String="", arg8:String=""):int
		{
			var index:int;
			var session:String;
			var devIdno:String;
			var channel:String;
			var streamtype:String;
			var playNow:Boolean;
			var server:String="";
			var port:String="";
			var sip:*;
			var sport:*;
			var urlParm:UrlParm;
			var um:UrlManager;
			
			var loc1:*;
			index = arg1;
			session = arg2;
			devIdno = arg3;
			channel = arg4;
			streamtype = arg5;
			playNow = arg6;
			server = arg7;
			port = arg8;
			sip = this.serverIP;
			sport = this.serverPort;
			if (server != "") 
			{
				sip = server;
			}
			if (port != "") 
			{
				sport = port;
			}
			if (index < 0) 
			{
				return 3;
			}
			if (this.num == 0) 
			{
				return 1;
			}
			if (index >= this.num) 
			{
				return 2;
			}
			if (sip == "" || sport == "") 
			{
				return 4;
			}
			urlParm = new UrlParm();
			urlParm.Channel = channel;
			urlParm.DevIdno = devIdno;
			urlParm.ServerIp = sip;
			urlParm.ServerPort = sport;
			urlParm.Session = session;
			urlParm.StreamType = streamtype;
			urlParm.AvType = 1;
			urlParm.MediaType = 1;
			if (this.vod[index] == null) 
			{
				this.vod[index] = new Player();
				addChildAt(this.vod[index], 0);
				this.vod[index].id = index;
				this.vod[index].addEventListener(PlayerEvent.CLICK, this.selectVod);
				this.vod[index].addEventListener(PlayerEvent.DOUBLE_CLICK, this.vodFull);
				this.vod[index].addEventListener(PlayerEvent.ALLTIME, this.getAlltime);
				this.vod[index].addEventListener(PlayEvent.SOUND, this.onSound);
				this.vod[index].setRect(this.rect[index]);
			}
			this.vod[index].urlParm = urlParm;
			if (this.num == 1) 
			{
				this.currVod = this.vod[index];
				//this.tools.setVod(this.currVod);
			}
			this.vod[index].disvol();
			this.vod[index].iswait = false;
			this.vod[index].showLoading();
			um = null;
			if (this.vod[index].urlManager != null) 
			{
				um = this.vod[index].urlManager;
			}
			else 
			{
				var url = "http://"+server+":"+port+"/realstream?fmt=flv&vchn="+channel+"&vstreamtype="+streamtype+"&achn=-1&atype=0&datatype=0&phone="+devIdno;
				//url="http://39.108.194.249:6604/rtmp/1551409948284/?NjBBNTFEQkQ2M0I0NkJCOEExNkI1NjY4MkQ4MERBMzMsMSwwMTg2MDAwMDAwMDQsMCwxLDAsMA=="
				url=arg2;
				vod[index].flvstat = 1;
				if (playNow)
				{
					vod[index].playFLV(url);
					if (num == 1)
					{
						currVod = vod[index];
					}
				}
//				vod[index].disvol();
//				um = new UrlManager(this.vod, sip);
//				this.vod[index].urlManager = um;
//				um.addEventListener(UrlEvent.GETURL, function (arg1:*):*
//				{
//					trace("ServerIp==" + arg1.ServerIp);
//					var loc1:*=new Date();
//					var loc2:*=arg1.um.Session + ",1," + arg1.um.DevIdno + "," + arg1.um.Channel + "," + arg1.um.StreamType + ",0,0";
//					var loc3:*="http://" + arg1.ServerIp + ":" + arg1.Port + "/rtmp/" + loc1.getTime() + "/?" + Base64.encode(loc2);
//					loc3="http://39.108.194.249:6604/rtmp/1551409948284/?NjBBNTFEQkQ2M0I0NkJCOEExNkI1NjY4MkQ4MERBMzMsMSwwMTg2MDAwMDAwMDQsMCwxLDAsMA=="
//					vod[index].serverPort = arg1.Port;
//					vod[index].serverId = arg1.ServerId;
//					vod[index].param = Base64.encode(loc2);
//					vod[index].flvstat = 1;
//					if (playNow) 
//					{
//						vod[index].playFLV(loc3);
//						if (num == 1) 
//						{
//							currVod = vod[index];
//							tools.setVod(currVod);
//						}
//					}
//					vod[index].disvol();
//					return;
//				})
			}
			//um.Stop();
			//um.getUrl(urlParm);
			this.addEventListener(flash.events.Event.ENTER_FRAME, this.refreshTime);
			return 0;
		}
		
		public function startVideo(arg1:int, arg2:String):int
		{
			if (arg1 < 0) 
			{
				return 3;
			}
			if (this.num == 0) 
			{
				return 1;
			}
			if (arg1 >= this.num) 
			{
				return 2;
			}
			if (this.vod[arg1] == null) 
			{
				this.vod[arg1] = new Player();
				addChildAt(this.vod[arg1], 0);
				this.vod[arg1].id = arg1;
				this.vod[arg1].addEventListener(PlayerEvent.CLICK, this.selectVod);
				this.vod[arg1].addEventListener(PlayerEvent.DOUBLE_CLICK, this.vodFull);
				this.vod[arg1].addEventListener(PlayerEvent.ALLTIME, this.getAlltime);
				this.vod[arg1].addEventListener(PlayEvent.SOUND, this.onSound);
				this.vod[arg1].addEventListener(PlayEvent.FULL, this.onFull);
				this.vod[arg1].addEventListener(PlayEvent.NORM, this.onNorm);
				this.vod[arg1].setRect(this.rect[arg1]);
			}
			this.vod[arg1].param = "";
			this.vod[arg1].flvstat = 2;
			this.vod[arg1].playFLV(arg2);
			this.vod[arg1].disvol();
			if (this.num == 1) 
			{
				this.vod[arg1].ablevol();
				this.currVod = this.vod[arg1];
				//this.tools.setVod(this.currVod);
			}
			this.addEventListener(flash.events.Event.ENTER_FRAME, this.refreshTime);
			return 0;
		}
		
		function vodPlay(arg1:flash.events.MouseEvent):void
		{
			var loc1:*=arg1.currentTarget.id;
			this.vod[loc1].Play();
			//this.tools.setPlayBtn();
			arg1.currentTarget.visible = false;
			return;
		}
		
		public function setWindowNum(arg1:int):int
		{
			if (arg1 <= 0) 
			{
				return 1;
			}
			this.num = arg1;
			this.free();
			RectManager.stage = stage;
			RectManager.setRectNum(arg1);
			var loc1:*=0;
			while (loc1 < this.num) 
			{
				this.rect[loc1] = RectManager.Rect[loc1];
				if (this.vod[loc1] == null) 
				{
					this.vod[loc1] = new Player();
					this.vod[loc1].updatePic(this.cfg);
					addChildAt(this.vod[loc1], 0);
					this.vod[loc1].addEventListener(PlayerEvent.CLICK, this.selectVod);
					this.vod[loc1].addEventListener(PlayerEvent.DOUBLE_CLICK, this.vodFull);
					this.vod[loc1].addEventListener(PlayerEvent.ALLTIME, this.getAlltime);
					this.vod[loc1].addEventListener(PlayEvent.SOUND, this.onSound);
					this.vod[loc1].addEventListener(PlayEvent.FULL, this.onFull);
					this.vod[loc1].addEventListener(PlayEvent.NORM, this.onNorm);
				}
				this.vod[loc1].setRect(this.rect[loc1]);
				//this.vod[loc1].setNorm();
				this.vod[loc1].id = loc1;
				//this.vod[loc1].disvol();
				this.vod[loc1].visible = true;
				this.vod[loc1].hideBorder();
				++loc1;
			}
			if (this.num != 1) 
			{
				if (this.num > 1 && (this.currVod == null || this.currVod.id > (this.num - 1))) 
				{
					this.selectVideo(0);
				}
				else 
				{
					this.currVod.showBorder();
				}
			}
			else 
			{
				this.vod[0].hideBorder();
			}

			return 0;
		}
		
		public function stopVideo(arg1:int):int
		{
			if (arg1 < 0) 
			{
				return 3;
			}
			if (this.num == 0) 
			{
				return 1;
			}
			if (arg1 >= this.vod.length) 
			{
				return 2;
			}
			if (this.vod[arg1] == null) 
			{
				return 4;
			}
			var loc1:*=0;
			while (loc1 < this.vod.length) 
			{
				this.vod[loc1].reSize();
				++loc1;
			}
			this.vod[arg1].Stop();
			return 0;
		}
		
		public function pauseVideo(arg1:int):int
		{
			if (arg1 < 0) 
			{
				return 3;
			}
			if (this.num == 0) 
			{
				return 1;
			}
			if (arg1 >= this.num) 
			{
				return 2;
			}
			if (this.vod[arg1] == null) 
			{
				return 4;
			}
			this.vod[arg1].Paus();
			if (this.currVod.id == arg1) 
			{
				//this.tools.setVod(this.currVod);
			}
			return 0;
		}
		
		private function resizeVod():void
		{
			var loc2:*=undefined;
			if (stage.displayState == flash.display.StageDisplayState.FULL_SCREEN) 
			{
				loc2 = 0;
				while (loc2 < this.vod.length) 
				{
					if (this.vod[loc2] != null) 
					{
						this.vod[loc2].CtrlPan.btnFull.onFull();
					}
					++loc2;
				}
				flash.external.ExternalInterface.call("onVideoMsg", "" + 0 + "", "WindowFull");
			}
			else 
			{
				//this.tools.setNorm();
				loc2 = 0;
				while (loc2 < this.vod.length) 
				{
					if (this.vod[loc2] != null) 
					{
						this.vod[loc2].CtrlPan.btnFull.onNorm();
					}
					++loc2;
				}
				flash.external.ExternalInterface.call("onVideoMsg", "" + 0 + "", "WindowNorm");
			}
			RectManager.stage = stage;
			RectManager.reSizeVideo();
			var loc1:*=0;
			while (loc1 < this.num) 
			{
				if (this.vod[loc1] != null) 
				{
					this.vod[loc1].reSize();
				}
				++loc1;
			}
			if (this.currVod != null) 
			{
				this.currVod.showBorder();
			}
			return;
		}
		
		function refreshTime(arg1:flash.events.Event):void
		{
			if (this.currVod == null) 
			{
				return;
			}
			//this.tools.setTime(this.currVod.getPos());
			return;
		}
		
		function getAlltime(arg1:PlayerEvent):void
		{
			if (this.currVod == arg1.target) 
			{
				//this.tools.setVod(this.currVod);
			}
			return;
		}
		
		function vodFull(arg1:PlayerEvent):void
		{
			trace("main Set full  ...");
			var loc1:*=undefined;
			var loc2:*=undefined;
			if (this.num <= 1) 
			{
				return;
			}
			if (this.vod[arg1.currentTarget.id].isfull) 
			{
				loc1 = 0;
				while (loc1 < this.num) 
				{
					if (this.vod[loc1] != null) 
					{
						this.vod[loc1].visible = true;
					}
					++loc1;
				}
				this.vod[arg1.currentTarget.id].isfull = false;
				this.vod[arg1.currentTarget.id].reSize();
				this.vod[arg1.currentTarget.id].showBorder();
				flash.external.ExternalInterface.call("onVideoMsg", "" + arg1.currentTarget.id + "", "norm");
			}
			else 
			{
				if (this.currVod != null) 
				{
					this.currVod.hideBorder();
				}
				loc2 = 0;
				while (loc2 < this.num) 
				{
					if (arg1.currentTarget.id == loc2) 
					{
						this.vod[loc2].setFull();
					}
					else if (this.vod[loc2] != null) 
					{
						this.vod[loc2].visible = false;
					}
					++loc2;
				}
				flash.external.ExternalInterface.call("onVideoMsg", "" + arg1.currentTarget.id + "", "full");
			}
			this.currVod = this.vod[arg1.currentTarget.id];
			//this.tools.setVod(this.currVod);
			return;
		}
		
		function onFull(arg1:PlayEvent):void
		{
			flash.external.ExternalInterface.call("onVideoMsg", "" + arg1.currentTarget.id + "", "WindowFull");
			stage.displayState = flash.display.StageDisplayState.FULL_SCREEN;
			var loc1:*=0;
			while (loc1 < this.vod.length) 
			{
				if (this.vod[loc1] != null) 
				{
					this.vod[loc1].CtrlPan.btnFull.onFull();
				}
				++loc1;
			}
			return;
		}
		
		function onNorm(arg1:PlayEvent):void
		{
			flash.external.ExternalInterface.call("onVideoMsg", "" + arg1.currentTarget.id + "", "WindowNorm");
			stage.displayState = flash.display.StageDisplayState.NORMAL;
			var loc1:*=0;
			while (loc1 < this.vod.length) 
			{
				if (this.vod[loc1] != null) 
				{
					this.vod[loc1].CtrlPan.btnFull.onNorm();
				}
				++loc1;
			}
			return;
		}
		
		function onSound(arg1:PlayEvent):void
		{
			this.disAllSound();
			arg1.currentTarget.ablevol();
			this.stopListen();
			this.stopTalkback();
			return;
		}
		
		function selectVideo(arg1:int):void
		{
			var loc1:*=0;
			while (loc1 < this.vod.length) 
			{
				this.vod[loc1].hideBorder();
				++loc1;
			}
			this.currVod = this.vod[arg1];
			if (this.vod.length > 1) 
			{
				this.currVod.showBorder();
			}
			if (this.currVod.isPlaying) 
			{
				this.disAllSound();
				this.currVod.ablevol();
			}
			//this.tools.setVod(this.currVod);
			flash.external.ExternalInterface.call("onVideoMsg", "" + arg1 + "", "select");
			return;
		}
		
		function selectVod(arg1:PlayerEvent):void
		{
			trace("selectVod");
			if (this.num <= 1) 
			{
				return;
			}
			this.selectVideo(arg1.currentTarget.id);
			return;
		}
		
		function disAllSound():*
		{
			var loc1:*=0;
			while (loc1 < this.vod.length) 
			{
				if (this.vod[loc1] != null) 
				{
					this.vod[loc1].disvol();
				}
				++loc1;
			}
			return;
		}
		
		function free():void
		{
			var loc1:*=0;
			while (loc1 < this.num) 
			{
				if (this.vod[loc1] != null) 
				{
					this.vod[loc1].visible = true;
				}
				++loc1;
			}
			var loc2:*=this.num;
			while (loc2 < this.vod.length) 
			{
				if (this.vod[loc2] != null) 
				{
					this.vod[loc2].visible = false;
				}
				++loc2;
			}
			return;
		}
		
		function setPIC(arg1:ConfigEvent):void
		{
			var loc1:*=0;
			while (loc1 < this.num) 
			{
				if (this.vod[loc1] != null) 
				{
					this.vod[loc1].updatePic(this.cfg);
				}
				++loc1;
			}
			return;
		}
		
		function setVideoInfo(arg1:int, arg2:String):int
		{
			if (arg1 < 0) 
			{
				return 3;
			}
			if (this.num == 0) 
			{
				return 1;
			}
			if (arg1 >= this.num) 
			{
				return 2;
			}
			if (this.vod[arg1] == null) 
			{
				return 4;
			}
			if (this.vod[arg1] != null) 
			{
				this.vod[arg1].setVideoInfo(arg2);
			}
			return 0;
		}
		
		function updateUiText(arg1:LangEvent):void
		{
			//this.tools.updateUiText(this.lang);
			var loc1:*=0;
			while (loc1 < this.num) 
			{
				if (this.vod[loc1] != null) 
				{
					this.vod[loc1].updateUiText(this.lang);
				}
				++loc1;
			}
			return;
		}
		
		public function setVideoFrame(arg1:int, arg2:String):int
		{
			if (arg1 < 0) 
			{
				return 3;
			}
			if (this.num == 0) 
			{
				return 1;
			}
			if (arg1 >= this.vod.length) 
			{
				return 2;
			}
			if (this.vod[arg1] == null) 
			{
				return 4;
			}
			if (this.vod[arg1] != null) 
			{
				this.vod[arg1].WH = arg2;
				this.vod[arg1].reSize();
				return 0;
			}
			return 0;
		}
		
		public function setBufferTime(arg1:int, arg2:Number):int
		{
			if (arg1 < 0) 
			{
				return 3;
			}
			if (this.num == 0) 
			{
				return 1;
			}
			if (arg1 >= this.num) 
			{
				return 2;
			}
			if (this.vod[arg1] == null) 
			{
				return 4;
			}
			if (arg2 <= 0) 
			{
				return 5;
			}
			if (this.vod[arg1] != null) 
			{
				this.vod[arg1].setBufferTime(arg2);
			}
			return 0;
		}
		
		public function setBufferTimeMax(arg1:int, arg2:Number):int
		{
			if (arg1 < 0) 
			{
				return 3;
			}
			if (this.num == 0) 
			{
				return 1;
			}
			if (arg1 >= this.num) 
			{
				return 2;
			}
			if (this.vod[arg1] == null) 
			{
				return 4;
			}
			if (arg2 <= 0) 
			{
				return 5;
			}
			if (this.vod[arg1] != null) 
			{
				this.vod[arg1].setBufferTimeMax(arg2);
			}
			return 0;
		}
		
		public function reSetVideo(arg1:int):*
		{
			if (arg1 < 0) 
			{
				return 3;
			}
			if (this.num == 0) 
			{
				return 1;
			}
			if (arg1 >= this.vod.length) 
			{
				return 2;
			}
			if (this.vod[arg1] == null) 
			{
				return 4;
			}
			var loc1:*=0;
			while (loc1 < this.vod.length) 
			{
				this.vod[loc1].reSize();
				++loc1;
			}
			if (this.vod[arg1] != null) 
			{
				this.vod[arg1].reSet();
			}
			return 0;
		}
		
		public function setVideoFocus(arg1:int):int
		{
			if (arg1 < 0) 
			{
				return 3;
			}
			if (this.num == 0) 
			{
				return 1;
			}
			if (arg1 >= this.num) 
			{
				return 2;
			}
			if (this.vod[arg1] == null) 
			{
				return 4;
			}
			this.selectVideo(arg1);
			return 0;
		}
	}
}
