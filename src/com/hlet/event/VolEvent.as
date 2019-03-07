package com.hlet.event
{
	import flash.events.*;
	
	public class VolEvent extends flash.events.Event
	{
		public function VolEvent(arg1:Number)
		{
			super(VOL);
			this.vol = arg1;
			return;
		}
		
		public static const VOL:String="VOLUME";
		
		public var vol:Number;
	}
}