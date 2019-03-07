package com.hlet
{
	import flash.display.*;
	import flash.events.*;
	import com.hlet.event.*;
	
	public class SoundBar extends flash.display.MovieClip
	{
		public var speaker:flash.display.MovieClip;		
		public var volBar:Vol;		
		public var vol:Number;		
		var stat:Boolean;		
		public var defaultVol:Number=0.8;		
		public var lang:Array;
		
		public function SoundBar()
		{
			super();
			this.lang = new Array();
			this.lang[0] = "取消静音";
			this.lang[1] = "静音";
			this.stat = false;
			this.vol = this.defaultVol;
			this.setVolume(this.vol);
			this.speaker.addEventListener(flash.events.MouseEvent.CLICK, this.noSound);
			this.speaker.buttonMode = true;
			this.speaker.jy.visible = false;
			this.speaker.addEventListener(flash.events.MouseEvent.MOUSE_OVER, this.showJY);
			this.speaker.addEventListener(flash.events.MouseEvent.MOUSE_OUT, this.hideJY);
			return;
		}
		
		public function setLable(arg1:String, arg2:String):void
		{
			this.lang[0] = arg1;
			this.lang[1] = arg2;
			if (this.stat) 
			{
				this.speaker.jy.setText(this.lang[0]);
			}
			else 
			{
				this.speaker.jy.setText(this.lang[1]);
			}
			return;
		}
		
		public function setVolume(arg1:Number):void
		{
			this.vol = arg1;
			var loc1:*=Math.ceil(100 * this.vol / 33) + 1;
			if (loc1 > 4) 
			{
				loc1 = 4;
			}
			this.speaker.gotoAndStop(loc1);
			this.speaker.jy.visible = false;
			if (this.vol != 0) 
			{
				this.stat = false;
				this.speaker.jy.setText(this.lang[1]);
			}
			else 
			{
				this.stat = true;
				this.speaker.jy.setText(this.lang[0]);
			}
			this.volBar.setVol(arg1);
			return;
		}
		
		public function stopdrag():void
		{
			this.volBar.stopdrag();
			return;
		}
		
		public function setVol(arg1:Number):void
		{
			this.vol = arg1;
			if (arg1 == 0) 
			{
				this.stat = true;
			}
			var loc1:*=Math.ceil(100 * this.vol / 33) + 1;
			if (loc1 > 4) 
			{
				loc1 = 4;
			}
			this.speaker.gotoAndStop(loc1);
			this.speaker.jy.visible = false;
			if (this.vol != 0) 
			{
				this.stat = false;
			}
			else 
			{
				this.stat = true;
			}
			return;
		}
		
		function noSound(arg1:flash.events.MouseEvent):void
		{
			var loc1:*=undefined;
			if (this.stat) 
			{
				if (this.vol <= 0) 
				{
					this.vol = this.defaultVol;
				}
				loc1 = Math.ceil(100 * this.vol / 33) + 1;
				if (loc1 > 4) 
				{
					loc1 = 4;
				}
				this.speaker.gotoAndStop(loc1);
				this.volBar.setVol(this.vol);
				dispatchEvent(new VolEvent(this.vol));
				this.stat = false;
			}
			else 
			{
				this.speaker.gotoAndStop(1);
				this.volBar.setVol(0);
				dispatchEvent(new VolEvent(0));
				this.stat = true;
			}
			if (this.stat) 
			{
				this.speaker.jy.setText(this.lang[0]);
			}
			else 
			{
				this.speaker.jy.setText(this.lang[1]);
			}
			return;
		}
		
		public function sendVol():void
		{
			if (this.vol != 0) 
			{
				this.stat = false;
			}
			else 
			{
				this.stat = true;
			}
			dispatchEvent(new VolEvent(this.vol));
			return;
		}
		
		function showJY(arg1:flash.events.MouseEvent):void
		{
			if (this.stat) 
			{
				this.speaker.jy.setText(this.lang[0]);
			}
			else 
			{
				this.speaker.jy.setText(this.lang[1]);
			}
			this.speaker.jy.visible = true;
			return;
		}
		
		function hideJY(arg1:flash.events.MouseEvent):void
		{
			this.speaker.jy.visible = false;
			return;
		}
	}
}
