package com.zerog.components.buttons {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;	

	/**
	 * @author Chris
	 * 
	 * Handles basic button behavior such as rollovers, selection, and disabling
	 */
	public class AbstractButton extends MovieClip {

		protected var isSelectable:Boolean;
		protected var isSelectOnClick:Boolean;
		protected var selected:Boolean;
		protected var isEnabled:Boolean;
		protected var myData:Object;
		
		public function AbstractButton() {
			if (getQualifiedClassName(this) == "com.zerog.components.buttons::AbstractButton") {
				throw new ArgumentError("AbstractButton can't be instantiated directly");
			}
			
			var hitClip:Sprite = this.getChildByName("hit") as Sprite;
			
			if (hitClip != null) {
				hitClip.mouseEnabled = false;
				this.hitArea = hitClip;
				this.hitArea.visible = false;
			}
			
			this.buttonMode = false;
			this.mouseChildren = false;
			this.focusRect = false;
			
			addEventListener(MouseEvent.ROLL_OVER, ourRollOver, false, 1, true);
			addEventListener(MouseEvent.ROLL_OUT, ourRollOut, false, 1, true);
			addEventListener(MouseEvent.MOUSE_DOWN, ourMouseDown, false, 1, true);
			addEventListener(MouseEvent.MOUSE_UP, ourMouseUp, false, 1, true);
			addEventListener(MouseEvent.CLICK, ourClick, false, 1, true);
			
			this.isSelectable = false;
			
			this.isSelectOnClick = isSelectable;
			
			//set to not currently selected
			this.selected = false;
			
			//set to enabled
			this.isEnabled = true;
		}

		public function getSelectOnClick():Boolean { 
			return this.isSelectOnClick; 
		}

		public function setSelectOnClick(s:Boolean):void {
			//if selectable
			if (this.isSelectable) {
				this.isSelectOnClick = s;
			}
		}

		public function isSelected():Boolean { 
			return this.selected; 
		}

		public function setSelected(s:Boolean, dispatch:Boolean = true):void {
			
			//if selectable and setting to something different
			if (this.isSelectable && this.selected != s ) {
				//set as selected
				this.selected = s;
				
				//if selected, disable. if not selected then enable
				this.isEnabled = !selected;
				
				//if selectable and selected
				if (this.selected) {
					
					//dispatch a selected event
					if (dispatch) {
						this.dispatchEvent(new ButtonEvent(ButtonEvent.SELECTED));
					}
				}
				else {
					//dispatch a deselected event
					if (dispatch) {
						this.dispatchEvent(new ButtonEvent(ButtonEvent.DESELECTED));
					}
				}
			}
		}

		public function getData():Object { 
			return this.myData; 
		}

		public function setData(d:Object):void {
			this.myData = d;
		}
		
		override public function set enabled(e:Boolean):void {
			this.isSelectOnClick = e;
			
			//if setting to something different
			if (this.isEnabled != e) {
				//set the new value
				this.isEnabled = e;
				
				//if you are enabled
				if (this.isEnabled) {
					//dispatch an enabled event
					this.dispatchEvent(new ButtonEvent(ButtonEvent.ENABLED));
				} 
				else {
					//dispatch disabled event
					this.dispatchEvent(new ButtonEvent(ButtonEvent.DISABLED));
				}
			}
		}
		
		protected function ourClick( e:MouseEvent ):void {
			//if enabled or currently selected
			if (this.isEnabled || this.selected) {
				//if you are selectable on click
				if (this.isSelectOnClick) {
					//reverse selected state
					this.setSelected(!selected);
				}
			} else {
				//stop all processing of events
				e.stopImmediatePropagation();
			}
		}

		protected function ourMouseUp(e:MouseEvent):void {
			//if not enabled
			if (!this.isEnabled) {
				//stop all processing of events
				e.stopImmediatePropagation();
			}
		}

		protected function ourMouseDown(e:MouseEvent):void {
			//if not enabled
			if (!this.isEnabled) {
				//stop all processing of events
				e.stopImmediatePropagation();
			}
		}

		protected function ourRollOut(e:MouseEvent):void {
			//if not enabled
			if (!this.isEnabled) {
				//stop all processing of events
				e.stopImmediatePropagation();
			}
		}

		protected function ourRollOver(e:MouseEvent):void {
			trace("roll over");
			//if not enabled
			if (!this.isEnabled) {
				//stop all processing of events
				e.stopImmediatePropagation();
			}
		}
	}
}
