package com.hlet
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Logo extends flash.display.Sprite
	{
		public var logoTxt:flash.text.TextField=new TextField();		
		public var px:Number=0;
		public var py:Number=0;		
		var ld:flash.display.Loader;		
		public var Rect:*;		
		public var isFull:*=false;
		
		public function Logo()
		{
			super();
			this.logoTxt.visible = false;
			return;
		}
		
		public function reSet():*
		{
			this.logoTxt.visible = false;
			this.logoTxt.textColor = 0;
			this.logoTxt.text = "";
			return;
		}
		
		public function setRect(arg1:RECT):void
		{
			this.Rect = arg1;
			return;
		}
		
		public function reSize():void
		{
			if (this.isFull) 
			{
//				this.x = (-(this.Rect.sw - 550)) / 2;
//				this.y = (-(this.Rect.sh - 400)) / 2;
				this.x = 1;
				this.y = 1;
			}
			else 
			{
				this.x = this.Rect.rx;
				this.y = this.Rect.ry;
			}
			return;
		}
		
		function oncmp(arg1:flash.events.Event):void
		{
			addChild(this.ld);
			this.reSize();
			return;
		}
		
		public function updatePic(arg1:Config):void
		{
			if (arg1.logo == "") 
			{
				return;
			}
			if (this.ld != null) 
			{
				removeChild(this.ld);
				this.ld = null;
			}
			this.ld = new flash.display.Loader();
			this.ld.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, this.oncmp);
			var loc1:*=new flash.net.URLRequest(arg1.logo);
			this.ld.load(loc1);
			return;
		}
		
		function setTxt(arg1:String, arg2:Number, arg3:int, arg4:int, arg5:int):void
		{
			this.logoTxt.visible = true;
			this.logoTxt.textColor = arg2;
			this.logoTxt.text = arg1;
			var loc1:*=new flash.text.TextFormat();
			loc1.size = arg5;
			this.logoTxt.setTextFormat(loc1);
			this.logoTxt.x = arg3;
			this.logoTxt.y = arg4;
			this.reSize();
			return;
		}
		
		public function setLogo(arg1:String, arg2:int, arg3:int):void
		{
			if (this.ld != null) 
			{
				removeChild(this.ld);
				this.ld = null;
			}
			this.ld = new flash.display.Loader();
			this.ld.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, this.oncmp);
			var loc1:*=new flash.net.URLRequest(arg1);
			this.ld.load(loc1);
			this.ld.x = arg2;
			this.ld.y = arg3;
			return;
		}
	}
}