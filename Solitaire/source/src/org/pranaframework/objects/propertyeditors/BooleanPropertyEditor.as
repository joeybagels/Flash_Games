package org.pranaframework.objects.propertyeditors {
	
	/**
	 * Converts boolean string values (true or false) to a typed
	 * Boolean value.
	 * 
	 * @author Christophe Herreman
	 */
	public class BooleanPropertyEditor extends AbstractPropertyEditor {
		
		private static const VALUE_TRUE:String = "true";
		private static const VALUE_FALSE:String = "false";
		
		/**
		 * Creates a new BooleanPropertyEditor.
		 */
		public function BooleanPropertyEditor() {
			super();
		}
		
		override public function set text(value:String):void {
			if (value.toLowerCase() == VALUE_TRUE) {
				this.value = true;
			}
			else if (value.toLowerCase() == VALUE_FALSE) {
				this.value = false;
			}
		}
		
	}
}