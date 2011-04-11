package org.pranaframework.domain {
	
	/**
	 * Describes a value object.
	 */
	public interface IValueObject {
		
		/**
		 * Clones (copies) the value object.
		 */
		function clone():*;
		
		/**
		 * Copies the properties from the given value object into this value object.
		 */
		function copyFrom(other:*):void;
		
		/**
		 * Checks if this value object is equal to another value object.
		 */
		function equals(other:*):Boolean;
		
	}
}