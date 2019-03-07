package com.hlet
{
	import flash.events.*;
	import flash.external.*;
	import flash.net.*;
	import com.hlet.event.*;
	
	public class Language extends flash.events.EventDispatcher
	{
		public var pausTxt:String="暂停";		
		public var playTxt:String="播放";		
		public var stopTxt:String="停止";		
		public var fastPre:String="快退";		
		public var fastNxt:String="快进";		
		public var disableSound:String="静音";		
		public var enableSound:String="取消静音";		
		public var full:String="全屏";		
		public var norm:String="正常";		
		public var ontalk:String="启动对讲";		
		public var offtalk:String="停止对讲";		
		public var oncamera:String="切换摄像头";		
		public var offcamera:String="切换摄像头";		
		public var loading:*="正在缓冲";		
		public var connect:String="正在连接";		
		public var connectError:String="无法连接";		
		public var offLine:String="当前设备不在线";		
		public var waiting:String="";		
		public var capTxt:String="抓取图像";		
		var ld:flash.net.URLLoader;
		
		public function Language()
		{
			super();
			this.ld = new flash.net.URLLoader();
			this.ld.addEventListener(flash.events.Event.COMPLETE, this.cmp);
			flash.external.ExternalInterface.addCallback("setLanguage", this.setLanguage);
			return;
		}
		
		public function setLanguage(arg1:String):void
		{
			var loc1:*=new flash.net.URLRequest(arg1);
			this.ld.load(loc1);
			return;
		}
		
		function cmp(arg1:flash.events.Event):void
		{
			var loc1:*=XML(this.ld.data);
			this.pausTxt = loc1.attribute("pausTxt");
			this.playTxt = loc1.attribute("playTxt");
			this.stopTxt = loc1.attribute("stopTxt");
			this.fastPre = loc1.attribute("fastPre");
			this.fastNxt = loc1.attribute("fastNxt");
			this.disableSound = loc1.attribute("disableSound");
			this.enableSound = loc1.attribute("enableSound");
			this.full = loc1.attribute("full");
			this.norm = loc1.attribute("norm");
			this.ontalk = loc1.attribute("ontalk");
			this.offtalk = loc1.attribute("offtalk");
			this.oncamera = loc1.attribute("oncamer");
			this.offcamera = loc1.attribute("offcamer");
			this.loading = loc1.attribute("loading");
			this.connect = loc1.attribute("connect");
			this.connectError = loc1.attribute("connectError");
			this.offLine = loc1.attribute("offLine");
			this.waiting = loc1.attribute("waiting");
			this.capTxt = loc1.attribute("captxt");
			dispatchEvent(new LangEvent());
			return;
		}
	}
}
