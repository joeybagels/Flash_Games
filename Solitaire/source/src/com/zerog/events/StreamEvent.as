package com.zerog.events {
	import com.zerog.utils.load.ILoadStream;

	public class StreamEvent extends AbstractDataEvent {
		public static const OPEN:String = "streamOpen";
		public static const STATUS:String = "streamStatus";
		public static const ERROR:String = "streamError";
		public static const COMPLETE:String = "complete";
		public static const MULTIPLE_COMPLETE:String = "multipleComplete";
		public static const MULTIPLE_STATUS:String = "multipleStatus";
		public static const MULTIPLE_OPEN:String = "multipleOpen";
		
		protected static const LOAD_STATUS:int = 1;
		protected static const LOAD_STREAM:int = 2;
		protected static const LOAD_DATA:int = 3;

		public function StreamEvent(type:String, stream:ILoadStream, bubbles:Boolean = false, 
			cancelable:Boolean = false) {
			super(type, stream, bubbles, cancelable);
		}

		public function getStream():ILoadStream {
			return this.data;
		}
	}
}