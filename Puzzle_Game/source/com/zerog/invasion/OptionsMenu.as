package com.zerog.invasion
{
	//import com.zerog.components.buttons.BasicButton;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.text.TextField;

	import com.zerog.invasion.Game;
	import com.zerog.events.ButtonEvent;
	import com.zerog.components.dialogs.AbstractDialog;	

	public class OptionsMenu extends AbstractDialog {
		//public var okay:BasicButton;
		//public var CANCEL_EVENT:BasicButton;
		//public var soundOn:BasicButton;
		//public var soundOff:BasicButton;
		
		public static const CANCEL_EVENT:String = "CANCEL_EVENT";
		public static const OK_EVENT:String = "ok";

		public static const SOUND_ON:String = "sound on";
		public static const SOUND_OFF:String = "sound off";

		private var sound:Boolean;
		public static const MUSIC_ON:String = "music on";
		public static const MUSIC_OFF:String =  "music off";
		public static const TUTORIAL_ON:String = "tutorial on";
		public static const TUTORIAL_OFF:String =  "tutorial off";
		private var music:Boolean;
		private var tutorial:Boolean;

		
		public function OptionsMenu() {
			super();
			
			this.resetHighScore.addEventListener(MouseEvent.CLICK, onResetHighScore);
			this.okay.addEventListener(MouseEvent.CLICK, onOkay);
			this.cancel.addEventListener(MouseEvent.CLICK, onClose);
			
			this.soundOn.addEventListener(ButtonEvent.SELECTED, onSoundOnSelected);
			this.soundOff.addEventListener(ButtonEvent.SELECTED, onSoundOffSelected);
			
			this.musicOn.addEventListener(ButtonEvent.SELECTED, onMusicOnSelected);
			this.musicOff.addEventListener(ButtonEvent.SELECTED, onMusicOffSelected);
			
			this.tutorialOn.addEventListener(ButtonEvent.SELECTED, onTutorialOnSelected);
			this.tutorialOff.addEventListener(ButtonEvent.SELECTED, onTutorialOffSelected);
			
			
			block.addEventListener(MouseEvent.MOUSE_OVER, mouseEvents, true);
			block.addEventListener(MouseEvent.MOUSE_OUT, mouseEvents, true);
		}
		private function mouseEvents(e:MouseEvent):void {
			e.stopImmediatePropagation();
		}
		private function onResetHighScore(e:MouseEvent):void {
			var mySo:SharedObject = SharedObject.getLocal(Main.MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME);
			mySo.data.highScore = 0;
			mySo.flush();
			
			highScore.text = "0";
		}
		
		override public function showDialog(x:Number = Number.NaN, y:Number = Number.NaN):void {
			super.showDialog(x,y);
			
			//save the current state
			if (this.soundOn.isSelected()) {
				this.sound = true;
			}
			else {
				this.sound = false;	
			}
			
			if (this.musicOn.isSelected()) {
				this.music = true;
			}
			else {
				this.music = false;
			}
			
			if (this.tutorialOn.isSelected()) {
				this.tutorial = true;
			}
			else {
				this.tutorial = false
			}
			
			//display high score
			var mySo:SharedObject = SharedObject.getLocal(Main.MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME);
			if (mySo.data.highScore == undefined) {
				highScore.text = "0";
			}
			else {
				highScore.text = mySo.data.highScore;
			}
		}

		private function onTutorialOnSelected(e:ButtonEvent):void {
			this.tutorialOff.setSelected(false, false);
			this.tutorialOff.setSelectOnClick(true);
			
			this.tutorialOn.setSelectOnClick(false);
			
			dispatchEvent(new Event(TUTORIAL_ON));
		}

		private function onTutorialOffSelected(e:ButtonEvent):void {
			this.tutorialOn.setSelected(false, false);
			this.tutorialOn.setSelectOnClick(true);
			
			this.tutorialOff.setSelectOnClick(false);
		
			dispatchEvent(new Event(TUTORIAL_OFF));
		}

		private function onMusicOnSelected(e:ButtonEvent):void {
			this.musicOff.setSelected(false, false);
			this.musicOff.setSelectOnClick(true);
			
			this.musicOn.setSelectOnClick(false);
			
			dispatchEvent(new Event(MUSIC_ON));
		}

		private function onMusicOffSelected(e:ButtonEvent):void {
			this.musicOn.setSelected(false, false);
			this.musicOn.setSelectOnClick(true);
			
			this.musicOff.setSelectOnClick(false);
		
			dispatchEvent(new Event(MUSIC_OFF));
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

		private function onOkay(e:MouseEvent):void {
			//store settings
			var mySo:SharedObject = SharedObject.getLocal(Main.MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME);
			mySo.data.sounds = this.soundOn.isSelected();
			mySo.data.music = this.musicOn.isSelected();
			mySo.data.tutorial = this.tutorialOn.isSelected();
			mySo.flush();
			trace("optiosn music ? " + this.musicOn.isSelected())
			dispatchEvent(new Event(OK_EVENT));

			removeDialog();	
		}

		private function onClose(e:MouseEvent):void {
			if (this.parent != null) {
				this.parent.removeChild(this);
				
				//restore the current state
				if (this.sound) {
					selectSounds(true);
					trace("set sounds true")
				}
				else {
					selectSounds(false);
					trace("set sounds false")
				}
				
				if (this.music) {
					selectMusic(true);
				}
				else {
					selectMusic(false);
				}
				
				if (this.tutorial) {
					selectTutorial(true)
				}
				else {
					selectTutorial(false)
				}
				
				dispatchEvent(new Event(CANCEL_EVENT));
			}
		}

		public function selectTutorial(enable:Boolean):void {
			//store it
			var mySo:SharedObject = SharedObject.getLocal(Main.MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME);
			mySo.data.tutorial = enable;
			mySo.flush();
			
			if (enable) {
				this.tutorialOn.setSelected(true, false);
				this.tutorialOn.setSelectOnClick(false);
				this.tutorialOff.setSelected(false, false);
				this.tutorialOff.setSelectOnClick(true);
				
			}
			else {
				//trace("select tutorials " + enable);
				this.tutorialOff.setSelected(true, false);
				this.tutorialOff.setSelectOnClick(false);
				this.tutorialOn.setSelected(false, false);
				this.tutorialOn.setSelectOnClick(true);
			}
		}
		
		public function selectMusic(enable:Boolean):void {
			//store it
			var mySo:SharedObject = SharedObject.getLocal(Main.MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME);
			mySo.data.music = enable;
			mySo.flush();
			
			if (enable) {
				this.musicOn.setSelected(true, false);
				this.musicOn.setSelectOnClick(false);
				this.musicOff.setSelected(false, false);
				this.musicOff.setSelectOnClick(true);
				
			}
			else {
				//trace("select musics " + enable);
				this.musicOff.setSelected(true, false);
				this.musicOff.setSelectOnClick(false);
				this.musicOn.setSelected(false, false);
				this.musicOn.setSelectOnClick(true);
			}
		}
		
		public function selectSounds(enable:Boolean):void {
			//store it
			var mySo:SharedObject = SharedObject.getLocal(Main.MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME);
			mySo.data.sounds = enable;
			mySo.flush();
			
			if (enable) {
				this.soundOn.setSelected(true, false);
				this.soundOn.setSelectOnClick(false);
				this.soundOff.setSelected(false, false);
				this.soundOff.setSelectOnClick(true);
				
			}
			else {
				//trace("select sounds " + enable);
				this.soundOff.setSelected(true, false);
				this.soundOff.setSelectOnClick(false);
				this.soundOn.setSelected(false, false);
				this.soundOn.setSelectOnClick(true);
			}
		}
	}
}