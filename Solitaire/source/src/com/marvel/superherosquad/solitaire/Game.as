package com.marvel.superherosquad.solitaire
{
	import as3cards.core.Card;
	import as3cards.core.CardValue;
	import as3cards.core.Suit;
	import as3cards.visual.CardEvent;
	import as3cards.visual.CardPile;
	import as3cards.visual.SkinManager;
	import as3cards.visual.VisualCard;
	import as3cards.visual.VisualDeck;
	
	import com.zerog.components.buttons.AbstractButton;
	import com.zerog.components.buttons.ButtonEvent;
	import com.zerog.components.dialogs.*;
	import com.zerog.components.list.LinearList;
	import com.zerog.effects.particles.ParticleExplosion;
	import com.zerog.events.AbstractDataEvent;
	import com.zerog.events.DialogEvent;
	import com.zerog.events.StreamEvent;
	import com.zerog.klondike.AcePile;
	import com.zerog.klondike.KlondikeGame;
	import com.zerog.klondike.KlondikePile;
	import com.zerog.utils.format.TimeFormat;
	import com.zerog.utils.geom.Position;
	import com.zerog.utils.load.*;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import gs.TweenLite;
	import gs.TweenMax;
	import gs.easing.*;
	
	import mx.core.BitmapAsset;

	[Frame(factoryClass="com.marvel.superherosquad.solitaire.Preloader")]

	
	public class Game extends KlondikeGame 
	{
		private var pointsMultiplier:Number = 1;
		private var bonusHintDialog:BonusHintDialog;
		private var disableAddFoundationSound:Boolean;
		private var initialized:Boolean = false;
		
		public static const COPING_CAT:int = 14;
		public static const DIET_CAT:int = 10;
		public static const EXCERCISE_CAT:int = 13;
		public static const FOOT_CARE_CAT:int = 15;
		public static const GLUCOSE_MONITORING_CAT:int = 12;
		public static const MED_COMPLIANCE_CAT:int = 11;
		
		private static const SOUNDS_URL:String = "http://174.129.22.44/data/";
		
		private var questionSoundChannel:SoundChannel;
		private var questionSound:Sound;
		private var answer1Sound:Sound;
		private var answer2Sound:Sound;
		private var answer3Sound:Sound;
		
		private const MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME:String = "MARVEL_SUPERHERO_SQUAD_SOLITAIRE";
		public static const END_GAME:String = "end game";
		
		private var gameOver:MovieClip;
		private var gameNum:uint;
//		private var tracker:AnalyticsTracker;
		private var sounds:Sounds;
			
		private var lasso:MovieClip;
		private var goldCards:IGoldCard;
		private var captainAmerica:IBonusCard;
		//private var drDoom:IBonusCard;
		private var hulk:IBonusCard;
		private var ironMan:IBonusCard;
		private var msMarvel:IBonusCard;
		private var thor:IBonusCard;
		private var wolverine:IBonusCard;
		
		private var creditsButton:AbstractButton;
		private var creditsPage:AbstractDialog;
		private var autoCompleteDialog:AbstractDialog;
		private var questionDialog:QuestionDialog;
		
		private var empty:Sprite;
		
		private var kingSpadesBurn:MovieClip;
		private var kingClubsBurn:MovieClip;
		private var kingHeartsBurn:MovieClip;
		private var kingDiamondsBurn:MovieClip;
		
		
		[Embed(source="../../../../../artwork/background.png")]
		private var Background:Class;
		private var bg:BitmapAsset = new Background();
		
		[Embed(source="../../../../../artwork/board/captain-america-shield.png")]
		private var CaptainAmericaShield:Class;
		private var captainAmericaShield:BitmapAsset = new CaptainAmericaShield();
		
		[Embed(source="../../../../../artwork/board/captain-america-star-white.png")]
		private var CaptainAmericaStarWhite:Class;
		private var captainAmericaStarWhite:BitmapAsset = new CaptainAmericaStarWhite();
		
		[Embed(source="../../../../../artwork/board/captain-america-star-red.png")]
		private var CaptainAmericaStarRed:Class;
		private var captainAmericaStarRed:BitmapAsset = new CaptainAmericaStarRed();
		
		[Embed(source="../../../../../artwork/board/captain-america-star-blue.png")]
		private var CaptainAmericaStarBlue:Class;
		private var captainAmericaStarBlue:BitmapAsset = new CaptainAmericaStarBlue();
		
		[Embed(source="../../../../../bin-debug/com/marvel/superherosquad/solitaire/Assets.swf#Loading")]
 		private var PreloadDisplay:Class;
 		private var preloadDisplay:Sprite = new PreloadDisplay();

 		[Embed(source="../../../../../artwork/logo.png")]
		private var Logo:Class;
		private var logo:BitmapAsset = new Logo();

 		private var preloadDialog:LoadingDisplay;
 		
		//[Embed(source="../../../../../artwork/board/wolverine-scratch-small.png")]
		//private var WolverineScratch:Class;
		//private var wolverineScratch:BitmapAsset = new WolverineScratch();
		private var train:Train;
		private var wolverineScratch:BonusCardAnimation;
		private var sash:BonusCardAnimation;
		private var hulkStomp:BonusCardAnimation;
		private var options:AbstractButton;
		private var undo:AbstractButton;
		//private var heroes:AbstractButton;
		private var howToPlay:AbstractButton;
		private var startGameButton:AbstractButton;
		private var moreGames:AbstractButton;
		private var howToPlayText:IDialog;
		private var optionsMenu:OptionsMenu;
		
		private var scoreArea:MovieClip;
		private var timeArea:MovieClip;

		private var bb:MovieClip;
		private var tb:MovieClip;
		
		/**
		 * An array of GameState objects
		 */
		private var history:Array;
				
		private var doubleDialog:DoubleYourPointsDialog;
		private var doubleEntryDialog:DoubleYourPointsEntryDialog;
		
		private static const NORMAL_STATE:uint = 0;
		private static const CAPTAIN_AMERICA_STATE:uint = 1;

		private var historyId:int = 0;
		
		private var list:LinearList;
		
		private var a:IAssets;
		
		
		private var autoCompleteAnswered:Boolean = false;
		//game state
		private var score:int = 0;
		private var deckCycles:uint = 0;
		
		private var timer:Timer;
		
		//bonus card locations
		private var ironManLocation:uint;
		private var hulkLocation:uint;
		private var msMarvelLocation:uint;
		private var captainAmericaLocation:uint;
		private var thorLocation:uint;
		//private var drDoomLocation:uint;
		private var wolverineLocation:uint;
								
		private var questionCategories:Array;
		
		//private var adHarness:AdHarnessInterface;
		private var loginDialog:LoginDialog;
		private var server:DatabaseAPI;
		private var terms:TermsAndAgreement;
		
		
		private var lastBonusCardClicked:IBonusCard;
		
		public function Game()
		{
			super(this.bg);

			this.disableAddFoundationSound = false;
            
       
			
			this.empty = new Sprite();

			this.gameNum = 0;
			
			//set the skin by default to be
			var mySo:SharedObject = SharedObject.getLocal(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME);
			SkinManager.skinCreator = new GlymetrixWesternSkin();
			
			this.sounds = Sounds.getInstance();
			
			this.timer = new Timer(1000);
			this.timer.addEventListener(TimerEvent.TIMER, onTimer);
				
			this.list = new LinearList(null, LinearList.HORIZONTAL);
			this.list.setSingleSelect(true);
			this.list.y = 1282;
			this.list.x = 150;
			
			
			addEventListener(TO_ACE_PILE, onAcePileAdded);
			addEventListener(DECK_TO_KLONDIKE_PILE, onDeckToKlondikePileAdded);
			addEventListener(KLONDIKE_PILE_TO_KLONDIKE_PILE, onKlondikeToKlondikePileAdded);
			addEventListener(ACE_PILE_TO_KLONDIKE_PILE, onAceToKlondikePileAdded);
			
			//load external assets
			var l:DisplayLoadStream = new DisplayLoadStream("Assets.swf");
			l.addEventListener(StreamEvent.COMPLETE, onComplete);
			
			this.preloadDialog = new LoadingDisplay();
			this.preloadDialog.setDisplay(this.preloadDisplay);
			this.preloadDialog.setStatus("Loading art...");
			this.preloadDialog.setParent(this);
			this.preloadDialog.setStream(l);
			this.preloadDialog.showDialog();
			
			LoadUtil.load(l);
			
			addEventListener(Event.ADDED, onAdded);
		}
		

	
		
		//import flash.events.*;
		override protected function onAddedToStage(e:Event):void {
			super.onAddedToStage(e);
			

			
			this.server = new DatabaseAPI(this.root.loaderInfo.parameters);
			
			this.server.addEventListener(DatabaseAPI.REGISTER_SUCCESS, onRegister);
			this.server.addEventListener(DatabaseAPI.REGISTER_FAIL, onRegisterFail);
			this.server.addEventListener(DatabaseAPI.LOGGED_IN_FAIL, onLoggedInFail);
			this.server.addEventListener(DatabaseAPI.DOUBLE_POINTS, onDoublePoints);
			this.server.addEventListener(DatabaseAPI.LOGGED_IN, onLoggedIn);
			this.server.addEventListener(DatabaseAPI.NEW_GAME, onNewGame);
			this.server.addEventListener(DatabaseAPI.RECEIVED_QUESTION, onReceivedQuestion);
			this.server.addEventListener(DatabaseAPI.RECEIVED_TOS, onReceivedTOS);
			
		}
		private function onDoublePoints(e:Event):void {
			this.pointsMultiplier = 2;
		}
		
		override public function get width():Number {
			return 760;
		}
		
		override public function get height():Number {
			return 610;
		}
		
		/*
		import flash.events.KeyboardEvent;
 private function keyHandlerfunction (event:KeyboardEvent):void
   		{
     	 	if ( event.keyCode == 71) {
     	 	
     	 		checkWin();
   		 }
   		}*/
   		
		private function onAdded(e:Event):void {
			if (this.numChildren > 0) {
				var dObject:DisplayObject = getChildAt(this.numChildren -1);
				
				//if not one of the ones below
				//except for the case of the options menu and heroes page and effects
				if (
					(dObject as LinearList != this.list) && 
					//(dObject as AbstractButton != this.undo) &&
					(dObject as MovieClip != this.scoreArea) &&
					(dObject as MovieClip != this.timeArea) &&
					(dObject as MovieClip != this.bb) &&
					(dObject as Sprite != this.empty) && 
					!(dObject is HowToPlay) &&
					!(dObject is QuestionDialog) &&
					!(dObject is LoginDialog) &&
					!(dObject is TermsAndAgreement) &&      
					!(dObject is OptionsMenu) && 
					!(dObject is ParticleExplosion) && 
					!(dObject == this.creditsPage) &&
					!(dObject == this.bonusHintDialog)
					//(dObject as Bitmap) != this.thorElectricity.getAnimatedElectricityBitmap()
					) {
						
					var displayObject:DisplayObject = getChildAt(this.numChildren - 1);
		
					if (displayObject != null && !(displayObject is LinearList)) {
					
						
						if (this.scoreArea != null) {
							
							addChild(this.scoreArea);
						}

						if (this.timeArea != null) {
							addChild(this.timeArea);
						}
						
						//if (this.undo != null) {
						//	addChild(this.undo);
						//}
						
						if (this.empty != null) {
							addChild(this.empty);
						}
						
						if (this.bb != null) {
							addChild(this.bb);
						}
							if (this.list != null) {
							addChild(this.list);
						}
						if (this.creditsButton != null) {
							addChild(this.creditsButton);
						
						}
					} 
				}
			}
		}
		
		
		
		private function onAceToKlondikePileAdded(e:Event):void {
			if (soundsEnabled()) { 
				this.sounds.addToPile();
			}
			addToScore(-15);
		}
		
		private function onKlondikeToKlondikePileAdded(e:Event):void {
			if (soundsEnabled()) {
				this.sounds.addToPile();
			}
			
			promptAutoComplete();
		}

		private function onDeckToKlondikePileAdded(e:Event):void {
			if (soundsEnabled()) {
				this.sounds.addToPile();
			}
			addToScore(5);
			
			promptAutoComplete();
		}
		
		private function onAcePileAdded(e:Event):void {
			//trace("on ace pile added");
			if (soundsEnabled() && !this.disableAddFoundationSound) {
				this.sounds.addToFoundation();
			}
			
			addToScore(10);
			
			var won:Boolean = checkWin();
			
			
			if (!won) {
				promptAutoComplete();
			}
			
			//start timer if is a timed game
			var mySo:SharedObject = SharedObject.getLocal(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME);
			
			
			//if a timed game and not running
			if (mySo.data.timed && !this.timer.running) {
				this.timer.start();
			}
		}
		
		private function autoCompleteGame():void {
			if (soundsEnabled()) {
				this.sounds.autocomplete();
			}
			
			trace("auto complete ok");
			var kp:KlondikePile;
				
			var totalCount:int = 0;
			
			//count how many cards in klondike piles
			for each (kp in this.klondikePiles) {
				if (!kp.isEmpty()) {
					totalCount += kp.numChildren;
				}
			}
			
			var count:int = 0;
			
			//while cards in k piles
			while (getKlondikePileCardCount() > 0) {
				for each (kp in this.klondikePiles) {
					if (!kp.isEmpty()) {
						var card:VisualCard = kp.getTopCard();
						
						//get rid of drag
						configureDrag(card, false);
						
						for each (var ap:AcePile in this.acePiles) {
							if (ap.canAddCard(card.card)) {
								//increment cound
								count++;
								
								//save the globa cords
								var oldPoint:Point = Position.getGlobal(card);
								
								//make it invis
								card.visible = false;
								
								//add it
								ap.addCard(card);
								
								//save new local coords
								//var oldX:Number = card.x;
								//var oldY:Number = card.y;
								
								//get the new global coords
								var newPoint:Point = Position.getGlobal(card);
								
								//get the offset
								var offX:Number = oldPoint.x - newPoint.x;
								var offY:Number = oldPoint.y - newPoint.y;
								
								//move the card by that offset
								card.x += offX;
								card.y += offY;
								card.visible = true;
								
								
								
								//trace(oldX + " " + oldY);
								TweenLite.delayedCall(count*.05, autoCardsMove, new Array(card, count, totalCount));
							}
						}
					}
				}
			}
			
			addToScore(count * 10);
		}
		
		private function autoCardsMove(card:VisualCard, count:int, totalCount:int):void {
			if (count == totalCount) {
				TweenLite.to(card, .5, {x:0, y:0, onComplete: checkWin});
			}
			else {
				TweenLite.to(card, .5, {x:0, y:0});
			}
		}
		
		private function getKlondikePileCardCount():uint {
			var kPileCardCount:uint = 0;
			
			for each (var kp:KlondikePile in this.klondikePiles) {
				if (!kp.isEmpty()) {
					kPileCardCount += kp.numChildren;
				}
			}
			
			return kPileCardCount;
		}
		private var gameOverFlag:Boolean = false;
		private function checkWin():Boolean {
			var win:Boolean = false;
			
			//if deck is empty
			if (this.visualDeck.isEmpty() && this.dealtPile.isEmpty()) {
			//if (true) {
				
				win = true;
				
				//this.server.submitScore(this.score);
				
				//if all klondikes are empty
				for each (var kp:KlondikePile in this.klondikePiles) {
					//if one not empty
					if (!kp.isEmpty()) {
						win = false;
						break;
					}
				}

				if (win) {
					gameOverFlag = true;
				//if (true) {
					//this.tracker.trackEvent(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME, getGameString(), "complete", this.timer.currentCount);
					
					if (this.soundsEnabled()) {
						this.sounds.win();
					}
					
					//trace("you won son");
					var mySo:SharedObject = SharedObject.getLocal(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME);
					
					var wins:Number;
					if (this.drawType == DRAW_ONE) {
						if (timerEnabled()) {
							wins = mySo.data.drawOneWinsTimer == undefined ? 0:mySo.data.drawOneWinsTimer;
							wins++;
							mySo.data.drawOneWinsTimer = wins;							
						}
						else {
							wins = mySo.data.drawOneWins == undefined ? 0:mySo.data.drawOneWins;
							trace("WINS WERW " + wins);
							wins++;
							trace("WINS ARE " + wins);
							mySo.data.drawOneWins = wins;	
						}
					}
					else {
						if (timerEnabled()) {
							wins = mySo.data.drawThreeWinsTimer == undefined ? 0:mySo.data.drawThreeWinsTimer;
							wins++;
							mySo.data.drawThreeWinsTimer = wins;	
						}
						else {
							wins = mySo.data.drawThreeWins == undefined ? 0:mySo.data.drawThreeWins;
							wins++;
							mySo.data.drawThreeWins = wins;	
						}
					}
					mySo.flush();
					trace("WINS are  " + mySo.data.drawOneWins);
					updateStatsDisplay();
					
					this.timer.stop();
					
					clearHistory();
					
					for each (var k:KlondikePile in this.klondikePiles) {
						removeChild(k);
					}

					//start end game anime
					if (this.gameOver != null) {
						this.gameOver.x = (this.width - this.gameOver.width)/2;
						this.gameOver.y = (this.height - this.gameOver.height)/2;
												
						this.addChild(this.gameOver);
					}
					
					for (var i:uint = 0; i < 20; i++) {
						var randX:Number = this.width * Math.random();
						if (randX < 100) {
							randX += 100;
						}
						
						if (randX > this.width - 100) {
							randX -= 100;
						}
						
						var randY:Number = this.height * Math.random();
						
						if (randY < 100) {
							randY += 100;
						}
						
						if (randY > this.height - 100) {
							randY -= 100;
						}
						TweenLite.delayedCall(i * Math.random() * .5, createFireworks, new Array(randX, randY));
					}
					
					TweenLite.delayedCall(10, endGame);
				}
			}
			
			return win;
		}
		
		private function endGame():void {
			dispatchEvent(new Event(END_GAME));
			//if (this.adHarness != null) {
			//	this.adHarness.endGame();	
			//}
			
			this.server.submitScore(this.score);
			this.server.endGame();
		}
		
		private function updateScoreDisplay():void {
			if (this.scoreArea != null) {
				//trace("update score display " + this.score);
				var tf:TextField = this.scoreArea.getChildByName("score") as TextField;
				tf.text = new String(this.score);
			}
		}
		
		private function addToScore(num:int):void {
			if (num > 0) {
				num *= this.pointsMultiplier;
			}
			setScore(this.score + num);
		}
		
		private function setScore(score:int):void {
			if (this.score != score) {
				if (score < 0) {
					score = 0;
				}
				
				this.score = score;
				
				
				updateScoreDisplay();
				
				//update best score if needed
				var mySo:SharedObject = SharedObject.getLocal(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME);
				
				if (this.drawType == DRAW_ONE) {
					if (timerEnabled()) {
						if (mySo.data.drawOneHighScoreTimer == undefined || mySo.data.drawOneHighScoreTimer < this.score) {
							mySo.data.drawOneHighScoreTimer = this.score;
							mySo.flush();
							updateStatsDisplay();	
						}
					}
					else {
						if (mySo.data.drawOneHighScore == undefined || mySo.data.drawOneHighScore < this.score) {
							trace("SET SCORE " + mySo.data.drawOneHighScore + " vs " + this.score);
							mySo.data.drawOneHighScore = this.score;
							mySo.flush();
							updateStatsDisplay();	
						}
					}
				}
				else if (this.drawType == DRAW_THREE) {
					if (timerEnabled()) {
						if (mySo.data.drawThreeHighScoreTimer == undefined || mySo.data.drawThreeHighScoreTimer < this.score) {
							mySo.data.drawThreeHighScoreTimer = this.score;
							mySo.flush();
							updateStatsDisplay();
						}
					}
					else {
						if (mySo.data.drawThreeHighScore == undefined || mySo.data.drawThreeHighScore < this.score) {
							mySo.data.drawThreeHighScore = this.score;
							mySo.flush();
							updateStatsDisplay();
						}
					}
				}
				
				updateBestScoreDisplay();
			}
		}
		
		private function updateBestScoreDisplay():void {
			if (this.tb != null) {
				var tf:TextField = this.tb.getChildByName("bestScore") as TextField;
			}
			
			if (tf != null) {
				var mySo:SharedObject = SharedObject.getLocal(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME);
			
				if (this.drawType == DRAW_ONE) {
					if (timerEnabled()) {
						if (mySo.data.drawOneHighScoreTimer != undefined) {
							tf.text = new String(mySo.data.drawOneHighScoreTimer);
						}						
					}
					else {
						if (mySo.data.drawOneHighScore != undefined) {
							tf.text = new String(mySo.data.drawOneHighScore);
						}
					}
				}
				else if (this.drawType == DRAW_THREE) {
					if (timerEnabled()) {
						if (mySo.data.drawThreeHighScoreTimer != undefined) {
							tf.text = new String(mySo.data.drawThreeHighScoreTimer);
						}
					}
					else {
						if (mySo.data.drawThreeHighScore != undefined) {
							tf.text = new String(mySo.data.drawThreeHighScore);
						}
					}
				}
			}
		}
		
		private function computeBonusCardLocations():void {
			trace("COMPUTE BONUS CARD LCOA");
			//reset all
			this.ironManLocation = 0;
			this.hulkLocation = 0;
			this.msMarvelLocation = 0;
			this.captainAmericaLocation = 0;
			this.thorLocation = 0;
			//this.drDoomLocation = 0;
			this.wolverineLocation = 0;

			//for each suit
			for (var i:uint = 0; i < 4; i++) {
				//for each value
				for (var j:uint = 2; j < 15; j++) {
					var n:Number;
					//probability, 7/52 chance
					if (this.drawType == DRAW_ONE) {
						n = Math.ceil(Math.random() * 16);
					}
					else {
						n = Math.ceil(Math.random() * 16);
					}
					
					if (n < 14) {
						//now a 1 in 7 chance for each card
						n = Math.ceil(Math.random() * 6);
						
						var location:uint = (i * 13) + j;
						
						trace(" BONUS CARD LOCATION ---------------------------- " + location + "," + n);

						//find a match and translate the suit/value into a location index
						switch (n) {
							case 1:
								this.ironManLocation = location;
								break;
							case 2:
								this.hulkLocation = location;
								break;
							case 3:
								this.msMarvelLocation = location;
								break;
							case 4:
								this.captainAmericaLocation = location;
								break;
							case 5:
								this.thorLocation = location;
								break;
							//case 6:
								//this.drDoomLocation = location;
								//break;
							case 6:
								this.wolverineLocation = location;
								break;
						}
					}
				}
			}
		}
		
		override public function dragStart( event:MouseEvent ):void {
			if (soundsEnabled()) {
				this.sounds.cardSelect();
			}	
			super.dragStart(event);
			
			
		}
		

		override public function newGame(bg:DisplayObject = null):void {
			
			gameOverFlag = false;

			this.sounds.stopSplash();
			
			if (contains(this.logo)) {
				removeChild(this.logo);
			}
			
			this.autoCompleteAnswered = false;

			//kill all animations
			TweenLite.killDelayedCallsTo(createFireworks);
			//if a new game has been started
			//if (gameNum > 0) {
				//this.tracker.trackEvent(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME, getGameString(), "fail", this.timer.currentCount);
			//}
			
			//this.tracker.trackEvent(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME, getGameString(), "start");

			gameNum++;
			
			var mySo:SharedObject = SharedObject.getLocal(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME);
			var wins:Number = 0;
			var played:Number = 0;
			
			//if draw type is set in cookie
			if (mySo.data.drawType == DRAW_THREE || mySo.data.drawType == DRAW_ONE) {
				//set it 
				this.drawType = mySo.data.drawType;
			}
			//default to draw one
			else {
				this.drawType = DRAW_ONE;
			}
			
			//incrememnt the # of games played
			if (this.drawType == DRAW_THREE) {
				if (!this.timerEnabled()) {
					played = mySo.data.drawThreePlayed == undefined ? 0:mySo.data.drawThreePlayed;
					played++;
					mySo.data.drawThreePlayed = played;	
				}
				else {
					played = mySo.data.drawThreePlayedTimer == undefined ? 0:mySo.data.drawThreePlayedTimer;
					played++;
					mySo.data.drawThreePlayedTimer = played;
				}
			}
			else {
				if (!this.timerEnabled()) {
					played = mySo.data.drawOnePlayed == undefined ? 0:mySo.data.drawOnePlayed;
					played++;
					mySo.data.drawOnePlayed = played;
				}
				else {
					played = mySo.data.drawOnePlayedTimer == undefined ? 0:mySo.data.drawOnePlayedTimer;
					played++;
					mySo.data.drawOnePlayedTimer = played;
				}
			}
			
			
			
			//save it
			mySo.flush();
			
			updateStatsDisplay();
		trace("NEW GAME " + mySo.data.drawOneHighScore);
			
			if (soundsEnabled()) {
				this.sounds.shuffle();
			}
			
			computeBonusCardLocations();
			
			//reset history
			this.history = new Array();
			
			updateUndoButton();
			
			//reset score
			setScore(0);
			
			//reset deck cycles
			this.deckCycles = 0;
			
			//reset timer
			if (this.timer != null) {
				this.timer.reset();
			}
			
			this.bg.x = 0;
			this.bg.y = 0;
			
			super.newGame(this.bg);
			
			//save new state
			saveState(getState());
			
			handleAssets();
			
			//reset time area
			if (this.timeArea != null) {
				var tf:TextField = this.timeArea.getChildByName("time") as TextField;
				
				if (tf != null) {
					tf.text = "";
				}
			}
			
			//create list
			addChild(this.list);
			
			
			if (initialized == false) {
				initialized = true;
				
				//give two bonus cards
				giveTwoBonusCards();
				
				TweenLite.delayedCall(1, showHint);
				
			}
		}
		
		private function showHint():void {
			//show dialog
				this.bonusHintDialog.showDialog();
		}
		private function createFireworks(x:Number, y:Number):void {
			var p:ParticleExplosion = new ParticleExplosion(5,.025,75);
			
			addChild(p);
			var colorIndex:uint = Math.ceil(Math.random() * 3);
			var color:Number;
			switch(colorIndex) {
				case 1:
					color = 0xffffff;
					break;
				case 2:
					color = 0x00ff00;
					break;
				case 3:
					color = 0xffff00;
					break;
			}
			var bm:BitmapData = new BitmapData(5,5,false,color);
			p.createExplosionFromBitmap(x,y,bm);
		}
		private function getGameString():String {
			var gameString:String;
			
			if (this.drawType == DRAW_ONE) {
				gameString = "draw_one";
			}
			else {
				gameString = "draw_three";
			}
			
			if (timerEnabled()) {
				gameString += ",time_on";
			}
			else {
				gameString += ",time_off";
			}
			
			if (soundsEnabled()) {
				gameString += ",sound_on";
			}
			else {
				gameString += ",sound_off";
			}
			
			return gameString;
		}

		private function onTimer(e:TimerEvent):void {
			
			
			//if timer is enabled
			if (timerEnabled()) {
				if (this.timer.currentCount % 10 == 0) {
					//subtract two points every ten seconds
					addToScore(-2);	
				}
				
				//update display
				if (this.timeArea != null) {
					var tf:TextField = this.timeArea.getChildByName("time") as TextField;
					tf.text = TimeFormat.convertTime(this.timer.currentCount);
				}
			}
		}
		
		override protected function deckClick( event:MouseEvent ):VisualCard {
			//start timer if is a timed game
			var mySo:SharedObject = SharedObject.getLocal(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME);
			
			//if a timed game and not running
			if (mySo.data.timed && !this.timer.running) {
				this.timer.start();
			}
			
			if (soundsEnabled()) {
				if (this.drawType == DRAW_ONE) {
					this.sounds.flip();
				}
				else {
					this.sounds.flip3();
				}
			}
			
			//increment the # of times you cycled through
			if (this.visualDeck.isEmpty()) {
				this.deckCycles++;
				
				if (this.drawType == DRAW_ONE && this.deckCycles > 1) {
					addToScore(-100);
				}
				else if (this.drawType == DRAW_THREE && this.deckCycles > 3) {
					addToScore(-20);
				}
			}
			
			var vc:VisualCard = super.deckClick(event);
			
			getBonusCard(null);

			//save new state
			saveState(getState());
			
			return vc;
		}
		
		override public function turnOver(event:MouseEvent):VisualCard {
			if (soundsEnabled()) {
				this.sounds.turnTableau();
			}
			
			var card:VisualCard = super.turnOver(event);
			
			addToScore(5);
			
			//save new state
			saveState(getState());
			
			getBonusCard(card);
			
			promptAutoComplete();
			
			return card;
		}
		//private var b:uint = 0;
		private function giveTwoBonusCards():void {
			var n1:int = Math.ceil(Math.random() * 6);
			var n2:int = Math.ceil(Math.random() * 6);
			
			var bc1:IBonusCard = null;
			var bc2:IBonusCard = null;
			
						switch (n1) {
							case 1:
								bc1 = this.ironMan;
								break;
							case 2:
								bc1 = this.hulk;
								break;
							case 3:
								bc1 = this.msMarvel;
								break;
							case 4:
								bc1 = this.captainAmerica;
								break;
							case 5:
								bc1 = this.thor
								break;
							case 6:
								bc1 = this.wolverine;
								break;
						}
						
						switch (n2) {
							case 1:
								bc2 = this.ironMan;
								break;
							case 2:
								bc2 = this.hulk;
								break;
							case 3:
								bc2 = this.msMarvel;
								break;
							case 4:
								bc2 = this.captainAmerica;
								break;
							case 5:
								bc2 = this.thor
								break;
							case 6:
								bc2 = this.wolverine;
								break;
						}
						
						bc1.increment();
						bc2.increment();
						
						if (!this.list.containsItem(bc1)) {
							this.list.addItem(bc1);	
						}
						
						if (!this.list.containsItem(bc2)) {
							this.list.addItem(bc2);	
						}
						if(soundsEnabled()) {
							this.sounds.bonusCard();
						}
						
		}
		private function getNonListedBonusCard():IBonusCard {
			var n1:int = 0;
			
			var bonusCard:IBonusCard = null;
				
			//if full
			if (this.list.getNumItems() == 6) {
				n1 = Math.ceil(Math.random() * 6);
			
				
			
				switch (n1) {
					case 1:
						bonusCard = this.ironMan;
						break;
					case 2:
						bonusCard = this.hulk;
						break;
					case 3:
						bonusCard = this.msMarvel;
						break;
					case 4:
						bonusCard = this.captainAmerica;
						break;
					case 5:
						bonusCard = this.thor
						break;
					case 6:
						bonusCard = this.wolverine;
						break;
				}
				
				return bonusCard;
			}
			else {
				var a:Array = new Array();
				//out of items not there
				if (this.ironMan.getCount() == 0) {
					a.push(this.ironMan);
				}
				
				if (this.hulk.getCount() == 0) {
					a.push(this.hulk);
				}
				
				if (this.msMarvel.getCount() == 0) {
					a.push(this.msMarvel);
				}
				
				if (this.captainAmerica.getCount() == 0) {
					a.push(this.captainAmerica);
				}
				
				if (this.thor.getCount() == 0) {
					a.push(this.thor);
				}
				
				if (this.wolverine.getCount() == 0) {
					a.push(this.wolverine);
				}
				
				n1 = Math.floor(Math.random() * a.length);
			
				return a[n1] as IBonusCard;
			
			}
		}
		
		private function getBonusCard(vc:VisualCard):void {
			
	/*
			
 			if (!this.list.containsItem(this.thor)) {
			this.list.addItem(this.thor);	
				}
				this.thor.increment();
				
			if (!this.list.containsItem(this.ironMan)) {
			this.list.addItem(this.ironMan);	
				}
				this.ironMan.increment();
				
			if (!this.list.containsItem(this.hulk)) {
			this.list.addItem(this.hulk);	
				}
				this.hulk.increment();
			if (!this.list.containsItem(this.captainAmerica)) {
			this.list.addItem(this.captainAmerica);	
				}
				this.captainAmerica.increment();
			
			if (!this.list.containsItem(this.wolverine)) {
			this.list.addItem(this.wolverine);	
				}
				this.wolverine.increment();
			
			
			if (!this.list.containsItem(this.msMarvel)) {
			this.list.addItem(this.msMarvel);	
				}
				this.msMarvel.increment();
				this.msMarvel.increment();
				this.msMarvel.increment();
				this.msMarvel.increment();
				this.msMarvel.increment();
				this.msMarvel.increment();
				this.msMarvel.increment();
				this.msMarvel.increment();
				this.msMarvel.increment();
				this.msMarvel.increment();
				this.msMarvel.increment();
				this.msMarvel.increment();
				this.msMarvel.increment();
				this.msMarvel.increment();
				
									if (soundsEnabled()) {
						this.sounds.bonusCard();
					}	
				
				return; 
		*/
				var bonusCard:IBonusCard = getNonListedBonusCard();
						
						
				var prob:Number = Math.random() * 100;	
				
				//if bonus card found
				if (bonusCard != null && bonusCard.getCount() < 3 && prob < 8) {
					//if not in the list
					if (!this.list.containsItem(bonusCard)) {
						//trace("add bonus card " + location);
						//add it
						this.list.addItem(bonusCard);
					}
					
					if (soundsEnabled()) {
						this.sounds.bonusCard();
					}
					
					//increment
					bonusCard.increment();
				}
			//}
		}
		
		override protected function moveBack(originatingPile:CardPile, draggingPile:CardPile):void {
			super.moveBack(originatingPile, draggingPile);
		}
		override protected function onDoubleClickCard(event:MouseEvent):Boolean {
			var result:Boolean = super.onDoubleClickCard(event);
			
			if (result) {
				saveState(getState());
			}
			
			return result;
		}

		override public function checkDrop(e:MouseEvent):Boolean {
			var result:Boolean = super.checkDrop(e);
			
			//if it was a successful move
			if (result) {
				//start timer if is a timed game
				var mySo:SharedObject = SharedObject.getLocal(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME);
				
				//if a timed game and not running
				if (mySo.data.timed && !this.timer.running) {
					this.timer.start();
				}
				
				//save new state
				saveState(getState());
			}
			
			
			return result;
		}

		private function saveState(gs:GameState):void {
			if (this.history == null) {
				this.history = new Array();
			}
			
			//if less than two
			if (this.history.length < 2) {
				this.history.push(gs);
			}
			//two
			else {
				this.history.shift();
				this.history.push(gs);
			}
			
			updateUndoButton();
		}
		
		private function updateUndoButton():void {
			if (this.undo != null) {
				if (this.history == null || this.history.length < 2) {
					this.undo.enabled = false;
				}
				else {
					this.undo.enabled = true;
				}
			}
		}
		override protected function createBoard():void {
			super.createBoard();
			
			this.visualDeck.x = 11;
			this.visualDeck.y = 50;
			
			for (var i:uint = 0; i < this.acePiles.length; i++) {
				var ap:AcePile = this.acePiles[i] as AcePile;
				ap.y = 50;
				ap.x = 331 + i * 107;
			}
			
			for (var j:uint = 0; j < this.klondikePiles.length; j++) {
				var kp:KlondikePile = this.klondikePiles[j] as KlondikePile;
				kp.y = 194;
				kp.x = 10 + j * 107;
			}
			
			this.dealtPile.y = 50;
			this.dealtPile.x = 118;
		}


		
		private function refreshSkins():void {
			if (this.visualDeck != null) {
				this.visualDeck.updateSkin();
			}
			
			//trace("update klondike skin");
			for each (var cp:CardPile in this.klondikePiles) {
				if (cp != null) {
					cp.updateSkin();
				}
			}
		}
		private function onCaptainAmericaDeselected(e:ButtonEvent):void {
			trace("ca deselct");
			captainAmericaUnlock();
		}
		
		private function onHulkDeselected(e:ButtonEvent):void {
			hulkUnlock();
		}
		private function onMsMarvelDeselected(e:ButtonEvent):void {
			msMarvelUnlock();
		}
		private function onMoreGames(e:MouseEvent):void {
			onMenuSelect(e);
			//this.tracker.trackEvent(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME, "linkOut", "moreGames");
			
			var request:URLRequest = new URLRequest(this.root.loaderInfo.parameters.gameZoneUrl);
			try {
  				navigateToURL(request, '_blank'); 
			}
			catch (e:Error) {
			}			
		}
		private function onHowToPlay(e:MouseEvent):void {
			this.sounds.stopSplash();
			if (soundsEnabled()) {
				this.sounds.dialog();
			}
			
			onMenuSelect(e);
			//this.tracker.trackEvent(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME, "menu", "instructions");
			this.howToPlayText.showDialog(0,0);
		}
		private function onMarvelKidsClick(e:MouseEvent):void {
			//this.tracker.trackEvent(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME, "linkOut", "marvelLogo");
			
			var request:URLRequest = new URLRequest("http://marvelkids.marvel.com");
			try {
  				navigateToURL(request, '_blank'); 
			}
			catch (e:Error) {
			}		
		}

		private function onResetStats(e:Event):void {
			var mySo:SharedObject = SharedObject.getLocal(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME);
			
			mySo.data.drawThreeWins = undefined;
			mySo.data.drawThreeWinsTimer = undefined;
			
			mySo.data.drawThreePlayed = undefined;
			mySo.data.drawThreePlayedTimer = undefined;
			
			mySo.data.drawOneWins = undefined;
			mySo.data.drawOneWinsTimer = undefined;
			
			mySo.data.drawOnePlayed = undefined;
			mySo.data.drawOnePlayedTimer = undefined;

			mySo.data.drawThreeHighScore = undefined;
			mySo.data.drawThreeHighScoreTimer = undefined;
						
			mySo.data.drawOneHighScore = undefined;
			mySo.data.drawOneHighScoreTimer = undefined;
			
			updateStatsDisplay();
		}
		
		private function onCreditsClick(e:MouseEvent):void {
			this.sounds.stopSplash();
			if (soundsEnabled()) {
				this.sounds.dialog();
			}
			this.creditsPage.showDialog();
		}
	
		private function onClickCredits(e:MouseEvent):void {
			this.sounds.stopDialogSound();
			this.creditsPage.removeDialog();
		}
		
		private function promptAutoComplete():void {
			
				var deckClear:Boolean = true;
				var klondikeClear:Boolean = true;
				
				//is the deck is not empty or the dealt pile is not empty
				if (!this.visualDeck.isEmpty() || !this.dealtPile.isEmpty()) {
					deckClear = false;
				}
				
				//for each klondike pile
				for each (var kp:KlondikePile in this.klondikePiles) {
					//if not empty
					if (!kp.isEmpty()) {
						//if there are face down cards
						if (kp.hasFaceDownCards()) {
							klondikeClear = false;
						}
					}
				}
				
				//if both the deck and klondike piles are clear
				if (deckClear && klondikeClear && !autoCompleteAnswered) {
					autoCompleteAnswered = true;
					this.autoCompleteDialog.showDialog(0,0);
				}
			
		}
		private function onAutoCompleteConfirm(e:DialogEvent):void {
			autoCompleteGame();
		}
		
		private function onAnswerSoundComplete(e:Event):void {
			this.questionDialog.removeDialog();
			
			if (this.lastBonusCardClicked == this.ironMan) {
				activateIronMan();
			}  
			else if (this.lastBonusCardClicked == this.thor) {
				activateThor();
			}
			else if (this.lastBonusCardClicked == this.hulk) {
				activateHulk();
			}
			else if (this.lastBonusCardClicked == this.captainAmerica) {
				activateCaptainAmerica();
			}
			else if (this.lastBonusCardClicked == this.wolverine) {
				activateWolverine();
			}
			else if (this.lastBonusCardClicked == this.msMarvel) {
				activateMsMarvel();
			}
		}
		private function onAnswerQuestion(e:AbstractDataEvent):void {
			this.questionSoundChannel.stop();
			var answer:AnswerChoice = e.getObject() as AnswerChoice;
			var sc:SoundChannel;
			
			switch(answer.getSelection()) {
				case 1:
				
				sc = this.answer1Sound.play();
				sc.addEventListener(Event.SOUND_COMPLETE, onAnswerSoundComplete);
				
				break;
				
				case 2:
				sc = this.answer2Sound.play();
				break;
				
				case 3:
				sc = this.answer3Sound.play();
				break;
				
			}
			
			sc.addEventListener(Event.SOUND_COMPLETE, onAnswerSoundComplete);
			
			this.server.submitAnswer(answer.getId(), this.questionDialog.getStart(),this.questionDialog.getQuestion().getScore() ,answer.isAnswer(),this.questionDialog.getQuestion().getId());
		}
		
		private function onPrizesButton(e:MouseEvent):void {
			onMenuSelect(e);
			//this.tracker.trackEvent(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME, "linkOut", "moreGames");
			
			var request:URLRequest = new URLRequest(this.root.loaderInfo.parameters.prizesUrl);
			try {
  				navigateToURL(request, '_blank'); 
			}
			catch (e:Error) {
			}	
		}
		private function onDouble(e:DialogEvent):void {
			this.doubleEntryDialog.showDialog();
		}
		private function onDoubleEntry(e:DialogEvent):void {
			if (soundsEnabled()) {
				this.sounds.doubleYourPoints();
			}
			var healthRecords:Array = new Array();
			
			healthRecords.push( { RecordItemName:"GlucoseBeforeBreakfast", 
			Value: this.doubleEntryDialog.getBreakfastGlucose(), 
			Measure: this.doubleEntryDialog.getBreakfastUnits(), 
			Source: "user" } );

			healthRecords.push( { RecordItemName:"GlucoseBeforeLunch", 
			Value: this.doubleEntryDialog.getLunchGlucose(), 
			Measure: this.doubleEntryDialog.getLunchUnits(), 
			Source: "user" } );			
			
			healthRecords.push( { RecordItemName:"GlucoseAfterSnack", 
			Value: this.doubleEntryDialog.getSnackGlucose(), 
			Measure: this.doubleEntryDialog.getSnackUnits(), 
			Source: "user" } );
			
			healthRecords.push( { RecordItemName:"GlucoseBeforeDinner", 
			Value: this.doubleEntryDialog.getDinnerGlucose(), 
			Measure: this.doubleEntryDialog.getDinnerUnits(), 
			Source: "user" } );
			
			this.server.submitGlucose(healthRecords);
		}
		private function handleAssets():void {
			
			var mySo:SharedObject = SharedObject.getLocal(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME);
			
			
			if (this.doubleDialog == null) {
				this.doubleDialog = a.getMovieClip("doubleYourPointsDialog") as DoubleYourPointsDialog;
				this.doubleDialog.addEventListener(DialogEvent.DIALOG_CONFIRM, onDouble);
				this.doubleDialog.setParent(this);	
			}
			
			if (this.doubleEntryDialog == null) {
				this.doubleEntryDialog = a.getMovieClip("doubleYourPointsEntryDialog") as DoubleYourPointsEntryDialog;
				this.doubleEntryDialog.addEventListener(DialogEvent.DIALOG_CONFIRM, onDoubleEntry);
				this.doubleEntryDialog.setParent(this);	
			}
			
			if (this.bonusHintDialog == null) {
				this.bonusHintDialog = a.getMovieClip("bonusHintDialog") as BonusHintDialog;
				this.bonusHintDialog.setParent(this);	
			}
			
			if (this.kingClubsBurn == null) {
				this.kingClubsBurn = a.getMovieClip("kingClubsBurn");
				this.kingClubsBurn.stop();
			}
			
			if (this.kingDiamondsBurn == null) {
				this.kingDiamondsBurn = a.getMovieClip("kingDiamondsBurn");
				this.kingDiamondsBurn.stop();
			}
			
			if (this.kingSpadesBurn == null) {
				this.kingSpadesBurn = a.getMovieClip("kingSpadesBurn");
				this.kingSpadesBurn.stop();
			}
			
			if (this.kingHeartsBurn == null) {
				this.kingHeartsBurn = a.getMovieClip("kingHeartsBurn");
				this.kingHeartsBurn.stop();
			}

			if (this.questionDialog == null) {
				this.questionDialog = a.getMovieClip("questionDialog") as QuestionDialog;
				this.questionDialog.addEventListener(DialogEvent.DIALOG_DISMISS, removeQuestionDialog);
				this.questionDialog.addEventListener(QuestionDialog.ANSWER, onAnswerQuestion);
				
				this.questionDialog.setParent(this);
			}
			
			if (this.lasso == null) {
				this.lasso = a.getMovieClip("lasso") as MovieClip;	
			}
		
			if (this.goldCards == null) {
				this.goldCards = a.getGoldCards();
			}

			if (this.loginDialog == null) {
				this.loginDialog = a.getMovieClip("loginDialog") as LoginDialog;		
				this.loginDialog.setParent(this);					
				this.loginDialog.loginButton.addEventListener(MouseEvent.CLICK, onLogin);
				this.loginDialog.addEventListener(LoginDialog.SEND_SIGN_UP, onSendSignUp);
				
				this.loginDialog.loginButton.addEventListener(MouseEvent.CLICK, onMenuSelect);
				this.loginDialog.signUpButton.addEventListener(MouseEvent.CLICK, onMenuSelect);
				this.loginDialog.signUpDialog.confirmButton.addEventListener(MouseEvent.CLICK, onMenuSelect);
				this.loginDialog.signUpDialog.maleButton.addEventListener(MouseEvent.CLICK, onMenuSelect);
				this.loginDialog.signUpDialog.femaleButton.addEventListener(MouseEvent.CLICK, onMenuSelect);
				this.loginDialog.signUpDialog.dismissButton.addEventListener(MouseEvent.CLICK, onClose2);
			}
			
			if (this.terms == null) {
				this.terms = a.getMovieClip("terms") as TermsAndAgreement;
				this.terms.setParent(this);
				this.terms.addEventListener(DialogEvent.DIALOG_DISMISS, onTerms);
				this.terms.dismissButton.addEventListener(MouseEvent.CLICK, onMenuSelect);
			}
			
			if (this.autoCompleteDialog == null) {
				this.autoCompleteDialog = a.getMovieClip("autoCompleteDialog") as AbstractDialog;
				this.autoCompleteDialog.setParent(this);
				this.autoCompleteDialog.addEventListener(DialogEvent.DIALOG_CONFIRM, onClose2);
				this.autoCompleteDialog.addEventListener(DialogEvent.DIALOG_DISMISS, onClose2);
				this.autoCompleteDialog.addEventListener(DialogEvent.DIALOG_CONFIRM, onAutoCompleteConfirm);
			}
			
			if (this.howToPlayText == null) {
				this.howToPlayText = a.getHowToPlay();
				(this.howToPlayText as MovieClip).close.addEventListener(MouseEvent.CLICK, onClose);
				this.howToPlayText.setParent(this);
			}

			if (this.sash == null) {
				this.sash = a.getBonusCardAnimation("sash");
			}
			
			if (this.gameOver == null) {
				this.gameOver = a.getMovieClip("gameOver");
			}
			
			if (this.train == null) {
				this.train = a.getMovieClip("train") as Train;
			}
			
			if (this.hulkStomp == null) {
				this.hulkStomp = a.getBonusCardAnimation("hulkStomp");
				this.hulkStomp.gotoAndStop(1);
			}
			
			if (this.wolverineScratch == null) {
				this.wolverineScratch = a.getBonusCardAnimation("wolverineScratch");
			}

			if (this.scoreArea == null) {
				this.scoreArea = a.getMovieClip("score");
				this.scoreArea.x = 516;
				this.scoreArea.y = 0;
			}
			trace("add score area--------------");
			addChild(this.scoreArea);
					
			if (this.timeArea == null) {
				this.timeArea = a.getMovieClip("time");
				this.timeArea.x = 581;
				this.timeArea.y = 9;
			}

			addChild(this.timeArea);

			if (this.bb == null) {
				this.bb = a.getMovieClip("bottomBar");
				this.bb.y = 0;
				this.bb.x = 0;
				
				if (this.undo == null) {
					this.undo = this.bb.getChildByName("undo") as AbstractButton;
					
					this.undo.enabled = false;
					this.undo.addEventListener(MouseEvent.CLICK, onUndo);
				}	
			}
			
			//last minute hack
			addChild(this.empty);
			
			addChild(this.bb);
					
			if (this.tb == null) {
				this.tb = a.getMovieClip("topBar");
				this.tb.y = 0;
				this.tb.x = 16;
				
				var ed:MovieClip = this.tb.getChildByName("marvelKids") as MovieClip;
				
				if (ed != null) {
					ed.buttonMode = true;
					ed.addEventListener(MouseEvent.CLICK, onMarvelKidsClick);
				}
				

			}
			
			addChild(tb);
					
			
			if (this.creditsButton == null) {
				this.creditsButton = a.getButton("creditsButton");
				this.creditsButton.x = 731;
				this.creditsButton.y = 598;
				this.creditsButton.addEventListener(MouseEvent.CLICK, onCreditsClick);
				addChild(this.creditsButton);
			}
			
			if (this.creditsPage == null) {
				this.creditsPage = a.getMovieClip("creditsPage") as AbstractDialog;
				this.creditsPage.setParent(this);
				this.creditsPage.addEventListener(MouseEvent.CLICK, onClickCredits);
			}
			
			if (this.optionsMenu == null) {
				this.optionsMenu = a.getOptionsMenu();
				this.optionsMenu.setParent(this);
				
				this.optionsMenu.statsDialog.addEventListener(StatsDialog.CLOSE, onClose2);
				this.optionsMenu.statsDialog.addEventListener(StatsDialog.RESET_STATS, onMenuSelect);
				this.optionsMenu.statsDialog.addEventListener(StatsDialog.RESET_STATS, onResetStats);
				
				this.optionsMenu.addEventListener(OptionsMenu.DECK_PICK, onMenuSelect);
				this.optionsMenu.addEventListener(OptionsMenu.STATS_CHECK, onMenuSelect);
				this.optionsMenu.addEventListener(OptionsMenu.TIMER_OFF, onMenuSelect);
				this.optionsMenu.addEventListener(OptionsMenu.TIMER_ON, onMenuSelect);
				this.optionsMenu.addEventListener(OptionsMenu.DRAW_1, onMenuSelect);
				this.optionsMenu.addEventListener(OptionsMenu.DRAW_3, onMenuSelect);
				this.optionsMenu.addEventListener(OptionsMenu.OK, onClose);
				this.optionsMenu.addEventListener(OptionsMenu.CANCEL, onClose);
				this.optionsMenu.addEventListener(OptionsMenu.SOUND_OFF, onSoundOff);
				this.optionsMenu.addEventListener(OptionsMenu.SOUND_OFF, onMenuSelect);
				this.optionsMenu.addEventListener(OptionsMenu.SOUND_ON, onSoundOn);
				this.optionsMenu.addEventListener(OptionsMenu.SOUND_ON, onMenuSelect);
				
				//this.optionsMenu.okay.addEventListener(MouseEvent.CLICK, onClose);
				//this.optionsMenu.cancel.addEventListener(MouseEvent.CLICK, onClose);
				
				//this.optionsMenu.statsDialog.close.addEventListener(MouseEvent.CLICK, onClose2);
				//this.optionsMenu.statsDialog.resetStats.addEventListener(MouseEvent.CLICK, onMenuSelect);
				
				this.optionsMenu.addEventListener(OptionsMenu.NEW_GAME, onOptionsStartNewGame);
				
				
				updateStatsDisplay();
				
				mySo.flush();
			}	
				
			if (this.howToPlay == null) {
				this.howToPlay = bb.getChildByName("howToPlay") as AbstractButton;
				this.howToPlay.addEventListener(MouseEvent.CLICK, onHowToPlay);
				
			}
					
			if (this.options == null) {
				this.options = bb.getChildByName("options") as AbstractButton;
				this.options.addEventListener(MouseEvent.CLICK, onOptions);
			}
			
			if (this.startGameButton == null) {	
				this.startGameButton = bb.getChildByName("startGame") as AbstractButton;
				this.startGameButton.enabled = false;
				this.startGameButton.addEventListener(MouseEvent.CLICK, onStartGame);
				this.startGameButton.addEventListener(MouseEvent.CLICK, onMenuSelect);
				
				var deal:AbstractButton = bb.getChildByName("deal") as AbstractButton;
				deal.addEventListener(MouseEvent.CLICK, onStartGame);
				deal.addEventListener(MouseEvent.CLICK, onMenuSelect);
			}

			if (this.moreGames == null) {	
				this.moreGames = bb.getChildByName("moreGames") as AbstractButton;
				this.moreGames.addEventListener(MouseEvent.CLICK, onMoreGames);
			}
			
			var pb:AbstractButton = bb.getChildByName("prizes") as AbstractButton;
			if (pb != null) {
				pb.addEventListener(MouseEvent.CLICK, onPrizesButton);
			}
			
			if (this.captainAmerica == null) {
				this.captainAmerica = a.getBonusCard("captainAmerica");
				this.captainAmerica.addEventListener(ButtonEvent.SELECTED, onCaptainAmericaClick);
				this.captainAmerica.addEventListener(ButtonEvent.DESELECTED, onCaptainAmericaDeselected);
			}
			
			//if (this.drDoom == null) {	
			//	this.drDoom = a.getBonusCard("drDoom");
			//	this.drDoom.addEventListener(TimerEvent.TIMER_COMPLETE, onDrDoomTimerComplete);
			//	this.drDoom.addEventListener(TimerBonusCard.TIME_BONUS_CARD_TICK, onBonusCardTick);
			//}
			
			if (this.hulk == null) {	
				this.hulk = a.getBonusCard("hulk");
				this.hulk.addEventListener(ButtonEvent.SELECTED, onHulkClick);
				this.hulk.addEventListener(ButtonEvent.DESELECTED, onHulkDeselected);
			}
				
			if (this.ironMan == null) {
				this.ironMan = a.getBonusCard("ironMan");
				this.ironMan.addEventListener(MouseEvent.CLICK, onIronManClick);
			}

			if (this.msMarvel == null) {
				this.msMarvel = a.getBonusCard("msMarvel");
				this.msMarvel.addEventListener(ButtonEvent.SELECTED, onMsMarvelClick);
				this.msMarvel.addEventListener(ButtonEvent.DESELECTED, onMsMarvelDeselected);
			}
			
			if (this.thor == null) {
				this.thor = a.getBonusCard("thor");
				this.thor.addEventListener(MouseEvent.CLICK, onThorClick);
			}
			
			if (this.wolverine == null) {
				this.wolverine = a.getBonusCard("wolverine");
				this.wolverine.addEventListener(ButtonEvent.SELECTED, onWolverineSelected);
				this.wolverine.addEventListener(ButtonEvent.DESELECTED, onWolverineDeselected);
			}
			
			if (timerEnabled()) {
				//select it in the menu
				this.optionsMenu.selectTimerOn();
			}
			else {
				this.optionsMenu.selectTimerOff();
			}
			
			if (mySo.data.sounds == true || mySo.data.sounds == undefined) {
				trace("select sounds true");
				this.optionsMenu.selectSounds(true);	
			}
			else {
				trace("select sounds false");
				this.optionsMenu.selectSounds(false);
			}
			
			if (mySo.data.drawType == DRAW_THREE) {
				this.optionsMenu.selectDraw3();
			}
			else {
				this.optionsMenu.selectDraw1();
			}

			//only od it once
			if (this.bb != null && gameNum == 0) {
				this.bb.play();
			}
			
			updateUndoButton();
			updateScoreDisplay();
			updateBestScoreDisplay();
			
			if (!this.server.isLoggedIn()) {
				if (soundsEnabled()) {
					this.sounds.splash();
				}
				
				if (!this.terms.hasBeenShown()) {
					this.server.queryTermsOfService();
				}
				
	/*
				//if the username and hash are set
				//if (this.root.loaderInfo.parameters.username != undefined && this.root.loaderInfo.parameters.hash != undefined) {
				if (this.root.loaderInfo.parameters.login == "auto") {
					this.server.login(this.root.loaderInfo.parameters.username, this.root.loaderInfo.parameters.hash);
				}
				//else {
				else if (this.root.loaderInfo.parameters.login == "prompt") {
					this.loginDialog.showDialog(0,0);
				}
				else if (this.root.loaderInfo.parameters.login == "skip") {
					this.server.queryTermsOfService();
				}*/
			}
		}

		private function updateStatsDisplay():void {
			if (this.optionsMenu != null) {
				var mySo:SharedObject = SharedObject.getLocal(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME);
				
				var dohs:Number = mySo.data.drawOneHighScore == undefined ? 0:mySo.data.drawOneHighScore;
				var dths:Number = mySo.data.drawThreeHighScore == undefined ? 0:mySo.data.drawThreeHighScore;
				
				var dohst:Number = mySo.data.drawOneHighScoreTimer == undefined ? 0:mySo.data.drawOneHighScoreTimer;
				var dthst:Number = mySo.data.drawThreeHighScoreTimer == undefined ? 0:mySo.data.drawThreeHighScoreTimer;
				
				var dow:Number = mySo.data.drawOneWins == undefined ? 0:mySo.data.drawOneWins;
				var dowt:Number = mySo.data.drawOneWinsTimer == undefined ? 0:mySo.data.drawOneWinsTimer;
				
				var dtw:Number = mySo.data.drawThreeWins == undefined ? 0:mySo.data.drawThreeWins;
				var dtwt:Number = mySo.data.drawThreeWinsTimer == undefined ? 0:mySo.data.drawThreeWinsTimer;
				
				var dop:Number = mySo.data.drawOnePlayed == undefined ? 0:mySo.data.drawOnePlayed;
				var dopt:Number = mySo.data.drawOnePlayedTimer == undefined ? 0:mySo.data.drawOnePlayedTimer;
				
				var dtp:Number = mySo.data.drawThreePlayed == undefined ? 0:mySo.data.drawThreePlayed;
				var dtpt:Number = mySo.data.drawThreePlayedTimer == undefined ? 0:mySo.data.drawThreePlayedTimer;
				
				var dowp:Number;
				var dtwp:Number;
				
				var dowpt:Number;
				var dtwpt:Number;
				
				//if invalid
				if (dop == 0) {
					dowp = -1;
				}
				else {
					dowp = dow/dop;
				}
				
				//if invalid
				if (dtp == 0) {
					dtwp = -1;
				}
				else {
					dtwp = dtw/dtp;
				}
				
				//if invalid
				if (dopt == 0) {
					dowpt = -1;
				}
				else {
					dowpt = dowt/dopt;
				}
				
				//if invalid
				if (dtpt == 0) {
					dtwpt = -1;
				}
				else {
					dtwpt = dtwt/dtpt;
				}
				
				//trace("draw one played " + dop);
				//trace ("draw one won" + dow);
				
				//trace("update stats" + dohs  + " " + dowp + " " + dths + " " + dtwp); 
				this.optionsMenu.setStats(dohs, dowp, dths, dtwp, dohst, dowpt, dthst, dtwpt);
			}
		}
		
		private function onSoundOn(e:Event):void {
			//this.tracker.trackEvent(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME, "toggleSFX", "on");
			
			var mySo:SharedObject = SharedObject.getLocal(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME);
			
			mySo.data.sounds = true;
			mySo.flush();
		}

		private function onSoundOff(e:Event):void {
			//this.tracker.trackEvent(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME, "toggleSFX", "off");
			
			var mySo:SharedObject = SharedObject.getLocal(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME);
			
			mySo.data.sounds = false;
			mySo.flush();
		}
		
		private function timerEnabled():Boolean {
			var mySo:SharedObject = SharedObject.getLocal(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME);
			
			if (mySo.data.timed == true) {
				return true;
			}
			else {
				return false;
			} 
		}
		
		private function soundsEnabled():Boolean {
			var mySo:SharedObject = SharedObject.getLocal(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME);
			
			if (mySo.data.sounds == undefined) {
				return true;
			}
			else {
				return mySo.data.sounds;
			} 
		}

		private function onOptionsStartNewGame(e:Event):void {
			onMenuSelect(e);
			
			var mySo:SharedObject = SharedObject.getLocal(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME);
			
			mySo.data.timed = this.optionsMenu.isTimed();
			
			if (this.optionsMenu.isDraw1()) {
				mySo.data.drawType = DRAW_ONE;
				this.drawType = DRAW_ONE;
			}
			else {
				mySo.data.drawType = DRAW_THREE;
				this.drawType = DRAW_THREE;		
			}
			
			newGame(this.bg);
		}
		
		protected function onComplete(e:StreamEvent):void {
			this.preloadDialog.removeDialog();
			
			//get an array of all streams
			var stream:ILoadStream = e.getStream()
			
			if (stream != null) {
				this.a = stream.getData();
			}
			
			//newGame(this.bg);
			this.bg.y = 0;
			this.bg.x = 0;
			addChild(this.bg);
			addChild(this.logo);
			if (this.a != null) {
				handleAssets();
			}
			
			
		}
		
		private function dealCards():void {
			newGame(this.bg);
		}
		private function onClose2(e:Event):void {
		
			if (soundsEnabled()) {
				this.sounds.closeMenu();
			}
			
			
		}
		
		private function onClose(e:Event):void {
			this.sounds.stopDialogSound();
			if (soundsEnabled()) {
				this.sounds.closeMenu();
			}
			
			
		}
		private function onMenuSelect(e:Event):void {
			if (soundsEnabled()) {
				this.sounds.selectMenuItem();
			}
		}
		
		private function onOptions(e:MouseEvent):void {
			this.sounds.stopSplash();
			this.optionsMenu.showDialog();
			if (soundsEnabled()) {
				this.sounds.dialog();
			}
			
			onMenuSelect(e);
		}

		/*
		 * Removes a card from a card pile visually and in memory
		 */
		private function removeCard(index:uint, pile:CardPile):void {
								
			//make a new pile								
			var temp:Array = new Array();

			//save the card to remove
			var remove:VisualCard = pile.removeChildAt(index) as VisualCard;
			
			var vc:VisualCard = null;
			
			//save the other cards
			while(pile.numChildren > 0) {
				//trace(pile.getChildAt(0));
				vc = pile.removeChildAt(0) as VisualCard;
				temp.push(vc);
			}
			
			//now add back all cards
			for each (vc in temp) {
				pile.addCard(vc);
			}
			
			updatePileState(pile);
		}
		
		private function onWolverineDeselected(e:ButtonEvent):void {
			trace("wolverine desleect");
			wolverineUnlock();	
		}

		private function onWolverineSelected(e:ButtonEvent):void {
			if (gameOverFlag) {
				this.wolverine.setSelected(false);
				return;	
			}
			
			this.lastBonusCardClicked = this.wolverine;
			setupQuestion(FOOT_CARE_CAT);
		}
		
		private function activateWolverine():void {
		//	unlockOthers();
			this.wolverine.helpBubble("REVEAL CARDS","Click a column to reveal its cards.");
			//this.tracker.trackEvent(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME, "miscellaneous", "wolverine_bonus_card");
			wolverineLock();
		}

		
		private function onThorClick(e:MouseEvent):void {
			if (gameOverFlag) {
				this.thor.setSelected(false);
				return;	
			}
			
			if (emptyKlondikePile()) {
				
				var king:VisualCard = null;
				var position:Point = null;
				
				//find an king
				//search through tableaus first
				//for each tableau
				for (var i:uint = 0; i < this.klondikePiles.length; i++) {
					var kPile:KlondikePile = this.klondikePiles[i];
					//if king not found yet
					if (king == null && !kPile.isEmpty()) {
						//look through all face down tableau cards for an ace
						for (var j:uint = 0; j < kPile.numChildren; j++) {
							var vc:VisualCard = kPile.getChildAt(j) as VisualCard;
							if (vc != null && vc.isDown) {
								var c:Card = vc.card;
								
								if (c.value == CardValue.KING) {
									
									//set the found king
									king = vc;
									
									break;
								}
							}
						}
					}
				}
				
				//we didnt find an ace in the tableaus, so look in the deck
				if (king == null) {
					//trace("lookin in deck");
					this.cardDealer.reset();
					
					for each (var card:Card in this.visualDeck.deck.cards) {
						if (card.value == CardValue.KING) {
							king = new VisualCard(card);
							
							break;
						}
					}
				}
				
				if (king == null) {
					this.thor.helpBubble("FIND KING","All the Kings have been found.");
					this.thor.setSelected(false);
				}
				else {
					this.lastBonusCardClicked = this.thor;
					setupQuestion(EXCERCISE_CAT);
				}
			}
			else {
				this.thor.helpBubble("FIND KING","An empty slot is needed first.");
				this.thor.setSelected(false);
			}
		}
		
		private function thorAddToPile(cp:CardPile, vc:VisualCard, anim:MovieClip):void {
			if (contains(anim)) {
				removeChild(anim);
			}
			vc.isDown = false;
			configureDrag(vc);
			cp.addCard(vc);
			
			decreaseBonusCard(this.thor);
			this.thor.setSelected(false);
		}
							
		private function activateThor():void {
			//this.tracker.trackEvent(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME, "miscellaneous", "thor_bonus_card");
			//trace("on thor click");
			if (emptyKlondikePile()) {
				
				var king:VisualCard = null;
				var position:Point = null;
				
				//find an king
				//search through tableaus first
				//for each tableau
				for (var i:uint = 0; i < this.klondikePiles.length; i++) {
					var kPile:KlondikePile = this.klondikePiles[i];
					//if king not found yet
					if (king == null && !kPile.isEmpty()) {
						//look through all face down tableau cards for an ace
						for (var j:uint = 0; j < kPile.numChildren; j++) {
							var vc:VisualCard = kPile.getChildAt(j) as VisualCard;
							if (vc != null && vc.isDown) {
								var c:Card = vc.card;
								
								if (c.value == CardValue.KING) {
									//trace("found king of " + c.suit + " " + c.value + " in pile " + i + " of card " + j);
									
									//set the found king
									king = vc;
									
									//save the coordinates
									position = Position.getGlobal(king);
									
									//get the new klondike pile with the king removed
									removeCard(j, kPile);
									
									break;
								}
							}
						}
					}
				}
				
				//we didnt find an ace in the tableaus, so look in the deck
				if (king == null) {
					//trace("lookin in deck");
					this.cardDealer.reset();
					
					for each (var card:Card in this.visualDeck.deck.cards) {
						if (card.value == CardValue.KING) {
							king = new VisualCard(card);
							
							//save the position
							position = Position.getGlobal(this.visualDeck);
							
							//trace("found " + card.suit + " " + card.value);
							
							this.visualDeck.deck.remove(card);
							
							break;
						}
					}
				}
				
				if (king == null) {
					this.thor.helpBubble("FIND KING","All the Kings have been found.");
					this.thor.setSelected(false);
				}
				else {
					//we found a king, now move it to the next empty klondike pile
					//trace("place in klondike pile");
					clearHistory();
					
					//find first empty klondike pile
					//if we found an ace there MUST be one empty ace pile
					for each (var kp:KlondikePile in this.klondikePiles) {
						//if you can add it
						if (kp.canAdd(new CardPile(king))) {
							//get the suit
							var anim:MovieClip = null;
							
							switch (king.card.suit) {
								case Suit.CLUBS:
								anim = this.kingClubsBurn;
								break;
								
								case Suit.DIAMONDS:
								anim = this.kingDiamondsBurn;
								break;
								
								case Suit.HEARTS:
								anim = this.kingHeartsBurn;
								break;
								
								case Suit.SPADES:
								anim = this.kingSpadesBurn;
								break;
							}
							
							anim.x = position.x;
							anim.y = position.y;
							
							if (soundsEnabled()) {
								this.sounds.thor();
							}
							
							var kpg:Point = kp.localToGlobal(new Point(0,0));
							
								
							addChild(anim);
							anim.gotoAndStop(1);
							anim.play();
							//TweenLite.delayedCall(1,moveThor,new Array(anim,2,{x:kpg.x, y:kpg.y, onComplete:thorAddToPile, onCompleteParams:new Array(kp, king, anim)}));
							TweenLite.to(anim,3,{delay:1, x:kpg.x, y:kpg.y, onComplete:thorAddToPile, onCompleteParams:new Array(kp, king, anim)});

							
							/*
							//set face up
							king.isDown = false;
					
							//reset the position
							king.x = position.x;
							king.y = position.y;

							if (soundsEnabled()) {
								this.sounds.thor();
							}
			
			
							//add it
							kp.addEventListener(CardEvent.CARD_IN_MOTION, onThorCardInMotion);
							kp.addEventListener(CardEvent.CARD_MOTION_COMPLETE, onThorCardComplete);
							this.thor.removeEventListener(MouseEvent.CLICK, onThorClick);
							kp.addEventListener(CardPile.ADD_CARD, onBonusCardAnimation);
							configureDrag(king);
							kp.addCardWithMotion(king, 0, 0, 1);
							*/
							
							break;
						}
					}
				}
			}
			else {
				this.thor.helpBubble("FIND KING","An empty slot is needed first.");
				this.thor.setSelected(false);
			}
		}	
		
		private function activateCaptainAmerica():void {
		//	unlockOthers();
			//if (this.emptyKlondikePile()) {
				this.captainAmerica.helpBubble("MOVE TO BLANK","Click a card in a column to move it to an empty slot.");
				captainAmericaLock();
				//this.tracker.trackEvent(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME, "miscellaneous", "captain_america_bonus_card");
			//}
			//else {
				
				//this.captainAmerica.helpBubble("I can only move cards to an empty slot.");
				//captainAmericaUnlock();
			//}
		}

		private function removeQuestionDialog(e:DialogEvent):void {
			this.questionDialog.removeDialog();
			this.questionSoundChannel.stop();
			
			//deselet all
			this.thor.setSelected(false, false);
			this.ironMan.setSelected(false, false);
			this.hulk.setSelected(false, false);
			this.captainAmerica.setSelected(false, false);
			this.wolverine.setSelected(false, false);
			this.msMarvel.setSelected(false, false);
			
			
		}
		
		private function getQuestion(catId:int):void {
			this.server.queryQuestion(catId);

		}
		
		private function onIronManClick(e:MouseEvent):void {
			if (gameOverFlag) {
				
				return;	
			}
			
			var ace:VisualCard = null;
			var position:Point = null;
			
			//find an ace
			//search through tableaus first
			//for each tableau
			for (var i:uint = 0; i < this.klondikePiles.length; i++) {
				var kPile:KlondikePile = this.klondikePiles[i];
				//if ace not found yet
				if (ace == null && !kPile.isEmpty()) {

					//look through all face down tableau cards for an ace
					for (var j:uint = 0; j < kPile.numChildren; j++) {
						var vc:VisualCard = kPile.getChildAt(j) as VisualCard;
						if (vc != null && vc.isDown) {
							var c:Card = vc.card;
							
							if (c.value == CardValue.ACE) {
	
								//set the found ace
								ace = vc;
								
								
								break;
							}
						}
					}
				}
			}

			if (ace == null) {
				this.cardDealer.reset();
				
				for each (var card:Card in this.visualDeck.deck.cards) {
					if (card.value == CardValue.ACE) {
			
						ace = new VisualCard(card);
						
						break;
					}
				}
			}


			if (ace == null) {
				//no aces anywhere, display error message
				this.ironMan.helpBubble("FIND ACE","All Aces have been found.");
				this.ironMan.setSelected(false);
			}
			else {
				this.lastBonusCardClicked = this.ironMan;
				
				setupQuestion(GLUCOSE_MONITORING_CAT);
			}
		}
		
		
		
		private function setupQuestion(id:int):void {
			this.server.queryQuestion(id);
		}


		
		private function questionSoundReady(e:Event):void {
			this.questionSoundChannel = this.questionSound.play();
			
			this.questionDialog.showLoading(false);
			
		}
		private function playIronManSound():void {
						if (soundsEnabled()) {
							this.sounds.ironMan();
						}
		}
		private function activateIronMan():void {
			
			
			//trace("on iron man click");
			//this.tracker.trackEvent(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME, "miscellaneous", "iron_man_bonus_card");
			
			var ace:VisualCard = null;
			var position:Point = null;
			
			//find an ace
			//search through tableaus first
			//for each tableau
			for (var i:uint = 0; i < this.klondikePiles.length; i++) {
				var kPile:KlondikePile = this.klondikePiles[i];
				//if ace not found yet
				if (ace == null && !kPile.isEmpty()) {

					//look through all face down tableau cards for an ace
					for (var j:uint = 0; j < kPile.numChildren; j++) {
						var vc:VisualCard = kPile.getChildAt(j) as VisualCard;
						if (vc != null && vc.isDown) {
							var c:Card = vc.card;
							
							if (c.value == CardValue.ACE) {
								//trace("found ace of " + c.suit + " " + c.value + " in pile " + i + " of card " + j);
								//trace(vc.x + " " + vc.y);
								//set the found ace
								ace = vc;
								
								
								//preserve position
								position = Position.getGlobal(ace);
								
								//get the new klondike pile with the ace removed
								removeCard(j, kPile);
								//trace(vc.x + " " + vc.y);
								break;
							}
						}
					}
				}
			}
			
			//we didnt find an ace in the tableaus, so look in the deck
			if (ace == null) {
				//trace("lookin in deck");
				this.cardDealer.reset();
				
				for each (var card:Card in this.visualDeck.deck.cards) {
					if (card.value == CardValue.ACE) {
			
						ace = new VisualCard(card);
						
						//preserve position
						//its in the deck so use the deck coords
						position = new Point(this.visualDeck.x, this.visualDeck.y);
								
						//trace("found " + card.suit + " " + card.value);
						this.visualDeck.deck.remove(card);
						
						break;
					}
				}
			}
			
			if (ace == null) {
				//no aces anywhere, display error message
				this.ironMan.helpBubble("FIND ACE","All Aces have been found.");
			}
			else {
				clearHistory();
				//we found an ace, now move it to the next empty ace pile
				//trace("place in ace pile");
				
				//find first empty ace pile
				//if we found an ace there MUST be one empty ace pile
				for each (var ap:AcePile in this.acePiles) {
					//if you can add it
					if (ap.canAddCard(ace.card)) {
						this.ironMan.enabled = false;
						

						
						//set face up
						ace.isDown = false;
				
						//ace has been removed , right now has no parent so reset global position
						ace.x = position.x;
						ace.y = position.y;
						
						//lock the iron man bonus
						this.ironMan.removeEventListener(MouseEvent.CLICK, onIronManClick);

						//move it		
						ap.addEventListener(CardEvent.CARD_IN_MOTION, onIronManCardMotion);
						ap.addEventListener(CardEvent.CARD_MOTION_COMPLETE, onIronManCardComplete);
						ap.addEventListener(CardPile.ADD_CARD, onBonusCardAnimation);
						ap.addCardWithMotion(ace,0,1,2);
						
						TweenLite.delayedCall(1, playIronManSound);
						this.goldCards.x = ace.x;
						this.goldCards.y = ace.y;
						
						this.goldCards.reset();
						
						this.disableAddFoundationSound = true;
						
						this.stage.addChild(this.goldCards as DisplayObject);
						this.goldCards.showSuit(ace.card.suit)
						
						//add drag
						//configureDrag(ace);
						
						break;
					}
				}
			}
		}	

		private function onIronManCardMotion(e:CardEvent):void {
			var vc:VisualCard = e.getData();
			
			if (vc != null) {
				
				
				//var global:Point = Position.getGlobal(this.ironMan as MovieClip);
				//adjust to get center of Thor
				//global.x += this.ironMan.width/2 - 18;
				//global.y += this.ironMan.height/2 - 25;
				
				var cardGlobal:Point = Position.getGlobal(vc);
				
				this.goldCards.x = cardGlobal.x;
				this.goldCards.y = cardGlobal.y;
				
				//this.ironManLaser.drawLaser(this.ironManLaser.getLaserShape(), 0xffffff, 0xaaaaff, cardGlobal, global, 10, 10);
				////trace(vc.x + " " + vc.y);
			}
		}
		
		private function removeGoldCards():void { 
			if (this.stage.contains(this.goldCards as DisplayObject)) {
				this.stage.removeChild(this.goldCards as DisplayObject);
			}
			
			this.ironMan.enabled = true;
			this.disableAddFoundationSound = false;
		}
		
		private function onIronManCardComplete(e:CardEvent):void {
			this.goldCards.dropCoins();
			
			dispatchEvent(new Event(TO_ACE_PILE));
			

						
			TweenLite.delayedCall(2, removeGoldCards);
			
			var cp:CardPile = e.target as CardPile;
			cp.removeEventListener(CardEvent.CARD_IN_MOTION, onIronManCardMotion);
			cp.removeEventListener(CardEvent.CARD_MOTION_COMPLETE, onIronManCardComplete);
			
			decreaseBonusCard(this.ironMan);
			this.ironMan.setSelected(false);
		}

		private function onBonusCardAnimation(e:Event):void {
			//trace("on bonus card anime " + this.ironMan.hasEventListener(MouseEvent.CLICK));
			//unlock bonus cards this affects
			this.ironMan.addEventListener(MouseEvent.CLICK, onIronManClick);
			
			this.msMarvel.addEventListener(ButtonEvent.SELECTED, onMsMarvelClick);
			
			this.captainAmerica.addEventListener(ButtonEvent.SELECTED, onCaptainAmericaClick);
			
			this.thor.addEventListener(MouseEvent.CLICK, onThorClick);
			
			
			//remove
			var cp:CardPile = e.target as CardPile;
			cp.removeEventListener(CardPile.ADD_CARD, onBonusCardAnimation);
			
			var vc:VisualCard = cp.getTopCard();

			if (vc != null) {
				configureDrag(vc);
			}
		}

		private function decreaseBonusCard(card:IBonusCard):void {
			card.decrement();
			trace("decrease bonus card");
			if (card.getCount() == 0) {
				trace("remove item");
				this.list.removeItem(card);
			}
		}
		//private function unlockOthers():void {
			//wolverineUnlock();
			//msMarvelUnlock();
			//captainAmericaUnlock();
			//hulkUnlock();
			
		//}
		private function onHulkClick(e:ButtonEvent):void {
			if (gameOverFlag) {
				this.hulk.setSelected(false);	
			}
			else {
				this.lastBonusCardClicked = this.hulk;
				setupQuestion(COPING_CAT);
			}
		}
		private function activateHulk():void {
		//	unlockOthers();
			//this.tracker.trackEvent(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME, "miscellaneous", "hulk_bonus_card");
			this.hulk.helpBubble("SHUFFLE","Click the deck or a column to shuffle.");
			// the tableaus and deck
			hulkLock();
		}
		private function onMsMarvelClick(e:ButtonEvent):void {
			if (gameOverFlag) {
				this.msMarvel.setSelected(false);
				return;	
			}
			
			this.lastBonusCardClicked = this.msMarvel;
			setupQuestion(MED_COMPLIANCE_CAT);
		}
		private function activateMsMarvel():void {
			//unlockOthers();
			this.msMarvel.helpBubble("FIND NEXT","Click a card in a column to find the next card.");
			//this.tracker.trackEvent(MARVEL_SUPERHERO_SQUAD_SOLITAIRE_NAME, "miscellaneous", "ms_marvel_bonus_card");
			msMarvelLock();			
		}
		
		
		private function captainAmericaLock():void {
			//remove the click listener for the deck
			this.visualDeck.removeEventListener( MouseEvent.CLICK, deckClick );
			
			//add listeners for klondike piles
			for each (var kPile:KlondikePile in this.klondikePiles) {
				//trace("captain america lock, add event listen on " + kPile);
				kPile.addEventListener(MouseEvent.MOUSE_DOWN, onCaptainAmericaPileClick, true);
			}
			
			//add listeners for ace piles
			for each (var aPile:AcePile in this.acePiles) {
				aPile.addEventListener(MouseEvent.MOUSE_DOWN, onCaptainAmericaPileClick, true);
			}
			
			this.dealtPile.addEventListener(MouseEvent.MOUSE_DOWN, onCaptainAmericaPileClick, true);
			
			//this.captainAmerica.setSelectOnClick(false);
			
		}

		private function captainAmericaUnlock():void {
			trace("ca unliock");
			
			this.captainAmerica.setSelected(false, false);
			//this.captainAmerica.setSelectOnClick(true);
		
			//add click listener
			this.visualDeck.addEventListener( MouseEvent.CLICK, deckClick );

			//remove listeners for klondike pile
			for each (var kPile:KlondikePile in this.klondikePiles) {
				kPile.removeEventListener(MouseEvent.MOUSE_DOWN, onCaptainAmericaPileClick, true);
			}
			
			//remove listeners for ace piles
			for each (var aPile:AcePile in this.acePiles) {
				aPile.removeEventListener(MouseEvent.MOUSE_DOWN, onCaptainAmericaPileClick, true);
			}
			
			this.dealtPile.removeEventListener(MouseEvent.MOUSE_DOWN, onCaptainAmericaPileClick, true);
		}
		
		private function wolverineLock():void {
			//this.wolverine.removeEventListener(ButtonEvent.SELECTED, onWolverineSelected);
			
			//remove the click listener for the deck
			this.visualDeck.removeEventListener( MouseEvent.CLICK, deckClick );
			this.visualDeck.addEventListener(MouseEvent.CLICK, onWolverineDeckClick);
			
			//add listeners for klondike piles
			for each (var kPile:KlondikePile in this.klondikePiles) {
				kPile.addEventListener(MouseEvent.MOUSE_DOWN, onWolverinePileClick, true);
			}
			
			//add listeners for ace piles
			for each (var aPile:AcePile in this.acePiles) {
				aPile.addEventListener(MouseEvent.MOUSE_DOWN, stopImmediatePropagation, true);
			}
			
			
		}
		
		private function wolverineUnlock():void {
			this.wolverine.setSelected(false, false);
			//this.wolverine.addEventListener(ButtonEvent.SELECTED, onWolverineSelected);
			
			//add click listener
			this.visualDeck.addEventListener( MouseEvent.CLICK, deckClick );
			this.visualDeck.removeEventListener(MouseEvent.CLICK, onWolverineDeckClick);
			
			//remove listeners for klondike pile
			for each (var kPile:KlondikePile in this.klondikePiles) {
				kPile.removeEventListener(MouseEvent.MOUSE_DOWN, onWolverinePileClick, true);
			}
			
			//remove listeners for ace piles
			for each (var aPile:AcePile in this.acePiles) {
				aPile.removeEventListener(MouseEvent.MOUSE_DOWN, stopImmediatePropagation, true);
			}
			
			
		}
		
		private function msMarvelLock():void {
			//remove the click listener for the deck
			this.visualDeck.removeEventListener( MouseEvent.CLICK, deckClick );
			
			//add listeners for klondike piles
			for each (var kPile:KlondikePile in this.klondikePiles) {
				kPile.addEventListener(MouseEvent.MOUSE_DOWN, onMsMarvelPileClick, true);
			}
			
			//add listeners for ace piles
			for each (var aPile:AcePile in this.acePiles) {
				aPile.addEventListener(MouseEvent.MOUSE_DOWN, stopImmediatePropagation, true);
			}
			
			//
		}
		
		private function msMarvelUnlock():void {
			this.msMarvel.setSelected(false, false);
			//add click listener
			this.visualDeck.addEventListener( MouseEvent.CLICK, deckClick );
			
			//remove listeners for klondike pile
			for each (var kPile:KlondikePile in this.klondikePiles) {
				kPile.removeEventListener(MouseEvent.MOUSE_DOWN, onMsMarvelPileClick, true);
			}
			
			//remove listeners for ace piles
			for each (var aPile:AcePile in this.acePiles) {
				aPile.removeEventListener(MouseEvent.MOUSE_DOWN, stopImmediatePropagation, true);
			}
			
		}
		
		private function stopImmediatePropagation(e:MouseEvent):void {
			//stop the event bubbling
			e.stopImmediatePropagation();
		}
		
		private function emptyKlondikePile():Boolean {
			var empty:Boolean = false;
			
			for each (var kPile:KlondikePile in this.klondikePiles) {
				if (kPile.isEmpty()) {
					empty = true;
				}
			}
			
			return empty;
		}
		
		private function onUndo(e:MouseEvent):void {
			if (this.history != null) {
				//trace("dfd");
				var gState:GameState = null;
				
				//pop the stack. the top is the current state
				gState = this.history.pop();
				//trace("popped id " + gState.getId());
				 
				//pop again. this is the state before
				gState = this.history[this.history.length - 1] as GameState;
				
				updateUndoButton();
				
				//trace("niow using id " + gState.getId());
				var cardPile:CardPile = null;
				var vc:VisualCard = null;
				var array:Array = null;
				
				//trace("game state " + gState);
				
				if (gState != null) {
					if (soundsEnabled()) {
						this.sounds.undo();
					}
					//trace("RESET SCORE TO " + gState.getScore());
					setScore(gState.getScore());
					this.deckCycles = gState.getDeckCycles();
					
					/*
					this.ironManLocation = gState.getIronManLocation();
					this.hulkLocation = gState.getHulkLocation();
					this.msMarvelLocation = gState.getMsMarvelLocation();
					this.wolverineLocation = gState.getWolverineLocation();
					this.drDoomLocation = gState.getDrDoomLocation();
					this.captainAmericaLocation = gState.getCaptainAmericaLocation();
					this.thorLocation = gState.getThorLocation();
					
					
					//remove bonus
					this.list.removeAll();
					*/
					
					//remove current stuff
					if (this.klondikePiles != null) {
						for each (cardPile in this.klondikePiles) {
							if (cardPile != null) {
						//		cardPile.removeEventListener(CardPile.ADD_CARD, onCardPileAdd);
								
								//remove drag listeners if face up
								for (var i:uint = 0; i < cardPile.numChildren; i++) {
									vc = cardPile.getChildAt(i) as VisualCard;
									
									if (vc != null && !vc.isDown) {
										configureDrag(vc, false);
									} 
								}
								
								//remove the card pile
								removeChild(cardPile);
							}
						}
					}
					
					if (this.acePiles != null) {
						for each (cardPile in this.acePiles) {
							if (cardPile != null) {
								removeChild(cardPile);
							}
						}
					}
					
					if (this.visualDeck != null) {
						//remove event listener
						setupListeners(false);
						
						//remove visual deck
						removeChild(this.visualDeck);
					}
					
					if (this.dealtPile != null) {
						//remove event listener
						//dealtPile.removeEventListener(CardPile.ADD_CARD, onCardPileAdd);
						
						vc = this.dealtPile.getTopCard();
						
						if (vc != null) {
							configureDrag(vc, false);
						}
						
						removeChild(this.dealtPile);
					}
					
					//set new visual deck
					this.visualDeck = gState.getVisualDeck().copy();
					
					//setup visual deck listeners
					setupListeners();
					
					addChild(this.visualDeck);
					
					//set new dealt pile
					this.dealtPile = gState.getDealtPile().copy();
					//this.dealtPile.addEventListener(CardPile.ADD_CARD, onCardPileAdd);
					
					//add drag listener to dealt pile
					vc = this.dealtPile.getTopCard();
					
					if (vc != null) {
						configureDrag(this.dealtPile.getTopCard());
					}
					
					for (var l:uint = 0; l < this.dealtPile.numChildren; l++) {
						vc = this.dealtPile.getChildAt(l) as VisualCard;
						if(vc!=null) {
							//trace("dealth pile from bottom " + vc.card.suit + " " + vc.card.value);
						}						
					}
					
					//add dealt pile
					addChild(this.dealtPile);
					
					//copy the ace piles
					var acePiles:Array = gState.getAcePiles();
					array = new Array();
					
					for each (var aPile:AcePile in acePiles) {
						if (aPile != null) {
							array.push(aPile.copy());
						}
					}
					
					//set the ace pile
					this.acePiles = array;
					
					//add the ace piles
					for each (cardPile in this.acePiles) {
						addChild(cardPile);
						updatePileState(cardPile);
					}
					
					//set klondike piles
					var kPiles:Array = gState.getKlondikePiles();
					array = new Array();
					for each (var kPile:KlondikePile in kPiles) {
						
						if (kPile != null) {
						//	kPile.addEventListener(CardPile.ADD_CARD, onCardPileAdd);
							array.push(kPile.copy());
						}
					}
					//set the klondike pile
					this.klondikePiles = array;
					
					//add each klondike pile
					for each (cardPile in this.klondikePiles) {
						//get top card
						//vc = cardPile.getTopCard();
						
						//if (vc != null) {
							//if top card is down
							//if (vc.isDown) {
								
							//}
						//}
						
						//remove drag listeners if face up
						for (i = 0; i < cardPile.numChildren; i++) {
							vc = cardPile.getChildAt(i) as VisualCard;
									
							//if face up configure drag
							if (vc != null && !vc.isDown) {
								configureDrag(vc, true);
							} 
						}
						
						addChild(cardPile);
						
						updatePileState(cardPile);
					}

					/*
					//get the bonus cards
					var bonusCards:Array = gState.getBonusCards();
					
					//reset bonus card counts
					this.wolverine.setCount(0);
					this.captainAmerica.setCount(0);
					this.hulk.setCount(0);
					this.msMarvel.setCount(0);
					this.ironMan.setCount(0);
					this.thor.setCount(0);
					this.drDoom.setCount(0);
					
					//for each bonus card
					for each (var bcs:BonusCardState in bonusCards) {
						var type:uint = bcs.getType();
						var bc:IBonusCard;
						
						switch(type) {
							case BonusCardState.CAPTAIN_AMERICA_TYPE:
								bc = this.captainAmerica;
								break;
							case BonusCardState.THOR_TYPE:
								bc = this.thor;
								break;
							case BonusCardState.HULK_TYPE:
								bc = this.hulk;
								break;
							case BonusCardState.IRON_MAN_TYPE:
								bc = this.ironMan;
								break;
							case BonusCardState.WOLVERINE_TYPE:
								bc = this.wolverine;
								break;
							case BonusCardState.MS_MARVEL_TYPE:
								bc = this.msMarvel;
								break;
							case BonusCardState.DR_DOOM_TYPE:
								bc = this.drDoom;
								break;
						}
						
						//if found
						if (bc != null) {
							//trace("on undo " + bcs.getCount());
							
							//set the count
							bc.setCount(bcs.getCount());
							
							//if not in the list
							if (!this.list.containsItem(bc)) {
								//add it
								this.list.addItem(bc);
							}
						}
					}
					*/
					this.cardDealer.setDealtPile(this.dealtPile);
					this.cardDealer.setDeck(this.visualDeck);

					handleAssets();
				}
			}
		}

		
		
		
		private function onCaptainAmericaClick(e:ButtonEvent):void {
			if (gameOverFlag) {
				this.captainAmerica.setSelected(false);
				return;	
			}
			
			if (emptyKlondikePile()) {		
				this.lastBonusCardClicked = this.captainAmerica;
			
				setupQuestion(DIET_CAT);
			}
			else {
				this.captainAmerica.helpBubble("MOVE TO BLANK","Cards can only be moved to an empty slot.");
				this.captainAmerica.setSelected(false);
			}
		}
		
		private function onCaptainAmericaPileClick(e:MouseEvent):void {

			e.stopImmediatePropagation();
			
			if (emptyKlondikePile()) {				
				trace("has empoty pile");
				var clickedPile:CardPile = e.currentTarget as CardPile;
	
				if (clickedPile is KlondikePile || clickedPile == this.dealtPile) {
					trace("clicked pile por");
					//if clicked is not empty pile			
					if (!clickedPile.isEmpty()) {
						trace("clicked pile not empty");
						var top:VisualCard = clickedPile.getTopCard();
						
						//find the first empty slot and add the card
						for each (var kPile:KlondikePile in this.klondikePiles) {
							if (kPile.isEmpty()) {
								this.captainAmerica.removeBubble();
								
								//lock captain america until animation is done
								this.captainAmerica.removeEventListener(ButtonEvent.SELECTED, onCaptainAmericaClick);
	
								//if dealt pile is clicked, remove it from the deck
								if (clickedPile == this.dealtPile) {
									this.visualDeck.deck.remove(top.card);
									this.visualDeck.updateSkin();
								}
								
								var start:Point = Position.getGlobal(top);
								start.x += top.width/2;
								start.y += top.height + 50;
								
							//	var end:Point = Position.getGlobal(kPile);
							//	end.x += kPile.width/2;
							//	end.y += kPile.height/2;
								
								if (this.train != null) {
									
									//find out if shield is 
									if (soundsEnabled()) {
										this.sounds.captainAmerica();
									}
								
									this.train.x = this.width;
									this.train.y = start.y;
									
									this.stage.addChild(this.train);
									
									//calculate time if moving 300px per second
									var pixDiff:Number = this.train.x - start.x;
									
									TweenLite.to(this.train, pixDiff/200, {ease:Linear.easeNone,x:start.x, onComplete: onCAShieldToStart, onCompleteParams: new Array(kPile,top)});
									
									this.captainAmerica.setSelectOnClick(false);
								}
	//end hack
								clearHistory();
								
								decreaseBonusCard(this.captainAmerica);
								break;
							}
						}
					}
					else {
						this.captainAmerica.helpBubble("MOVE TO BLANK","Cards can only be moved to an empty slot.");
					}
				}
				else {
					this.captainAmerica.helpBubble("MOVE TO BLANK","Cards can't be moved from here.");
				}
			}
			else {
				this.captainAmerica.helpBubble("MOVE TO BLANK","Cards can only be moved to an empty slot.");
			}
			
			//unlock
			captainAmericaUnlock();
		}
		
		private function clearHistory():void {
			this.history = new Array();
			updateUndoButton();
		}
		private function onCAShieldToStart(kPile:KlondikePile, cardToAdd:VisualCard):void {
			//show smoke
			this.train.puffSmoke();
			
			if (soundsEnabled()) {
				this.sounds.whistle();
			}
			//move card in arch
			var global:Point = cardToAdd.localToGlobal(new Point(0,0));
			var parentPile:CardPile = cardToAdd.parent as CardPile;
			
			if (parentPile != null) {
				var cp:CardPile = parentPile.removeCard(cardToAdd);
				//cardToAdd.parent.removeChild(cardToAdd);
				updatePileState(parentPile);
			}
			
			
			cp.x = global.x;
			cp.y = global.y
			this.stage.addChild(cp);
			//find distance and divide by quarters
			//var dist:Number = cardToAdd.x - kPile.x;
			//var bezierSection:Number = dist/4;
			
			
			//trace("bezeir tween " + cardToAdd.x + " " + (cardToAdd.x - bezierSection) + " " + (cardToAdd.x - (bezierSection * 2)) + " " + kPile.x)
			TweenMax.to(cp, 1.5, {onComplete:onTrainCardComplete, onCompleteParams:new Array(kPile,cp), bezier:[{x:cp.x, y:0}, {x:kPile.x, y:0}, {x:kPile.x, y:kPile.y}], ease:Linear.easeNone});
			
			//kPile.addEventListener(CardEvent.CARD_MOTION_COMPLETE, onCaptainAmericaCardComplete);
			//kPile.addEventListener(CardPile.ADD_CARD, onBonusCardAnimation);
			//kPile.addCardWithMotion(cardToAdd,0,0,.75);
			
			//move train to end
			var diff:Number = train.x - (this.train.width * -1);
			TweenLite.to(this.train, diff/200, {ease:Linear.easeNone,x:(this.train.width * -1), onComplete:onCAShieldEnd});
		}
	
		private function onTrainCardComplete(kPile:KlondikePile, cp:CardPile):void {
			kPile.addPile(cp);
			captainAmericaUnlock();
		}
		
		private function onCAShieldEnd():void {
			
			if (this.stage.contains(this.train)) {
				this.stage.removeChild(this.train);
			}
			this.captainAmerica.setSelectOnClick(true);
			this.captainAmerica.addEventListener(ButtonEvent.SELECTED, onCaptainAmericaClick);
		}
	
		
		private function onWolverineDeckClick(e:MouseEvent):void {
			this.wolverine.helpBubble("REVEAL CARDS", "Cards can't be revealed here.");
		}
		
		private function onWolverinePileClick(e:MouseEvent):void {
			
			var clickedKPile:KlondikePile = e.currentTarget as KlondikePile;

			if (clickedKPile != null && clickedKPile.hasFaceDownCards()) {			
				TweenLite.killDelayedCallsTo(removeWolverineScratch);
				//trace("wolve pile");
				//stop the event bubbling
				e.stopImmediatePropagation();
				
				wolverineUnlock();
				
				var top:VisualCard = clickedKPile.getTopCard();
				
				if (top != null) {
					//palce it top center it on the card pile
					var globalTop:Point = top.localToGlobal(new Point(0,0));
					
					this.wolverineScratch.x = globalTop.x
					this.wolverineScratch.y = globalTop.y;
				}
				
				if (!contains(this.wolverineScratch)) {
					addChild(this.wolverineScratch);
				}
				this.wolverine.setSelectOnClick(false);
				this.wolverineScratch.play();
				
				if (soundsEnabled()) {
					this.sounds.wolverine();
				}
				
				wolverineMoveCards(clickedKPile);
				//TweenLite.delayedCall(1, wolverineMoveCards, new Array(clickedKPile));
			}
			else {
				this.wolverine.helpBubble("REVEAL CARDS","Nothing to reveal.");
				this.wolverine.setSelected(false);
			}
		}
		
		private function shuffleMoveCards(clickedKPile:KlondikePile):void {
			
			var showList:Array = new Array();
			var showListPoints:Array = new Array();
			
			var lastY:Number;
			
			for (var i:int = clickedKPile.numChildren - 1; i >= 0 ; i--) {
				//trace("i is " + i);
				var vc:VisualCard = clickedKPile.getChildAt(i) as VisualCard;
				
				//if the card is down, add it to the list
				if (vc != null && vc.isDown) {
					//if not initialized
					if (isNaN(lastY)) {
						lastY = vc.y;
					}
					
					//move coordinates up
					lastY -= 50;
					
					//add to the list
					showList.push(vc);
					showListPoints.push(vc.y);
			
					//move the card up
					TweenLite.to(vc, .3, {y: lastY});
				}
			}	
			if(showList.length > 0) {
				TweenLite.delayedCall(.3, shuffleMoveCardsBack, new Array(showList, showListPoints, clickedKPile));
			}
		}
		
		private function wolverineMoveCards(clickedKPile:KlondikePile):void {
			
			var showList:Array = new Array();
			var showListPoints:Array = new Array();
			
			var lastY:Number;
			
			for (var i:int = clickedKPile.numChildren - 1; i >= 0 ; i--) {
				//trace("i is " + i);
				var vc:VisualCard = clickedKPile.getChildAt(i) as VisualCard;
				
				//if the card is down, add it to the list
				if (vc != null && vc.isDown) {
					//if not initialized
					if (isNaN(lastY)) {
						lastY = vc.y;
						
						//trace("set lastY to " + lastY);
					}
					
					//move coordinates up
					lastY -= 25;
					
					//add to the list
					showList.push(vc);
					showListPoints.push(vc.y);
					//trace("move to " + lastY);
					//move the card up
					TweenLite.to(vc, .5, {y: lastY});
					//vc.y = lastY;
					
					//show face up
					vc.isDown = false;
					
					//update skin
					vc.updateSkin();
					//trace("");
				}
			}	
			
			TweenLite.delayedCall(3, wolverineMoveCardsBack, new Array(showList, showListPoints, clickedKPile));
			TweenLite.delayedCall(3, removeWolverineScratch);
			
			decreaseBonusCard(this.wolverine);
		}
		
		private function removeWolverineScratch():void {
			if (contains(this.wolverineScratch)) {
				this.wolverineScratch.gotoAndStop(1);
				removeChild(this.wolverineScratch);
			}
			
			this.wolverine.setSelectOnClick(true);
		}
		private function shuffleMoveCardsBack(showList:Array, points:Array, clickedKPile:KlondikePile):void {
					//for each card in hte pile
			for (var i:int = 0; i < clickedKPile.numChildren; i++) {
				var vc:VisualCard = clickedKPile.getChildAt(i) as VisualCard;
				
				//if visual card not null
				if (vc != null) {
					//loop through the show list
					for (var j:int = 0; j < showList.length; j++) {
						var vc2:VisualCard = showList[j] as VisualCard;
						
						//if the same object
						if (vc2 != null && vc == vc2) {
							//move back
							TweenLite.to(vc, .5, {y: points[j], ease:Bounce.easeOut});
							
							//break this inner loop
							break;
						} 
					}
				}
			}
		}
		
		private function wolverineMoveCardsBack(showList:Array, points:Array, clickedKPile:KlondikePile):void {
			//trace("move vack");
			
			
			//for each card in hte pile
			for (var i:int = 0; i < clickedKPile.numChildren; i++) {
				var vc:VisualCard = clickedKPile.getChildAt(i) as VisualCard;
				
				//if visual card not null
				if (vc != null) {
					//loop through the show list
					for (var j:int = 0; j < showList.length; j++) {
						var vc2:VisualCard = showList[j] as VisualCard;
						
						//if the same object
						if (vc2 != null && vc == vc2) {
							//move back
							TweenLite.to(vc, .5, {y: points[j], onComplete: fixKlondikeFaceUp, onCompleteParams: new Array(clickedKPile, showList)});
							
							//break this inner loop
							break;
						} 
					}
				}
			}
		}
		
		/*
					for (var i:int = 0; i < clickedKPile.numChildren; i++) {
				var vc:VisualCard = clickedKPile.getChildAt(i) as VisualCard;
				
				//if visual card not null
				if (vc != null) {
					//loop through the show list
					for (var j:int = 0; j < showList.length; j++) {
						var vc2:VisualCard = showList[j] as VisualCard;
						
						//if the same object
						if (vc2 != null && vc == vc2) {
							//move back
							TweenLite.to(vc, .5, {y: points[j], onComplete: fixKlondikeFaceUp, onCompleteParams: new Array(clickedKPile, showList)});
							
							//break this inner loop
							break;
						} 
					}
				}
			}
			
			*/
		private function fixKlondikeFaceUp(clickedKPile:KlondikePile, showList:Array):void {
			if (clickedKPile != null) {
				for (var i:int = 0; i < clickedKPile.numChildren; i++) {
					var vc:VisualCard = clickedKPile.getChildAt(i) as VisualCard;
					
					//if visual card not null
					if (vc != null) {
						//loop through the show list
						for (var j:int = 0; j < showList.length; j++) {
							var vc2:VisualCard = showList[j] as VisualCard;
							
							//if the same object
							if (vc2 != null && vc == vc2) {
								//face down
								vc.isDown = true;
								vc.updateSkin();
							} 
						}
					}
				}
			}
			
			
		}
		
		private function onMsMarvelPileClick(e:MouseEvent):void {
			//trace("ms marvel pile click");
			//stop the event bubbling
			e.stopImmediatePropagation();
			
			//get the clicked pile
			var clickedKPile:KlondikePile = e.currentTarget as KlondikePile;
			
			var nextCard:VisualCard = null;
			var vc:VisualCard = null;
			//var position:Point = null;
			//for all klondike piles except the chosen one
			//for each (var kPile:KlondikePile in this.klondikePiles) {
			for (var i:uint = 0; i < this.klondikePiles.length; i++) {
				var kPile:KlondikePile = this.klondikePiles[i];
				
				//if this is not the clicked pile and noting found yet
				//if (kPile != clickedKPile && nextCard == null) {
				
				//if nothing found yet
				if (nextCard == null) {
					//for each card in this Klondike Pile
					for (var j:uint = 0; j < kPile.numChildren; j++) {
						vc = kPile.getChildAt(j) as VisualCard;
						
						//if its face down and it can be added to the chosen pile
						if (vc != null && vc.isDown && clickedKPile.canAddCard(vc.card)) {
							//trace("match card is " + vc.card.suit + " : " + vc.card.value);
							
							//set the next card
							nextCard = vc;
							
							//position = Position.getGlobal(nextCard);
							
							//remove it from the pile
							removeCard(j, kPile);
							
							break;
						}
					}
				}
			}
			
			//if not in the pile look in the deck
			if (nextCard == null) {
				//reset 
				this.cardDealer.reset();
				
				//for each card in the deck
				for each (var card:Card in this.visualDeck.deck.cards) {
					vc = new VisualCard(card);
					//if its can be added to the clicked pile
					if (clickedKPile.canAddCard(vc.card)) {
						//set the next card
						nextCard = vc;
						
						//position = Position.getGlobal(nextCard);
							
						//trace("found in deck " + card.suit + " " + card.value);
						this.visualDeck.deck.remove(card);
						this.visualDeck.updateSkin();
						break;
					}
				}
			}
			
			
			if (nextCard != null) {
				this.msMarvel.removeBubble();
				
				nextCard.isDown = false;
				//next card is floating now so set global coords
				//nextCard.x = position.x;
				//nextCard.y = position.y;
				
				
				
				//lockl
				this.msMarvel.removeEventListener(ButtonEvent.SELECTED, onMsMarvelClick);
				
				clickedKPile.addEventListener(CardPile.ADD_CARD, onBonusCardAnimation);
				
				//var clickedKPileGlobalPosition:Point = Position.getGlobal(clickedKPile);
				//var nextCardLocalPosition:Point = ;
				
				//get the global coords of the animation
				var animationPosition:Point = clickedKPile.localToGlobal(clickedKPile.getNextCardLocation());
				//var nextCardGlobalPosition:Point = clickedKPileGlobalPosition.add(nextCardLocalPosition);
				
				//clickedKPile.addCard(nextCard);
				
				clearHistory();
				decreaseBonusCard(this.msMarvel);
				
				this.sash.x = animationPosition.x;
				this.sash.y = animationPosition.y;
				
				this.msMarvel.setSelectOnClick(false);
				
				//
				if (soundsEnabled()) {
					this.sounds.msMarvel();
				}
								
				TweenLite.delayedCall(1.25, fadeSash, new Array(clickedKPile, nextCard));
				this.sash.alpha = 1;
				addChild(this.sash);
				this.sash.play();
			}
			else {
				this.msMarvel.helpBubble("FIND NEXT", "The next card isn't available.");
			}
			
			msMarvelUnlock();
			
		}
		
		protected function getRandomEdgePoint(dObject:DisplayObject):Point {
			var tob:uint = Math.random() * 4;
			var x:Number;
			var y:Number;
			
			//if greater than 1 its going to be on top or bottom
			if (tob > 2) {
				
				//if greater than one its top
				if (tob > 3) {
					y = - dObject.height;
				}
				else {
					y = this.stage.height + dObject.height;
				}
				
				x = this.width * Math.random();
			}
			//its going to be one of the sides
			else {
				if (tob > 1) {
					x = this.stage.width + dObject.width;	
				}
				else {
					x = -dObject.width;	
				}
				
				y = this.height * Math.random();
			}
			
			return new Point(x,y);
		}
		
		private function fadeSash(clickedKPile:KlondikePile, nextCard:VisualCard):void {
			configureDrag(nextCard);
			clickedKPile.addCard(nextCard);
			TweenLite.to(this.sash, 1, {alpha: 0, onComplete:removeSash});
		}
		private function removeSash():void {
			if (contains(this.sash)) {
				removeChild(this.sash);
			}
			this.msMarvel.setSelectOnClick(true);
		}
		private function hulkLock():void {
			
			//this.hulk.removeEventListener(ButtonEvent.SELECTED, onHulkClick);
			
			//reroute the click listener for the deck
			this.visualDeck.removeEventListener( MouseEvent.CLICK, deckClick );
			this.visualDeck.addEventListener( MouseEvent.CLICK, onHulkDeckClick );
			
			for each (var kPile:KlondikePile in this.klondikePiles) {
				kPile.addEventListener(MouseEvent.MOUSE_DOWN, onHulkKlondikePileClick, true);
			}
			
			//add listeners for ace piles
			for each (var aPile:AcePile in this.acePiles) {
				aPile.addEventListener(MouseEvent.MOUSE_DOWN, stopImmediatePropagation, true);
			}
			
			this.undo.enabled = false;
		}
		
		private function hulkUnlock():void {
			this.hulk.setSelected(false, false);
			//trace("ADDING HULK CLICKL");
			//this.hulk.addEventListener(ButtonEvent.SELECTED, onHulkClick);


			//reroute the click listener for the deck
			this.visualDeck.removeEventListener( MouseEvent.CLICK, onHulkDeckClick );
			this.visualDeck.addEventListener( MouseEvent.CLICK, deckClick );
			
			for each (var kPile:KlondikePile in this.klondikePiles) {
				kPile.removeEventListener(MouseEvent.MOUSE_DOWN, onHulkKlondikePileClick, true);
			}
			
			//add listeners for ace piles
			for each (var aPile:AcePile in this.acePiles) {
				aPile.removeEventListener(MouseEvent.MOUSE_DOWN, stopImmediatePropagation, true);
			}
			
			this.undo.enabled = true;
		}
		
		private function removeHulkStomp():void {

			if (contains(this.hulkStomp)) {
				removeChild(this.hulkStomp);
			}
			hulkUnlock();
			this.hulk.setSelectOnClick(true);
		}
		private function onHulkKlondikePileClick(e:MouseEvent):void {
			var kPile:KlondikePile = e.currentTarget as KlondikePile;
			trace("hulk " + kPile.hasFaceDownCards());
			if (kPile != null && kPile.hasFaceDownCards()) {
				TweenLite.killDelayedCallsTo(removeHulkStomp);
				
				//stop propagation of events
				e.stopImmediatePropagation();
				
				decreaseBonusCard(this.hulk);
				
				//shuffle the face down cards
				
				var top:VisualCard = kPile.getTopCard();
				
				if (top != null) {
					
					if (this.hulkStomp != null) {
						var global:Point = Position.getGlobal(top);
						this.hulkStomp.x = global.x + top.width/2;
						this.hulkStomp.y = global.y;
						
						if (soundsEnabled()) {
							this.sounds.hulk();
						}
			
			
					//trace("ADD HULK STOMP ++++++++++++++++++++++++++++++++++++++++++++++++");
						if (!contains(this.hulkStomp)) {
							addChild(this.hulkStomp);
						}
						this.hulkStomp.play();
						this.hulk.setSelectOnClick(false);
						TweenLite.delayedCall(.5, shuffleMoveCards,new Array(kPile));
						TweenLite.delayedCall(1.5, removeHulkStomp);
					}
					
				}
				
				//trace("hulk shuffled face down tableous");
				
				//save the current state of the cards in this pile
				var downCards:Array = new Array();
				var upCards:Array = new Array();
				
				//remove cards from pile and store in arrays
				while (kPile.numChildren > 0) {
					
					var vc:VisualCard = kPile.removeChildAt(0) as VisualCard;
					
					if (vc.isDown) {
						//trace("OG down card is " + vc.card.suit + ":" + vc.card.value);
						downCards.push(vc);
					}
					else {
						upCards.push(vc);
					}
				}
				
				//for all down cards
				while (downCards.length > 0) {
					//pick out a random index from the face down cards 
					var randomIndex:int = Math.floor( Math.random() * downCards.length );
					
					//get the random card, removing it from the array
					var randomCard:VisualCard = downCards.splice(randomIndex, 1)[0];
					
					//add it to the pile
					kPile.addCard(randomCard);
				}
				
				//now add back all the up cards in the original order
				for each (var upCard:VisualCard in upCards) {
					kPile.addCard(upCard);
				}
				
				clearHistory();
			}
			else {
				this.hulk.helpBubble("SHUFFLE", "No hidden cards here.");
			}
			hulkUnlock();
		}
		
		private function onHulkDeckClick(e:MouseEvent):void {
			e.stopImmediatePropagation();
			if (!this.visualDeck.isEmpty()) {
				//reset the stuff
				this.cardDealer.reset();

				//shuffle the deck
				this.visualDeck.shuffle();
				
				var global:Point = Position.getGlobal(this.visualDeck);
				if (this.hulkStomp != null) {
					this.hulkStomp.x = global.x + this.visualDeck.width/2;
					this.hulkStomp.y = global.y;
	
					addChild(this.hulkStomp);
					
					if (soundsEnabled()) {
						this.sounds.hulk();
					}
			
			
					this.hulkStomp.play();
					this.hulk.setSelectOnClick(false);
					TweenLite.delayedCall(1.5, removeHulkStomp);
				}
				clearHistory();
				//trace("hulk shuffled deck");
				decreaseBonusCard(this.hulk);
				
				
			}
			else {
				this.hulk.helpBubble("SHUFFLE","Deck is empty.");
			}
		}

		private function getState():GameState {
			//create state object
			var gameState:GameState = new GameState();
				
			this.historyId++;
			
			gameState.setId(this.historyId);
			gameState.setScore(this.score);
			gameState.setDeckCycles(this.deckCycles);
			
			//save the locations of the bonus cards
			/*
			gameState.setIronManLocation(this.ironManLocation);
			gameState.setThorLocation(this.thorLocation);
			gameState.setCaptainAmericaLocation(this.captainAmericaLocation);
			gameState.setDrDoomLocation(this.drDoomLocation);
			gameState.setWolverineLocation(this.wolverineLocation);
			gameState.setMsMarvelLocation(this.msMarvelLocation);
			gameState.setHulkLocation(this.hulkLocation);
			*/
			//save the bonus cards
			var items:Array = this.list.getItems();
			
			/*
			var bonusCards:Array = new Array();
			
			//for each card in the list
			for each (var bc:BonusCard in items) {
				var bcs:BonusCardState = new BonusCardState();
				
				//save its state
				if (bc == this.ironMan) {
					bcs.setType(BonusCardState.IRON_MAN_TYPE);
				}
				else if (bc == this.thor) {
					bcs.setType(BonusCardState.THOR_TYPE);
				}
				else if (bc == this.captainAmerica) {
					bcs.setType(BonusCardState.CAPTAIN_AMERICA_TYPE);
				}
				else if (bc == this.wolverine) {
					bcs.setType(BonusCardState.WOLVERINE_TYPE);
				}
				else if (bc == this.drDoom) {
					bcs.setType(BonusCardState.DR_DOOM_TYPE);
				}
				else if (bc == this.msMarvel) {
					bcs.setType(BonusCardState.MS_MARVEL_TYPE);
				}
				else if (bc == this.hulk) {
					bcs.setType(BonusCardState.HULK_TYPE);
				}
				
				bcs.setCount(bc.getCount());
				
				//trace("save state array is " + bc);

				//add to the array
				bonusCards.push(bcs);
			}
			
			//save the bonus card state in the game state
			gameState.setBonusCards(bonusCards);
			*/
			//trace("+++++++++++++++++++++ SAVE ID +++++++++++++++++++++++++++" + gameState.getId());
			
			var vc:VisualCard = null;
			
			//make a new array
			var array:Array = new Array();
			
			//for each current klondike pile
			for each (var kPile:KlondikePile in this.klondikePiles) {
				if (kPile != null) {
					//add the new kpile copy to the array
					array.push(kPile.copy());
				}
			}

			//set klondike piles
			gameState.setKlondikePiles(array);
			
			//make a new array
			array = new Array();
			
			//for each current ace pile
			for each (var aPile:AcePile in this.acePiles) {
				if (aPile != null) {
					//add the apile copy
					array.push(aPile.copy());
				}
			}

			//set ace piles
			gameState.setAcePiles(array);
		
			//make and set new dealt pile
			var newDealtPile:CardPile = this.dealtPile.copy();
			gameState.setDealtPile(newDealtPile);
			
			//make a new visual deck
			var vd:VisualDeck = this.visualDeck.copy();
			gameState.setVisualDeck(vd);
			
			return gameState;
		}
		
		
		
		////new////////////////////////////////////////////////////////////////////new/////////////
		
		private function onStartGame(e:MouseEvent):void {
			
			this.server.newGame("Trivia Challenge");
		}
				
		private function onNewGame(e:Event):void {
			//get the questions
			//this.server.queryQuestions();
			dealCards();
		}
		
		private function onRegister(e:Event):void {
			this.loginDialog.removeSignUp();
			//this.loginDialog.removeDialog();
			
			this.loginDialog.setStatus("Your account has been created. Please log in");
		}
		
		private function onRegisterFail(e:AbstractDataEvent):void {
			this.loginDialog.setRegisterStatus(e.getString());
		}
		private function onLoggedInFail(e:Event):void {
			this.loginDialog.setStatus("Login error");
		}
		
		private function onLoggedIn(e:Event):void {
			this.loginDialog.removeDialog();
			//this.terms.showDialog(0,0);
			this.server.queryTermsOfService();
		}
		
		private function onLogin(e:MouseEvent):void {
			 this.server.login(this.loginDialog.getUsername(), this.loginDialog.getPassword());
		}

		private function onTerms(e:DialogEvent):void {
			this.startGameButton.enabled = true;
			
			trace("ON TERMS");
			if (!this.doubleDialog.hasBeenShown()) {
				this.doubleDialog.showDialog();
			}
			
		}
		
		private function onReceivedQuestion(e:Event):void {
			var q:Question = this.server.getQuestionsCategory().getQuestion();
			this.questionDialog.setCategory(this.server.getQuestionsCategory().getTitle());
			this.questionDialog.setQuestion(q);
			
			this.questionDialog.showLoading(true);
			this.questionDialog.showDialog(0,0);
			
			var answers:Array = q.getAnswers();
			//dl the sounds
			
			var qURL:URLRequest = new URLRequest(SOUNDS_URL + q.getId() + "q.mp3");
			var a1URL:URLRequest = new URLRequest(SOUNDS_URL + (answers[0] as AnswerChoice).getId() + "a.mp3");
                        var a2URL:URLRequest = new URLRequest(SOUNDS_URL + (answers[1] as AnswerChoice).getId() + "a.mp3");
                        var a3URL:URLRequest = new URLRequest(SOUNDS_URL + (answers[2] as AnswerChoice).getId() + "a.mp3");
                        
                        if (this.questionSound != null) {
                        	this.questionSound.removeEventListener(Event.COMPLETE,questionSoundReady);
                        }
						this.questionSound = new Sound();
                        this.questionSound.addEventListener(Event.COMPLETE,questionSoundReady);
                        this.answer1Sound = new Sound();
                        this.answer2Sound = new Sound();
                        this.answer3Sound = new Sound();
                        
                        this.questionSound.load(qURL);
                        
                        this.answer1Sound.load(a1URL);
                        this.answer2Sound.load(a2URL);
                        this.answer3Sound.load(a3URL);
		}

		private function onReceivedTOS(e:Event):void {
			this.terms.setTOS(this.server.getTermsOfService());
			this.terms.showDialog(0,0);
		}

		private function onSendSignUp(e:Event):void {
			this.server.registerUser(this.loginDialog.getRegisterUsername(), this.loginDialog.getRegisterPass(), this.loginDialog.getRegisterGender());
		}
	}
}