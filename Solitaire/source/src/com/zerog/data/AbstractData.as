package com.zerog.data {
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	import com.zerog.data.IData;	

	/**
	 * Abstract data class.  Should be subclassed and not instantiated.
	 * Unfortunately Flash has no support for true abstract classes so
	 * there is nothing stopping you from instantiating this.
	 *  
	 * @author Chris.Lam
	 * 
	 */
	public class AbstractData implements IData {
		protected var data:* = null;
	
		public function AbstractData() {
			if (getQualifiedClassName(this) == "com.zerog.data::AbstractData") {
				throw new ArgumentError("AbstractData can't be instantiated directly");
			}
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
			return this.data[name];
		}
		
		public function getInt(name:* = null):int {
			return this.data[name];
		}

		public function getNumber(name:* = null):Number {
			return this.data[name];
		}

		public function getString(name:* = null):String {
			return this.data[name];
		}

		public function getDate(name:* = null):Date {
			return this.data[name];
		}
		
		public function getObject(name:* = null):Object {
			return this.data[name];
		}
		
		public function getArray(name:* = null):Array {
			return this.data[name];
		}
		
		public function getBoolean(name:* = null):Boolean {
			return this.data[name];
		}
		
		public function getByteArray(key:* = null):ByteArray {
			return this.data;
		}
	}
}