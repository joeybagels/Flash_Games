package org.pranaframework.objects {
	
	/**
	 * Defines a registry for property editors.
	 * 
	 * @author Christophe Herreman
	 */
	public interface IPropertyEditorRegistry {
		
		/**
		 * Registers the given property editor for the given type.
		 * 
		 * @param requiredType the type of the property
		 * @param propertyEditor the property editor to register
		 */
		function registerCustomEditor(requiredType:Class, propertyEditor:IPropertyEditor):void;
		
		/**
		 * Finds a property editor that was registered against the given type.
		 * 
		 * @param requiredType the type of the property
		 */
		function findCustomEditor(requiredType:Class):IPropertyEditor;
		
	}
}