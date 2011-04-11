package com.zerog.components.list {
	import flash.display.MovieClip;
	import flash.errors.IllegalOperationError;
	import flash.utils.getQualifiedClassName;	

	/**
	 * @author Chris
	 */
	public class AbstractListItem extends MovieClip implements IListItem {
		protected var index:uint;
		protected var data:Object;

		public function AbstractListItem() {
			if (getQualifiedClassName(this) == "com.zerog.components.list::AbstractListItem") {
				throw new ArgumentError("AbstractListItem can't be instantiated directly");
			}
		}

		public function getData():Object {
			return this.data;
		}

		public function setData(data:Object):void {
			this.data = data;
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

		public function setSelected(select:Boolean, dispatch:Boolean = false):void {
			throw new IllegalOperationError("operation not supported");
		}
		
		public function setEnabled(enabled:Boolean):void {
			this.enabled = enabled;
		}
		
		public function isSelected():Boolean {
			throw new IllegalOperationError("operation not supported");
		} 
	}
}
