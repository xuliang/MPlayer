package com.hlet.event
{
	import flash.events.*;
	
	public class TimeEvent extends flash.events.Event
	{
		public function TimeEvent(arg1:Number)
		{
			super(TIME);
			this.tim = arg1;
			return;
		}
		
		public static const TIME:String="time";
		
		public var tim:Number;
	}
}