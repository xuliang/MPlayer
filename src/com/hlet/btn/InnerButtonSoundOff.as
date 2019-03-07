package com.hlet.btn
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import mx.core.BitmapAsset;

	public dynamic class InnerButtonSoundOff extends InnerButton
	{
		[Embed(source="../images/off1.png")]  
		[Bindable]    
		private var en:Class;  
		
		[Embed(source="../images/off3.png")]  
		[Bindable]    
		private var dis:Class;
		
		[Embed(source="../images/off2.png")]  
		[Bindable]
		private var over:Class;
		private var img:Bitmap = new Bitmap();
		
		public function InnerButtonSoundOff()
		{
			var data:BitmapData = BitmapAsset(new en()).bitmapData;
			img.bitmapData = data;
			img.y = 5;
			addChild(img);
			super();
		}
		public override function switchFrame(index:int):void{
			if(index == 1){
				img.bitmapData = BitmapAsset(new en()).bitmapData;
			}else if(index == 2){
				img.bitmapData = BitmapAsset(new over()).bitmapData;
			}else if(index == 3){
				img.bitmapData = BitmapAsset(new dis()).bitmapData;
			}	
		}
	}
}