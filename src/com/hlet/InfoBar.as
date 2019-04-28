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
			//this.height=100;
			//this.y = 5;
			
			addChild(BackGround);
			//infoTxt.alwaysShowSelection=false;
			//infoTxt.focusRect=false;
			//infoTxt.mouseEnabled=false;
			//infoTxt.border=true;
			infoTxt.selectable=false;
			infoTxt.y=5;
			infoTxt.height = 30;
			addChild(infoTxt);
			
		}
		
	}
}