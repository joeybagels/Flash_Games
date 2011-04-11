package com.zerog.utils.load {
	import flash.net.URLLoaderDataFormat;	
	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLStream;

	/**
	 * @author Chris
	 */
	public class LoadUtil {
		private var swfQueue:Array;
		private var imageQueue:Array;
		private var fileQueue:Array;
		private var binaryQueue:Array;

		public function LoadUtil() {
			this.swfQueue = new Array();
			this.imageQueue = new Array();
			this.fileQueue = new Array();
			this.binaryQueue = new Array();
		}

		public static function loadMultiple(multipleStream:MultipleLoadStream):void {
			//get the streams
			var streams:Array = multipleStream.getStreams();
			
			for each (var stream:ILoadStream in streams) {
				try {
					load(stream);
				}
				catch (e:Error) {
					multipleStream.removeStream(stream);
				}
			}
		}

		public static function load(stream:ILoadStream):void {
			var type:uint = stream.getType();
			
			if (type == LoadTypes.DISPLAY_STREAM) {
				loadDisplay(stream);
			}
			else if (type == LoadTypes.TEXT_STREAM) {
				loadText(stream);
			}
			else if (type == LoadTypes.BINARY_STREAM) {
				loadBytes(stream);
			}
			else if (type == LoadTypes.BINARY_ARRAY_STREAM) {
				loadByteArray(stream);
			}
			else {
				throw new Error("ILoadStream object has invalid type");
			}
		}

		private static function loadDisplay(stream:ILoadStream):void {   
			var request:URLRequest = new URLRequest(stream.getUrl());
			var loader:Loader = new Loader();
            
			stream.setLoader(loader.contentLoaderInfo);
			
			loader.load(request);
		}

		private static function loadText(stream:ILoadStream):void {
			var request:URLRequest = new URLRequest(stream.getUrl());
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			
			stream.setLoader(loader);
			
			loader.load(request);
		}

		private static function loadBytes(stream:ILoadStream):void {
			var request:URLRequest = new URLRequest(stream.getUrl());
			var loader:URLStream = new URLStream();
			
			stream.setLoader(loader);
			
			loader.load(request);
		}
	
		private static function loadByteArray(stream:ILoadStream):void {
			var loader:Loader = new Loader();
            
			stream.setLoader(loader.contentLoaderInfo);
			
			loader.loadBytes(stream.getByteArray());
		}
	}
}
