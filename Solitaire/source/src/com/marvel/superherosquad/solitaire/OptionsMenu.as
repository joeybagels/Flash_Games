package com.marvel.superherosquad.solitaire
{
	import com.zerog.components.buttons.BasicButton;
	import com.zerog.components.buttons.ButtonEvent;
	import com.zerog.components.dialogs.AbstractDialog;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class OptionsMenu extends AbstractDialog {
		public var timerOff:BasicButton;
		public var timerOn:BasicButton;
		public var draw1:BasicButton;
		public var draw3:BasicButton;
		public var okay:BasicButton;
		public var cancel:BasicButton;
		public var soundOn:BasicButton;
		public var soundOff:BasicButton;
		public var confirm:OptionsConfirmDialog;
		

		public var stats:BasicButton;
		public var statsDialog:StatsDialog;
		
		public static const TIMER_OFF:String = "timer off";
		public static const TIMER_ON:String = "timer on";
		public static const DRAW_1:String = "draw 1";
		public static const DRAW_3:String = "draw 3";
		public static const CANCEL:String = "cancel";
		public static const OK:String = "ok";

		public static const CONFIRM_CANCEL:String = "cancel";
		public static const CONFIRM_OK:String = "ok";
		public static const SOUND_ON:String = "sound on";
		public static const SOUND_OFF:String = "sound off";
		public static const NEW_GAME:String = "new game";


		
		public static const DECK_PICK:String = "deck pick";
		public static const STATS_CHECK:String = "stats check";
		
		private var requiresNewGame:Boolean = false;
		private var drawOne:Boolean;
		private var sound:Boolean;
		private var timer:Boolean;
		
		public function OptionsMenu() {
			super();
			
			
			this.stats.addEventListener(MouseEvent.CLICK, onStatsClick);
			
			this.statsDialog.setParent(this);
			this.statsDialog.removeDialog();
			
			
			this.confirm.setParent(this);
			this.confirm.okay.addEventListener(MouseEvent.CLICK, onConfirmOk);
			this.confirm.cancel.addEventListener(MouseEvent.CLICK, onConfirmCancel);
			this.confirm.removeDialog();
			
			this.timerOff.addEventListener(ButtonEvent.SELECTED, onTimerOff);
			this.timerOn.addEventListener(ButtonEvent.SELECTED, onTimerOn);

			this.draw1.addEventListener(ButtonEvent.SELECTED, onDraw1);
			this.draw3.addEventListener(ButtonEvent.SELECTED, onDraw3);
			
			this.okay.addEventListener(MouseEvent.CLICK, onOkay);
			this.cancel.addEventListener(MouseEvent.CLICK, onClose);
			
			this.soundOn.addEventListener(ButtonEvent.SELECTED, onSoundOnSelected);
			this.soundOff.addEventListener(ButtonEvent.SELECTED, onSoundOffSelected);
			
		
		}

	

		private function onStatsClick(e:MouseEvent):void {
			dispatchEvent(new Event(STATS_CHECK));
			this.statsDialog.showDialog();
		}
		
		public function setStats(drawOneHigh:Number, drawOnePercent:Number, drawThreeHigh:Number, drawThreePercent:Number, drawOneHighTimer:Number, drawOnePercentTimer:Number, drawThreeHighTimer:Number, drawThreePercentTimer:Number):void {
			this.statsDialog.setScores(drawOneHigh, drawOnePercent, drawThreeHigh, drawThreePercent, drawOneHighTimer, drawOnePercentTimer, drawThreeHighTimer, drawThreePercentTimer);
		}

	
		override public function showDialog(x:Number = Number.NaN, y:Number = Number.NaN):void {
			super.showDialog(x,y);
		
			this.requiresNewGame = false;

			//save the current state
			if (this.draw1.isSelected()) {
				this.drawOne = true;
			}
			else {
				this.drawOne = false;
			}
			
			if (this.soundOn.isSelected()) {
				this.sound = true;
			}
			else {
				this.sound = false;	
			}
			
			if (this.timerOn.isSelected()) {
				this.timer = true;
			}
			else {
				this.timer = false;
			}
		}

		private function onSoundOnSelected(e:ButtonEvent):void {
			this.soundOff.setSelected(false, false);
			this.soundOff.setSelectOnClick(true);
			
			this.soundOn.setSelectOnClick(false);
			
			
			dispatchEvent(new Event(SOUND_ON));
		}

		private function onSoundOffSelected(e:ButtonEvent):void {
			this.soundOn.setSelected(false, false);
			this.soundOn.setSelectOnClick(true);
			
			this.soundOff.setSelectOnClick(false);
			
			dispatchEvent(new Event(SOUND_OFF));
		}
		
		private function onConfirmCancel(e:MouseEvent):void {
			dispatchEvent(new Event(CONFIRM_CANCEL));
			
			this.confirm.removeDialog();
		}
		
		private function onConfirmOk(e:MouseEvent):void {
			dispatchEvent(new Event(CONFIRM_OK));
			dispatchEvent(new Event(NEW_GAME));
			
			this.confirm.removeDialog();
		}

		private function onOkay(e:MouseEvent):void {
			dispatchEvent(new Event(OK));
			
			if (this.requiresNewGame) {
				this.confirm.showDialog();
			}
			else {
				removeDialog();
			}
		}

		private function onClose(e:MouseEvent):void {
			if (this.parent != null) {
				this.parent.removeChild(this);
				
				//restore the current state
				if (this.drawOne) {
					selectDraw1();
				}
				else {
					selectDraw3();
				}
				
				if (this.sound) {
					selectSounds(true);
				}
				else {
					selectSounds(true);
				}
				
				if (this.timer) {
					selectTimerOn();
				}
				else {
					selectTimerOff();
				}
				
				dispatchEvent(new Event(CANCEL));
			}
		}

		private function onDraw1(e:ButtonEvent):void {
			this.requiresNewGame = true;
			
			this.draw1.setSelectOnClick(false);

			this.draw3.setSelected(false, false);
			this.draw3.setSelectOnClick(true);
			
			dispatchEvent(new Event(DRAW_1));
		}
		
		private function onDraw3(e:ButtonEvent):void {
			this.requiresNewGame = true;
			
			this.draw3.setSelectOnClick(false);
			
			this.draw1.setSelected(false, false);
			this.draw1.setSelectOnClick(true);
			
			dispatchEvent(new Event(DRAW_3));
		}
		
		private function onTimerOff(e:ButtonEvent):void {
			this.requiresNewGame = true;
			
			this.timerOff.setSelectOnClick(false);
			
			this.timerOn.setSelected(false, false);
			this.timerOn.setSelectOnClick(true);
			
			dispatchEvent(new Event(TIMER_OFF));
		}
		
		private function onTimerOn(e:ButtonEvent):void {
			this.requiresNewGame = true;
			
			this.timerOn.setSelectOnClick(false);
			
			this.timerOff.setSelected(false, false);
			this.timerOff.setSelectOnClick(true);
			
			dispatchEvent(new Event(TIMER_ON));
		}
		
		public function isDraw1():Boolean {
			return this.draw1.isSelected();
		}
		
		public function isTimed():Boolean {
			return this.timerOn.isSelected();
		}
		public function selectSounds(enable:Boolean):void {
			
			if (enable) {
				trace("sound on");
				this.soundOn.setSelected(true, false);
				this.soundOn.setSelectOnClick(false);
				
				this.soundOff.setSelected(false, false);
				this.soundOff.setSelectOnClick(true);
			}
			else {
				
				trace("select sounds " + enable);
				this.soundOff.setSelected(true, false);
				this.soundOff.setSelectOnClick(false);
				
				this.soundOn.setSelected(false, false);
				this.soundOn.setSelectOnClick(true);
			}
		}
		
		public function selectTimerOff():void {
			this.timerOff.setSelected(true, false);
			
			this.timerOff.setSelectOnClick(false);

			this.timerOn.setSelected(false, false);
			this.timerOn.setSelectOnClick(true);
		}

		public function selectTimerOn():void {
			this.timerOn.setSelected(true, false);
			
			this.timerOn.setSelectOnClick(false);
			
			this.timerOff.setSelected(false, false);
			this.timerOff.setSelectOnClick(true);
		}
		
		public function selectDraw1():void {
			this.draw1.setSelected(true, false);
			
			this.draw1.setSelectOnClick(false);
			
			this.draw3.setSelected(false, false);
			this.draw3.setSelectOnClick(true);
			
		}
		
		public function selectDraw3():void {
			this.draw3.setSelected(true, false);
			
			this.draw3.setSelectOnClick(false);
			
			this.draw1.setSelected(false, false);
			this.draw1.setSelectOnClick(true);
		}
	}
}