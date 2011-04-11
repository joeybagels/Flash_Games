package com.zerog.utils.binary {
	import flash.utils.ByteArray;	
	
	/**
	 * @author Chris
	 */
	public class BinaryUtil {
		/*
		///TODO fix this!
		public static function writeLong(ba:ByteArray, val:Number):void {
			ba.writeByte((val >>> 56) & 255);
			ba.writeByte((val >>> 48) & 255);
			ba.writeByte((val >>> 40) & 255);
			ba.writeByte((val >>> 32) & 255);
			ba.writeByte((val >>> 24) & 255);
			ba.writeByte((val >>> 16) & 255);
			ba.writeByte((val >>> 8) & 255);
			ba.writeByte((val >>> 0) & 255);
		}
		*/
		public static function readLong(ba:ByteArray):Number {
			var longVal:Number;
			
			longVal = ba.readUnsignedByte();
			longVal = longVal * 256 + ba.readUnsignedByte();
			longVal = longVal * 256 + ba.readUnsignedByte();
			longVal = longVal * 256 + ba.readUnsignedByte();
			longVal = longVal * 256 + ba.readUnsignedByte();
			longVal = longVal * 256 + ba.readUnsignedByte();
			longVal = longVal * 256 + ba.readUnsignedByte();
			longVal = longVal * 256 + ba.readUnsignedByte();

			return longVal; 
		}
	}
}
