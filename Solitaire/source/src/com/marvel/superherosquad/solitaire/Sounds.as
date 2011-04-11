package com.marvel.superherosquad.solitaire
{
	import flash.media.SoundChannel;
	
	import mx.core.SoundAsset;
	
	public class Sounds
	{
		private var splashPlayed:Boolean;
		
		[Embed(source="../../../../../sounds/move_train_whistle.mp3")]
		private var Whistle:Class;
		private var whistleSound:SoundAsset = new Whistle() as SoundAsset;
		
		[Embed(source="../../../../../sounds/Dialougefaded.mp3.mp3")]
		private var Dialog:Class;
		private var dialogSound:SoundAsset = new Dialog() as SoundAsset;
		
		[Embed(source="../../../../../sounds/Zero G-Western Theme.mp3")]
		private var Splash:Class;
		private var splashSound:SoundAsset = new Splash() as SoundAsset;

		[Embed(source="../../../../../sounds/card_place_6.mp3")]
		private var TT:Class;
		private var ttSound:SoundAsset = new TT() as SoundAsset;
		
		[Embed(source="../../../../../sounds/autocomplete.mp3")]
		private var AutoComplete:Class;
		private var autoCompleteSound:SoundAsset = new AutoComplete() as SoundAsset;
		
		[Embed(source="../../../../../sounds/move_train.mp3")]
		private var CaptainAmerica:Class;
		private var captainAmericaSound:SoundAsset = new CaptainAmerica() as SoundAsset;
		
		[Embed(source="../../../../../sounds/next_rope.mp3")]
		private var MsMarvel:Class;
		private var msMarvelSound:SoundAsset = new MsMarvel() as SoundAsset;

		[Embed(source="../../../../../sounds/ace_coins.mp3")]
		private var IronMan:Class;
		private var ironManSound:SoundAsset = new IronMan() as SoundAsset;

		[Embed(source="../../../../../sounds/reveal_horseshoe.mp3")]
		private var Wolverine:Class;
		private var wolverineSound:SoundAsset = new Wolverine() as SoundAsset;
		
		[Embed(source="../../../../../sounds/shuffle_boulder.mp3")]
		private var Hulk:Class;
		private var hulkSound:SoundAsset = new Hulk() as SoundAsset;
		
		[Embed(source="../../../../../sounds/king_burn.mp3")]
		private var Thor:Class;
		private var thorSound:SoundAsset = new Thor() as SoundAsset;
				
		[Embed(source="../../../../../sounds/win_game.mp3")]
		private var Win:Class;
		private var winSound:SoundAsset = new Win() as SoundAsset;
		
		[Embed(source="../../../../../sounds/card_in_foundation.mp3")]
		private var Atf:Class;
		private var atfSound:SoundAsset = new Atf() as SoundAsset;
		
		[Embed(source="../../../../../sounds/card_place_3.mp3")]
		private var Atp:Class;
		private var atpSound:SoundAsset = new Atp() as SoundAsset;

		[Embed(source="../../../../../sounds/dealgame.mp3")]
		private var Shuffle:Class;
		private var shuffleSound:SoundAsset = new Shuffle() as SoundAsset;
		
		[Embed(source="../../../../../sounds/undo_1.mp3")]
		private var Undo:Class;
		private var undoSound:SoundAsset = new Undo() as SoundAsset;
		
		[Embed(source="../../../../../sounds/turn_draw_deck_1.mp3")]
		private var Flip:Class;
		private var flipSound:SoundAsset = new Flip() as SoundAsset;

		[Embed(source="../../../../../sounds/turn_draw_deck_2.mp3")]
		private var Flip3:Class;
		private var flip3Sound:SoundAsset = new Flip3() as SoundAsset;

		[Embed(source="../../../../../sounds/game_bonus.mp3")]
		private var BonusCard:Class;
		private var bonusCardSound:SoundAsset = new BonusCard() as SoundAsset;

		[Embed(source="../../../../../sounds/card_pickup_1.mp3")]
		private var CardSelect:Class;
		private var cardSelectSound:SoundAsset = new CardSelect() as SoundAsset;
		
		[Embed(source="../../../../../sounds/menu_back_1.mp3")]
		private var CloseMenu:Class;
		private var closeMenuSound:SoundAsset = new CloseMenu() as SoundAsset;
		
		[Embed(source="../../../../../sounds/menu_click_1.mp3")]
		private var SelectMenuItem:Class;
		private var selectMenuItemSound:SoundAsset = new SelectMenuItem() as SoundAsset;
		
		[Embed(source="../../../../../sounds/ace_coins2.mp3.wav.mp3")]
		private var DoublePointsClass:Class;
		private var doublePointsSound:SoundAsset = new DoublePointsClass() as SoundAsset;
		
		private static var sounds:Sounds = null;
		private var dialogChannel:SoundChannel;
		private var splashChannel:SoundChannel;
		
		public function Sounds(p:PrivateClass)
		{
		}
		
		public static function getInstance():Sounds {
			if (sounds == null) {
				sounds = new Sounds(new PrivateClass());
			}
			
			return sounds;	
		}
		
		public function whistle():void {
			this.whistleSound.play();
		}
		
		public function dialog():void {
			stopDialogSound();
			
			this.dialogChannel = this.dialogSound.play(0, int.MAX_VALUE);
		}
		public function stopDialogSound():void {
			if (this.dialogChannel != null) {
				this.dialogChannel.stop();
			}
		}

		public function splash():void {
			
			
			if (!this.splashPlayed) {
				this.splashChannel = this.splashSound.play();
			}
			
			this.splashPlayed = true;
		}
		public function stopSplash():void {
			if (this.splashChannel != null) {
				this.splashChannel.stop();
			}
			
		}
		public function autocomplete():void {
			this.autoCompleteSound.play();
		}
		
		public function captainAmerica():void {
			this.captainAmericaSound.play();
		}
		
		public function msMarvel():void {
			this.msMarvelSound.play();
		}
		
		public function thor():void {
			this.thorSound.play();
		}
		
		public function hulk():void {
			this.hulkSound.play();
		}
		
		public function wolverine():void {
			this.wolverineSound.play();
		}
		
		public function ironMan():void {
			this.ironManSound.play();
		}
		
		public function win():void {
			//var n:Number = Math.round(Math.random());
			
			//if (n == 0) {
			//	this.splashSound.play();
			//}
			//else {
				this.winSound.play();
			//}
		}
		
		public function closeMenu():void {
			this.closeMenuSound.play();
		}
		public function selectMenuItem():void {
			this.selectMenuItemSound.play();
		}
		
		public function cardSelect():void {
			this.cardSelectSound.play();
		}
		
		public function bonusCard():void {
			this.bonusCardSound.play();
		}
		
		public function turnTableau():void {
			this.ttSound.play();
		}
		public function flip():void {
			this.flipSound.play();
		}
		
		public function flip3():void {
			this.flip3Sound.play();
		}
		
		public function undo():void {
			this.undoSound.play();
		}
		
		public function addToFoundation():void {
			this.atfSound.play();
		}
		
		public function addToPile():void {
			this.atpSound.play();
		}
		
		public function shuffle():void {
			this.shuffleSound.play();
		}
		
		public function doubleYourPoints():void {
			this.doublePointsSound.play();
		}
	}
}

class PrivateClass {
}