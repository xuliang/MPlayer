package com.hlet.btn
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class Tip extends flash.display.MovieClip
	{
		public function Tip()
		{
			super();
			return;
		}
		
		public function setText(arg1:String):*
		{
			this.lable.text = arg1;
			var loc3:*;
			this.lable.width = loc3 = this.lable.textWidth + 5;
			var loc1:*=loc3;
			this.lable.x = (-this.lable.width) / 2 + 2;
			var loc2:*=(loc1 - this.tipmid.width) / 2;
			this.conright.width = loc3 = loc2;
			this.conleft.width = loc3;
			this.conleft.x = this.tipmid.x - this.conleft.width;
			this.tipleft.x = this.conleft.x - this.tipleft.width + 1;
			this.conright.x = this.tipmid.x + this.tipmid.width;
			this.tipright.x = (this.conright.x + this.conright.width - 1);
			return;
		}
		
		public var tipleft:flash.display.MovieClip=new MovieClip();
		
		public var tipright:flash.display.MovieClip=new MovieClip();
		
		public var conright:flash.display.MovieClip=new MovieClip();
		
		public var conleft:flash.display.MovieClip=new MovieClip();
		
		public var lable:flash.text.TextField=new TextField();
		
		public var tipmid:flash.display.MovieClip=new MovieClip();
	}
}
