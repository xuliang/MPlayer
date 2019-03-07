package com.hlet.btn
{
//	import com.hlet.Common;
	import com.hlet.event.PlayEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Capture extends flash.display.MovieClip
	{
		
		public var innerBtn1:InnerButtonCapture=new InnerButtonCapture();		
		//public var tip:Tip=new Tip();
		
		public function Capture()
		{
			super();
			stop();
			//addChild(tip);
			addChild(innerBtn1);
			//this.tip.visible = false;
			//this.updateUiText();
			this.disable();
			return;
		}
		
		public function enable():*
		{
			this.buttonMode = true;
			addEventListener(flash.events.MouseEvent.MOUSE_OVER, this.msover);
			addEventListener(flash.events.MouseEvent.MOUSE_OUT, this.msout);
			addEventListener(flash.events.MouseEvent.CLICK, this.onclick);
			//var loc1:*=this.getChildByName("innerBtn" + currentFrame);
			var loc1:*=this.getChildAt(0);
			loc1.enable();
			return;
		}
		
		public function disable():*
		{
			this.buttonMode = false;
			removeEventListener(flash.events.MouseEvent.MOUSE_OVER, this.msover);
			removeEventListener(flash.events.MouseEvent.MOUSE_OUT, this.msout);
			removeEventListener(flash.events.MouseEvent.CLICK, this.onclick);
			//var loc1:*=this.getChildByName("innerBtn" + currentFrame);
			var loc1:*=this.getChildAt(0);
			loc1.disable();
			return;
		}
		
		function onclick(arg1:flash.events.Event):void
		{
			var loc1:*=new PlayEvent("capture");
			dispatchEvent(loc1);
			arg1.stopPropagation();
			return;
		}
		
		function msover(arg1:flash.events.MouseEvent):void
		{
			//this.tip.visible = true;
			return;
		}
		
		function msout(arg1:flash.events.MouseEvent):void
		{
			//this.tip.visible = false;
			return;
		}
		
		public function updateUiText():void
		{
			//this.tip.setText(Common.lang.capTxt);
			return;
		}
	}
}