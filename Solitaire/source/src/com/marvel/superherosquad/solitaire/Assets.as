package com.marvel.superherosquad.solitaire
{
	import com.zerog.components.buttons.AbstractButton;
	import com.zerog.components.buttons.BasicButton;
	import com.zerog.components.dialogs.AbstractDialog;
	import com.zerog.components.dialogs.IDialog;
	
	import flash.display.MovieClip;
	
	public class Assets extends MovieClip implements IAssets
	{
		public var doubleYourPointsDialog:DoubleYourPointsDialog;
		public var doubleYourPointsEntryDialog:DoubleYourPointsEntryDialog;
		public var bonusHintDialog:BonusHintDialog;
		public var kingSpadesBurn:MovieClip;
		public var kingDiamondsBurn:MovieClip;
		public var kingHeartsBurn:MovieClip;
		public var kingClubsBurn:MovieClip;
		
		public var questionDialog:QuestionDialog;
		public var goldCards:GoldCards;
		public var terms:TermsAndAgreement;
		public var loginDialog:LoginDialog;
		public var creditsButton:BasicButton;
		public var autoCompleteDialog:AbstractDialog;
		public var creditsPage:AbstractDialog;
		public var howToPlayText:IDialog;
		public var sash:BonusCardAnimation;
		public var gameOver:MovieClip;
		public var train:Train;
		public var wolverineScratch:BonusCardAnimation;
		public var hulkStomp:BonusCardAnimation;
		public var drDoom:IBonusCard;
		public var ironMan:IBonusCard;
		public var hulk:IBonusCard;
		public var msMarvel:IBonusCard;
		public var thor:IBonusCard;
		public var wolverine:IBonusCard;
		public var captainAmerica:IBonusCard;

		public var bottomBar:BottomBar;
		public var topBar:MovieClip;

		public var score:MovieClip;
		public var time:MovieClip;
		
		public var menu:OptionsMenu;
		
		//public var undo:AbstractButton;
		public var options:AbstractButton;
		
		
		public var loading:MovieClip;
		
		public function Assets()
		{
			super();
		}
		public function getGoldCards():IGoldCard {
			return this.goldCards;
		}
		public function getBonusCardAnimation(name:String):BonusCardAnimation {
			return getChildByName(name) as BonusCardAnimation;
		}

		public function getHowToPlay():IDialog {
			return this.howToPlayText;
		}
		
		
		
		public function getOptionsMenu():OptionsMenu {
			return this.menu;
		}
		
		public function getMovieClip(name:String):MovieClip {
			return getChildByName(name) as MovieClip;
		}
		
		public function getBonusCard(name:String):IBonusCard {
			return getChildByName(name) as IBonusCard;
		}
		
		public function getButton(name:String):AbstractButton {
			return getChildByName(name) as AbstractButton;
		}
	}
}