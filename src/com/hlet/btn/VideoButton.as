package com.hlet.btn
{
	import com.hlet.RECT;
	import com.hlet.btn.InnerVideoPlayButton;
	import com.hlet.event.PlayEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class VideoButton extends flash.display.MovieClip
	{
		public var innerBtn1:InnerVideoPlayButton=new InnerVideoPlayButton();		
		var Rect:RECT;		
		public var isFull:*=false;
		
		public function VideoButton()
		{
			this.buttonMode = true;
			addChild(innerBtn1);
			addEventListener(flash.events.MouseEvent.CLICK, this.onPlay);
			innerBtn1.enable();
			this.visible = false;
		}
		public function onPlay(arg1:flash.events.Event):void
		{
			trace("Video Button Click...");
			var loc1:*=new PlayEvent("play");
			dispatchEvent(loc1);
			this.visible = false;
			arg1.stopPropagation();
			return;
		}
		
		public function reSize():void
		{
			if (this.isFull)
			{
				this.x = this.Rect.sw/2-this.width/2;
				this.y = this.Rect.sh/2-this.width/2;
			}
			else
			{
				this.x = this.Rect.rx + this.Rect.rw / 2-this.width/2;
				this.y = this.Rect.ry + this.Rect.rh / 2-this.height/2;
			}
			return;
		}
		
		public function setRect(arg1:RECT):void
		{
			this.Rect = arg1;
			this.reSize();
			return;
		}
	}
}