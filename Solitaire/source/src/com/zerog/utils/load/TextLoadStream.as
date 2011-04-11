package com.zerog.utils.load {
	import com.zerog.utils.load.AbstractSingleLoadStream;
	
	/**
	 * @author Chris
	 */
	public class TextLoadStream extends AbstractSingleLoadStream {
		public function TextLoadStream(url:String, id:String = null) {
			this.url = url;		
			this.id = id;
			this.type = LoadTypes.TEXT_STREAM;
		}
	}
}
