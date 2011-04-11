package com.zerog.data {

	/**
	 * @author Chris
	 */
	public class XMLData extends AbstractData {
		public function XMLData() {
			super();
		}

		public function setXML(xmlString:String):void {
			this.data = new XML(xmlString);
		}
	}
}
