package com.hlet
{
	import flash.events.*;
	import flash.external.*;
	import flash.ui.*;
	
	public class MenuItem extends Object
	{
		public function MenuItem(arg1:String, arg2:String, arg3:int, arg4:int)
		{
			super();
			this.id = arg4;
			this.menuId = arg1;
			this.menuName = arg2;
			this.item = new flash.ui.ContextMenuItem(arg2);
			if (arg3 == 1) 
			{
				this.item.separatorBefore = true;
			}
			this.item.addEventListener(flash.events.ContextMenuEvent.MENU_ITEM_SELECT, this.onMenu);
			return;
		}
		
		function onMenu(arg1:flash.events.ContextMenuEvent):*
		{
			trace("index " + this.id + " menuid" + this.menuId);
			flash.external.ExternalInterface.call("onVideoRightMenu", "" + this.id + "", this.menuId);
			return;
		}
		
		public function del():*
		{
			this.item.removeEventListener(flash.events.ContextMenuEvent.MENU_ITEM_SELECT, this.onMenu);
			this.item = null;
			return;
		}
		
		public var menuId:String;
		
		public var menuName:String;
		
		public var item:flash.ui.ContextMenuItem;
		
		var id:int;
	}
}