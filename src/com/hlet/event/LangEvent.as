package com.hlet.event
{
    import flash.events.Event;

    public class LangEvent extends Event
    {
        public static const CHANGE:String = "change";

        public function LangEvent() : void
        {
            super(CHANGE);
            return;
        }// end function

    }
}
