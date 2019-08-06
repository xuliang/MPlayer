package com.hlet.btn
{
//	import com.hlet.Common;
	import com.hlet.event.PlayEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Sound extends flash.display.MovieClip
	{
		
		public var innerBtn0:InnerButtonSoundOff=new InnerButtonSoundOff();		
		public var innerBtn1:InnerButtonSoundOn=new InnerButtonSoundOn();		
		//public var tip:Tip=new Tip();		
		public var index:int = 1;
		var eb:*=false;
		
		public function Sound()
		{
			super();
			addChild(innerBtn0);
			addChild(innerBtn1);


			
			innerBtn0.visible =false;
			//addChild(tip);
			//this.tip.visible = false;
			//this.updateUiText();
			this.disable();
			//this.silent();
			return;
		}
		
		public function enable():*
		{
			this.buttonMode = true;
			addEventListener(flash.events.MouseEvent.MOUSE_OVER, this.msover);
			addEventListener(flash.events.MouseEvent.MOUSE_OUT, this.msout);
			addEventListener(flash.events.MouseEvent.CLICK, this.onsound);
			//var loc1:*=this.getChildByName("innerBtn" + currentFrame);
			var loc1:* = this.getChildAt(index);
			loc1.enable();
			this.eb = true;
			return;
		}
		
		public function disable():*
		{
			this.buttonMode = false;
			removeEventListener(flash.events.MouseEvent.MOUSE_OVER, this.msover);
			removeEventListener(flash.events.MouseEvent.MOUSE_OUT, this.msout);
			removeEventListener(flash.events.MouseEvent.CLICK, this.onsound);
			//var loc1:*=this.getChildByName("innerBtn" + currentFrame);
			var loc1:* = this.getChildAt(index);
			loc1.disable();
			this.eb = false;
			return;
		}
		
		function onsound(arg1:flash.events.Event):void
		{
			trace("Sound Button OnSound...");
			if (index != 1) 
			{
				switchFrame(1);
				var loc1:*=this.getChildAt(index);
				loc1.enable();
				loc1 = new PlayEvent("sound");
				//trace("Sound...");
			}
			else 
			{
				switchFrame(0);
				var loc1:*=this.getChildAt(index);
				loc1.enable();
				loc1 = new PlayEvent("silent");
				//trace("Silent...");
			}
			dispatchEvent(loc1);
			arg1.stopPropagation();
			return;
		}
		
		function msover(arg1:flash.events.MouseEvent):void
		{
//			this.tip.visible = true;
			if(innerBtn1.visible)
			Object(parent.parent).sliderbg.visible=true;
			//trace(Object(parent));
			return;
		}
		
		function msout(arg1:flash.events.MouseEvent):void
		{
//			this.tip.visible = false;
			//Object(parent.parent).slider.visible=false;
			return;
		}
		
		public function updateUiText():void
		{
//			if (index != 2) 
//			{
//				this.tip.setText(Common.lang.disableSound);
//			}
//			else 
//			{
//				this.tip.setText(Common.lang.enableSound);
//			}
			return;
		}
		
		public function silent():*
		{
			trace("Sound Button silent...");
			switchFrame(0);
//			var loc1:*=this.getChildAt(index);
//			loc1.enable();
//			
//			loc1 = new PlayEvent("silent");
//			var loc1:*=undefined;
//			gotoAndStop(2);
//			if (this.eb) 
//			{
//				//var loc1:*=this.getChildByName("innerBtn" + currentFrame);
//				var loc1:*=this.getChildAt(0);
//				loc1.enable();
//			}
//			this.tip.lable.text = Common.lang.enableSound;
			return;
		}
		
		public function sound():*
		{
			trace("Sound Button sound...");
			switchFrame(1);
//			var loc1:*=this.getChildAt(index);
//			loc1.enable();
//			
//			loc1 = new PlayEvent("sound");
//			var loc1:*=undefined;
//			switchFrame(1);
//			if (this.eb) 
//			{
//				//var loc1:*=this.getChildByName("innerBtn" + currentFrame);
//				var loc1:*=this.getChildAt(0);
//				loc1.enable();
//			}
//			this.tip.lable.text = Common.lang.disableSound;
			return;
		}
		public function switchFrame(index:int):void{
			trace("Sound Button  index:"+index);
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