package com.hlet.event
{
    import flash.events.Event;

    public class ConfigEvent extends Event
    {
        public static const CHANGE:String = "change";

        public function ConfigEvent() : void
        {
            super(CHANGE);
            return;
        }// end function
		
    }
}
