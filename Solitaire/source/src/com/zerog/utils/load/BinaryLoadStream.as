package com.zerog.utils.load {
	import com.zerog.utils.load.AbstractSingleLoadStream;
	
	/**
	 * @author Chris
	 */
	public class BinaryLoadStream extends AbstractSingleLoadStream {
		public function BinaryLoadStream(url:String, id:String = null) {
			this.url = url;		
			this.id = id;
			this.type = LoadTypes.BINARY_STREAM;
		}
	}
}
