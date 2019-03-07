package com.hlet
{
	/**
	 * 
	 */
	public class RECT extends Object
	{
		public var rw:Number;//当前宽		
		public var rh:Number;//当前高		
		public var rx:Number;//	列号
		public var ry:Number;//	行号
		public var sw:Number;//总宽	
		public var sh:Number;//总高
		
		/**
		 * 
		 * param1 列号
		 * param2 行号
		 * param3 当前宽
		 * param4 当前高
		 * param5 总宽
		 * param6 总高
		 */
		public function RECT(arg1:Number, arg2:Number, arg3:Number, arg4:Number, arg5:Number, arg6:Number)
		{
			super();
			this.sw = arg5;
			this.sh = arg6;
			this.rh = arg4-2;
			this.rw = arg3-2;
//			this.rx = arg1 * arg3 + 1 - arg5 / 2 + 275;
//			this.ry = arg2 * arg4 + 1 - arg6 / 2 + 200;
			this.rx = arg1 * arg3 + 1;
			this.ry = arg2 * arg4 + 1;			
			return;
		}
		
		/**
		 * param1 列号
		 * param2 行号
		 * param3 当前宽
		 * param4 当前高
		 * param5 总宽
		 * param6 总高
		 */
		public function resizeRect(arg1:Number, arg2:Number, arg3:Number, arg4:Number, arg5:Number, arg6:Number):void
		{
			this.sw = arg5;
			this.sh = arg6;
			this.rh = arg4-2;
			this.rw = arg3-2;
//			this.rx = arg1 * arg3 + 1 - arg5 / 2 + 275;
//			this.ry = arg2 * arg4 + 1 - arg6 / 2 + 200;
			this.rx = arg1 * arg3 + 1;
			this.ry = arg2 * arg4 + 1;		
			return;
		}
	}
}
