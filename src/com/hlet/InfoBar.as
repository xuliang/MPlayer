package com.hlet
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class InfoBar extends MovieClip
	{
		var infoTxt:TextField = new TextField();
		var BackGround:VideoInfoBg = new VideoInfoBg();
		public function InfoBar()
		{
			this.y = 5;
			//infoTxt.height = 25;
			addChild(BackGround);
			addChild(infoTxt);
			
		}
		
	}
}