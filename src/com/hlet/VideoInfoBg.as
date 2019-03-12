package com.hlet
{
	import flash.display.*;
	
	public class VideoInfoBg extends flash.display.Sprite
	{
		public function VideoInfoBg()
		{
			super();
			this.graphics.beginFill(this.color, this.alp);
			this.graphics.drawRect(0, 0, 200, 30);
			this.graphics.endFill();
			return;
		}
		
		public function setColor(arg1:String, arg2:Number=1):void
		{
			this.color = "0x" + arg1;
			this.graphics.clear();
			this.graphics.beginFill(this.color, arg2);
			this.graphics.drawRect(0, 0, 200, 30);
			this.graphics.endFill();
			return;
		}
		
		var color:*=0;
		
		var alp:*=1;
	}
}
