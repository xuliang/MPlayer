package com.hlet
{
	import flash.display.*;
	import flash.events.*;
	import flash.external.*;
	import flash.net.*;
	import com.hlet.event.*;
	
	public class Config extends flash.events.EventDispatcher
	{
		
		var ld:flash.net.URLLoader;		
		var rqst:flash.net.URLRequest;		
		var playerBG:String;		
		var logo:String;		
		var bg:*;
		[Bindable]
		[Embed(source="../images/player.jpg")]
		public var playerbg:Class;
		
		public function Config()
		{
			super();
			this.playerBG = "";
			this.logo = "";
			this.bg = new playerbg();
			this.ld = new flash.net.URLLoader();
			this.ld.addEventListener(flash.events.Event.COMPLETE, this.oncmp);
			flash.external.ExternalInterface.addCallback("setConfig", this.setConfig);
			return;
		}
		
		public function setConfig(arg1:String):void
		{
			var loc1:*=new flash.net.URLRequest(arg1);
			this.ld.load(loc1);
			return;
		}
		
		function oncmp(arg1:flash.events.Event):void
		{
			var loc1:*=XML(this.ld.data);
			this.playerBG = loc1.attribute("playerBG");
			this.logo = loc1.attribute("logo");
			if (this.bg != null) 
			{
				this.bg = null;
			}
			this.bg = new flash.display.Loader();
			this.bg.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, this.onloadBG);
			var loc2:*=new flash.net.URLRequest(this.playerBG);
			this.bg.load(loc2);
			return;
		}
		
		function onloadBG(arg1:flash.events.Event):void
		{
			trace("getBg");
			dispatchEvent(new ConfigEvent());
			return;
		}
		
		public function getBG():flash.display.Sprite
		{
			var loc1:*=new flash.display.Sprite();
			var loc2:*=new flash.display.BitmapData(this.bg.width, this.bg.height, true, 0);
			loc2.draw(this.bg);
			loc1.addChild(new flash.display.Bitmap(loc2));
			return loc1;
		}
	}
}
