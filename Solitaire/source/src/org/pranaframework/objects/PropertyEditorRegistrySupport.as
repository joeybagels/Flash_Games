package org.pranaframework.objects {
	
	import flash.utils.Dictionary;
	
	import org.pranaframework.objects.propertyeditors.BooleanPropertyEditor;
	import org.pranaframework.objects.propertyeditors.ClassPropertyEditor;
	import org.pranaframework.objects.propertyeditors.NumberPropertyEditor;
	import org.pranaframework.utils.Assert;
	
	/**
	 * Default implementation of a property editor registry.
	 * 
	 * @author Christophe Herreman
	 */
	public class PropertyEditorRegistrySupport implements IPropertyEditorRegistry {
		
		private var _customEditors:Dictionary = new Dictionary();
		
		/**
		 * 
		 */
		public function PropertyEditorRegistrySupport() {
			registerDefaultEditors();
		}
		
		/**
		 * @inheritDoc
		 */
		public function registerCustomEditor(requiredType:Class, propertyEditor:IPropertyEditor):void {
			Assert.notNull(requiredType, "The required type cannot be null");
			Assert.notNull(propertyEditor, "The property editor cannot be null");
			_customEditors[requiredType] = propertyEditor;
		}
		
		/**
		 * @inheritDoc
		 */
		public function findCustomEditor(requiredType:Class):IPropertyEditor {
			return _customEditors[requiredType];
		}
		
		/**
		 * 
		 */
		private function registerDefaultEditors():void {
			registerCustomEditor(Boolean, new BooleanPropertyEditor());
			registerCustomEditor(Number, new NumberPropertyEditor());
			registerCustomEditor(Class, new ClassPropertyEditor());
		}
		
	}
}