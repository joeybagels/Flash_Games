package org.pranaframework.objects.propertyeditors {
	
	import flash.errors.IllegalOperationError;
	
	import org.pranaframework.objects.IPropertyEditor;
	
	/**
	 * Abstract property editor.
	 * 
	 * @author Christophe Herreman
	 */
	public class AbstractPropertyEditor implements IPropertyEditor {
		
		private var _value:*;
		
		public function AbstractPropertyEditor() {
		}
		
		public function get text():String {
			return value.toString();
		}
		
		public function set text(value:String):void {
			throw new IllegalOperationError("set text must be implemented");
		}
		
		public function get value():* {
			return _value;
		}
		
		public function set value(v:*):void {
			_value = v;
		}
		
	}
}