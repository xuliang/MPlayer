package com.hlet.event
{
	import flash.events.Event;
	
	public class PlayEvent extends flash.events.Event
	{
		public function PlayEvent(arg1:String)
		{
			this.ev = arg1;
			super(arg1);
			return;
		}
		public static const FULL:String="full";
		
		public static const NORM:String="norm";
		
		public static const PLAY:String="play";
		
		public static const STOP:String="stop";
		
		public static const PAUS:String="paus";
		
		public static const SOUND:String="sound";
		
		public static const SILENT:String="silent";
		
		public static const CAPTURE:String="capture";
		
		public static const ONTALK:String="ontalk";
		
		public static const OFFTALK:String="offtalk";
		
		public static const ONCAMER:String="oncamer";
		
		public static const OFFCAMER:String="offcamer";
		
		public var ev:*;
	}
}