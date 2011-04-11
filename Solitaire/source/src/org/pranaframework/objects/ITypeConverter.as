package org.pranaframework.objects {
	
	/**
	 * Converts a string value to a typed object.
	 * 
	 * @author Christophe Herreman
	 */
	public interface ITypeConverter {
		
		/**
		 * Convert the given value to the required type.
		 * 
		 * @param value the value to convert
		 * @param requiredType the type to convert to
		 */
		function convertIfNecessary(value:*, requiredType:Class = null):*;
		
	}
}