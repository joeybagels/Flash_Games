package com.zerog.utils.load {
	import flash.display.LoaderInfo;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLStream;
	
	import com.zerog.events.StreamEvent;		

	internal class AbstractSingleLoadStream extends AbstractLoadStream {
		private var broadcaster:IEventDispatcher;
		
		public override function setLoader(loader:IEventDispatcher):void {
			broadcaster = loader;
			broadcaster.addEventListener(Event.OPEN, onOpen);
			broadcaster.addEventListener(ProgressEvent.PROGRESS, onProgress);
			broadcaster.addEventListener(IOErrorEvent.IO_ERROR, onError);
			broadcaster.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			broadcaster.addEventListener(Event.COMPLETE, onComplete);
		}
		
		private function onOpen(e:Event):void {
			//only change to open if in idle state
			if (this.loadStatus == IDLE) {
				this.loadStatus = OPEN;
			}
			
			dispatchEvent(new StreamEvent(StreamEvent.OPEN, this));
		}

		private function onComplete(e:Event):void {
			
			loadStatus = COMPLETE;
			
			totalLoaded = loadTotal;
			
			if (e.currentTarget is URLLoader) {
				data = e.target.data;
			}
			else if (e.currentTarget is LoaderInfo) {
				data = e.target.content;
			}
			else if (e.currentTarget is URLStream) {
				data = e.target;
			}
			
			dispatchEvent(new StreamEvent(StreamEvent.COMPLETE, this));
		}

		private function onProgress(e:ProgressEvent):void {
			loadStatus = PROGRESS;
			
			totalLoaded = e.bytesLoaded;
			loadTotal = e.bytesTotal;
			
			if (e.currentTarget is URLStream) {
				data = e.currentTarget;
			}
			
			dispatchEvent(new StreamEvent(StreamEvent.STATUS, this));
		}

		private function onError(e:IOErrorEvent):void {
			trace(e);
			loadStatus = ERROR;
			dispatchEvent(new StreamEvent(StreamEvent.ERROR, this));
			dispatchEvent(new StreamEvent(StreamEvent.COMPLETE, this));
		}
	}
}