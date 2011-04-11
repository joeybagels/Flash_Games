package com.zerog.events {
	import com.zerog.data.IData;

	import flash.events.Event;
	import flash.utils.ByteArray;

	/**
	 * Abstract class for an event with data 
	 * 
	 * @author Chris Lam
	 */
	public class AbstractDataEvent extends Event implements IData {
		protected var data:*;

		public function AbstractDataEvent(type:String, data:Object = null, 
			bubbles:Boolean = true, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			
			this.data = data;
		}

		public function setData(name:*, value:*):void {
			this.data[name] = value;
		}
		
		public function setObject(name:*, value:Object):void {
			this.data[name] = value;
		}
		
		public function setBoolean(name:*, value:Boolean):void {
			this.data[name] = value;
		}
		
		public function setInt(name:*, value:int):void {
			this.data[name] = value;
		}

		public function setNumber(name:*, value:Number):void {
			this.data[name] = value;
		}

		public function setString(name:*, value:String):void {
			this.data[name] = value;
		}

		public function setDate(name:*, value:Date):void {
			this.data[name] = value;
		}

		public function setByteArray(name:*, value:ByteArray):void {
			this.data[name] = value;
		}
		
		public function getData(name:* = null):* {
			return this.data;	
		}
		
		public function getArray(name:* = null):Array {
			return this.data;
		}
		
		public function getBoolean(name:* = null):Boolean {
			return this.data;
		}
		
		public function getInt(name:* = null):int {
			return this.data;
		}
		
		public function getObject(name:* = null):Object {
			return this.data;
		}
		
		public function getNumber(name:* = null):Number {
			return this.data;
		}
		
		public function getString(name:* = null):String {
			return this.data;
		}
		
		public function getDate(name:* = null):Date {
			return this.data;
		}
		
		public function getByteArray(key:* = null):ByteArray {
			return this.data;
		}
	}
}
