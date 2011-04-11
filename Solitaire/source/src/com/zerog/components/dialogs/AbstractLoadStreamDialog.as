package com.zerog.components.dialogs {
	import com.zerog.components.dialogs.AbstractDialog;
	import com.zerog.events.StreamEvent;
	import com.zerog.utils.load.ILoadStream;

	import flash.errors.IllegalOperationError;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Chris
	 * 
	 * Sets basic listener functions for events from an ILoadStream object
	 */
	public class AbstractLoadStreamDialog extends AbstractDialog {
		protected var loadStream:ILoadStream;
		
		public function AbstractLoadStreamDialog() {
			if (getQualifiedClassName(this) == "com.zerog.components.dialogs::AbstractLoadStreamDialog") {
				throw new ArgumentError("AbstractLoadStreamDialog can't be instantiated directly");
			}
		}
		
		public function setStream(loadStream:ILoadStream):void {
			this.loadStream = loadStream;
			
			//sent by SingleLoadStream object
			this.loadStream.addEventListener(StreamEvent.STATUS, onStatus);
			
			//sent off by a MultipleLoadStream object
			this.loadStream.addEventListener(StreamEvent.MULTIPLE_STATUS, onMultipleStatus);
		}
		
		protected function onMultipleStatus(e:StreamEvent):void {
			throw new IllegalOperationError("operation not supported");
		}

		protected function onStatus(e:StreamEvent):void {
			throw new IllegalOperationError("operation not supported");
		}
	}
}
