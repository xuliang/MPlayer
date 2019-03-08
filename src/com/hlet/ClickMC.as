package com.hlet
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import mx.core.BitmapAsset;
	
	public class ClickMC extends flash.display.Sprite
	{
		//public var mc:flash.display.MovieClip=new MovieClip();	
		var mc:Bitmap = new Bitmap();
		var Rect:*;		
		public var isFull:*=false;
		
		[Embed(source="../images/msk.jpg")]  
		[Bindable]    
		private var bg:Class;
		public function ClickMC()
		{
			super();
			var data:BitmapData = BitmapAsset(new bg()).bitmapData;
			mc.bitmapData = data;
			this.mc.alpha = 0;
			//mc = new bg();
			addChild(mc);
			return;
		}
		
		public function setRect(arg1:RECT):void
		{
			this.mouseChildren = false;
			this.doubleClickEnabled = true;
			this.Rect = arg1;
			return;
		}
		
		public function reSize():void
		{
			if (this.isFull) 
			{
//				this.mc.x = (-(this.Rect.sw - 550)) / 2;
//				this.mc.y = (-(this.Rect.sh - 400)) / 2;
				this.mc.x = 1;
				this.mc.y = 1;
				this.mc.height = this.Rect.sh;
				this.mc.width = this.Rect.sw;
			}
			else 
			{
				this.mc.x = this.Rect.rx;
				this.mc.y = this.Rect.ry;
				this.mc.height = this.Rect.rh;
				this.mc.width = this.Rect.rw;
			}
			return;
		}
		
		public function Show():*
		{
			trace("show mask");
			this.mc.alpha = 0.7;
			return;
		}
		
		public function Hide():*
		{
			this.mc.alpha = 0;
			return;
		}
	}
}
