package com.zerog.components.buttons {
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;	

	/*
	 * @author Chris
	 * 
	 * Relies on the use of frame labels for animation/changing visual state of buttons.
	 */
	public class BasicButton extends AbstractButton {
		// button states
		public static const STATE_IDLE:String = 'idle';
		public static const STATE_UP:String = 'up';
		public static const STATE_DOWN:String = 'down';
		public static const STATE_OVER:String = 'over';
		public static const STATE_OUT:String = 'out';
		public static const STATE_SELECTED:String = 'selected';
		public static const STATE_DISABLED:String = 'disabled';

		protected var states:Dictionary;
		protected var currentState:FrameLabel;

		public function BasicButton() {
			super();
			
			prepareStates();
			changeState(STATE_IDLE);
			
			//if there is a selected state, this button is selectable
			//by click
			this.isSelectable = this.hasState(STATE_SELECTED);
			this.isSelectOnClick = this.isSelectable;
		}

		private function prepareStates():void {
			this.states = new Dictionary();
			for each (var f:FrameLabel in this.currentLabels) {
				this.states[f.name] = f;
			}
			this.currentState = this.states[currentLabel];
		}

		public function changeState(state:String):Boolean {
			//set the target frame
			var targetFrame:FrameLabel = this.states[state];

			//if not found
			if (targetFrame == null) {
				return false;
			}
			else {
				this.currentState = targetFrame;
				if (this.currentState != null && this.currentState.name != this.currentLabel) {
					gotoAndPlay(targetFrame.frame);
				}
				return true;
			}
		}

		public function hasState(state:String):Boolean {
			return (this.states[state] != null);
		}

		override protected function ourRollOver( e:MouseEvent ):void { 
			//if the button is enabled
			if (this.isEnabled) {
				//change the state to over
				changeState(STATE_OVER);
			} else {
				//stop all processing of this event
				e.stopImmediatePropagation();
			}
		}

		override protected function ourRollOut( e:MouseEvent ):void {
			//if the button is enabled
			if (this.isEnabled) {
				//if you have optional out state
				if (hasState(STATE_OUT)) {
					//change the state to out
					changeState(STATE_OUT);
				}
				else {
					//change the state to up
					changeState(STATE_UP);
				}
			}
			else {
				//stop all processing of this event
				e.stopImmediatePropagation();
			}
		}

		override protected function ourMouseDown( e:MouseEvent ):void {
			//if the button is enabled
			if (this.isEnabled) {
				//if you have this optional down state
				if (hasState(STATE_DOWN)) {
					//change to state down
					changeState(STATE_DOWN);
				}
			} else {
				trace("moue down stop");
				//stop all processing of events
				e.stopImmediatePropagation();
			}
		}

		override protected function ourMouseUp( e:MouseEvent ):void {
			//if enabled
			if (this.isEnabled) {
				//if you have this optional down state
				if ( this.hasState(STATE_UP) ) {
					//change to state up
					this.changeState(STATE_UP);
				}
			} else {
				//stop all processing of events
				e.stopImmediatePropagation();
			}
		}

		override public function get enabled():Boolean { 
			return this.isEnabled; 
		}

		override public function set enabled(e:Boolean):void {
			//if setting to something different
			if (this.isEnabled != e) {
				super.enabled = e;
				
				//if you are enabled
				if (e) {
					//change the state to idle
					changeState(STATE_IDLE);
				} 
				else {
					if (hasState(STATE_DISABLED)) {
						//change state to disabled
						changeState(STATE_DISABLED);
					}
				}
			}
		}

		override public function setSelected(s:Boolean, dispatch:Boolean = true):void {
			//trace("state is selected? " + selected + " vs  " + s);
			//if setting to something different
			if (selected != s) {
			//	trace("different");
				super.setSelected(s, dispatch);
				
				//if selectable and selected
				if (selected && isSelectable) {
				//	trace("selected and selectable");
					//if you have a selected state
					if ( this.hasState(STATE_SELECTED) ) {
						trace("change stat select");
						this.changeState(STATE_SELECTED);
					}
				} 
				else {
				//	trace("not selected or selectable");
					if (isEnabled) {
						//trace("change stat iodle");
						//change to idle state
						this.changeState(STATE_IDLE);
					}
					else {
						//trace("change stat disable");
						this.changeState(STATE_DISABLED);
					}
				}
			}
		}
	}
}
