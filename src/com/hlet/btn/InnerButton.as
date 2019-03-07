package com.hlet.btn
{
		import flash.display.*;
		import flash.events.*;
		
		public class InnerButton extends flash.display.MovieClip
		{
			private var able:Boolean=false;
			
			public function InnerButton()
			{
				super();
				//this.gotoAndStop(3);
				//this.switchFrame(3);
				return;
			}
			
			public function mson(arg1:flash.events.Event):void
			{
				if (this.able == false) 
				{
					return;
				}
				//this.gotoAndStop(2);
				this.switchFrame(2);
				return;
			}
			
			public function msout(arg1:flash.events.Event):void
			{
				//this.gotoAndStop(1);
				this.switchFrame(1);
				return;
			}
			
			public function disable():void
			{
				this.removeEventListener(flash.events.MouseEvent.MOUSE_OVER, this.mson);
				this.removeEventListener(flash.events.MouseEvent.MOUSE_OUT, this.msout);
				this.able = false;
				//this.gotoAndStop(3);
				this.switchFrame(3);
				return;
			}
			
			public function enable():void
			{
				this.able = true;
				//this.gotoAndStop(1);
				this.switchFrame(1);
				this.addEventListener(flash.events.MouseEvent.MOUSE_OVER, this.mson);
				this.addEventListener(flash.events.MouseEvent.MOUSE_OUT, this.msout);
				return;
			}
			
			
			public function switchFrame(index:int):void{
				
			}
		}
}
