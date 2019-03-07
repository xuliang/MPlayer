package com.hlet
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class Loading extends flash.display.MovieClip
	{
		public var ldinfo:flash.text.TextField=new TextField();
		public var loadingTxt:flash.text.TextField=new TextField();
		var rect:*;
		var isfull:Boolean;
		
		public function Loading()
		{
			super();
			this.isfull = false;
			this.ldinfo.visible = false;
			this.loadingTxt.visible = false;
			return;
		}
		
		public function setRect(arg1:RECT):void
		{
			this.rect = arg1;
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
	}
}
