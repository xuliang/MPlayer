package com.hlet
{
	import com.hlet.btn.tools.FastNextButton;
	import com.hlet.btn.tools.FastPrevButton;
	import com.hlet.event.TimeEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	public class TimeBar extends flash.display.MovieClip
	{		
		public var timeMc:flash.display.MovieClip;		
		public var time1:flash.text.TextField;		
		public var time2:flash.text.TextField;		
		public var fnxt:FastNextButton;		
		public var timeprogress:flash.display.MovieClip;		
		public var btnpro:flash.display.MovieClip=new MovieClip();		
		public var fpre:FastPrevButton;		
		var curr:Number;		
		public var alltime:Number;		
		var rect:flash.geom.Rectangle;		
		var sx:Number;		
		var oldx:Number;		
		var w:Number;		
		var tBar:*;		
		var isDrag:Boolean;		
		var fastStep:Number=new Number();
		
		public function TimeBar()
		{
			super();
			this.fastStep = 5;
			this.curr = 0;
			this.isDrag = false;
			this.btnpro.stop();
			this.timeMc.visible = false;
			this.btnpro.buttonMode = true;
			this.buttonMode = true;
			this.sx = this.btnpro.x;
			this.w = this.timeprogress.width - this.btnpro.width;
			this.rect = new flash.geom.Rectangle(this.btnpro.x, this.btnpro.y, this.w, 0);
			this.tBar = this.timeprogress.timebar;
			this.tBar.x = -this.tBar.width;
			this.setAlltime(0);
			return;
		}
		
		function showTimeBar():void
		{
			this.timeprogress.visible = true;
			this.fpre.visible = true;
			this.fnxt.visible = true;
			this.btnpro.visible = true;
			this.time2.visible = true;
			return;
		}
		
		function addEvent():void
		{
			this.timeprogress.addEventListener(flash.events.MouseEvent.CLICK, this.timeBarClick);
			this.btnpro.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, this.dragSrart);
			this.btnpro.addEventListener(flash.events.MouseEvent.MOUSE_UP, this.dragEnd);
			this.btnpro.addEventListener(flash.events.MouseEvent.MOUSE_OVER, this.btnpromsover);
			this.btnpro.addEventListener(flash.events.MouseEvent.MOUSE_OUT, this.btnpromsout);
			this.fpre.addEventListener(flash.events.MouseEvent.CLICK, this.fastPre);
			this.fnxt.addEventListener(flash.events.MouseEvent.CLICK, this.fastNxt);
			return;
		}
		
		function removeEvent():void
		{
			this.timeprogress.removeEventListener(flash.events.MouseEvent.CLICK, this.timeBarClick);
			this.btnpro.removeEventListener(flash.events.MouseEvent.MOUSE_DOWN, this.dragSrart);
			this.btnpro.removeEventListener(flash.events.MouseEvent.MOUSE_UP, this.dragEnd);
			this.btnpro.removeEventListener(flash.events.MouseEvent.MOUSE_OVER, this.btnpromsover);
			this.btnpro.removeEventListener(flash.events.MouseEvent.MOUSE_OUT, this.btnpromsout);
			this.fpre.removeEventListener(flash.events.MouseEvent.CLICK, this.fastPre);
			this.fnxt.removeEventListener(flash.events.MouseEvent.CLICK, this.fastNxt);
			return;
		}
		
		function timeBarClick(arg1:flash.events.Event):void
		{
			var loc1:*=mouseX - this.timeprogress.x - 4;
			this.btnpro.x = this.sx + loc1;
			this.curr = 4 + (this.alltime + 1) * loc1 / this.w;
			this.tBar.x = this.tBar.width * loc1 / this.w - this.tBar.width;
			dispatchEvent(new TimeEvent(this.curr));
			return;
		}
		
		public function stopdrag():void
		{
			if (!this.isDrag) 
			{
				return;
			}
			this.btnpro.stopDrag();
			this.isDrag = false;
			this.timeMc.visible = false;
			this.removeEventListener(flash.events.Event.ENTER_FRAME, this.refreshTime);
			dispatchEvent(new TimeEvent(this.curr));
			return;
		}
		
		public function setTime(arg1:Number):void
		{
			if (this.isDrag) 
			{
				return;
			}
			this.curr = arg1;
			this.refreshTime2();
			return;
		}
		
		function fastPre(arg1:flash.events.MouseEvent):void
		{
			this.curr = this.curr - 5;
			if (this.curr < 0) 
			{
				this.curr = 0;
			}
			this.refreshTime2();
			dispatchEvent(new TimeEvent(this.curr));
			return;
		}
		
		function fastNxt(arg1:flash.events.MouseEvent):void
		{
			this.curr = this.curr + 5;
			if (this.curr > this.alltime) 
			{
				this.curr = this.alltime;
			}
			this.refreshTime2();
			dispatchEvent(new TimeEvent(this.curr));
			return;
		}
		
		function btnpromsover(arg1:flash.events.MouseEvent):void
		{
			this.btnpro.gotoAndStop(2);
			return;
		}
		
		function btnpromsout(arg1:flash.events.MouseEvent):void
		{
			this.btnpro.gotoAndStop(1);
			return;
		}
		
		function refreshTime(arg1:flash.events.Event):void
		{
			var loc1:*=this.btnpro.x - this.sx;
			this.curr = 4 + (this.alltime + 1) * loc1 / this.w;
			var loc2:*=int(this.curr / 3600);
			var loc3:*=int((this.curr - loc2 * 3600) / 60);
			var loc4:*=int(this.curr - loc2 * 3600 - loc3 * 60);
			this.timeMc.Time.text = loc2 + ":" + loc3 + ":" + loc4;
			if (this.btnpro.x <= (550 - stage.stageWidth) / 2 + 35) 
			{
				this.timeMc.x = (550 - stage.stageWidth) / 2 + 35;
			}
			else if (this.btnpro.x >= 275 + stage.stageWidth / 2 - 40) 
			{
				this.timeMc.x = 275 + stage.stageWidth / 2 - 40;
			}
			else 
			{
				this.timeMc.x = this.btnpro.x;
			}
			this.tBar.x = this.tBar.width * loc1 / this.w - this.tBar.width;
			if (this.alltime > 0) 
			{
				this.time1.text = this.formToTimeString(this.curr) + " |";
			}
			else 
			{
				this.time1.text = this.formToTimeString(this.curr);
			}
			return;
		}
		
		function refreshTime2():void
		{
			var loc1:*=undefined;
			var loc2:*=undefined;
			var loc3:*=undefined;
			var loc4:*=undefined;
			if (this.alltime > 0) 
			{
				loc1 = this.w * this.curr / (this.alltime + 1);
				this.btnpro.x = this.sx + loc1;
				loc2 = int(this.curr / 3600);
				loc3 = int((this.curr - loc2 * 3600) / 60);
				loc4 = int(this.curr - loc2 * 3600 - loc3 * 60);
				this.timeMc.Time.text = loc2 + ":" + loc3 + ":" + loc4;
				if (this.btnpro.x <= (550 - stage.stageWidth) / 2 + 35) 
				{
					this.timeMc.x = (550 - stage.stageWidth) / 2 + 35;
				}
				else if (this.btnpro.x >= 275 + stage.stageWidth / 2 - 40) 
				{
					this.timeMc.x = 275 + stage.stageWidth / 2 - 40;
				}
				else 
				{
					this.timeMc.x = this.btnpro.x;
				}
				this.tBar.x = this.tBar.width * loc1 / this.w - this.tBar.width;
			}
			if (this.alltime > 0) 
			{
				this.time1.text = this.formToTimeString(this.curr) + " |";
			}
			else 
			{
				this.time1.text = this.formToTimeString(this.curr);
			}
			return;
		}
		
		function dragSrart(arg1:flash.events.MouseEvent):void
		{
			this.btnpro.startDrag(false, this.rect);
			this.isDrag = true;
			this.addEventListener(flash.events.Event.ENTER_FRAME, this.refreshTime);
			this.timeMc.visible = true;
			return;
		}
		
		function dragEnd(arg1:flash.events.MouseEvent):void
		{
			this.btnpro.stopDrag();
			this.timeMc.visible = false;
			this.isDrag = false;
			this.removeEventListener(flash.events.Event.ENTER_FRAME, this.refreshTime);
			dispatchEvent(new TimeEvent(this.curr));
			return;
		}
		
		public function changeSize():void
		{
			var loc1:*=stage.stageWidth;
			this.fpre.x = 275 - loc1 / 2;
			this.fnxt.x = 540 + loc1 / 2 - 275;
			this.timeprogress.x = this.fpre.x + 10;
			this.timeprogress.timeBarBB.width = stage.stageWidth - 20;
			this.timeprogress.timeBarMask.width = stage.stageWidth - 20;
			this.timeprogress.timebar.width = stage.stageWidth - 20;
			this.rect = null;
			this.w = this.timeprogress.timeBarBB.width - this.btnpro.width;
			this.rect = new flash.geom.Rectangle(this.timeprogress.x + 4, this.btnpro.y, this.w, 0);
			this.sx = this.timeprogress.x + 5;
			var loc2:*=this.curr / (this.alltime + 1) * this.w;
			this.btnpro.x = this.sx + loc2;
			this.tBar.x = this.tBar.width * this.curr / (this.alltime + 1) - this.tBar.width;
			this.time1.x = this.fpre.x + 90;
			this.time2.x = this.time1.x + this.time1.width;
			return;
		}
		
		function formToTimeString(arg1:Number, arg2:String=":", arg3:String=":"):String
		{
			var loc1:*=arg1 / 60 / 60 >> 0;
			var loc2:*=arg1 / 60 % 60;
			var loc3:*=arg1 % 60;
			var loc4:*="";
			loc4 = loc4 + ((loc1 > 100 ? loc1.toString() : (100 + loc1).toString().substr(1)) + arg2);
			loc4 = loc4 + ((loc2 < 10 ? "0" + loc2.toString() : loc2.toString()) + arg3);
			loc4 = loc4 + (loc3 < 10 ? "0" + loc3.toString() : loc3.toString());
			return loc4;
		}
		
		public function setAlltime(arg1:Number):void
		{
			if (arg1 > 0) 
			{
				this.alltime = arg1;
				var loc1:*;
				this.time1.text = loc1 = this.formToTimeString(this.alltime);
				this.time2.text = loc1;
				this.addEvent();
				this.showTimeBar();
			}
			else 
			{
				this.alltime = 0;
				this.time1.text = loc1 = this.formToTimeString(this.alltime);
				this.time2.text = loc1;
				this.btnpro.x = this.sx + this.w;
				this.tBar.x = 0;
				this.removeEvent();
				this.hideTimeBar();
			}
			return;
		}
		
		function hideTimeBar():void
		{
			this.timeprogress.visible = false;
			this.fpre.visible = false;
			this.fnxt.visible = false;
			this.btnpro.visible = false;
			this.time2.visible = false;
			return;
		}
	}
}
