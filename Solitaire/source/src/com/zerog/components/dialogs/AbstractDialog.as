package com.zerog.components.dialogs {
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Chris
	 */
	public class AbstractDialog extends MovieClip implements IDialog {
		protected var parentContainer:DisplayObjectContainer;

		public function AbstractDialog() {
			if (getQualifiedClassName(this) == "com.zerog.components.dialogs::AbstractDialog") {
				throw new ArgumentError("AbstractDialog can't be instantiated directly");
			}
		}

		public function getParentContainer():DisplayObjectContainer {
			return this.parentContainer;
		}

		/*
		 * @param parentContainer
		 * 
		 * Sets the parent container
		 */
		public function setParent(parentContainer:DisplayObjectContainer):void {
			this.parentContainer = parentContainer;
		}

		/*
		 * @param x the x coordinate to place the dialog in relationship to <code>parentContainer</code>
		 * @param y the y coordinate to place the dialog in relationship to <code>parentContainer</code>
		 * 
		 * If x and y are not specified, the dialog is placed in the center of the 
		 * <code>parentContainer</code>, assuming that the
		 * parent is larger than the dialog if x and y are not specified
		 */
		public function showDialog(x:Number = Number.NaN, y:Number = Number.NaN):void {
			showDialogAt(x, y, this.parentContainer.numChildren);
		}

		public function showDialogAt(x:Number = Number.NaN, y:Number = Number.NaN, index:int = 0):void {
			trace(this.parentContainer);
			trace(this.parentContainer.width + " " + this.parentContainer.height);
			if (isNaN(x)) {
				//find the center coordinates, assuming the dialog is smaller than the parent
				x = (this.parentContainer.width - this.width)/2;
			}
			
			if (isNaN(y)) {
				y = (this.parentContainer.height - this.height)/2;
			}
			trace("x y " + x  + " " + y);
			this.x = Math.round(x);
			this.y = Math.round(y);
			
			this.parentContainer.addChildAt(this, index);
		}
		
		/*
		 * Removes the dialog from the <code>parentContainer</code>
		 */
		public function removeDialog():void {
			if (this.parentContainer.contains(this)) {
				this.parentContainer.removeChild(this);
			}
		}
	}
}
