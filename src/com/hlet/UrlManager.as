package com.hlet
{
	
	import com.hlet.RTMP.*;
	import com.adobe.serialization.json.*;
	import flash.events.*;
	import flash.external.*;
	import flash.net.*;
	import flash.utils.*;
	import com.hlet.event.*;
	
	public class UrlManager extends flash.events.EventDispatcher
	{
		var vod:*;		
		var serverIp:*;		
		var urlParm:UrlParm;		
		var loader:flash.net.URLLoader;		
		public var retry:Boolean=true;		
		var tim:*;		
		var tim1:*;
		
		public function UrlManager(arg1:*, arg2:*)
		{
			super();
			this.serverIp = arg2;
			this.vod = arg1;
			this.loader = new flash.net.URLLoader();
			this.loader.addEventListener(flash.events.Event.COMPLETE, this.onComp);
			this.loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.urlLoaderIoErrorHandler);
			return;
		}
		
		public function getUrl(arg1:UrlParm, arg2:*="0"):*
		{
			var urlParm:UrlParm;
			var Type:*="0";
			var url:*;
			var req:flash.net.URLRequest;
			
			var loc1:*;
			urlParm = arg1;
			Type = arg2;
			this.retry = true;
			this.tim1 = flash.utils.setTimeout(this.timeout, 10000);
			this.urlParm = urlParm;
			flash.external.ExternalInterface.call("onVideoMsg", "" + 0 + "", "beginGetServerInfo");
			url = "http://" + urlParm.ServerIp + ":" + urlParm.ServerPort + "/3/1?MediaType=1&AVType=" + urlParm.AvType + "&DevIDNO=" + urlParm.DevIdno + "&Channel=" + urlParm.Channel + "&Type=" + Type;
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			
			url = "https://test.hletong.com/ywbeidou/action/hletong/regionTemplate/monitor?simNo=" + urlParm.DevIdno + "&lcn=" + urlParm.Channel + "&type=" + urlParm.AvType + "&bitStream=" + Type;	
			
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			flash.external.ExternalInterface.call("onDebug", "getURLAPI==" + url);
			req = new flash.net.URLRequest(url);
			req.requestHeaders.push(new URLRequestHeader("__sid",urlParm.Session)); 
			try 
			{
				this.loader.load(req);

			}
			catch (error:Error)
			{
				if (retry) 
				{
					tim = flash.utils.setTimeout(getUrl1, 5000);
				}
			}
			return;
		}
		
		public function getUrl1():*
		{
			var url:*;
			var req:*;
			
			var loc1:*;
			this.tim1 = flash.utils.setTimeout(this.timeout, 10000);
			flash.external.ExternalInterface.call("onVideoMsg", "" + 0 + "", "retryGetServerInfo");
			url = "http://" + this.urlParm.ServerIp + ":" + this.urlParm.ServerPort + "/3/1?MediaType=1&AVType=" + this.urlParm.AvType + "&DevIDNO=" + this.urlParm.DevIdno + "&Channel=" + this.urlParm.Channel + "&Type=0";
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			
			url = "https://test.hletong.com/ywbeidou/action/hletong/regionTemplate/monitor?simNo=" + this.urlParm.DevIdno + "&lcn=" + this.urlParm.Channel + "&type=" + this.urlParm.AvType + "&bitStream=0";	
			
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			trace("getURLAPI   " + url);
			req = new flash.net.URLRequest(url);
			req.requestHeaders.push(new URLRequestHeader("__sid",urlParm.Session)); 
			try 
			{
				this.loader.load(req);
			}
			catch (error:Error)
			{
				if (retry) 
				{
					tim = flash.utils.setTimeout(getUrl1, 5000);
				}
			}
			return;
		}
		
		function onComp(arg1:flash.events.Event):void
		{
			var loc7:*=undefined;
			var loc10:*=undefined;
			var loc13:*=undefined;
			var loc14:*=null;
			var loc15:*=undefined;
			var loc16:*=undefined;
			var loc17:*=undefined;
			flash.utils.clearTimeout(this.tim1);
			var loc1:*=String(arg1.currentTarget.data);
			flash.external.ExternalInterface.call("onDebug", "urlbackdata==" + loc1);
			var loc2:*=com.adobe.serialization.json.JSON.decode(loc1);
			if (loc2.result != 0) 
			{
				flash.external.ExternalInterface.call("onVideoMsg", "" + 0 + "", "getServerInfoError");
				if (this.retry) 
				{
					this.tim = flash.utils.setTimeout(this.getUrl1, 5000);
				}
				return;
			}
			var loc3:*=loc2.server.svrid;
			var loc4:*=new Array();
			loc4.push(loc2.server.clientIp);
			loc4.push(loc2.server.clientIp2);
			loc4.push(loc2.server.lanip);
			var loc5:*=this.serverIp;
			trace("服务器ip=" + loc5);
			var loc6:*=false;
			var loc18:*=0;
			var loc19:*=loc4;
			for each (loc7 in loc19) 
			{
				if (loc5 != loc7) 
				{
					continue;
				}
				loc6 = true;
				break;
			}
			if (!loc6) 
			{
				loc5 = loc2.server.clientIp;
			}
			trace("服务器ip=" + loc5);
			var loc8:*=new Array();
			loc8[loc2.server.clientPort] = 0;
			var loc9:*=loc2.server.clientOtherPort.split(";");
			if (loc9.length > 0) 
			{
				loc15 = 0;
				while (loc15 < loc9.length) 
				{
					loc16 = parseInt(loc9[loc15], 10);
					if (loc16 > 0 && loc16 <= 65535) 
					{
						loc8[loc16] = 0;
					}
					++loc15;
				}
			}
			loc18 = 0;
			loc19 = this.vod;
			for each (loc10 in loc19) 
			{
				if (loc10.serverId != loc3) 
				{
					continue;
				}
				loc17 = loc8[loc10.serverPort];
				if (loc17 == null) 
				{
					continue;
				}
				var loc20:*;
				var loc21:*;
				var loc22:*=((loc20 = loc8)[loc21 = loc10.serverPort] + 1);
				loc20[loc21] = loc22;
			}
			if (RtmpManager.listenerServerId == loc3) 
			{
				loc17 = loc8[RtmpManager.listenerServerPort];
				if (loc17 != null) 
				{
					loc20 = ((loc18 = loc8)[loc19 = RtmpManager.listenerServerPort] + 1);
					loc18[loc19] = loc20;
				}
			}
			if (RtmpManager.talkServerId == loc3) 
			{
				loc17 = loc8[RtmpManager.talkServerPort];
				if (loc17 != null) 
				{
					loc20 = ((loc18 = loc8)[loc19 = RtmpManager.talkServerPort] + 1);
					loc18[loc19] = loc20;
				}
			}
			var loc11:*=-1;
			var loc12:*=9999;
			loc18 = 0;
			loc19 = loc8;
			for (loc13 in loc19) 
			{
				if (!(loc12 > loc8[loc13])) 
				{
					continue;
				}
				loc11 = loc13;
				loc12 = loc8[loc13];
			}
			trace("port=" + loc11);
			loc14 = new UrlEvent();
			loc14.ServerIp = loc5;
			loc14.Port = loc11;
			loc14.ServerId = loc3;
			loc14.um = this.urlParm;
			this.dispatchEvent(loc14);
			flash.external.ExternalInterface.call("onVideoMsg", "" + 0 + "", "getServerInfo ip=" + loc5 + "&port=" + loc11);
			return;
		}
		
		function timeout():*
		{
			trace("TimeOut");
			if (this.retry) 
			{
				this.tim = flash.utils.setTimeout(this.getUrl1, 5000);
			}
			return;
		}
		
		function urlLoaderIoErrorHandler(arg1:flash.events.IOErrorEvent):void
		{
			trace("loadServerInfoError");
			if (this.retry) 
			{
				this.tim = flash.utils.setTimeout(this.getUrl1, 5000);
			}
			flash.utils.clearTimeout(this.tim1);
			return;
		}
		
		function urlLoaderHttpStatusHandler(arg1:flash.events.HTTPStatusEvent):void
		{
			trace(arg1.status);
			return;
		}
		
		public function Stop():*
		{
			this.retry = false;
			flash.utils.clearTimeout(this.tim);
			flash.utils.clearTimeout(this.tim1);
			try 
			{
				this.loader.close();
			}
			catch (e:*)
			{
			};
			return;
		}
	}
}
