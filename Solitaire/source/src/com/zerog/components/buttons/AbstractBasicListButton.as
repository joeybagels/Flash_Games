package com.zerog.components.buttons {
	import flash.errors.IllegalOperationError;
	import flash.utils.getQualifiedClassName;
	
	import com.zerog.components.buttons.BasicButton;
	import com.zerog.components.list.IListItem;		

	/**
	 * @author Chris
	 * 
	 * Extends the behaviors of an <code>BasicButton</code> while implementing
	 * the <code>IListItem</code> interface so that this button is usable in lists.
	 */
	public class AbstractBasicListButton extends BasicButton implements IListItem {
		protected var index:uint;
		
		public function AbstractBasicListButton() {
			if (getQualifiedClassName(this) == "com.zerog.components.buttons::AbstractBasicListButton") {
				throw new ArgumentError("AbstractBasicListButton can't be instantiated directly");
			}
		}
		
		public function getIndex():uint {
			return this.index;
		}
		
		public function setIndex(index:uint):void {
			this.index = index;
		}
		
		public function getLabel():Object {
			throw new IllegalOperationError("operation not supported");
		}
		
		public function setEnabled(enabled:Boolean):void {
			super.enabled = enabled;
		}
	}
}