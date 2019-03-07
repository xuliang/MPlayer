package com.hlet.btn
{
//	import com.hlet.Common;
	import com.hlet.event.PlayEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Camera extends flash.display.MovieClip
	{
		public var innerBtn1:InnerButtonCamera=new InnerButtonCamera();		
		//public var tip:Tip=new Tip();		
		var eb:*=false;
		
		public function Camera()
		{
			super();
			stop();
			addChild(innerBtn1);

			//this.tip.visible = false;
			//this.updateUiText();
			this.enable();
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
			this.eb = true;
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
			loc1.enable();
			this.eb = false;
			return;
		}
		
		function onclick(arg1:flash.events.Event):void
		{
			trace("Canera Onclick...");
			var loc1:*=undefined;
			loc1 = new PlayEvent("oncamer");
//			if (currentFrame != 1) 
//			{
//				gotoAndStop(1);
//				//this.tip.setText(Common.lang.oncamera);
//				this.innerBtn1.enable();
//				loc1 = new PlayEvent("offcamera");
//			}
//			else 
//			{
//				gotoAndStop(2);
//				//this.tip.setText(Common.lang.offcamera);
//				this.innerBtn2.enable();
//				loc1 = new PlayEvent("oncamera");
//			}
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
//			if (currentFrame != 2) 
//			{
//				this.tip.setText(Common.lang.offcamera);
//			}
//			else 
//			{
//				this.tip.setText(Common.lang.oncamera);
//			}
			return;
		}
	}
}
