package com.hlet.event
{
	import flash.events.*;
	
	public class PlayerEvent extends Event
	{
		public static const CLICK:String = "pclick";
		public static const DOUBLE_CLICK:String = "pdoubleclick";
		public static const ALLTIME:String = "alltime";
		
		public function PlayerEvent(param1:String) : void
		{
			super(param1);
			return;
		}// end function
		
	}
}
