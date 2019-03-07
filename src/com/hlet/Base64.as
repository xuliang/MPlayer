package com.hlet
{
	import flash.utils.*;
	
	public class Base64 extends Object
	{
		public function Base64()
		{
			super();
			throw new Error("Base64 class is static container only");
		}
		
		public static function encode(arg1:String):String
		{
			var loc1:*=new flash.utils.ByteArray();
			loc1.writeUTFBytes(arg1);
			return encodeByteArray(loc1);
		}
		
		public static function encodeByteArray(arg1:flash.utils.ByteArray):String
		{
			var loc2:*=null;
			var loc4:*=0;
			var loc5:*=0;
			var loc6:*=0;
			var loc1:*="";
			var loc3:*=new Array(4);
			arg1.position = 0;
			while (arg1.bytesAvailable > 0) 
			{
				loc2 = new Array();
				loc4 = 0;
				while (loc4 < 3 && arg1.bytesAvailable > 0) 
				{
					loc2[loc4] = arg1.readUnsignedByte();
					++loc4;
				}
				loc3[0] = (loc2[0] & 252) >> 2;
				loc3[1] = (loc2[0] & 3) << 4 | loc2[1] >> 4;
				loc3[2] = (loc2[1] & 15) << 2 | loc2[2] >> 6;
				loc3[3] = loc2[2] & 63;
				loc5 = loc2.length;
				while (loc5 < 3) 
				{
					loc3[loc5 + 1] = 64;
					++loc5;
				}
				loc6 = 0;
				while (loc6 < loc3.length) 
				{
					loc1 = loc1 + BASE64_CHARS.charAt(loc3[loc6]);
					++loc6;
				}
			}
			return loc1;
		}
		
		public static function decode(arg1:String):String
		{
			var loc1:*=decodeToByteArray(arg1);
			return loc1.readUTFBytes(loc1.length);
		}
		
		public static function decodeToByteArray(arg1:String):flash.utils.ByteArray
		{
			var loc5:*=0;
			var loc6:*=0;
			var loc1:*=new flash.utils.ByteArray();
			var loc2:*=new Array(4);
			var loc3:*=new Array(3);
			var loc4:*=0;
			while (loc4 < arg1.length) 
			{
				loc5 = 0;
				while (loc5 < 4 && loc4 + loc5 < arg1.length) 
				{
					loc2[loc5] = BASE64_CHARS.indexOf(arg1.charAt(loc4 + loc5));
					++loc5;
				}
				loc3[0] = (loc2[0] << 2) + ((loc2[1] & 48) >> 4);
				loc3[1] = ((loc2[1] & 15) << 4) + ((loc2[2] & 60) >> 2);
				loc3[2] = ((loc2[2] & 3) << 6) + loc2[3];
				loc6 = 0;
				while (loc6 < loc3.length) 
				{
					if (loc2[loc6 + 1] == 64) 
					{
						break;
					}
					loc1.writeByte(loc3[loc6]);
					++loc6;
				}
				loc4 = loc4 + 4;
			}
			loc1.position = 0;
			return loc1;
		}
		
		private static const BASE64_CHARS:String="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
		
		public static const version:String="1.0.0";
	}
}
