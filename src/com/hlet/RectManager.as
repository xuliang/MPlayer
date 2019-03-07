package com.hlet
{
	public class RectManager extends Object
	{
		public static var Rect:Array;
		public static var stage:*;
		static var Num:*=4;
		
		public function RectManager()
		{
			super();
			return;
		}
		
		public static function setRectNum(arg1:int):void
		{
			Num = arg1;
			var loc1:*=arg1;
			switch (loc1) 
			{
				case 6:
				{
					setVideo6();
					break;
				}
				case 8:
				{
					setVideo8();
					break;
				}
				default:
				{
					setVideo(arg1);
				}
			}
			return;
		}
		
		static function reSizeVideo():void
		{
			var loc1:*=Num;
			switch (loc1) 
			{
				case 6:
				{
					setVideo6();
					break;
				}
				case 8:
				{
					setVideo8();
					break;
				}
				default:
				{
					setVideo(Num);
				}
			}
			return;
		}
		
		static function setVideo(arg1:int):void
		{
			var loc1:*=undefined;
			var loc2:*=undefined;
			var loc3:*=undefined;
			var loc4:*=undefined;
			var loc5:*=undefined;
			loc3 = Math.ceil(Math.sqrt(arg1));
			loc1 = stage.stageWidth / loc3;
			loc2 = stage.stageHeight / loc3;
			var loc7:*;
			loc5 = loc7 = 0;
			loc4 = loc7;
			var loc6:*=0;
			while (loc6 < arg1) 
			{
				if (Rect[loc6] != null) 
				{
					Rect[loc6].resizeRect(loc4, loc5, loc1, loc2, stage.stageWidth, stage.stageHeight);
				}
				else 
				{
					Rect[loc6] = new RECT(loc4, loc5, loc1, loc2, stage.stageWidth, stage.stageHeight);
				}
				++loc4;
				if (loc4 >= loc3) 
				{
					loc4 = 0;
					++loc5;
				}
				++loc6;
			}
			return;
		}
		
		static function setVideo6():void
		{
			var loc1:*=3;
			var loc2:*=stage.stageWidth / loc1;
			var loc3:*=stage.stageHeight / loc1;
			if (Rect[0] != null) 
			{
				Rect[0].resizeRect(0, 0, 2 * loc2, 2 * loc3, stage.stageWidth, stage.stageHeight);
			}
			else 
			{
				Rect[0] = new RECT(0, 0, 2 * loc2, 2 * loc3, stage.stageWidth, stage.stageHeight);
			}
			if (Rect[1] != null) 
			{
				Rect[1].resizeRect(2, 0, loc2, loc3, stage.stageWidth, stage.stageHeight);
			}
			else 
			{
				Rect[1] = new RECT(2, 0, loc2, loc3, stage.stageWidth, stage.stageHeight);
			}
			if (Rect[2] != null) 
			{
				Rect[2].resizeRect(2, 1, loc2, loc3, stage.stageWidth, stage.stageHeight);
			}
			else 
			{
				Rect[2] = new RECT(2, 1, loc2, loc3, stage.stageWidth, stage.stageHeight);
			}
			var loc4:*=3;
			while (loc4 < 6) 
			{
				if (Rect[loc4] != null) 
				{
					Rect[loc4].resizeRect(loc4 - 3, 2, loc2, loc3, stage.stageWidth, stage.stageHeight);
				}
				else 
				{
					Rect[loc4] = new RECT(loc4 - 3, 2, loc2, loc3, stage.stageWidth, stage.stageHeight);
				}
				++loc4;
			}
			return;
		}
		
		static function setVideo8():void
		{
			var loc1:*=4;
			var loc2:*=stage.stageWidth / loc1;
			var loc3:*=stage.stageHeight / loc1;
			if (Rect[0] != null) 
			{
				Rect[0].resizeRect(0, 0, 3 * loc2, 3 * loc3, stage.stageWidth, stage.stageHeight);
			}
			else 
			{
				Rect[0] = new RECT(0, 0, 3 * loc2, 3 * loc3, stage.stageWidth, stage.stageHeight);
			}
			if (Rect[1] != null) 
			{
				Rect[1].resizeRect(3, 0, loc2, loc3, stage.stageWidth, stage.stageHeight);
			}
			else 
			{
				Rect[1] = new RECT(3, 0, loc2, loc3, stage.stageWidth, stage.stageHeight);
			}
			if (Rect[2] != null) 
			{
				Rect[2].resizeRect(3, 1, loc2, loc3, stage.stageWidth, stage.stageHeight);
			}
			else 
			{
				Rect[2] = new RECT(3, 1, loc2, loc3, stage.stageWidth, stage.stageHeight);
			}
			if (Rect[3] != null) 
			{
				Rect[3].resizeRect(3, 2, loc2, loc3, stage.stageWidth, stage.stageHeight);
			}
			else 
			{
				Rect[3] = new RECT(3, 2, loc2, loc3, stage.stageWidth, stage.stageHeight);
			}
			var loc4:*=4;
			while (loc4 < 8) 
			{
				if (Rect[loc4] != null) 
				{
					Rect[loc4].resizeRect(loc4 - 4, 3, loc2, loc3, stage.stageWidth, stage.stageHeight);
				}
				else 
				{
					Rect[loc4] = new RECT(loc4 - 4, 3, loc2, loc3, stage.stageWidth, stage.stageHeight);
				}
				++loc4;
			}
			return;
		}
		
		
		{
			Rect = new Array();
			Num = 4;
		}
	}
}
