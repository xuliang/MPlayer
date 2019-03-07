package com.hlet
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class Info extends flash.display.MovieClip
	{
		public var msgTxt:flash.text.TextField=new TextField();		
		var connectError:String="";		
		var offLine:String="设备不在线";		
		var connect:String="正在连接";		
		var waiting:String="";		
		var rect:RECT;		
		var isfull:Boolean;		
		var curr:String;
		
		public function Info()
		{
			super();
			this.isfull = false;
			return;
		}
		
		public function setRect(arg1:RECT):void
		{
			this.rect = arg1;
			return;
		}
		
		public function updateUiText(arg1:Language):void
		{
			this.connectError = arg1.connectError;
			this.offLine = arg1.offLine;
			this.connect = arg1.connect;
			this.waiting = arg1.waiting;
			this.setMsg(this.curr);
			return;
		}
		
		public function reSize():void
		{
			if (this.isfull) 
			{
//				this.x = 275 - this.width / 2;
//				this.y = 200 - this.height / 2;
				this.x = this.rect.sw/2;
				this.y = this.rect.sh/2;
			}
			else 
			{
				this.x = this.rect.rx + (this.rect.rw - this.width) / 2;
				this.y = this.rect.ry + (this.rect.rh - this.height) / 2;
			}
			return;
		}
		
		public function setMsg(arg1:String):void
		{
			if (this.isfull) 
			{
				this.x = 275 - this.width / 2;
				this.y = 200 - this.height / 2;
			}
			else 
			{
				this.x = this.rect.rx + (this.rect.rw - this.width) / 2;
				this.y = this.rect.ry + (this.rect.rh - this.height) / 2;
			}
			var loc1:*=arg1;
			switch (loc1) 
			{
				case "connect":
				{
					this.msgTxt.text = Common.lang.connect;
					break;
				}
				case "offLine":
				{
					this.msgTxt.text = Common.lang.offLine;
					break;
				}
				case "connectError":
				{
					this.msgTxt.text = Common.lang.connectError;
					break;
				}
				case "waiting":
				{
					this.msgTxt.text = "";
					break;
				}
				default:
				{
					this.msgTxt.text = "";
				}
			}
			this.curr = arg1;
			return;
		}
		
		public function showMsg(arg1:String):void
		{
			if (this.isfull) 
			{
				this.x = 275 - this.width / 2;
				this.y = 200 - this.height / 2;
			}
			else 
			{
				this.x = this.rect.rx + (this.rect.rw - this.width) / 2;
				this.y = this.rect.ry + (this.rect.rh - this.height) / 2;
			}
			var loc1:*=arg1;
			switch (loc1) 
			{
				case "connect":
				{
					this.msgTxt.text = this.connect;
					break;
				}
				case "offLine":
				{
					this.msgTxt.text = this.offLine;
					break;
				}
				case "connectError":
				{
					this.msgTxt.text = this.connectError;
					break;
				}
				case "waiting":
				{
					this.msgTxt.text = "";
					break;
				}
			}
			this.curr = arg1;
			this.visible = true;
			return;
		}
	}
}