package com.hlet
{
	import com.hlet.btn.tools.FullButton;
	import com.hlet.btn.tools.NormalButton;
	import com.hlet.btn.tools.PauseButton;
	import com.hlet.btn.tools.PlayButton;
	import com.hlet.btn.tools.StopButton;
	import com.hlet.event.PlayEvent;
	import com.hlet.event.TimeEvent;
	import com.hlet.event.VolEvent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class Tools extends flash.display.MovieClip
	{
		
		public var pausbtn:PauseButton=new PauseButton();		
		public var nmbtn:NormalButton=new NormalButton();		
		public var fullbtn:FullButton=new FullButton();		
		public var l1:flash.display.MovieClip;		
		public var toolsBG:flash.display.MovieClip;		
		public var l2:flash.display.MovieClip;		
		public var timBar:TimeBar=new TimeBar();		
		public var l3:flash.display.MovieClip;		
		public var stopbtn:StopButton=new StopButton();		
		public var playbtn:PlayButton=new PlayButton();		
		public var sdBar:SoundBar=new SoundBar();		
		public var vod:Player=new Player();
		
		public function Tools()
		{
			super();
			this.pausbtn.visible = false;
			this.nmbtn.visible = false;
			this.timBar.addEventListener(TimeEvent.TIME, this.tim);
			this.sdBar.addEventListener(VolEvent.VOL, this.fvol);
			this.playbtn.addEventListener(flash.events.MouseEvent.CLICK, this.fplay);
			this.pausbtn.addEventListener(flash.events.MouseEvent.CLICK, this.fpaus);
			this.stopbtn.addEventListener(flash.events.MouseEvent.CLICK, this.fstop);
			this.fullbtn.addEventListener(flash.events.MouseEvent.CLICK, this.ffull);
			this.nmbtn.addEventListener(flash.events.MouseEvent.CLICK, this.fnorm);
			this.playbtn.disable();
			this.stopbtn.disable();
			this.pausbtn.disable();
			return;
		}
		
		public function setVod(arg1:Player):void
		{
			this.vod = arg1;
			this.timBar.setAlltime(arg1._duration);
			this.sdBar.setVolume(arg1.vol);
			if (arg1 == null || arg1.iswait && arg1.flvurl == "") 
			{
				this.playbtn.disable();
				this.stopbtn.disable();
				this.pausbtn.disable();
			}
			else 
			{
				this.playbtn.enable();
				this.pausbtn.enable();
				if (arg1.iswait) 
				{
					this.stopbtn.disable();
				}
				else 
				{
					this.stopbtn.enable();
				}
				if (arg1.ispaus) 
				{
					this.pausbtn.visible = false;
					this.playbtn.visible = true;
				}
				else 
				{
					this.pausbtn.visible = true;
					this.playbtn.visible = false;
				}
			}
			return;
		}
		
		function fvol(arg1:VolEvent):void
		{
			if (this.vod == null || this.vod.iswait) 
			{
				return;
			}
			dispatchEvent(new VolEvent(arg1.vol));
			return;
		}
		
		function ffull(arg1:flash.events.MouseEvent):void
		{
			this.fullbtn.visible = false;
			this.nmbtn.visible = true;
			dispatchEvent(new PlayEvent("full"));
			return;
		}
		
		public function setNorm():void
		{
			this.fullbtn.visible = true;
			this.nmbtn.visible = false;
			return;
		}
		
		function fnorm(arg1:flash.events.MouseEvent):void
		{
			this.fullbtn.visible = true;
			this.nmbtn.visible = false;
			dispatchEvent(new PlayEvent("norm"));
			return;
		}
		
		function fplay(arg1:flash.events.MouseEvent):void
		{
			if (this.vod == null || this.vod.iswait && this.vod.flvstat == 0) 
			{
				return;
			}
			this.playbtn.visible = false;
			this.pausbtn.visible = true;
			dispatchEvent(new PlayEvent("play"));
			return;
		}
		
		function fstop(arg1:flash.events.MouseEvent):void
		{
			if (this.vod == null || this.vod.iswait) 
			{
				return;
			}
			dispatchEvent(new PlayEvent("stop"));
			return;
		}
		
		function fpaus(arg1:flash.events.MouseEvent):void
		{
			if (this.vod == null || this.vod.iswait) 
			{
				return;
			}
			this.playbtn.visible = true;
			this.pausbtn.visible = false;
			dispatchEvent(new PlayEvent("paus"));
			return;
		}
		
		public function setPlayBtn():void
		{
			this.playbtn.visible = false;
			this.pausbtn.visible = true;
			return;
		}
		
		function tim(arg1:TimeEvent):void
		{
			dispatchEvent(new TimeEvent(arg1.tim));
			return;
		}
		
		public function stopdrag():void
		{
			this.timBar.stopdrag();
			this.sdBar.stopdrag();
			return;
		}
		
		public function setTime(arg1:Number):void
		{
			this.timBar.setTime(arg1);
			return;
		}
		
		public function changeSize():void
		{
			var loc1:*=stage.stageWidth;
			var loc2:*=200 - this.height + stage.stageHeight / 2;
			this.y = loc2;
			this.timBar.changeSize();
			this.toolsBG.width = stage.stageWidth + 5;
			this.toolsBG.x = 275 - stage.stageWidth / 2;
			this.playbtn.x = 15 + 275 - stage.stageWidth / 2;
			this.pausbtn.x = 15 + 275 - stage.stageWidth / 2;
			this.stopbtn.x = this.playbtn.x + 30;
			this.l1.x = this.stopbtn.x + 30;
			this.fullbtn.x = 550 + loc1 / 2 - 265 - 40;
			this.nmbtn.x = 550 + loc1 / 2 - 265 - 40;
			this.l3.x = this.fullbtn.x - 16;
			this.sdBar.x = this.l3.x - 10 - 126;
			this.l2.x = this.sdBar.x + 5;
			return;
		}
		
		public function updateUiText(arg1:Language):void
		{
			this.playbtn.setLable(arg1.playTxt);
			this.pausbtn.setLable(arg1.pausTxt);
			this.fullbtn.setLable(arg1.full);
			this.stopbtn.setLable(arg1.stopTxt);
			this.nmbtn.setLable(arg1.norm);
			this.timBar.fpre.setLable(arg1.fastPre);
			this.timBar.fnxt.setLable(arg1.fastNxt);
			this.sdBar.setLable(arg1.enableSound, arg1.disableSound);
			return;
		}
	}
}
