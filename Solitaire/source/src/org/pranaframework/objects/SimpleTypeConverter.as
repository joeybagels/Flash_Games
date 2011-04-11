package org.pranaframework.objects {
	
	import org.pranaframework.utils.TypeResolver;
	
	/**
	 * Simple implementation of the ITypeConverter interface.
	 * 
	 * @author Christophe Herreman
	 */
	public class SimpleTypeConverter extends PropertyEditorRegistrySupport implements ITypeConverter {
		
		/**
		 * Creates a new SimpleTypeConverter
		 */
		public function SimpleTypeConverter() {
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		public function convertIfNecessary(value:*, requiredType:Class = null):* {
			if (!requiredType) {
				requiredType = TypeResolver.resolveType(value.toString());
			}
			
			if (value is requiredType)
				return value;
			
			if (!(value is String))
				value = value.toString();
				
			var result:* = value;
			var editor:IPropertyEditor = findCustomEditor(requiredType);
			
			if (editor) {
				editor.text = value;
				result = editor.value;
			}

			return result;
		}
		
	}
}