package com.hlet.event
{
	import flash.events.*;
	import com.hlet.UrlParm;
	
	public class UrlEvent extends flash.events.Event
	{
		public static const GETURL:String="geturl";		
		public var ServerId:*;		
		public var ServerIp:*;		
		public var Port:*;		
		public var Url:*;		
		public var um:UrlParm;
		
		public function UrlEvent()
		{
			super("geturl");
			return;
		}
	}
}
