package com.hlet.btn
{
	//import com.hlet.Common;
	import com.hlet.event.PlayEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Play extends flash.display.MovieClip
	{
		public var innerBtn1:InnerButtonPlay=new InnerButtonPlay();		
		public var innerBtn0:InnerButtonStop=new InnerButtonStop();		
		//public var tip:Tip=new Tip();
		public var index:int = 1;
		
		public function Play()
		{
			super();
			stop();
			addChild(innerBtn0);
			addChild(innerBtn1);

			innerBtn0.visible =false;
			//addChild(tip);
			//this.tip.visible = false;
			//this.updateUiText();
			//this.onStop();
			//this.disable();
			this.disable();
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
			trace("Play Button Onclick...："+index);
			
			if (index == 1) 
			{
				switchFrame(1);
				var loc1:*=this.getChildAt(index);
				loc1.enable();
				loc1 = new PlayEvent("play");
			}
			else 
			{
				switchFrame(0);
				var loc1:*=this.getChildAt(index);
				loc1.enable();
				loc1 = new PlayEvent("stop");
			}
			dispatchEvent(loc1);
			arg1.stopPropagation();
			return;
		}
		
		function msover(arg1:flash.events.MouseEvent):void
		{
			//this.tip.visible = true;
			//trace("Paly mouse over");
			return;
		}
		
		function msout(arg1:flash.events.MouseEvent):void
		{
			//this.tip.visible = false;
			//trace("Paly mouse out");
			return;
		}
		
		public function updateUiText():void
		{
//			if (index != 2) 
//			{
//				this.tip.setText(Common.lang.stopTxt);
//			}
//			else 
//			{
//				this.tip.setText(Common.lang.playTxt);
//			}
			return;
		}
		
		public function onPlay():*
		{
			trace("Play Button onPlay...");
			switchFrame(0);
//			var loc1:*=this.getChildAt(index);
//			loc1.enable();
//			
//			loc1 = new PlayEvent("play");
//			innerBtn0.visible=true;
//			innerBtn1.visible=false;
////			//switchFrame(1);
////			//var loc1:*=this.getChildByName("innerBtn" + currentFrame);
//			var loc1:*=this.getChildAt(index);
//			loc1.enable();
////			//this.updateUiText();
			return;
		}
		
		public function onStop():*
		{
			trace("Play Button onStop...");
			switchFrame(1);
//			var loc1:*=this.getChildAt(index);
//			loc1.enable();
//			
//			loc1 = new PlayEvent("stop");
//			innerBtn0.visible=false;
//			innerBtn1.visible=true;
////			switchFrame(2);
////			//var loc1:*=this.getChildByName("innerBtn" + currentFrame);
//			var loc1:*=this.getChildAt(index);
//			loc1.enable();
////			this.updateUiText();
			return;
		}
		
		public function switchFrame(index:int):void{
			trace("Play Button Index:"+index);
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