package org.pranaframework.objects {
	
	/**
	 * A property editor converts strings to typed objects.
	 * 
	 * @author Christophe Herreman
	 */
	public interface IPropertyEditor {
		
		function get text():String;
		function set text(value:String):void;
		
		function get value():*;
		function set value(v:*):void;
		
	}
}