package com.zerog.utils.load {
	import com.adobe.utils.ArrayUtil;	
	
	import flash.events.EventDispatcher;
	
	import com.zerog.events.StreamEvent;
	import com.zerog.utils.load.ILoadStream;		

	/**
	 * @author Chris
	 */
	public class MultipleLoadStream extends AbstractLoadStream {		
		private var streams:Array;
		private var opened:Boolean;

		public function MultipleLoadStream() {
			this.streams = new Array();
			this.data = new Array();
			this.totalLoaded = 0;
			this.loadTotal = 0;
		}

		public function addStream(stream:ILoadStream):void {
			//store this stream with this id
			this.streams.push(stream);
			
			//listen for status events
			stream.addEventListener(StreamEvent.OPEN, onStreamOpen);
			stream.addEventListener(StreamEvent.STATUS, onStreamStatus);
			stream.addEventListener(StreamEvent.COMPLETE, onComplete);
			stream.addEventListener(StreamEvent.ERROR, onError);
		}

		public function removeStreams():void {
			//remove event listeners
			for each (var stream:ILoadStream in this.streams) {
				stream.removeEventListener(StreamEvent.OPEN, onStreamOpen);
				stream.removeEventListener(StreamEvent.STATUS, onStreamStatus);
				stream.removeEventListener(StreamEvent.COMPLETE, onComplete);
				stream.removeEventListener(StreamEvent.ERROR, onError);
			}
			
			//make a new array
			this.streams = new Array();
		}
		
		public function removeStream(stream:ILoadStream):void {
			//remove event listeners
			for each (var s:ILoadStream in this.streams) {
				if (s == stream) {
					s.removeEventListener(StreamEvent.OPEN, onStreamOpen);
					s.removeEventListener(StreamEvent.STATUS, onStreamStatus);
					s.removeEventListener(StreamEvent.COMPLETE, onComplete);
					s.removeEventListener(StreamEvent.ERROR, onError);
					
					ArrayUtil.removeValueFromArray(this.streams, s);
				}
			}
		}
		
		public function numStreams():uint {
			return this.streams.length;
		}
		
		/*
		 * An array of <code>com.zerog.util.load.ILoadStream</code> objects
		 */
		public function getStreams():Array {
			return this.streams;
		}
		
		public function getStreamById(id:String):ILoadStream {
			var returnVal:ILoadStream = null;
			
			for each (var stream:ILoadStream in this.streams) {
				if (stream.getId() == id) {
					returnVal = stream;
				}
			}
			
			return returnVal;
		}
		
		private function onError(e:StreamEvent):void {
			trace("stream error " + e.getData());
			loadStatus = ERROR;
			
			dispatchEvent(new StreamEvent(StreamEvent.ERROR, this));
		}

		private function onComplete(e:StreamEvent):void {
			var d:* = e.getStream().getData();
			
			if (d != undefined) {
				//store this data in the data array
				this.data.push(d);
				
				//if all streams complete
				if (this.data.length == this.streams.length) {
					this.loadStatus = COMPLETE;
					dispatchEvent(new StreamEvent(StreamEvent.COMPLETE, e.getStream()));
					dispatchEvent(new StreamEvent(StreamEvent.MULTIPLE_COMPLETE, this));
				}
				//not fully complete, but pass this data along
				else {
					this.loadStatus = PROGRESS;
					dispatchEvent(new StreamEvent(StreamEvent.COMPLETE, e.getStream()));
				}
			}
		}
		
		private function onStreamOpen(e:StreamEvent):void {
			if (!this.opened) {
				dispatchEvent(new StreamEvent(StreamEvent.OPEN, this));
				this.opened = true;
			}
			
			var se:StreamEvent = new StreamEvent(StreamEvent.MULTIPLE_OPEN, e.getStream());
			
			dispatchEvent(se);
		}

		private function onStreamStatus(e:StreamEvent):void {
			//dispatch this
			var singleStream:ILoadStream = e.getStream();
			dispatchEvent(new StreamEvent(StreamEvent.MULTIPLE_STATUS, singleStream));
			
			//use a temp variable to avoid race conditions
			var tempTotalLoaded:Number = 0;
			var tempTotal:Number = 0;
			
			//find the total amount loaded
			for each (var stream:ILoadStream in streams) {
				tempTotalLoaded += stream.getBytesLoaded();
				tempTotal += stream.getTotalBytes();
			}
			
			//store it
			totalLoaded = tempTotalLoaded;
			loadTotal = tempTotal;
			
			loadStatus = PROGRESS;
			
			//now dispatch a stream event of your own
			dispatchEvent(new StreamEvent(StreamEvent.STATUS, this));
		}
	}
}
