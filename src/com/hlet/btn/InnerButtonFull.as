package com.hlet.btn
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import mx.core.BitmapAsset;
	
	public dynamic class InnerButtonFull extends InnerButton
	{
		[Embed(source="../images/full1.png")]  
		[Bindable]    
		private var en:Class;  
		
		[Embed(source="../images/full3.png")]  
		[Bindable]    
		private var dis:Class;
		
		[Embed(source="../images/full2.png")]  
		[Bindable]
		private var over:Class;
		private var img:Bitmap = new Bitmap();
		
		public function InnerButtonFull()
		{
			super();
			var data:BitmapData = BitmapAsset(new en()).bitmapData;
			img.bitmapData = data;
			img.y = 5;
			addChild(img);
//			this.switchFrame(1);
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