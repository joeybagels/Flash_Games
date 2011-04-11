package com.zerog.data {
	import flash.utils.ByteArray;	
	
	/** 
	 *  
	 * @author Chris.Lam
	 * 
	 */
	public interface IData {
		function getData(key:* = null):*;
		
		function getByteArray(key:* = null):ByteArray;

		function getObject(key:* = null):Object;

		function getInt(key:* = null):int;

		function getBoolean(key:* = null):Boolean;

		function getNumber(key:* = null):Number;

		function getString(key:* = null):String;

		function getDate(key:* = null):Date;

		function getArray(key:* = null):Array;

		function setData(name:*, value:*):void;

		function setByteArray(name:*, value:ByteArray):void;

		function setObject(name:*, value:Object):void ;

		function setBoolean(name:*, value:Boolean):void;

		function setInt(name:*, value:int):void ;

		function setNumber(name:*, value:Number):void ;

		function setString(name:*, value:String):void ;

		function setDate(name:*, value:Date):void ;
	}
}