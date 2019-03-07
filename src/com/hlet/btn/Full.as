package com.hlet.btn
{
	//import com.hlet.Common;
	import com.hlet.event.PlayEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Full extends flash.display.MovieClip
	{
		public var innerBtn1:InnerButtonNormal=new InnerButtonNormal();		
		public var innerBtn0:InnerButtonFull=new InnerButtonFull();		
		//public var tip:Tip=new Tip();
		public var index:int = 1;
		
		public function Full()
		{
			super();
			stop();
			addChild(innerBtn0);
			addChild(innerBtn1);
			
			innerBtn0.visible =false;
			//addChild(tip);
			//this.tip.visible = false;
			//this.updateUiText();
			///this.onNorm();
			this.enable();
			return;
		}
		
		public function enable():*
		{
			this.buttonMode = true;
			addEventListener(flash.events.MouseEvent.MOUSE_OVER, this.msover);
			addEventListener(flash.events.MouseEvent.MOUSE_OUT, this.msout);
			addEventListener(flash.events.MouseEvent.CLICK, this.onclick);
			//var loc1:*=this.getChildByName("innerBtn" + currentFrame) as InnerButton;
			var loc1:* = this.getChildAt(index);
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
			var loc1:* = this.getChildAt(index);
			loc1.disable();
			return;
		}
		
		function onclick(arg1:flash.events.Event):void
		{
			trace("Full Button On click...");
			
			if (index != 1) 
			{
				switchFrame(1);
				var loc1:*=this.getChildAt(index);
				loc1.enable();				
				loc1 = new PlayEvent("norm");
			}
			else 
			{
				switchFrame(0);
				var loc1:*=this.getChildAt(index);
				loc1.enable();			
				loc1 = new PlayEvent("full");
			}
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
//			if (index != 2) 
//			{
//				this.tip.setText(Common.lang.full);
//			}
//			else 
//			{
//				this.tip.setText(Common.lang.norm);
//			}
			return;
		}
		
		public function onFull():void
		{
			/*
			gotoAndStop(2);
			var loc1:*=this.getChildByName("innerBtn" + currentFrame);
			loc1.enable();
			*/
//			switchFrame(2);
//			this.updateUiText();
			trace("onFull...");
			switchFrame(0);
//			var loc1:*=this.getChildAt(index);
//			loc1.enable();
//			
//			loc1 = new PlayEvent("full");
			return;
		}
		
		public function onNorm():void
		{
			/*
			gotoAndStop(1);
			var loc1:*=this.getChildByName("innerBtn" + currentFrame);
			loc1.enable();
			*/
//			switchFrame(1);
//			this.updateUiText();
			trace("onNorm...");
			switchFrame(1);
//			var loc1:*=this.getChildAt(index);
//			loc1.enable();
//			
//			loc1 = new PlayEvent("norm");
			return;
		}
		public function switchFrame(index:int):void{
			trace("Full Button Index:"+index);
			this.index = index;
			//var loc1:*=undefined;
			if (index == 0) 
			{
				innerBtn0.visible=true;
				innerBtn1.visible=false;
			}
			else 
			{
				innerBtn0.visible=false;
				innerBtn1.visible=true;
			}
		}
	}
}
