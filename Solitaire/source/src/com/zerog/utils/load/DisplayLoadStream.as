package com.zerog.utils.load {
	
	/**
	 * @author Chris
	 */
	public class DisplayLoadStream extends AbstractSingleLoadStream {		
		public function DisplayLoadStream(url:String, id:String = null) {
			this.url = url;		
			this.id = id;
			this.type = LoadTypes.DISPLAY_STREAM;
		}
	}
}
