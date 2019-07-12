package com.hlet
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class Vol extends flash.display.MovieClip
	{
		public var volMc:flash.display.MovieClip=new MovieClip();
		public var volbtn:flash.display.MovieClip=new MovieClip();
		var rect:flash.geom.Rectangle;
		var v:Number;
		var sx:Number;
		var oldx:Number;
		var w:Number;
		var isDrag:Boolean;
		
		public function Vol()
		{
			super();
			this.isDrag = false;
			this.sx = this.volbtn.x;
			//this.volMc.visible = false;
			this.w = 86;
			this.rect = new flash.geom.Rectangle(this.volbtn.x, (this.volbtn.y - 1), this.w, 150);
			this.buttonMode = true;
			this.addEventListener(flash.events.MouseEvent.CLICK, this.changeVol);
			this.volbtn.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, this.dragSrart);
			this.volbtn.addEventListener(flash.events.MouseEvent.MOUSE_UP, this.dragEnd);
			
			addChild(volMc);
			addChild(volbtn);
			return;
		}
		
		public function setVol(arg1:Number):void
		{
			this.v = arg1;
			gotoAndStop(int(arg1 * 100));
			var loc1:*;
			this.volbtn.x = loc1 = this.sx + this.w * arg1;
			this.oldx = loc1;
			return;
		}
		
		public function stopdrag():void
		{
			if (!this.isDrag) 
			{
				return;
			}
			this.volbtn.stopDrag();
			this.isDrag = false;
			this.removeEventListener(flash.events.Event.ENTER_FRAME, this.refreshVol);
			this.volMc.visible = false;
			Object(parent).sendVol();
			return;
		}
		
		function changeVol(arg1:flash.events.MouseEvent):void
		{
			var loc1:*=mouseX - this.x;
			this.volbtn.x = this.sx + loc1 - 6;
			this.oldx = this.volbtn.x;
			this.v = (this.oldx - this.sx) / this.w;
			if (this.v < 0) 
			{
				this.v = 0;
			}
			gotoAndStop(int(this.v * 101));
			this.volMc.volNum.text = int(this.v * 101) + "%";
			this.volMc.x = this.oldx;
			Object(parent).setVol(this.v);
			Object(parent).sendVol();
			return;
		}
		
		function refreshVol(arg1:flash.events.Event):void
		{
			if (this.oldx == this.volbtn.x) 
			{
				return;
			}
			this.oldx = this.volbtn.x;
			this.v = (this.oldx - this.sx) / this.w;
			if (this.v < 0) 
			{
				this.v = 0;
			}
			gotoAndStop(int(this.v * 101));
			this.volMc.volNum.text = int(this.v * 101) + "%";
			this.volMc.x = this.oldx;
			Object(parent).setVol(this.v);
			return;
		}
		
		function dragSrart(arg1:flash.events.MouseEvent):void
		{
			this.volbtn.gotoAndStop(2);
			this.volbtn.startDrag(false, this.rect);
			this.isDrag = true;
			this.volMc.visible = true;
			this.addEventListener(flash.events.Event.ENTER_FRAME, this.refreshVol);
			return;
		}
		
		function dragEnd(arg1:flash.events.MouseEvent):void
		{
			this.volbtn.gotoAndStop(1);
			this.volbtn.stopDrag();
			this.isDrag = false;
			this.removeEventListener(flash.events.Event.ENTER_FRAME, this.refreshVol);
			this.volMc.visible = false;
			Object(parent).sendVol();
			return;
		}

	}
}
