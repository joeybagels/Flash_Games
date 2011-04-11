package com.zerog.utils.load {
	import com.zerog.utils.load.TextLoadStream;
	
	/**
	 * @author Chris
	 */
	public class XmlLoadStream extends TextLoadStream {
		public function XmlLoadStream(url:String, id:String = null) {
			super(url, id);
		}
		
		override public function getData():* {
			return new XML(super.getData());
		}
	}
}
