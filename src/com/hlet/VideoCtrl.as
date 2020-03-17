package com.hlet
{
	//import com.hlet.btn.Camera;
	import com.hlet.btn.Capture;
	import com.hlet.btn.Full;
	import com.hlet.btn.Play;
	import com.hlet.btn.Sound;
	import com.hlet.event.PlayEvent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class VideoCtrl extends flash.display.Sprite
	{
		//public var btncamer:Camera=new Camera();		
		public var infoBar:InfoBar=new InfoBar();		
		public var btnCap:Capture=new Capture();		
		public var btnFull:Full=new Full();		
		public var btnPlay:Play=new Play();		
		public var btnSound:Sound=new Sound();		
		public var info:String="";		
		public var Rect:RECT;		
		public var isFull:*=false;		
		var btns:Array;
		//var infoTxt:TextField = new TextField();
		public function VideoCtrl()
		{
			this.btns = new Array();
			super();
			this.info ="";
//			this.infoTxt.text="苏A12345-通道1";
//			var format:TextFormat=new TextFormat();
//			format.color = 0xffffff;
//			format.size=14;
//			this.infoTxt.setTextFormat(format);
//			this.infoTxt.y=5;
//			addChild(infoTxt);
			addChild(infoBar);
			addChild(btnCap);
			addChild(btnPlay);
			addChild(btnSound);
			addChild(btnFull);
			addEventListener(MouseEvent.RIGHT_CLICK, doNothing); 
			
			this.btnPlay.addEventListener(PlayEvent.PLAY, this.dispatch);
			this.btnPlay.addEventListener(PlayEvent.PAUS, this.dispatch);
			this.btnPlay.addEventListener(PlayEvent.STOP, this.dispatch);
			this.btnFull.addEventListener(PlayEvent.FULL, this.dispatch);
			this.btnFull.addEventListener(PlayEvent.NORM, this.dispatch);
			this.btnSound.addEventListener(PlayEvent.SOUND, this.dispatch);
			this.btnSound.addEventListener(PlayEvent.SILENT, this.dispatch);
			this.btnCap.addEventListener(PlayEvent.CAPTURE, this.dispatch);
			//this.btncamer.addEventListener(PlayEvent.ONCAMER, this.dispatch);
			//this.btncamer.addEventListener(PlayEvent.OFFCAMER, this.dispatch);
			//this.btncamer.disable();
			this.btns[0] = this.btnFull;
			this.btns[1] = this.btnSound;
			this.btns[2] = this.btnPlay;
			this.btns[3] = this.btnCap;
			//this.btns[4] = this.btncamer;
			//var loc1:*=4;
			//while (loc1 < this.btns.length) 
			//{
			//	this.btns[loc1].visible = false;
			//	++loc1;
			//}
			return;
		}
		private function doNothing(e:MouseEvent):void
		{
			//屏蔽右键，什么都不做。
		}
		public function setToolBarVisible(arg1:int, arg2:Boolean):int
		{
//			if (arg1 >= 0 && arg1 < this.btns.length) 
//			{
//				this.btns[arg1].visible = arg2;
//				this.reSize();
//				return 0;
//			}
			return 201;
		}
		
		public function reSet():*
		{
			this.info = "";
			this.infoBar.BackGround.setColor("000000");
			return;
		}
		
		function dispatch(arg1:PlayEvent):void
		{
			var loc1:*=new PlayEvent(arg1.ev);
			dispatchEvent(loc1);
			return;
		}
		
		public function setBps(arg1:Number):void
		{
			arg1 = int(arg1);
			var loc1:*=this.info + " - " + arg1 + "KB/S";
			this.infoBar.infoTxt.text = loc1;
			var format:TextFormat=new TextFormat();
			format.color = 0xffffff;
			format.size=12;
			format.font="微软雅黑";
			this.infoBar.infoTxt.setTextFormat(format);
			return;
		}
		
		public function setColor(arg1:String):void
		{
			this.infoBar.BackGround.setColor(arg1);
			return;
		}
		
		public function showInfo():void
		{
			this.infoBar.infoTxt.text = this.info;
			return;
		}
		
		public function setRect(arg1:RECT):void
		{
			this.Rect = arg1;
			this.reSize();
			return;
		}
		
		public function reSize():void
		{
			//this.graphics.drawRect(Rect.rx,Rect.ry,Rect.rw,30);

			var loc2:*=undefined;
			var loc1:*=0;
			if (this.isFull) 
			{
				this.infoBar.BackGround.width = this.Rect.sw;
//				this.y = 400 + (this.Rect.sh - 400) / 2 - 25;
//				this.x = (-(this.Rect.sw - 550)) / 2;
				this.y =this.Rect.sh-30;
				this.x = 0;
				loc2 = 0;
				while (loc2 < this.btns.length) 
				{
					if (this.btns[loc2].visible) 
					{
						++loc1;
						this.btns[loc2].x = this.Rect.sw - 30 * loc1;
					}
					++loc2;
				}
			}
			else 
			{
				this.infoBar.BackGround.width = this.Rect.rw;
				this.y = this.Rect.ry + this.Rect.rh - 30;
				this.x = this.Rect.rx;
				loc2 = 0;
				while (loc2 < this.btns.length) 
				{
					if (this.btns[loc2].visible) 
					{
						++loc1;
						this.btns[loc2].x = this.Rect.rw - 30 * loc1;
					}
					++loc2;
				}
			}
			
			this.infoBar.infoTxt.width = this.infoBar.BackGround.width - 120;
			if (this.infoBar.infoTxt.width < 60) 
			{
				this.infoBar.infoTxt.visible = false;
			}
			else 
			{
				this.infoBar.infoTxt.visible = true;
			}
			return;
		}
		
		function updateUiText():*
		{
			this.btnFull.updateUiText();
			this.btnSound.updateUiText();
			this.btnPlay.updateUiText();
			this.btnCap.updateUiText();
			//this.btncamer.updateUiText();
			return;
		}
		
		function enable():*
		{
			this.btnFull.enable();
			this.btnSound.enable();
			this.btnPlay.enable();
			this.btnCap.enable();
			//this.btncamer.enable();
			return;
		}
		
		function disable():*
		{
			this.infoBar.infoTxt.text = "";
			this.btnSound.disable();
			this.btnCap.disable();
			this.btnPlay.disable();
			//this.btncamer.disable();
			return;
		}
	}
}