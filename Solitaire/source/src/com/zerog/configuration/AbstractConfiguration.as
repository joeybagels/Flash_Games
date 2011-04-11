package com.zerog.configuration {
	import flash.errors.IllegalOperationError;
	import flash.utils.getQualifiedClassName;
	
	import com.zerog.data.AbstractData;	

	/**
	 * Abstract class to store configuration properties
	 *  
	 * @author Chris.Lam
	 * 
	 */
	public class AbstractConfiguration extends AbstractData {
		public function AbstractConfiguration() {
			if (getQualifiedClassName(this) == "com.zerog.configuration::AbstractConfiguration") {
				throw new ArgumentError("AbstractConfiguration can't be instantiated directly");
			}
		}
		
		public function loadConfiguration(path:String):void {
			throw new IllegalOperationError("operation not supported");
		}
	}
}