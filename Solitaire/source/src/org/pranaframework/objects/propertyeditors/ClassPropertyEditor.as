package org.pranaframework.objects.propertyeditors {
	
	import org.pranaframework.utils.ClassUtils;
	
	/**
	 * Converts class names to class objects.
	 * 
	 * @author Christophe Herreman
	 */
	public class ClassPropertyEditor extends AbstractPropertyEditor {
		
		public function ClassPropertyEditor() {
			super();
		}
		
		override public function set text(value:String):void {
			this.value = ClassUtils.forName(value);
		}
		
	}
}