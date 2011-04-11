package org.pranaframework.objects.propertyeditors {
	
	import org.pranaframework.objects.IPropertyEditor;
	
	/**
	 * Converts a number represented by a string to a number object.
	 * 
	 * @author Christophe Herreman
	 */
	public class NumberPropertyEditor extends AbstractPropertyEditor {
		
		/**
		 * 
		 */
		public function NumberPropertyEditor() {
		}
		
		override public function set text(value:String):void {
			this.value = Number(value);
		}
		
	}
}