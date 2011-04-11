package com.zerog.utils.load {
	import flash.utils.ByteArray;	
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;		

	/**
	 * @author Chris
	 */
	internal class AbstractLoadStream extends EventDispatcher implements ILoadStream {
		public static const IDLE:String = "idle";
		public static const OPEN:String = "open";
        public static const PROGRESS:String = "progress";
        public static const ERROR:String = "error";
        public static const COMPLETE:String = "complete";
		
		protected var id:String = null;
		protected var url:String;
		protected var byteArray:ByteArray;
		protected var type:uint = undefined;
		protected var loadStatus:String = null;
		protected var loadTotal:Number = 0;
		protected var totalLoaded:Number = 0;
		protected var data:*;
		
		public function getData():* {
			return data;
		}
				
		public function getId():String {
			return id;
		}
		
		public function getUrl():String {
			return this.url;
		} 
		
		public function getByteArray():ByteArray {
			return this.byteArray;
		}
		
		public function getType():uint {
			return type;
		}
		
		public function getStatus():String {
			return loadStatus;
		}

		public function getPercentLoaded():Number {
			return totalLoaded/loadTotal * 100;
		}

		public function getTotalBytes():Number {
			return loadTotal;
		}
		
		public function getBytesLoaded():Number {
			return totalLoaded;
		}
		
		public function setLoader(loader:IEventDispatcher):void {
			throw new IllegalOperationError("operation not supported");
		}
	}
}
