package com.zerog.utils.load {
	import flash.utils.ByteArray;	
	
	import com.zerog.utils.load.AbstractSingleLoadStream;
	
	/**
	 * @author Chris
	 */
	public class BinaryArrayLoadStream extends AbstractSingleLoadStream {
		public function BinaryArrayLoadStream(bytes:ByteArray, id:String = null) {
			this.byteArray = bytes;
			this.id = id;
			this.type = LoadTypes.BINARY_ARRAY_STREAM;
		}
	}
}
