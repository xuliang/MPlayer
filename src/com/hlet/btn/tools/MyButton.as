package com.hlet.btn.tools
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class MyButton extends flash.display.MovieClip
	{
		public var lable:flash.text.TextField=new TextField();
		public function MyButton()
		{
			super();
			this.buttonMode = true;
			this.mouseChildren = false;
			stop();
			this.lable.visible = false;
			addEventListener(flash.events.MouseEvent.MOUSE_OVER, this.msover);
			addEventListener(flash.events.MouseEvent.MOUSE_OUT, this.msout);
			return;
		}
		
		public function disable():void
		{
			gotoAndStop(3);
			return;
		}
		
		public function enable():void
		{
			gotoAndStop(1);
			this.lable.visible = false;
			return;
		}
		
		function msover(arg1:flash.events.MouseEvent):void
		{
			if (currentFrame == 3) 
			{
				return;
			}
			gotoAndStop(2);
			this.lable.visible = true;
			return;
		}
		
		function msout(arg1:flash.events.MouseEvent):void
		{
			if (currentFrame == 3) 
			{
				return;
			}
			gotoAndStop(1);
			this.lable.visible = false;
			return;
		}
		
		function setLable(arg1:String):void
		{
			this.lable.text = arg1;
			return;
		}
	}
}
