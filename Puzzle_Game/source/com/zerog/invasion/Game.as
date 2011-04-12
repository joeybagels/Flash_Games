/***************************************************************

	Copyright 2008, Zero G Games Limited.
	
	Redistribution of part or whole of this file and
	the accompanying files is strictly prohibited.
	
	Redistribution of modified versions of this file and
	the accompaying files is also strictly prohibited.
	
****************************************************************/
	
	
	
package com.zerog.invasion {
	import flash.text.TextField;
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.*;
	
	import com.zerog.*;
	import com.zerog.components.dialogs.AbstractDialog;	

	public class Game extends com.zerog.Game {
		private var __level:int;
		private var __score:int;
		
		private var levelTime:int;
		
		private var dimensionX:int, dimensionY:int;
		
		private var backgrounds:Array;
		private var gems:Array;
		
		private var selectedX:int, selectedY:int;
		
		private var swappingGems:Array;
		
		private var combo:int;
		private var destroyingGems:Array;
		
		private var fallingGems:Array;
		
		private var startNoMoreMovesTime:int;
		
		private var startTime:int;
		private var startGemsTime:int;
		
		private var timer:Timer;
		private var gemsTimer:Timer;

		private var soundGroup:Sound;
		private var soundClick:Sound;
		private var soundSwap:Sound;
		private var soundLevelClear:Sound;
		private var soundGameOver:Sound;

		private var specialTileData:Object;
		
		private var gemOverTimer:Timer;
		private var curGemOver:Array;
		private var gemOverDir:int;
		
		private var levelMatchesRequired:int;
		private var nLevelColorsMax:int;
		private var nLevelBlockFreq:Number;
		private var nLevelSpecialMax;int;
		private var aLevelSpecialFreq:Array;
		private var nLevelSpecialFreq:Number;
		private var nMatches:int;
		
		private var aGemsToFlipAnim:Array;
		
		public var particleFactory:ParticleFactory;
		private var options:OptionsMenu;
		
		private var nTrackLevelStartTime:int;
		
		private var currentGroups:Array;
		private var bGroupsValid:Boolean;
	
		public var mcParent:MovieClip;
		
		private var bFinalPlaying:Boolean;
		private var bBeamFinalDone:Boolean;
		private var bMotherShipFinalDone:Boolean;
		private var heroesPage:HeroesPage;
		
		private var nLastGemOverDir:int;
		private var nWin_Level:Number;
		private var nWin_Hero:Number;
		
		private var nCurNumSpec:int;
		private var nCurNumBlock:int;
		private var nMaxNumSpec:int;
		private var nMaxNumBlock:int;
		private var nSpecUsed:int;
		private var nSpecDestroyed:int;
		
		private var nHarnessWaitState:uint;
		private var HARNESS_STATE_PRE:uint = 0;
		private var HARNESS_STATE_WAIT:uint = 1;
		private var HARNESS_STATE_DONE:uint = 2;
		private var HARNESS_STATE_OFF:uint = 3;
		
		private var nHintsUsed:int;
		
		private var nEndGameWait:int;
		
		function Game(tParent:MovieClip) {
			//SoundManager.getInstance().play(SoundManager.ROLLOVER);
			level = 1;
			score = 0;
			nHintsUsed = 0;
			
			this.tabEnabled = false;
			this.tabChildren = false;
			
			mcParent = tParent;
			highlight.visible = false;
			/*
			soundGroup = new SoundGroup();
			soundClick = new SoundClick();
			soundSwap = new SoundSwap();
			soundLevelClear = new SoundLevelClear();
			soundGameOver = new SoundGameOver();
			*/
			particleFactory = new ParticleFactory(this);
			
			curGemOver = [-1, -1];
			
			nHarnessWaitState = HARNESS_STATE_DONE;
			
			startLevel(1);
			
			//trace("START NEW GAME" + bottomBar)
			//Z DEBUG
			//startLevel(14);
			
			options = new OptionsMenu();
			//options.addEventListener(OptionsMenu.SOUND_OFF, onSoundOff);
			//options.addEventListener(OptionsMenu.SOUND_ON, onSoundOn);
			options.addEventListener(OptionsMenu.OK_EVENT, onOptionsOk);
			options.addEventListener(OptionsMenu.TUTORIAL_ON, onTutorialOn);
			options.addEventListener(OptionsMenu.TUTORIAL_OFF, onTutorialOff);
			options.setParent(this);
			//var sm:SoundManager = SoundManager.getInstance();
			
			var mySo:SharedObject = SharedObject.getLocal(Main.MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME);
			if (mySo.data.sounds == undefined || mySo.data.sounds == true) {
				//trace("SET SOUNDS TRUE")
				options.selectSounds(true);
				
			//	sm.setIsSound(true);
			//	sm.play(SoundManager.GAME_MUSIC);
			}
			else {
				//trace("SET SOUNDS FAKSE")
				options.selectSounds(false);
				
			//	sm.setIsSound(false);
			}
			
			if (mySo.data.music == undefined || mySo.data.music == true) {
				//trace("SET SOUNDS TRUE")
				options.selectMusic(true);
				
			//	sm.setIsSound(true);
			//	sm.play(SoundManager.GAME_MUSIC);
			}
			else {
				//trace("SET SOUNDS FAKSE")
				options.selectMusic(false);
				
			//	sm.setIsSound(false);
			}
			
			if (mySo.data.tutorial == undefined || mySo.data.tutorial == true) {
				options.selectTutorial(true);
				//tutorial.bActive = true;
				tutorial.bShowHelp = true;
				
				trace("SET TUT TRUE")
			}
			else {
				options.selectTutorial(false);
				//tutorial.bActive = false;
				tutorial.bShowHelp = false;
				
				trace("SET TUT falsE")
			}
		
			
			//bottomBar.play();
			bottomBar.options.addEventListener(MouseEvent.CLICK, onOptions);
			bottomBar.howToPlay.addEventListener(MouseEvent.CLICK, onHowToPlay);
			//bottomBar.startGame.addEventListener(MouseEvent.CLICK, onStartGame);
			bottomBar.quit.addEventListener(MouseEvent.CLICK, onQuit);
			bottomBar.moreGames.addEventListener(MouseEvent.CLICK, onMoreGames);
			bottomBar.heroes.addEventListener(MouseEvent.CLICK, onHeroes);
			
			//addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			bGroupsValid = false;
			
			heroesPage = new HeroesPage();
			//heroesPage.setParent(empty);
			heroesPage.setParent(this);
			
			//SoundManager.getInstance().play(SoundManager.GAME_MUSIC);
			//SoundManager.getInstance().setIsSound(true);
			
			creditsButton.addEventListener(MouseEvent.CLICK, onCredits)
			
			marvelkids.addEventListener(MouseEvent.CLICK, onMKClick);
		}
		
		public function prepareQuit():void {
			trace("prepareQuit()");
			particleFactory.clearGenerators();
			timeDisplay.shutdown();
			if (options) {
				options.removeEventListener(OptionsMenu.TUTORIAL_ON, onTutorialOn);
				options.removeEventListener(OptionsMenu.TUTORIAL_OFF, onTutorialOff);
				options.removeEventListener(OptionsMenu.OK_EVENT, onOptionsOk);
			}
			//bottomBar.startGame.addEventListener(MouseEvent.CLICK, onStartGame);
			if (bottomBar) {
				if (bottomBar.options) {
					bottomBar.options.removeEventListener(MouseEvent.CLICK, onOptions);
				}
				if (bottomBar.howToPlay) {
					bottomBar.howToPlay.removeEventListener(MouseEvent.CLICK, onHowToPlay);
				}
				if (bottomBar.quit) {
					bottomBar.quit.removeEventListener(MouseEvent.CLICK, onQuit);
				}
				if (bottomBar.moreGames) {
					bottomBar.moreGames.removeEventListener(MouseEvent.CLICK, onMoreGames);
				}
				if (bottomBar.heroes) {
					bottomBar.heroes.removeEventListener(MouseEvent.CLICK, onHeroes);
				}
			}
			if (creditsButton) {
				creditsButton.removeEventListener(MouseEvent.CLICK, onCredits)
			}
			if (gemOverTimer) {
				gemOverTimer.removeEventListener(TimerEvent.TIMER, onGemOverTime);
			}
			if (clickDetector) {
				clickDetector.removeEventListener(MouseEvent.MOUSE_DOWN, onGemMouseDown);
				clickDetector.removeEventListener(MouseEvent.MOUSE_UP, onGemMouseUp);
			}
			if (hintButton) {
				hintButton.removeEventListener(MouseEvent.CLICK, onHintClick);
			}
			if (marvelkids) {
				marvelkids.removeEventListener(MouseEvent.CLICK, onMKClick);
			}
			//credits
			//how to play
			if (timer) {
				timer.removeEventListener(TimerEvent.TIMER, preGeneratePause);
				timer.stop();
			}
		}

		
		private function onMKClick(event:MouseEvent):void {
			Object(mcParent).trackLinkOutEvent("marvelLogo");
			var request:URLRequest = new URLRequest("http://marvelkids.marvel.com");
			try {
				navigateToURL(request, '_blank'); 
			}
			catch (e:Error) {
			}                 
		}
		
		private function onCredits(event:MouseEvent):void {
			Object(mcParent).trackMenuEvent("credits");
			var c:CreditsPage = new CreditsPage()
			c.setParent(this);
			c.addEventListener(MouseEvent.CLICK, onCloseCredits);
			c.showDialog();
		}
		
		private function onCloseCredits(event:MouseEvent):void {
			event.target.removeDialog();
		}
		public function playSound(sound:uint):void {
			SoundManager.getInstance().play(sound);
		}
		public function stopSound(sound:uint):void {
			SoundManager.getInstance().stopSound(sound);
		}
		
		/*
		private function onAddedToStage(e:Event):void {
			tracker = new GATracker(this.stage, "UA-273913-11", "AS3", false);
		}
		*/
		private function onHowToPlay(e:Event):void {
			Object(mcParent).trackMenuEvent("instructions");
			
			var h:HowToPlay = new HowToPlay();
			h.setParent(empty);
			h.showDialog(0,0);
			h.closeButton.addEventListener(MouseEvent.CLICK, onCloseHowToPlay);
		}
		private function onCloseHowToPlay(event:MouseEvent):void {
			event.target.parent.removeDialog();
		}
	//	private function onStartGame(e:Event):void {
		//}
		private function onQuit(e:Event):void {
			
		}
		
		private function onMoreGames(e:Event):void {
			//this.tracker.trackEvent(MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME, "linkOut", "moreGames");
			
			var request:URLRequest = new URLRequest("http://marvelkids.marvel.com/games");
			try {
  				navigateToURL(request, '_blank'); 
			}
			catch (e:Error) {
			}	
			
			Object(mcParent).trackLinkOutEvent("moreGames");
			
			//tracker.trackEvent(MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME, "linkOut", "moreGames");
		}
		
		//private function onHeroes(e:Event):void {
		//	Object(mcParent).trackMenuEvent("characters");
			//example, to be used when players view individual hero pages
			//pass in the capitalized string of the hero name to be used in the tracker url
		//	Object(mcParent).trackHeroPageView("Wolverine");
			
		//}
		
		
		
		private function onTutorialOn(e:Event):void {
			tutorial.bShowHelp = true;
		}
		private function onTutorialOff(e:Event):void {
			tutorial.bShowHelp = false;
			tutorial.tutorialDone();
		}
		private function onOptionsOk(e:Event):void {
			var mySo:SharedObject = SharedObject.getLocal(Main.MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME);
			if(mySo.data.sounds != undefined) {
				
				SoundManager.getInstance().setIsSound(mySo.data.sounds);

				Object(mcParent).trackSoundEvent(mySo.data.sounds);
			}
			
			if (mySo.data.music == true) {
				SoundManager.getInstance().play(SoundManager.GAME_MUSIC);
				Object(mcParent).trackMusicEvent(mySo.data.music);
			}
			else {
				SoundManager.getInstance().stopSound(SoundManager.GAME_MUSIC);
				Object(mcParent).trackMusicEvent(mySo.data.music);
			}
		}
		/*
		private function onSoundOn(e:Event):void {
			//
			Object(mcParent).trackSoundEvent(true);
			trace("sound on");
		}

		private function onSoundOff(e:Event):void {
			//SoundManager.getInstance().setIsSound(false);
			Object(mcParent).trackSoundEvent(false);
			trace("sound off");
		}*/

		override public function get width():Number {
			return 760;
		}
		override public function get height():Number {
			return 600;
		}
		private function onHeroes(e:MouseEvent):void {
			Object(mcParent).trackMenuEvent("characters");
			heroesPage.setParent(this);
			heroesPage.showDialog(0,0);
		}
		
		private function onOptions(e:MouseEvent):void {
			Object(mcParent).trackMenuEvent("otherMenuItem");
			options.showDialog();
		}
		public function set matches(t:int):void {
			nMatches = t;
			//matchesText.text = nMatches.toString();
			matchesText.text = nMatches.toString() + " / " + levelMatchesRequired;
		}
		
		public function get matches():int {
			return nMatches;
		}
		
		public function set level(level:int):void {
			__level = level;
			levelText.text = level.toString();
		}
		
		public function get level():int {
			return __level;
		}
		
		public function getHighScore():int {
			var mySo:SharedObject = SharedObject.getLocal(Main.MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME);
			if (mySo.data.highScore == undefined) {
				return 0;
			} else {
				return int(mySo.data.highScore);
			}
		}
		public function set score(score:int):void {
			//Z:  We should not be doing this here, set score is called all throughout the game, we're probably doing this once each match.
			//get the high score
			var mySo:SharedObject = SharedObject.getLocal(Main.MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME);
			
			//if high score is less than score
			if (mySo.data.highScore == undefined || mySo.data.highScore < score) {
				//set the score
				mySo.data.highScore = score;
				mySo.flush();
			}
			
			__score = score;
			scoreText.text = score.toString();
		}
		
		public function get score():int {
			return __score;
		}
		
		
		
		
		
		public function generateParticleEffect(config:Object, useRandomColor:Boolean = false):void {
			if (useRandomColor) {
				config.useRandomColor = true;
			}
			generateParticle(config);
		}
		
		public function generateParticle(config:Object):void {
			particleFactory.generateParticle(config);
		}
		
		public function particleGravityReached():void {
			timeDisplay.playGemPowerAnim();
		}
		
		public function tutorialClear():void {
			particleFactory.clearGenerators();
		}
		
		public function tutorialGemEffectDestroy():void {
			//generateParticle({layer:Object(parent).heroOverLayer, num:4, pace:40, x:this.x, y:this.y});
			//generateParticle({layer:Object(parent).heroOverLayer, num:4, pace:40, x:this.x, y:this.y},false,true);
			//currentGroups.length-1
			//trace("currentGroups.length=" + currentGroups.length);
			//var tConfig:Object = {layer:this.heroOverLayer, num:40, pace:40, gravity:0, minSpeedX:0, maxSpeedX:0, minSpeedY:0, maxSpeedY:0, useTypeColor:true};
			//var tConfig:Object = {layer:this.heroOverLayer, num:40, pace:40, gravity:0, useTypeColor:true};
			//var tConfig:Object = {layer:this.heroOverLayer, num:200, pace:10, gravity:0, useTypeColor:true};
			//trace("tutorialGemEffectDestroy");
			//for (var x:int = currentGroups[currentGroups.length-1].length-1; x < currentGroups[currentGroups.length-1].length; x++) {
			for (var x:int = currentGroups[0].length-1; x < currentGroups[0].length; x++) {
				//for (var y:int = 0; y < currentGroups[currentGroups.length-1][x].length; y++) {
				for (var y:int = 0; y < currentGroups[0][x].length; y++) {
					var tConfig:Object = {layer:this.heroOverLayer, num:200, pace:10, gravity:0, minSpeedX:-2, maxSpeedX:2, minSpeedY:-2, maxSpeedY:2, useTypeColor:true};
					//tConfig.typeColor = currentGroups[currentGroups.length-1][x][y].type;
					tConfig.typeColor = currentGroups[0][x][y].type;
					//tConfig.x = gemsHolder.x+currentGroups[currentGroups.length-1][x][y].x;
					tConfig.x = gemsHolder.x+currentGroups[0][x][y].x;
					//tConfig.y = gemsHolder.y+currentGroups[currentGroups.length-1][x][y].y;
					tConfig.y = gemsHolder.y+currentGroups[0][x][y].y;
					//trace("color=" + tConfig.typeColor + ", pos=" + tConfig.x + "," + tConfig.y);
					generateParticle(tConfig);
					//generateParticleEffect(tConfig, true);
				}
			}
			
		}
		
		public function tutorialGemEffectSpecial():void {
			
		}
		
		
		private function startLevel(level:int):void {
			//trace("startLevel = mcParent=" + mcParent);
			Object(mcParent).trackLevelView(level);
			
			this.level = level;
			
			levelTime = Config.LEVEL_INITIALTIME - (level - 1) * Config.LEVEL_TIMEDECREASE;
			
			levelMatchesRequired = Config.LEVEL_MATCHES_REQ_BASE + ((level-1) * Config.LEVEL_MATCHES_REQ_MULT);
			//nLevelColorsMax = 4;
			nLevelColorsMax = Math.min(Config.LEVEL_COLORS_BASE + (level-1), Config.GEMS_TYPES);
			/*
			nLevelBlockFreq = (level-1) * Config.LEVEL_BLOCK_FREQ;
			//nLevelBlockFreq = (1) * Config.LEVEL_BLOCK_FREQ;
			*/
			nLevelSpecialMax = Math.min(Config.BLOCK_TYPES - 2 + level, Config.POWERUP_TYPES);
			/*
			aLevelSpecialFreq = [(level-1) * Config.SPEC_FREQ_1, (level-2) * Config.SPEC_FREQ_2, (level-3) * Config.SPEC_FREQ_3, (level-4) * Config.SPEC_FREQ_4, (level-5) * Config.SPEC_FREQ_5, (level-6) * Config.SPEC_FREQ_6, (level-7) * Config.SPEC_FREQ_7, (level-8) * Config.SPEC_FREQ_8, (level-9) * Config.SPEC_FREQ_9];
			*/
			//trace("Level " + level + ", matches_req=" + levelMatchesRequired + ", colorMax=" + nLevelColorsMax + ", block_freq=" + nLevelBlockFreq + ", specMax=" + nLevelSpecialMax + ", spec_freq=" + aLevelSpecialFreq);
			//block frequency should be set only if level 2.
			//  block frequency should have a starting value, a value per level, and a max value
			if (level < 2) {
				nLevelBlockFreq = 0;
			} else {
				nLevelBlockFreq = Math.min(Config.LEVEL_BLOCK_FREQ + ((level-1) * Config.LEVEL_BLOCK_FREQ_LEVEL_INC), Config.LEVEL_BLOCK_FREQ_MAX);
			}
			//special frequency should be set overall
			//then individual frequency should be set
			nSpecUsed = 0;
			nSpecDestroyed = 0;
			if (level < 2) {
				nLevelSpecialFreq = 0;
				nMaxNumSpec = 0;
				nMaxNumBlock = 0;
			} else {
				nLevelSpecialFreq = Math.min(Config.SPEC_FREQ + ((level-1) * Config.SPEC_FREQ_LEVEL_INC), Config.SPEC_FREQ_MAX);
				//aLevelSpecialFreq = [(level-1) * Config.SPEC_FREQ_1, (level-2) * Config.SPEC_FREQ_2, (level-3) * Config.SPEC_FREQ_3, (level-4) * Config.SPEC_FREQ_4, (level-5) * Config.SPEC_FREQ_5, (level-6) * Config.SPEC_FREQ_6, (level-7) * Config.SPEC_FREQ_7, (level-8) * Config.SPEC_FREQ_8, (level-9) * Config.SPEC_FREQ_9];
				aLevelSpecialFreq = new Array();
				level > 1 ? aLevelSpecialFreq.push(Config.SPEC_FREQ_1) : aLevelSpecialFreq.push(0);
				level > 2 ? aLevelSpecialFreq.push(Config.SPEC_FREQ_2) : aLevelSpecialFreq.push(0);
				level > 3 ? aLevelSpecialFreq.push(Config.SPEC_FREQ_3) : aLevelSpecialFreq.push(0);
				level > 4 ? aLevelSpecialFreq.push(Config.SPEC_FREQ_4) : aLevelSpecialFreq.push(0);
				level > 5 ? aLevelSpecialFreq.push(Config.SPEC_FREQ_5) : aLevelSpecialFreq.push(0);
				level > 6 ? aLevelSpecialFreq.push(Config.SPEC_FREQ_6) : aLevelSpecialFreq.push(0);
				level > 7 ? aLevelSpecialFreq.push(Config.SPEC_FREQ_7) : aLevelSpecialFreq.push(0);
				level > 8 ? aLevelSpecialFreq.push(Config.SPEC_FREQ_8) : aLevelSpecialFreq.push(0);
				level > 9 ? aLevelSpecialFreq.push(Config.SPEC_FREQ_9) : aLevelSpecialFreq.push(0);
				//nMaxNumSpec = Math.min(Math.floor(3 + ((level-1) * 0.35)),7);
				//nMaxNumBlock = Math.min(Math.floor(1 + ((level-1) / 5)),7);
				nMaxNumSpec = Math.min(Math.floor(3 + ((level-1) * 0.35)),10);
				//nMaxNumBlock = Math.min(Math.floor(1 + ((level-1) * 0.35)),20);
				if (level < 9) {
					nMaxNumBlock = Math.min(Math.floor(1 + ((level-1) * 1)),20);
				} else {
					nMaxNumBlock = Math.min(Math.floor(8 + ((level-8) * 0.75)),30);
				}
			}
			trace("Level " + level + ", matches_req=" + levelMatchesRequired + ", colorMax=" + nLevelColorsMax + ", block_freq=" + nLevelBlockFreq + ", specMax=" + nLevelSpecialMax + ", spec_freq=" + aLevelSpecialFreq);
			
			nCurNumSpec = 0;
			nCurNumBlock = 0;
			
			//Z debug - for testing game over
			/*
			nLevelBlockFreq = 0.7;
			nMaxNumBlock = 50;
			nMaxNumSpec = 0;
			*/
			
			matches = 0;
			
			nLastGemOverDir = -1;
			
			createBackgrounds();
			initializeGems();
			
			//tutorial.init(level, NewTimer.getTimer(), tutorial.bShowHelp);
			var mySo:SharedObject = SharedObject.getLocal(Main.MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME);
			var tTutOn:Boolean = false;
			if (mySo.data.tutorial == undefined || mySo.data.tutorial == true) {
				tTutOn = true;
			}
			tutorial.init(level, NewTimer.getTimer(), tTutOn);
			
			message.showLevel(level);
			if (level < 11) {
				var hmeter:int = Math.min(level-1, 9);
				heroesMeter.gotoAndPlay("level" + hmeter);
			}
			/*
			timer = new NewTimer(Config.MESSAGE_LEVELTIME, 1);
			timer.addEventListener(TimerEvent.TIMER, generateInitialGems);
			timer.start();
			*/
			timer = new NewTimer(1000, 1);
			timer.addEventListener(TimerEvent.TIMER, preGeneratePause);
			timer.start();
		}
		
		public function hideTutorial():void {
			trace("!! hideTutorial()");
			//Called when the user presses the hide tutorial checkbox
			//we need to rig it to store the value permanently.
			//when the game is loaded and shared object checked, from game should call:
			//  tutorial.init(level, NewTimer.getTimer(), false);
			//  in function startLevel() a couple lines above here
			//  just add that last param to be the appropriate value of showing tutorials
			//  right now i have it rigged to pass its own value in so that once i set it off internally it stays off
			
			options.selectTutorial(false);
		}
		
		private function preGeneratePause(timerEvent:TimerEvent):void {
			timer.stop();
			timer = new NewTimer(Config.MESSAGE_LEVELTIME, 1);
			timer.addEventListener(TimerEvent.TIMER, generateInitialGems);
			timer.start();
		}
		
		
		private function createBackgrounds():void {
			var levelInfo:Array = Config.LEVEL_INFOS[(level - 1) % Config.LEVEL_INFOS.length];
			var gemBackground:GemBackground;
			var i:int, j:int;
			
			dimensionY = levelInfo.length;
			
			dimensionX = 0;
			
			for(i=0;i<levelInfo.length;i++) {
				if(levelInfo[i].length > dimensionX) dimensionX = levelInfo[i].length;
			}
			
			backgrounds = new Array();
			
			var colOffset:Number = 0;
			
			for(i=0;i<dimensionX;i++) {
				backgrounds[i] = new Array();
				if (i%2 > 0) {
					colOffset = 0.5;
				} else {
					colOffset = 0;
				}
				
				for(j=0;j<dimensionY;j++) {
					if(levelInfo[j].charAt(i) == ' ') {
						backgrounds[i][j] = null;
					} else {
						gemBackground = new GemBackground();
						gemBackground.x = i * Config.BLOCKSIZE;
						gemBackground.y = (j * Config.BLOCKSIZE) + (Config.BLOCKSIZE * colOffset);
						
						backgroundsHolder.addChild(gemBackground);
						
						backgrounds[i][j] = gemBackground;
					}
				}
			}
			
			backgroundsHolder.x = (Config.GEMS_LEFT + Config.GEMS_RIGHT - backgroundsHolder.width) / 2;
			backgroundsHolder.y = (Config.GEMS_TOP + Config.GEMS_BOTTOM - backgroundsHolder.height) / 2;
			
			heroAnimation.setUpperLeft(backgroundsHolder.x, backgroundsHolder.y);
		}
		
		private function initializeGems():void {
			var x:Number, y:Number, d:Number;
			var i:int, j:int;
			
			gemsHolder.x = backgroundsHolder.x;
			gemsHolder.y = backgroundsHolder.y;
			gemsMask.x = backgroundsHolder.x;
			gemsMask.y = backgroundsHolder.y;
			clickDetector.x = backgroundsHolder.x;
			clickDetector.y = backgroundsHolder.y;
			scoresHolder.x = backgroundsHolder.x;
			scoresHolder.y = backgroundsHolder.y;
			
			gemsMask.graphics.clear();
			gemsMask.graphics.beginFill(0);
			
			/*
			gemsMask.graphics.moveTo(0, 0);
			gemsMask.graphics.lineTo(Config.GEMS_RIGHT - Config.GEMS_LEFT, 0);
			gemsMask.graphics.lineTo(Config.GEMS_RIGHT - Config.GEMS_LEFT, Config.GEMS_BOTTOM - Config.GEMS_TOP + Config.BLOCKSIZE);
			gemsMask.graphics.lineTo(0, Config.GEMS_BOTTOM - Config.GEMS_TOP + Config.BLOCKSIZE);
			gemsMask.graphics.lineTo(0, 0);
			*/
			/*
			gemsMask.graphics.moveTo(-20, -80);
			gemsMask.graphics.lineTo(Config.GEMS_RIGHT - Config.GEMS_LEFT + 20, -80);
			gemsMask.graphics.lineTo(Config.GEMS_RIGHT - Config.GEMS_LEFT + 20, Config.GEMS_BOTTOM - Config.GEMS_TOP + Config.BLOCKSIZE);
			gemsMask.graphics.lineTo(-20, Config.GEMS_BOTTOM - Config.GEMS_TOP + Config.BLOCKSIZE);
			gemsMask.graphics.lineTo(-20, -80);
			*/
			
			/*
			gemsMask.graphics.moveTo(-120, -80);
			gemsMask.graphics.lineTo(Config.GEMS_RIGHT - Config.GEMS_LEFT + 20, -80);
			gemsMask.graphics.lineTo(Config.GEMS_RIGHT - Config.GEMS_LEFT + 20, Config.GEMS_BOTTOM - Config.GEMS_TOP + Config.BLOCKSIZE);
			gemsMask.graphics.lineTo(-120, Config.GEMS_BOTTOM - Config.GEMS_TOP + Config.BLOCKSIZE);
			gemsMask.graphics.lineTo(-120, -80);
			*/
			gemsMask.graphics.moveTo(-120, -100);
			gemsMask.graphics.lineTo(Config.GEMS_RIGHT - Config.GEMS_LEFT + 80, -100);
			gemsMask.graphics.lineTo(Config.GEMS_RIGHT - Config.GEMS_LEFT + 80, Config.GEMS_BOTTOM - Config.GEMS_TOP + Config.BLOCKSIZE);
			gemsMask.graphics.lineTo(-120, Config.GEMS_BOTTOM - Config.GEMS_TOP + Config.BLOCKSIZE);
			gemsMask.graphics.lineTo(-120, -100);
			
			
			clickDetector.graphics.clear();
			clickDetector.graphics.beginFill(0, 0);
			
			d = Config.BLOCKSIZE;
			
			var colOffset:Number = 0;
			
			for(i=0;i<backgrounds.length;i++) {
				if (i%2 > 0) {
					colOffset = 0.5;
				} else {
					colOffset = 0;
				}
				for(j=0;j<backgrounds[i].length;j++) {
					if(!backgrounds[i][j]) continue;
					
					x = i * Config.BLOCKSIZE;
					y = (j * Config.BLOCKSIZE) + (Config.BLOCKSIZE * colOffset);
					/*
					gemsMask.graphics.moveTo(x, y);
					gemsMask.graphics.lineTo(x + d, y);
					gemsMask.graphics.lineTo(x + d, y + d);
					gemsMask.graphics.lineTo(x, y + d);
					gemsMask.graphics.lineTo(x, y);
					*/
					clickDetector.graphics.moveTo(x, y);
					clickDetector.graphics.lineTo(x + d, y);
					clickDetector.graphics.lineTo(x + d, y + d);
					clickDetector.graphics.lineTo(x, y + d);
					clickDetector.graphics.lineTo(x, y);
				}
			}
			if (gemOverTimer != null) {
				gemOverTimer.removeEventListener(TimerEvent.TIMER, onGemOverTime);
				gemOverTimer.stop();
			}
			gemOverTimer = new NewTimer(20, 0);
			gemOverTimer.addEventListener(TimerEvent.TIMER, onGemOverTime);
			gemOverTimer.start();
		}
		
		private function generateInitialGems(timerEvent:TimerEvent):void {
			var gem:Gem;
			var i:int, j:int;
			var colOffset:Number;
			
			message.hide();
			
			gems = new Array();
			
			var rndXOffset:Number;
			
			for(i=0;i<backgrounds.length;i++) {
				gems[i] = new Array();
				
				if (i%2 > 0) {
					colOffset = 0.5;
				} else {
					colOffset = 0;
				}
				
				for(j=0;j<backgrounds[i].length;j++) {
					if(backgrounds[i][j] == null) {
						gems[i][j] = null;
					} else {
						gem = new Gem();
						gem.initialize(i, j, dimensionY);
						
						gems[i][j] = gem;
						
						gem.initMoveFactor = 0.5 + 0.5 * Math.random();
						
						//gem.startFallX = Config.GEM_START_X;
						rndXOffset = 500 * Math.random();
						
						gem.startFallX = Config.GEM_START_X + rndXOffset;
						
						gem.endFallX = gem.x;
						
						gem.startFallY = Config.GEM_START_Y;
						//gem.startFallY = Config.GEM_START_Y - rndXOffset * 0.5;
						
						//gem.endFallY = (j + noOfSteps - k) * Config.BLOCKSIZE + Config.BLOCKSIZE / 2 + Config.BLOCKSIZE * colOffset;
						//gem.endFallY = gem.y;
						//gems[i][j].y = j * Config.BLOCKSIZE + Config.BLOCKSIZE / 2 + Config.BLOCKSIZE * colOffset - maxDistance + distance;
						gem.endFallY = j * Config.BLOCKSIZE + Config.BLOCKSIZE / 2 + Config.BLOCKSIZE * colOffset;
						
						gem.x = gem.startFallX;
						gem.y = gem.startFallY;
						
						gemsHolder.addChild(gem);
					}
				}
			}
			
			generateInitialGemTypes();
			mothershipGlowClip.gotoAndPlay("on");
			SoundManager.getInstance().play(SoundManager.SHIPS_FLY_IN);
			
			startTime = NewTimer.getTimer();
			
			timer = new NewTimer(1, 0);
			timer.addEventListener(TimerEvent.TIMER, onInitialGemTime);
			timer.start();
		}
		
		private function generateInitialGemTypes():void {
			var groups:Array;
			var i:int, j:int;
			var tRndX:int;
			var tRndY:int;
			
			while(true) {
				for(i=0;i<gems.length;i++) {
					for(j=0;j<gems[i].length;j++) {
						if(!gems[i][j]) continue;
						
						//gems[i][j].setType(Math.floor(Math.random() * Config.GEMS_TYPES));
						gems[i][j].setType(Math.floor(Math.random() * nLevelColorsMax));
					}
				}
				
				//now pick random spot for the new pieces this round
				//trace("gems.l=" + gems.length + ", gems[0].l=" + gems[0].length);
				//trace("gems.l=" + gems.length + ", gems[0]=" + gems[0]);
				//trace("         gems[0].l=" + gems[0].length);
				nCurNumBlock = 0;
				nCurNumSpec = 1;
				tRndX = 1 + Math.floor(Math.random() * (gems.length-2));
				tRndY = 1 + Math.floor(Math.random() * (gems[0].length-2));
				switch (this.level) {
					case 0:
					case 1:
						break;
					case 2:
						gems[tRndX][tRndY].setType(Config.BLOCK_TYPES + 0, nLevelColorsMax);
						gems[tRndX-1][tRndY].setBlockType();
						nCurNumBlock++;
						break;
					case 3:
						gems[tRndX][tRndY].setType(Config.BLOCK_TYPES + 1, nLevelColorsMax);
						break;
					case 4:
						gems[tRndX][tRndY].setType(Config.BLOCK_TYPES + 2, nLevelColorsMax);
						break;
					case 5:
						gems[tRndX][tRndY].setType(Config.BLOCK_TYPES + 3, nLevelColorsMax);
						break;
					case 6:
						gems[tRndX][tRndY].setType(Config.BLOCK_TYPES + 4, nLevelColorsMax);
						break;
					case 7:
						gems[tRndX][tRndY].setType(Config.BLOCK_TYPES + 5, nLevelColorsMax);
						break;
					case 8:
						gems[tRndX][tRndY].setType(Config.BLOCK_TYPES + 6, nLevelColorsMax);
						break;
					case 9:
						gems[tRndX][tRndY].setType(Config.BLOCK_TYPES + 7, nLevelColorsMax);
						break;
					case 10:
						gems[tRndX][tRndY].setType(Config.BLOCK_TYPES + 8, nLevelColorsMax);
						break;
					default:
						var tRndHeroType:int = Math.floor(Math.random() * 9);
						gems[tRndX][tRndY].setType(Config.BLOCK_TYPES + tRndHeroType, nLevelColorsMax);
						break;
				}
				//var tNumStartBlocks:int = 1 + Math.floor(Math.random() * ((level-1) / 7));
				var tNumStartBlocks:int;
				if (level == 1) {
					tNumStartBlocks = 0;
				} else if (level < 5) {
					tNumStartBlocks = 1;
				} else if (level < 9) {
					tNumStartBlocks = 2;
				} else if (level < 13) {
					tNumStartBlocks = 3;
				} else if (level < 17) {
					tNumStartBlocks = 4;
				} else if (level < 21) {
					tNumStartBlocks = 5;
				} else {
					tNumStartBlocks = 6;
				}
				for (i = nCurNumBlock; i < tNumStartBlocks; i++) {
					do {
						tRndX = 1 + Math.floor(Math.random() * (gems.length-2));
						tRndY = 1 + Math.floor(Math.random() * (gems[0].length-2));
					} while (gems[tRndX][tRndY].type >= Config.BLOCK_TYPES-1)
					gems[tRndX][tRndY].setType(Config.BLOCK_TYPES-1);
					nCurNumBlock++;
				}
				
				while(true) {
					groups = getFormedGroups();
					if(groups.length == 0) break;
					
					for(i=0;i<groups.length;i++) {
						for(j=0;j<groups[i].length;j++) {
							//groups[i][j].setType(Math.floor(Math.random() * Config.GEMS_TYPES));
							groups[i][j].setType(Math.floor(Math.random() * nLevelColorsMax));
						}
					}
				}
				
				if(!getHasMoves()) continue;
				
				break;
			}
		}
		
		private function numHerosInGrid():Number {
			var tReturn:Number = 0;
			for (var x:int = 0; x < gems.length; x++) {
				for (var y:int = 0; y < gems[x].length; y++) {
					if (gems[x][y]) {
						if (gems[x][y].type >= Config.BLOCK_TYPES) {
							tReturn++;
						}
					}
				}
			}
			return tReturn;
		}
		
		private function getFormedGroups():Array {
			var groups:Array = new Array();
			var group:Array;
			var i:int, j:int;
			
			//trace("#### getFormedGroups");
			for(i=0;i<dimensionX;i++) {
				for(j = 0; j < dimensionY - Config.GROUPSIZE + 1; j++) {
					if(!gems[i][j]) continue;
					
					group = getGroup(i, j, 0, 1);
					if(group == null) continue;
					
					groups.push(group);
					
					j += group.length - 1;
				}
			}
			//trace("      # got vertical groups");
			/*
			for(i=0;i<dimensionY;i++) {
				for(j = 0; j < dimensionX - Config.GROUPSIZE + 1; j++) {
					if(!gems[j][i]) continue;
					
					group = getGroup(j, i, 1, 0);
					if(group == null) continue;
					
					groups.push(group);
					
					j += group.length - 1;
				}
			}
			*/
			//trace("  ## Start ascending diagonal");
			for(i = 0; i < dimensionY; i++) {
				for(j = 0; j < dimensionX - Config.GROUPSIZE + 1; j++) {
					if(!gems[j][i]) continue;
					
					//trace("# group(j=" + j + ", i=" + i + ", 1, 1)");
					group = getGroupDiagonal(Number(j), Number(i), 1, 1);
					//group = getGroupDiagonal(Number(j), Number(i), 1, -1);
					if(group == null) continue;
					//trace("    grp.length=" + group.length + ", j=" + j + ", i=" + i);
					groups.push(group);
					
					//j += group.length - 1;
				}
			}
			//trace("  ## Start descending diagonal");
			for(i = dimensionY - 1; i > -1; i--) {
				for(j = 0; j < dimensionX - Config.GROUPSIZE + 1; j++) {
					if(!gems[j][i]) continue;
					
					//trace("# group(j=" + j + ", i=" + i + ", 1, -1)");
					group = getGroupDiagonal(Number(j), Number(i), 1, -1);
					//group = getGroupDiagonal(Number(j), Number(i), 1, 1);
					if(group == null) continue;
					//trace("    grp.length=" + group.length);
					groups.push(group);
					
					//j += group.length - 1;
				}
			}
			/*
			trace("!!! GROUPS:");
			for (var z:int = 0; z < groups.length; z++) {
				trace(" " + z + ": " + groups[z]);
			}
			*/
			return groups;
		}
		
		private function getGroup(x:int, y:int, stepX:int, stepY:int):Array {
			var group:Array = [ gems[x][y] ];
			var type:int = gems[x][y].type;
			if (type >= Config.GEMS_TYPES) return null;
			
			x += stepX;
			y += stepY;
			
			while(x >= 0 && y >= 0 && x < dimensionX && y < dimensionY && gems[x][y] != null) {
				if(gems[x][y].type != type) break;
				
				group.push(gems[x][y]);
				
				x += stepX;
				y += stepY;
			}
			
			if(group.length < Config.GROUPSIZE) return null;
			
			return group;
		}
		
		private function getGroupDiagonal(x:Number, y:Number, stepX:int, stepY:int):Array {
			var group:Array = [ gems[x][y] ];
			var type:int = gems[x][y].type;
			if (type >= Config.GEMS_TYPES) return null;
			
			//if even col, and step +1: 0, 1, 1, 2, 2
			//if odd col, and step +1: 0, 0, 1, 1, 2
			
			//if even col, and step -1: 2, 2, 1, 1, 0
			//if odd col, and step -1: 3, 2, 2, 1, 1
			/*
			0,   1, 1,   2, 2
			0.5, 1, 1.5, 2
			
			0, 0,   1, 1,   2
			0, 0.5, 1, 1.5, 2
			*/
			//trace("getGroupDiagonal(x=" + x + ", y=" + y + ", stepX=" + stepX + ", stepY=" + stepY + ")");
			
			var incYStep:Number = 0.5;
			if (stepY == 1) {
				/*
				if (x % 2 == 0) {
					y += incYStep;
				}
				*/
				if (x % 2 == 1) {
					y += incYStep;
				}
			}
			if (stepY == -1) {
				incYStep *= -1;
				/*
				if (x % 2 == 1) {
					y += incYStep;
				}
				*/
				if (x % 2 == 0) {
					y += incYStep;
				}
			}
			//trace("   incYStep=" + incYStep);
			
			x += stepX;
			//y += stepY;
			y += incYStep;
			var floorY:Number = Math.floor(y);
			if (incYStep < 0) {
				floorY = Math.ceil(y);
			}
			//trace("     x=" + x +", y=" + y + ", floorY=" + floorY);
			
			//while(x >= 0 && y >= 0 && x < dimensionX && y <= dimensionY - 1 && gems[x][floorY] != null) {
			while(x >= 0 && floorY >= 0 && x < dimensionX && floorY <= dimensionY - 1 && gems[x][floorY] != null) {
				if(gems[x][floorY].type != type) break;
				
				group.push(gems[x][floorY]);
				
				x += stepX;
				//y += stepY;
				y += incYStep;
				floorY = Math.floor(y);
				if (incYStep < 0) {
					floorY = Math.ceil(y);
				}
				//trace("     x=" + x +", y=" + y + ", floorY=" + floorY);
			}
			
			if(group.length < Config.GROUPSIZE) return null;
			
			return group;
		}
		
		private function getHasMoves():Boolean {
			var groups:Array;
			var i:int, j:int;
			
			currentGroups = new Array();
			bGroupsValid = true;
			/*
			for(i=0;i<dimensionX;i++) {
				for(j=0;j<dimensionY;j++) {
					if(!gems[i][j]) continue;
					
					if(i < dimensionX - 1 && gems[i + 1][j]) {
						swapGems(i, j, i + 1, j);
						
						groups = getFormedGroups();
						
						swapGems(i, j, i + 1, j);
						
						if(groups.length > 0) return true;
					}
					
					if(j < dimensionY - 1 && gems[i][j + 1]) {
						swapGems(i, j, i, j + 1);
						
						groups = getFormedGroups();
						
						swapGems(i, j, i, j + 1);
						
						if(groups.length > 0) return true;
					}
				}
			}
			*/
			var bHasHeroes:Boolean = false;
			//get groups in normal vertical direction only
			for(i=0;i<dimensionX;i++) {
				for(j = 0; j < dimensionY; j++) {
					if(!gems[i][j]) continue;
					if (gems[i][j].type > Config.BLOCK_TYPES-1) {
						bHasHeroes = true;
						continue;
					}
					if (gems[i][j].type == Config.BLOCK_TYPES-1) continue;
					
					if(j < dimensionY - 1 && gems[i][j + 1]) {
						if (gems[i][j + 1].type >= Config.BLOCK_TYPES-1) continue;
						
						swapGems(i, j, i, j + 1);
						
						groups = getFormedGroups();
						
						swapGems(i, j, i, j + 1);
						
						//if(groups.length > 0) return true;
						if(groups.length > 0) {
							currentGroups.push(groups);
							if (Math.random() < 0.02) {
								return true;
							}
						}
					}
					
				}
			}
			//get groups in diagonal direction
			var diagOffset:int = 0;
			//get groups in diagonal right up
			for(i=0;i<dimensionX;i++) {
				for(j = 0; j < dimensionY; j++) {
					//if(!gems[i][j] || gems[i][j].type >= Config.BLOCK_TYPES-1) continue;
					if(!gems[i][j]) continue;
					if (gems[i][j].type > Config.BLOCK_TYPES-1) {
						bHasHeroes = true;
						continue;
					}
					if (gems[i][j].type == Config.BLOCK_TYPES-1) continue;
					
					
					//if we're in an even column, set offset to y-1
					//else set offset to y+0
					if (i % 2 == 0) {
						diagOffset = -1;
					} else {
						diagOffset = 0;
					}
					
					if(i < dimensionX - 1 && j + diagOffset >= 0 && gems[i + 1][j + diagOffset]) {
						if (gems[i + 1][j + diagOffset].type >= Config.BLOCK_TYPES-1) continue;
						
						swapGems(i, j, i + 1, j + diagOffset);
						
						groups = getFormedGroups();
						
						swapGems(i, j, i + 1, j + diagOffset);
						
						//if(groups.length > 0) return true;
						if(groups.length > 0) {
							currentGroups.push(groups);
							if (Math.random() < 0.02) {
								return true;
							}
						}
					}
					
				}
			}
			//get groups in diagonal right down
			for(i=0;i<dimensionX;i++) {
				for(j = 0; j < dimensionY; j++) {
					//if(!gems[i][j] || gems[i][j].type >= Config.BLOCK_TYPES-1) continue;
					if(!gems[i][j]) continue;
					if (gems[i][j].type > Config.BLOCK_TYPES-1) {
						bHasHeroes = true;
						continue;
					}
					if (gems[i][j].type == Config.BLOCK_TYPES-1) continue;
					
					//if we're in an even column, set offset to y+0
					//else set offset to y+1
					if (i % 2 == 0) {
						diagOffset = 0;
					} else {
						diagOffset = 1;
					}
					
					if(i < dimensionX - 1 && j + diagOffset < dimensionY && gems[i + 1][j + diagOffset]) {
						if (gems[i + 1][j + diagOffset].type >= Config.BLOCK_TYPES-1) continue;
						
						swapGems(i, j, i + 1, j + diagOffset);
						
						groups = getFormedGroups();
						
						swapGems(i, j, i + 1, j + diagOffset);
						
						//if(groups.length > 0) return true;
						if(groups.length > 0) {
							currentGroups.push(groups);
							return true;
						}
					}
					
				}
			}
			if (currentGroups.length > 0) {
				return true;
			}
			if (bHasHeroes) {
				return true;
			}
			
			return false;
		}
		
		private function swapGems(x1:int, y1:int, x2:int, y2:int):void {
			var temp = gems[x1][y1];
			
			gems[x1][y1] = gems[x2][y2];
			gems[x2][y2] = temp;
			
			gems[x1][y1].indexX = x1;
			gems[x1][y1].indexY = y1;
			gems[x2][y2].indexX = x2;
			gems[x2][y2].indexY = y2;
		}
		
		private function onInitialGemTime(timerEvent:TimerEvent):void {
			timerEvent.updateAfterEvent();
			
			if(!doMoveInitialGems(startTime)) return;
			
			timer.stop();
			
			startPlay();
		}
		
		private function doMoveInitialGems(startTime:int):Boolean {
			var time:int = NewTimer.getTimer();
			var dTime:int = time - startTime;
			
			//var distance:Number = Config.GEMS_ACCELERATION * dTime * dTime / 2000000;
			var distance:Number = Config.GEMS_INIT_ACCELERATION * dTime * dTime / 2000000;
			//var distance:Number = Config.GEMS_INIT_ACCELERATION * dTime * dTime / 10000000;
			var maxDistance:Number = dimensionY * Config.BLOCKSIZE;
			var i:int, j:int;
			
			var ratio:Number = 1-(distance / maxDistance);
			var ratioSq:Number = ratio * ratio;
			//var ratioSq:Number = ratio * ratio * ratio * ratio;
			//var ratioRt:Number = Math.sqrt(ratio);
			var ratioY:Number;
			
			if(distance > maxDistance) distance = maxDistance;
			
			var colOffset:Number = 0;
			
			for(i=0;i<gems.length;i++) {
				if (i%2 > 0) {
					colOffset = 0.5;
				} else {
					colOffset = 0;
				}
				for(j=0;j<gems[i].length;j++) {
					if(gems[i][j] == null) continue;
					
					//gems[i][j].x = gems[i][j].startFallX + ((gems[i][j].endFallX - gems[i][j].startFallX)) * (1-ratioSq * gems[i][j].initMoveFactor);
					gems[i][j].x = gems[i][j].startFallX + (gems[i][j].endFallX - gems[i][j].startFallX) * (1-ratioSq);
					
					//gems[i][j].y = j * Config.BLOCKSIZE + Config.BLOCKSIZE / 2 + Config.BLOCKSIZE * colOffset - maxDistance + distance;
					
					//gems[i][j].y = gems[i][j].startFallY + (gems[i][j].endFallY - gems[i][j].startFallY) * (1-ratio*gems[i][j].initMoveFactor);
					//gems[i][j].y = gems[i][j].startFallY + (gems[i][j].endFallY - gems[i][j].startFallY) * (1-ratioSq);
					//gems[i][j].y = gems[i][j].startFallY + (gems[i][j].endFallY - gems[i][j].startFallY) * (1-ratio);
					/*
					if (gems[i][j].x > 400) {
						gems[i][j].y = gems[i][j].startFallY;
					} else {
						gems[i][j].y = gems[i][j].startFallY + (gems[i][j].endFallY - gems[i][j].startFallY) * (1-ratio);
					}
					*/
					if (gems[i][j].x > 460) {
						ratioY = 1;
					} else {
						ratioY = (gems[i][j].endFallX - gems[i][j].x) / (gems[i][j].endFallX - 460);
					}
					gems[i][j].y = gems[i][j].startFallY + (gems[i][j].endFallY - gems[i][j].startFallY) * (1-ratioY);
					
					if(distance >= maxDistance) {
						gems[i][j].x = gems[i][j].endFallX;
						gems[i][j].y = gems[i][j].endFallY;
					}
				}
			}
			
			if(distance >= maxDistance) {
				return true;
			} else {
				return false;
			}
		}
		
		private function startPlay():void {
			//timeDisplay.setTime(1);
			//timeDisplay.setTimeText(1, levelTime);
			timeDisplay.setMaxProgress(levelMatchesRequired);
			timeDisplay.setCurProgress(matches);
			
			selectedX = -1;
			selectedY = -1;
			
			combo = 0;
			
			nTrackLevelStartTime = NewTimer.getTimer();
			Object(mcParent).trackLevelEvent(level, "start");
			
			setControl();
			
			startTime = NewTimer.getTimer();
			
			timer = new NewTimer(1, 0);
			timer.addEventListener(TimerEvent.TIMER, onPlayTime);
			timer.start();
		}
		
		private function onPlayTime(timerEvent:TimerEvent):void {
			/*
			var time:int = NewTimer.getTimer();
			var ratio:Number = 1 - (time - startTime) / levelTime;
			
			if(ratio < 0) ratio = 0;
			*/
			timerEvent.updateAfterEvent();
			
			//timeDisplay.setTime(ratio);
			//timeDisplay.setTimeText(ratio, levelTime);
			
			var curTime:int = NewTimer.getTimer();
			tutorial.updateDisplay(curTime);
			timeDisplay.updateDisplay(curTime);
			particleFactory.updateDisplay();
			
			
			if (Math.random() < 0.005) {
				var rndX:int = Math.floor(Math.random() * gems.length);
				var rndY:int = Math.floor(Math.random() * gems[0].length);
				if (gems[rndX][rndY] != null && gems[rndX][rndY].nState == Config.GEM_STATE_READY) {
					if (Math.random() < 0.5) {
						generateParticleEffect({layer:beamOverLayer, num:1, pace:0, x:gemsHolder.x + gems[rndX][rndY].x + (Config.BLOCKSIZE * Math.random() - Config.BLOCKSIZE * 0.5) * 0.75, y:gemsHolder.y + gems[rndX][rndY].y + (Config.BLOCKSIZE * Math.random() - Config.BLOCKSIZE * 0.5) * 0.75, useTypeColor:true, typeColor:gems[rndX][rndY].type, minSpeedX:0, maxSpeedX:0, minSpeedY:0, maxSpeedY:0, gravity:0},false);
					} else {
						if (Math.random() < 0.35) {
							if (Math.random() < 0.6) {
								gems[rndX][rndY].spotAnim();
							}
							/*
						} else {
							//gems[rndX][rndY].flipAnim();
							//reduce amount this effect happens
							//mark to be giving a spot animation to play, will be something besides flipanim
							
							//trace("bGroupsValid=" + bGroupsValid + ", currentGroups=" + currentGroups);
							if (bGroupsValid) {
								if (currentGroups.length > 0 && currentGroups[currentGroups.length-1].length > 0) {
									//trace(currentGroups[0] + ", " + currentGroups[0].indexX);
									//trace(currentGroups[0][0] + ", " + currentGroups[0][0].indexX);
									//trace(currentGroups[0][0][0] + ", " + currentGroups[0][0][0].indexX);
									//for (var x:int = 0; x < currentGroups[0][0].length; x++) {
									//	trace("gem[" + x + "]=" + currentGroups[0][0][x].indexX + "," + currentGroups[0][0][x].indexY);
									//}
									if (Math.random() < 0.75) {
										var tRndShip:int = Math.floor(Math.random() * currentGroups[currentGroups.length-1][0].length);
										currentGroups[currentGroups.length-1][0][tRndShip].flipAnim();
									}
								}
							}
							*/
						}
					}
				}
			}
			/*
			if(ratio <= 0) {
				gameOver();
			}
			*/
		}
		
		private function setControl():void {
			clickDetector.addEventListener(MouseEvent.MOUSE_DOWN, onGemMouseDown);
			clickDetector.addEventListener(MouseEvent.MOUSE_UP, onGemMouseUp);
			/*
			clickDetector.addEventListener(MouseEvent.ROLL_OVER, onGemMouseOver);
			clickDetector.addEventListener(MouseEvent.ROLL_OUT, onGemMouseOut);
			*/
			clickDetector.buttonMode = true;
			hintButton.addEventListener(MouseEvent.CLICK, onHintClick);
		}
		
		private function unsetControl():void {
			clickDetector.removeEventListener(MouseEvent.MOUSE_DOWN, onGemMouseDown);
			clickDetector.removeEventListener(MouseEvent.MOUSE_UP, onGemMouseUp);
			/*
			clickDetector.removeEventListener(MouseEvent.ROLL_OVER, onGemMouseOver);
			clickDetector.removeEventListener(MouseEvent.ROLL_OUT, onGemMouseOut);
			*/
			clickDetector.buttonMode = false;
			bGroupsValid = false;
			hintButton.removeEventListener(MouseEvent.CLICK, onHintClick);
		}
		
		private function onGemOverTime(timerEvent:TimerEvent):void {
			//trace("over timer: " + NewTimer.getTimer());
			//called repeatedly while the game is active
			if (clickDetector.buttonMode) {
				//trace("over timer: " + NewTimer.getTimer());
				//calculate current grid position
				//test type for pieces that need direction
				//if (type == Config.GEM_TYPE_RND_DIR1 || type == Config.GEM_TYPE_RND_DIR2) {
				//if we're currently over a type that needs direction
				//set the current overlay item to this gem's position and set it's rotation frame
				var bUpdateHighlight:Boolean = false;
				var x:int = Math.floor(gemsHolder.mouseX / Config.BLOCKSIZE);
				var y:int = Math.floor(gemsHolder.mouseY / Config.BLOCKSIZE);
				if (x%2 > 0) {
					y = Math.floor((gemsHolder.mouseY - (Config.BLOCKSIZE * 0.5)) / Config.BLOCKSIZE);
				}
				
				var gemType:int; // = gems[x][y].type;
				//trace("over pre=" + x + ", " + y + ", curGemOver=" + curGemOver);
				//if (x != this.curGemOver[0] && y != this.curGemOver[1]) {
				if (x != curGemOver[0] || y != curGemOver[1]) {
					//trace("   here");
					bUpdateHighlight = true;
					if (x > -1 && x < dimensionX && y > -1 && y < dimensionY) {
						gemType = gems[x][y].type;
					}
				} else if (x > -1 && x < dimensionX && y > -1 && y < dimensionY) {
					gemType = gems[x][y].type;
					if (gemType == Config.GEM_TYPE_RND_DIR1 || gemType == Config.GEM_TYPE_RND_DIR2) {
						bUpdateHighlight = true;
					}
				}
				//trace("over cur= " + x + ", " + y + ", update=" + bUpdateHighlight + ", curGemOver=" + curGemOver);
				if (bUpdateHighlight) {
					//trace("over: " + x + ", " + y);
					this.curGemOver[0] = x;
					this.curGemOver[1] = y;
					if (x > -1 && x < dimensionX && y > -1 && y < dimensionY) {
						//var gemType:int = gems[x][y].type;
						//trace("over: " + x + ", " + y);
						//trace("  gem: " + gemType);
						SoundManager.getInstance().play(SoundManager.ROLLOVER);
						var colOffset:Number = 0;
						if (x%2 > 0) {
							colOffset = 0.5;
						} else {
							colOffset = 0;
						}
						gemOver.visible = true;
						/*
						gemOver.x = gemsHolder.x + x * Config.BLOCKSIZE;
						gemOver.y = gemsHolder.y + y * Config.BLOCKSIZE + (Config.BLOCKSIZE * colOffset);
						trace("gemOver.loc=" + gemOver.x + "," + gemOver.y + ", POS=" + x + "," + y + ", gem=" + (gemsHolder.x + gems[x][y].x) + "," + (gemsHolder.y + gems[x][y].y));
						*/
						gemOver.x = gemsHolder.x + gems[x][y].x;
						gemOver.y = gemsHolder.y + gems[x][y].y;
						if (gemType == Config.GEM_TYPE_RND_DIR1 || gemType == Config.GEM_TYPE_RND_DIR2) {
							//trace("here " + gemType);
							//update direction of arrow rollover
							//trace("  showing over");
							var ang:Number = Math.atan2(gemsHolder.mouseY - gems[x][y].y, gemsHolder.mouseX - gems[x][y].x) * (180/Math.PI);
							//trace("angle=" + ang);
							if (ang < -135) {
								gemOverDir = 5;
							} else if (ang < -45) {
								gemOverDir = 0;
							} else if (ang < 0) {
								gemOverDir = 1;
							} else if (ang < 45) {
								gemOverDir = 2;
							} else if (ang < 135) {
								gemOverDir = 3;
							} else {
								gemOverDir = 4;
							}
							//gemOver.gotoAndStop(gemOverDir+1);
							if (gemOverDir != nLastGemOverDir) {
								gemOver.gotoAndPlay("dir_" + gemOverDir.toString());
								nLastGemOverDir = gemOverDir;
							}
							gemOver.headClip.gotoAndStop(gemType - Config.BLOCK_TYPES + 2);
						} else if (gemType >= Config.BLOCK_TYPES) {
							//gemOver.gotoAndStop(7);
							nLastGemOverDir = -1;
							gemOver.gotoAndPlay("hero");
							gemOver.headClip.gotoAndStop(gemType - Config.BLOCK_TYPES + 2);
						} else if (gemType == Config.BLOCK_TYPES-1) {
							//gemOver.gotoAndStop(9);
							nLastGemOverDir = -1;
							gemOver.gotoAndPlay("block");
							gemOver.headClip.gotoAndStop(1);
						} else {
							//trace("  hiding over - not spec gem");
							//gemOver.visible = false;
							//gemOver.gotoAndStop(8);
							nLastGemOverDir = -1;
							gemOver.gotoAndPlay("gem");
							gemOver.headClip.gotoAndStop(1);
						}
					} else {
						//highlight is outside the grid, turn off highlight
						//trace("  hiding over - not on grid");
						nLastGemOverDir = -1;
						gemOver.visible = false;
					}
				}
			}
		}
		
		private function onHintClick(mouseEvent:MouseEvent):void {
			//trace("onHintClick() bGroupsValid=" + bGroupsValid + ", currentGroups.length=" + currentGroups.length + ", currentGroups[currentGroups.length-1].length=" + currentGroups[currentGroups.length-1].length);
			trace("onHintClick() bGroupsValid=" + bGroupsValid);
			trace("     currentGroups.length=" + currentGroups.length);
			if (currentGroups.length > 0) {
				trace("     currentGroups[currentGroups.length-1].length=" + currentGroups[currentGroups.length-1].length);
			}
			if (bGroupsValid) {
				var tCheckHeroes:Boolean = false;
				if (currentGroups.length > 0) {
					if (currentGroups[currentGroups.length-1].length > 0) {
						var tRndShip:int = Math.floor(Math.random() * currentGroups[currentGroups.length-1][0].length);
						trace("  currentGroups[currentGroups.length-1][0]["+tRndShip+"]=" + currentGroups[currentGroups.length-1][0][tRndShip]);
						currentGroups[currentGroups.length-1][0][tRndShip].flipAnim();
						nHintsUsed++;
					} else {
						tCheckHeroes = true;
					}
				} else {
					tCheckHeroes = true;
				}
				if (tCheckHeroes) {
					var tExit:Boolean = false;
					//find hero and tell it to play flip
					for(var i:int=0;i<dimensionX;i++) {
						for(var j:int = 0; j < dimensionY; j++) {
							if(!gems[i][j]) continue;
							if (gems[i][j].type > Config.BLOCK_TYPES-1) {
								tExit = true;
								gems[i][j].flipAnim();
								nHintsUsed++;
								break;
							}
						}
						if (tExit) {
							break;
						}
					}
					
				}
			}
		}
		
		private function onGemMouseDown(mouseEvent:MouseEvent):void {
			var x:int = Math.floor(gemsHolder.mouseX / Config.BLOCKSIZE);
			var y:int = Math.floor(gemsHolder.mouseY / Config.BLOCKSIZE);
			if (x%2 > 0) {
				y = Math.floor((gemsHolder.mouseY - (Config.BLOCKSIZE * 0.5)) / Config.BLOCKSIZE);
			}
			
			if(selectedX == -1 || selectedY == -1 || !getAreAdjacent(selectedX, selectedY, x, y)) {
				var colOffset:Number = 0;
				if (x%2 > 0) {
					colOffset = 0.5;
				} else {
					colOffset = 0;
				}
				if (gems[x][y].type == Config.BLOCK_TYPES - 1) {
					SoundManager.getInstance().play(SoundManager.CLICK_TECH_POD);
					return;
				}
				
				selectedX = x;
				selectedY = y;
				SoundManager.getInstance().play(SoundManager.SELECT_SHIP);
				
				//insert code to activate powerups here
				if (gems[x][y].type >= Config.GEMS_TYPES) return;
				/*
				highlight.x = gemsHolder.x + x * Config.BLOCKSIZE;
				highlight.y = gemsHolder.y + y * Config.BLOCKSIZE + (Config.BLOCKSIZE * colOffset);
				*/
				highlight.x = gemsHolder.x + gems[x][y].x;
				highlight.y = gemsHolder.y + gems[x][y].y;
				
				highlight.visible = true;
				gemOver.visible = false;
				//trace("selected: " + selectedX + ", " + selectedY);
				var rndParts:int = Math.floor(Math.random()*3)+1;
				for (var p:int = 0; p < rndParts; p++) {
					generateParticleEffect({layer:beamOverLayer, num:1, pace:0, x:highlight.x+Config.BLOCKSIZE*Math.random(), y:highlight.y+Config.BLOCKSIZE*Math.random(), useTypeColor:true, typeColor:gems[x][y].type, minSpeedX:0, maxSpeedX:0, minSpeedY:0, maxSpeedY:0, gravity:0},false);
				}
				gems[x][y].flipAnim();
				
				//soundClick.play();
				
			} else {
				if (gems[x][y].type == Config.BLOCK_TYPES - 1) {
					SoundManager.getInstance().play(SoundManager.CLICK_TECH_POD);
					return;
				}
				
				if (gems[x][y].type >= Config.GEMS_TYPES) {
					selectedX = x;
					selectedY = y;
					SoundManager.getInstance().play(SoundManager.SELECT_SHIP);
					return;
				}
				
				gemOver.visible = false;
				startSwapGems(selectedX, selectedY, x, y);
				//soundSwap.play();
			}
		}
		/*
		public function onGemMouseOver(mouseEvent:MouseEvent):void {
			trace("gem over");
		}
		
		public function onGemMouseOut(mouseEvent:MouseEvent):void {
			trace("gem out");
		}
		*/
		private function onGemMouseUp(mouseEvent:MouseEvent):void {
			var x:int = Math.floor(gemsHolder.mouseX / Config.BLOCKSIZE);
			var y:int = Math.floor(gemsHolder.mouseY / Config.BLOCKSIZE);
			if (x%2 > 0) {
				y = Math.floor((gemsHolder.mouseY - (Config.BLOCKSIZE * 0.5)) / Config.BLOCKSIZE);
			}
			
			if (gems[x][y].type < Config.GEMS_TYPES) {
				if(selectedX == -1 || selectedY == -1) return;
				if(!getAreAdjacent(selectedX, selectedY, x, y)) return;
				if (gems[selectedX][selectedY].type >= Config.BLOCK_TYPES) return;
				
				gemOver.visible = false;
				startSwapGems(selectedX, selectedY, x, y);
				
				//soundSwap.play();
			} else if (gems[x][y].type >= Config.BLOCK_TYPES && selectedX == x && selectedY == y) {
				//if(selectedX == -1 || selectedY == -1) return;
				//HELP:  if user already has one selected, we could block them from using a special
				//  or have the user have to select the special first, a double click by putting selection code on mouse up?
				//trace("special: " + gems[x][y].type);
				gemOver.visible = false;
				activateSpecialTile(x, y);
			} else if (gems[x][y].type >= Config.BLOCK_TYPES && selectedX != x && selectedY != y) {
				SoundManager.getInstance().play(SoundManager.INCORRECT_SWAP);
			} else {
				return;
			}
			
			//if (gems[x][y].type >= Config.GEMS_TYPES) return;
			
			
		}
		
		private function getAreAdjacent(x1:int, y1:int, x2:int, y2:int):Boolean {
			/*
			if(x1 == x2) {
				return Math.abs(y1 - y2) == 1;
			} else if(y1 == y2) {
				return Math.abs(x1 - x2) == 1;
			} else {
				return false;
			}
			*/
			var bResult:Boolean = false;
			if (x1 == x2) {
				switch (y1 - y2) {
					case 1:
					case -1:
					bResult = true;
					break;
				}
			} else if (Math.abs(x1 - x2) == 1) {
				//even rows, 0 and 1 off
				//odd rows, 0 and -1 off
				if (x1 % 2 == 1) {
					switch (y1 - y2) {
						case 0:
						case -1:
						bResult = true;
						break;
					}
				} else {
					switch (y1 - y2) {
						case 0:
						case 1:
						bResult = true;
						break;
					}
				}
			}
			return bResult;
		}
		
		private function activateSpecialTile(x:int, y:int):void {
			unsetControl();
			
			selectedX = -1;
			selectedY = -1;
			
			if (tutorial.bActive) {
				tutorial.actionTaken("special");
			}
			
			highlight.visible = false;
			
			//determine tile
			//specialTileData = new Object();
			//trace("gems["+x+"]["+y+"].type: " + gems[x][y].type);
			switch (gems[x][y].type) {
				//BLOCK_TYPES:int = 9
				//POWERUP_TYPES:int = 18
				case 9:
				//cap - destroy - direction - one
				//direction from input
				//specialTileData = {type:Config.PUP_TYPE_DESTROY, dir:Config.DIR_DOWN, dist:1, color:Config.COLOR_ALL};
				
				specialTileData = {type:Config.PUP_TYPE_DESTROY, dir:gemOverDir, dist:1, color:Config.COLOR_ALL};
				break;
				
				case 10:
				//thor - set color - rnd color type - all adjacent
				
				//specialTileData = {type:Config.PUP_TYPE_COLOR, dir:Config.DIR_ALL, dist:1, color:-1};
				specialTileData = {type:Config.PUP_TYPE_COLOR, dir:Config.DIR_ALL, dist:1, color:gems[x][y].colorType};
				break;
				
				case 11:
				//ss - set color - color type - all adjacent
				//color needs to come from the tile
				//specialTileData = {type:Config.PUP_TYPE_COLOR, dir:Config.DIR_ALL, dist:1, color:0};
				
				//specialTileData = {type:Config.PUP_TYPE_COLOR, dir:Config.DIR_ALL, dist:1, color:gems[x][y].colorType};
				specialTileData = {type:Config.PUP_TYPE_DESTROY, dir:Config.DIR_ALL, dist:-1, color:gems[x][y].colorType};
				break;
				
				case 12:
				//thing - destroy - color type - all
				//color needs from come from the tile
				//specialTileData = {type:Config.PUP_TYPE_DESTROY, dir:Config.DIR_ALL, dist:-1, color:1};
				
				//specialTileData = {type:Config.PUP_TYPE_DESTROY, dir:Config.DIR_ALL, dist:-1, color:gems[x][y].colorType};
				specialTileData = {type:Config.PUP_TYPE_DESTROY, dir:gemOverDir, dist:10, color:Config.COLOR_ALL};
				break;
				
				case 13:
				//iron - destroy - direction - 8
				//direction needs to come from the tile
				//specialTileData = {type:Config.PUP_TYPE_DESTROY, dir:Config.DIR_DOWN, dist:10, color:Config.COLOR_ALL};
				
				//specialTileData = {type:Config.PUP_TYPE_DESTROY, dir:gemOverDir, dist:10, color:Config.COLOR_ALL};
				specialTileData = {type:Config.PUP_TYPE_COLOR, dir:Config.DIR_ALL, dist:2, color:-1};
				break;
				
				case 14:
				//wolv - destroy - direction all - 1
				specialTileData = {type:Config.PUP_TYPE_DESTROY, dir:Config.DIR_ALL, dist:1, color:Config.COLOR_ALL};
				break;
				
				case 15:
				//hulk - set color - color type rnd - all
				
				//specialTileData = {type:Config.PUP_TYPE_COLOR, dir:Config.DIR_ALL, dist:-1, color:-1};
				specialTileData = {type:Config.PUP_TYPE_DESTROY, dir:Config.DIR_ROWS, dist:-1, color:Config.COLOR_ALL};
				break;
				
				case 16:
				//doom - destroy - block type - all
				specialTileData = {type:Config.PUP_TYPE_DESTROY, dir:Config.DIR_ALL, dist:-1, color:Config.BLOCK_TYPES-1};
				break;
				
				case 17:
				//galactus - destroy - direction all - 3
				//specialTileData = {type:Config.PUP_TYPE_DESTROY, dir:Config.DIR_ALL, dist:2, color:Config.COLOR_ALL};
				
				//specialTileData = {type:Config.PUP_TYPE_DESTROY, dir:Config.DIR_ROWS, dist:-1, color:Config.COLOR_ALL};
				specialTileData = {type:Config.PUP_TYPE_COLOR, dir:Config.DIR_ALL, dist:-1, color:-1};
				break;
				
				//destroy color - whole board, just needs color type
				//destroy direction - need direction and distance
				//set color - need distance (1 or all), and color (specific or random)
				
			}
			specialTileData.locX = x;
			specialTileData.locY = y;
			
			heroAnimation.playAnim(gems[x][y].type, x, y, gemOverDir, specialTileData.color);
			//trigger the special animation and do a pause with the code
			//  call specialDestroy instead 
			startGemsTime = NewTimer.getTimer();
			
			gemsTimer = new NewTimer(1, 0);
			gemsTimer.addEventListener(TimerEvent.TIMER, onSpecialTileTime);
			gemsTimer.start();
		}
		
		private function onSpecialTileTime(timerEvent:TimerEvent):void {
			timerEvent.updateAfterEvent();
			
			//see if we've waited long enough
			//  and call the action method
			if (!doSpecTileWait()) return;
			
			combo = 0;
			
			gemsTimer.stop();
			
			//trace("spec wait done.  specialTileData=" + specialTileData.type);
			//do color change
			//  start a new timer
			if (checkSpecialColor()) return;
			
			//trace("  no color, checking destroy");
			//after color change is finished, check for destroy
			
			if(!checkSpecialDestroy()) {
				//?
				//do we jump to color here?
			}
			
			
			
			/*
			if(!checkDestroy()) {
				soundSwap.play();
				
				startUnswapGems();
			}
			*/
			
			//do final actions here, such as clean up
			//if we call checkDestroy here, it will branch off if there's something to destroy, otherwise it will call false
			//in which case we want to do any other cleanup needed
			
			//if type color, add tiles to a color change list
			
			//clear special
		}
		
		private function doSpecTileWait():Boolean {
			var time:int = NewTimer.getTimer();
			var ratio:Number = (time - startGemsTime) / Config.PUP_WAITTIME;
			
			if(ratio > 1) ratio = 1;
			
			if(ratio < 1) return false;
			
			//swapGems(swappingGems[0].indexX, swappingGems[0].indexY, swappingGems[1].indexX, swappingGems[1].indexY);
			//call function to add special destroys to group
			//doSpecialTileResult();
			
			return true;
		}
		
		
		private function startSwapGems(x1:int, y1:int, x2:int, y2:int):void {
			unsetControl();
			
			selectedX = -1;
			selectedY = -1;
			
			highlight.visible = false;
			
			swappingGems = [ gems[x1][y1], gems[x2][y2] ];
			
			gems[x1][y1].flipAnim();
			gems[x2][y2].flipAnim();
			
			startGemsTime = NewTimer.getTimer();
			
			gemsTimer = new NewTimer(1, 0);
			gemsTimer.addEventListener(TimerEvent.TIMER, onSwapGemsTime);
			gemsTimer.start();
		}
		
		private function onSwapGemsTime(timerEvent:TimerEvent):void {
			timerEvent.updateAfterEvent();
			
			if(!doSwapGems()) return;
			
			combo = 0;
			
			gemsTimer.stop();
			
			if(!checkDestroy()) {
				//soundSwap.play();
				
				startUnswapGems();
			}
		}
		
		private function doSwapGems():Boolean {
			var time:int = NewTimer.getTimer();
			var ratio:Number = (time - startGemsTime) / Config.GEMS_SWAPTIME;
			var distance:Number;
			var i:int;
			
			if(ratio > 1) ratio = 1;
			
			distance = ratio * Config.BLOCKSIZE;
			
			var colOffset:Number = 0;
			var colYOffset:Number = 0;
			
			/*
			for(i=0;i<2;i++) {
				swappingGems[i].x = swappingGems[i].indexX * Config.BLOCKSIZE + Config.BLOCKSIZE / 2 + distance * (swappingGems[1 - i].indexX - swappingGems[i].indexX);
				if (swappingGems[1 - i].indexX%2 > 0) {
					colOffset = 0.5;
				} else {
					colOffset = 0;
				}
				trace("i=" + i + ", indexX=" + swappingGems[i].indexX + ", indexY=" + swappingGems[i].indexY);
				if (swappingGems[i].indexX != swappingGems[1-i].indexX) {
					colYOffset = 0.5;
				} else {
					colYOffset = 0;
				}
				//swappingGems[i].y = swappingGems[i].indexY * Config.BLOCKSIZE + Config.BLOCKSIZE / 2 + Config.BLOCKSIZE * colOffset + distance * (swappingGems[1 - i].indexY - swappingGems[i].indexY);
				//swappingGems[i].y = swappingGems[i].indexY * Config.BLOCKSIZE + Config.BLOCKSIZE / 2 + Config.BLOCKSIZE * colOffset + distance * (swappingGems[1 - i].indexY - swappingGems[i].indexY); //  - colYOffset
				swappingGems[i].y = swappingGems[i].indexY * Config.BLOCKSIZE + Config.BLOCKSIZE / 2 + Config.BLOCKSIZE * colOffset + distance * (swappingGems[1 - i].indexY - swappingGems[i].indexY);
			}
			*/
			//trace("x=" + swappingGems[0].x +", calc=" + (swappingGems[0].indexX * Config.BLOCKSIZE + Config.BLOCKSIZE / 2));
			//trace("ratio=" + ratio);
			for(i=0;i<2;i++) {
				if (swappingGems[1 - i].indexX%2 > 0) {
					colOffset = 0.5;
				} else {
					colOffset = 0;
				}
				if (swappingGems[i].indexX%2 > 0) {
					colYOffset = 0.5;
				} else {
					colYOffset = 0;
				}
				swappingGems[i].x = (swappingGems[i].indexX * Config.BLOCKSIZE + Config.BLOCKSIZE / 2) + (((swappingGems[1-i].indexX * Config.BLOCKSIZE + Config.BLOCKSIZE / 2) - (swappingGems[i].indexX * Config.BLOCKSIZE + Config.BLOCKSIZE / 2)) * ratio);
				swappingGems[i].y = (swappingGems[i].indexY * Config.BLOCKSIZE + Config.BLOCKSIZE / 2 + Config.BLOCKSIZE * colYOffset) + (((swappingGems[1-i].indexY * Config.BLOCKSIZE + Config.BLOCKSIZE / 2 + Config.BLOCKSIZE * colOffset) - (swappingGems[i].indexY * Config.BLOCKSIZE + Config.BLOCKSIZE / 2 + Config.BLOCKSIZE * colYOffset)) * ratio);
			}
			
			
			
			if(ratio < 1) return false;
			
			swapGems(swappingGems[0].indexX, swappingGems[0].indexY, swappingGems[1].indexX, swappingGems[1].indexY);
			
			return true;
		}
		
		private function startUnswapGems():void {
			SoundManager.getInstance().play(SoundManager.INCORRECT_SWAP);
			startGemsTime = NewTimer.getTimer();
			
			gemsTimer = new NewTimer(1, 0);
			gemsTimer.addEventListener(TimerEvent.TIMER, onUnswapGemsTime);
			gemsTimer.start();
		}
		
		private function onUnswapGemsTime(timerEvent:TimerEvent):void {
			timerEvent.updateAfterEvent();
			
			if(!doSwapGems()) return;
			
			gemsTimer.stop();
			
			setControl();
		}
		
		private function checkDestroy():Boolean {
			var groups:Array = getFormedGroups();
			var scoreAwarded:int;
			var minX:Number, maxX:Number, minY:Number, maxY:Number;
			var i:int, j:int;
			
			if(groups.length == 0) return false;
			
			minX = dimensionX * Config.BLOCKSIZE;
			minY = dimensionY * Config.BLOCKSIZE;
			maxX = 0;
			maxY = 0;
			
			scoreAwarded = Config.SCORE_GROUP * groups.length;
			scoreAwarded += Config.SCORE_EXTRAGROUP * (groups.length - 1);
			
			destroyingGems = new Array();
			
			var bAwardMatch:Boolean = false;
			
			for(i=0;i<groups.length;i++) {
				if(groups[i].length > Config.GROUPSIZE) scoreAwarded += (groups[i].length - Config.GROUPSIZE) * Config.SCORE_EXTRAGEM;
				
				bAwardMatch = false;
				
				for(j=0;j<groups[i].length;j++) {
					if(getIndexInArray(destroyingGems, groups[i][j]) != -1) continue;
					
					bAwardMatch = true;
					destroyingGems.push(groups[i][j]);
					
					backgrounds[groups[i][j].indexX][groups[i][j].indexY].setFinished();
					
					if(groups[i][j].x < minX) minX = groups[i][j].x;
					if(groups[i][j].y < minY) minY = groups[i][j].y;
					if(groups[i][j].x > maxX) maxX = groups[i][j].x;
					if(groups[i][j].y > maxY) maxY = groups[i][j].y;
				}
				if (bAwardMatch) {
					matches = matches + 1;
					timeDisplay.setCurProgress(matches);
				}
			}
			
			//scoreAwarded += Config.SCORE_COMBO * combo;
			if (combo > 0) {
				scoreAwarded += Config.SCORE_COMBO;
				scoreAwarded *= combo;
			}
			
			score += scoreAwarded;
			
			createScorePopup((minX + maxX) / 2, (minY + maxY) / 2, scoreAwarded, combo);
			
			combo++;
			
			//soundGroup.play();
			prepDestroyGems();
			
			startGemsTime = NewTimer.getTimer();
			
			gemsTimer = new NewTimer(1, 0);
			gemsTimer.addEventListener(TimerEvent.TIMER, onDestroyTime);
			gemsTimer.start();
			
			return true;
		}
		
		private function getDirectionSteps(dir:int):Array {
			var tReturn:Array;
			switch (dir) {
				case Config.DIR_UP:
				tReturn = [0,-1];
				break;
				case Config.DIR_UPRIGHT:
				tReturn = [1,-1];  //1,-1
				break;
				case Config.DIR_DOWNRIGHT:
				tReturn = [1,1];
				break;
				case Config.DIR_DOWN:
				tReturn = [0,1];
				break;
				case Config.DIR_DOWNLEFT:
				tReturn = [-1,1];
				break;
				case Config.DIR_UPLEFT:
				tReturn = [-1,-1];  //-1,-1
				break;
			}
			
			return tReturn;
		}
		
		private function checkSpecialColor():Boolean {
			//if the special is a color special, mark that, otherwise return false
			if (specialTileData.type != Config.PUP_TYPE_COLOR) return false;
			
			//specialTileData = {type:Config.PUP_TYPE_COLOR, dir:Config.DIR_ALL, dist:-1, color:-1};
			//specialTileData = {type:Config.PUP_TYPE_COLOR, dir:Config.DIR_ALL, dist:1, color:0};
			//add all colors to list of tiles for transformation
			var groups:Array = new Array();
			var group:Array;
			
			var directions:Array = new Array();
			if (specialTileData.dist > 0) {
				if (specialTileData.dir == Config.DIR_ALL) {
					//for distance, add in all directions
					//add all directions to list
					directions.push(getDirectionSteps(Config.DIR_UP));
					directions.push(getDirectionSteps(Config.DIR_UPRIGHT));
					directions.push(getDirectionSteps(Config.DIR_DOWNRIGHT));
					directions.push(getDirectionSteps(Config.DIR_DOWN));
					directions.push(getDirectionSteps(Config.DIR_DOWNLEFT));
					directions.push(getDirectionSteps(Config.DIR_UPLEFT));
				} else {
					//add just the specific direction to list
					directions.push(getDirectionSteps(specialTileData.dir));
				}
			}
			//loop through list of directions
			var stepX:Number;
			var stepY:Number;
			var incYStep:Number;
			var floorY:Number;
			var b:int;
			var c:int;
			for (b = 0; b < directions.length; b++) {
				//for distance, add gems in direction to destroy list
				group = new Array();
				stepX = specialTileData.locX;
				stepY = specialTileData.locY;
				if (directions[b][0] == 0) {
					incYStep = directions[b][1];
				} else {
					incYStep = 0.5;
					if (directions[b][1] == 1) {
						if (stepX % 2 == 1) {
							stepY += incYStep;
						}
					}
					if (directions[b][1] == -1) {
						incYStep *= -1;
						if (stepX % 2 == 0) {
							stepY += incYStep;
						}
					}
				}
				stepX += directions[b][0];
				stepY += incYStep;
				floorY = Math.floor(stepY);
				if (incYStep < 0) {
					floorY = Math.ceil(stepY);
				}
				//trace("    direction=" + directions[b] + ", incYStep=" + incYStep);
				for (c = 0; c < specialTileData.dist; c++) {
					//trace("      ["+c+"] step=" + stepX + "," + floorY + "   (" + stepY + ")");
					if (stepX > -1 && stepX < dimensionX && stepY > -1 && stepY < dimensionY) {
						//count from the locX,Y in the direction indicated
						//if color is -1, add all
						//if color is specific, only add if gem type matches
						//if (specialTileData.color == Config.COLOR_ALL || specialTileData.color == gems[stepX][floorY].type) {
						group.push(gems[stepX][floorY]);
						//}
						stepX += directions[b][0];
						stepY += incYStep;
						floorY = Math.floor(stepY);
						if (incYStep < 0) {
							floorY = Math.ceil(stepY);
						}
					}
				}
				if (group.length > 0) {
					groups.push(group);
				}
			}
			//if dist < 0 and dir = all, search whole grid for color/type match
			//  loop through the entire grid size
			if (specialTileData.dist < 0 && specialTileData.dir == Config.DIR_ALL) {
				for (b = 0; b < dimensionX; b++) {
					for (c = 0; c < dimensionY; c++) {
						//if (gems[b][c].type == specialTileData.color) {
						group = new Array();
						group.push(gems[b][c]);
						groups.push(group);
						//}
					}
				}
			}
			//
			
			var isColorAllGems:Boolean = (specialTileData.dist < 0 && specialTileData.dir == Config.DIR_ALL);
			//now loop through all and set color
			aGemsToFlipAnim = new Array();
			var bTech:Boolean = false;
			for (b = 0; b < groups.length; b++) {
				for (c = 0; c < groups[b].length; c++) {
					if (groups[b][c].type < Config.BLOCK_TYPES || isColorAllGems) {
						if (isColorAllGems && groups[b][c].indexX == specialTileData.locX && groups[b][c].indexY == specialTileData.locY) continue;
						if (groups[b][c].type == Config.BLOCK_TYPES-1) {
							nCurNumBlock--;
							bTech = true;
						}
						if (groups[b][c].type >= Config.BLOCK_TYPES) {
							nCurNumSpec--;
							nSpecDestroyed++;
						}
						
						if (specialTileData.color == Config.COLOR_ALL) {
							//groups[b][c].setRandomType();
							groups[b][c].setRandomType(nLevelColorsMax);
						} else {
							groups[b][c].setType(specialTileData.color);
						}
						
						aGemsToFlipAnim.push(groups[b][c]);
					}
				}
			}
			if (bTech) {
				SoundManager.getInstance().play(SoundManager.TECH_POD_DESTROY);
			} else {
				SoundManager.getInstance().play(SoundManager.SHIP_FADE_OUT);
			}
			for (b = 0; b < aGemsToFlipAnim.length; b++) {
				//trace("aGemsToFlipAnim["+b+"] = " + aGemsToFlipAnim[b].indexX + "," + aGemsToFlipAnim[b].indexY);
				if (aGemsToFlipAnim[b] != null) {
					aGemsToFlipAnim[b].flip2Anim();
				}
			}
			if (aGemsToFlipAnim.length > 0) {
				aGemsToFlipAnim = new Array();
			}
			
			
			if (gems[specialTileData.locX][specialTileData.locY].type == Config.GEM_TYPE_RND_COLOR1) {
				nCurNumSpec--;
				nSpecDestroyed++;
				gems[specialTileData.locX][specialTileData.locY].setType(specialTileData.color);
			}
			
			//set timer to animate color change
			//soundGroup.play();
			
			//startGemsTime = NewTimer.getTimer();
			
			gemsTimer = new NewTimer(1, 0);
			gemsTimer.addEventListener(TimerEvent.TIMER, onSpecialColorTime);
			gemsTimer.start();
			
			return true;
		}
		
		private function onSpecialColorTime(timerEvent:TimerEvent):void {
			var time:int = NewTimer.getTimer();
			var ratio:Number = (time - startGemsTime) / Config.PUP_COLORWAITTIME;
			var i:int;
			//trace("onSpecialColorTime time="+ time + ", startGemsTime=" + startGemsTime + ", /PUP_COLORWAITTIME=" + Config.PUP_COLORWAITTIME);
			if(ratio > 1) ratio = 1;
			
			timerEvent.updateAfterEvent();
			
			if(ratio >= 1) {
				gemsTimer.stop();
				
				finishedSpecialColor();
			}
		}
		
		public function gridColorCollision(dir:int):Boolean {
			//find location of the gem in direction indicated
			var tLocX:int = specialTileData.locX;
			var tLocY:int = specialTileData.locY;
			var tStepX:int = 0;
			var tStepY:int = 0;
			switch (dir) {
				case 0:
					tStepY = -1;
					break;
				case 1:
					//if row, x,y or not
					if (tLocX % 2 == 1) {
						tStepX = 1;
					} else {
						tStepX = 1;
						tStepY = -1;
					}
					break;
				case 2:
					if (tLocX % 2 == 1) {
						tStepX = 1;
						tStepY = 1;
					} else {
						tStepX = 1;
					}
					break;
				case 3:
					tStepY = 1;
					break;
				case 4:
					if (tLocX % 2 == 1) {
						tStepX = -1;
						tStepY = 1;
					} else {
						tStepX = -1;
					}
					break;
				case 5:
					if (tLocX % 2 == 1) {
						tStepX = -1;
					} else {
						tStepX = -1;
						tStepY = -1;
					}
					break;
			}
			
			//set color based on special type
			var bTech:Boolean = false;
			if ((tLocX+tStepX) > -1 && (tLocX+tStepX) < gems.length && (tLocY+tStepY) > -1 && (tLocY+tStepY) < gems[0].length) {
				if (gems[tLocX+tStepX][tLocY+tStepY].type < Config.BLOCK_TYPES) {
					if (gems[tLocX+tStepX][tLocY+tStepY].type == Config.BLOCK_TYPES-1) {
						nCurNumBlock--;
						bTech = true;
					}
					if (specialTileData.color == Config.COLOR_ALL) {
						gems[tLocX+tStepX][tLocY+tStepY].setRandomType(nLevelColorsMax);
					} else {
						gems[tLocX+tStepX][tLocY+tStepY].setType(specialTileData.color);
					}
				}
			}
			if (bTech) {
				SoundManager.getInstance().play(SoundManager.TECH_POD_DESTROY);
			} else {
				SoundManager.getInstance().play(SoundManager.SHIP_FADE_OUT);
			}
			
			return true;
			
		}
		
		public function gridDestroyCollision(dir:int):Boolean {
			//trace("gridDestroyCollision(dir=" + dir + ")");
			if (gemOverDir == dir) {
				startGemsTime -= Config.PUP_COLORWAITTIME * 3;
				return true;
			}
			return false;
		}
		
		public function gridAllCollision():void {
			//trace("gridAllCollision");
			startGemsTime -= Config.PUP_COLORWAITTIME * 3;
		}
		
		private function finishedSpecialColor():void {
			if(!checkSpecialDestroy()) {
			}
		}
		
		private function checkSpecialDestroy():Boolean {
			/*
			specialTileData = {type:Config.PUP_TYPE_DESTROY, dir:Config.DIR_ALL, dist:1, color:-1};
			specialTileData = {type:Config.PUP_TYPE_COLOR, dir:Config.DIR_ALL, dist:-1, color:-1};
			specialTileData.locX = x;
			specialTileData.locY = y;
			*/
			
			//trace("checkSpecialDestroy() specialTileData loc=" + specialTileData.locX + "," + specialTileData.locY);
			//trace("  type:" + specialTileData.type + ", dir:" + specialTileData.dir + ", dist:" + specialTileData.dist + ", color:" + specialTileData.color);
			//add special tile location to destroy list
			var groups:Array = new Array();
			
			var bIsColorBunch:Boolean = false;
			//specialTileData = {type:Config.PUP_TYPE_COLOR, dir:Config.DIR_ALL, dist:1, color:gems[x][y].colorType}
			if (specialTileData.type == Config.PUP_TYPE_COLOR && specialTileData.color != -1) {
				bIsColorBunch = true;
			}
			/*
			if (gems[specialTileData.locX][specialTileData.locY].type != Config.GEM_TYPE_RND_COLOR1) {
				var group:Array = [gems[specialTileData.locX][specialTileData.locY]];
				groups.push(group);
			}
			*/
			
			//var isColorAllGems:Boolean = (specialTileData.dist < 0 && specialTileData.dir == Config.DIR_ALL);
			
			if (!bIsColorBunch) {
				var group:Array = [gems[specialTileData.locX][specialTileData.locY]];
				groups.push(group);
			}
			
			
			//else if, do we need to add the whole set to a group?
			
			//if type destroy, all other tiles to destroy list, by direction param and color param
			if (specialTileData.type == Config.PUP_TYPE_DESTROY) {
				var directions:Array = new Array();
				if (specialTileData.dist > 0) {
					if (specialTileData.dir == Config.DIR_ALL) {
						//for distance, add in all directions
						//add all directions to list
						directions.push(getDirectionSteps(Config.DIR_UP));
						directions.push(getDirectionSteps(Config.DIR_UPRIGHT));
						directions.push(getDirectionSteps(Config.DIR_DOWNRIGHT));
						directions.push(getDirectionSteps(Config.DIR_DOWN));
						directions.push(getDirectionSteps(Config.DIR_DOWNLEFT));
						directions.push(getDirectionSteps(Config.DIR_UPLEFT));
					} else {
						//add just the specific direction to list
						directions.push(getDirectionSteps(specialTileData.dir));
					}
				}
				//trace("    directions=" + directions);
				//loop through list of directions
				var stepX:Number;
				var stepY:Number;
				var incYStep:Number;
				var floorY:Number;
				var b:int;
				var c:int;
				for (b = 0; b < directions.length; b++) {
					//for distance, add gems in direction to destroy list
					group = new Array();
					stepX = specialTileData.locX;
					stepY = specialTileData.locY;
					if (directions[b][0] == 0) {
						incYStep = directions[b][1];
					} else {
						incYStep = 0.5;
						if (directions[b][1] == 1) {
							if (stepX % 2 == 1) {
								stepY += incYStep;
							}
						}
						if (directions[b][1] == -1) {
							incYStep *= -1;
							if (stepX % 2 == 0) {
								stepY += incYStep;
							}
						}
					}
					stepX += directions[b][0];
					stepY += incYStep;
					floorY = Math.floor(stepY);
					if (incYStep < 0) {
						floorY = Math.ceil(stepY);
					}
					//trace("    direction=" + directions[b] + ", incYStep=" + incYStep);
					for (c = 0; c < specialTileData.dist; c++) {
						//trace("      ["+c+"] step=" + stepX + "," + floorY + "   (" + stepY + ")");
						if (stepX > -1 && stepX < dimensionX && stepY > -1 && stepY < dimensionY) {
							//count from the locX,Y in the direction indicated
							//if color is -1, add all
							//if color is specific, only add if gem type matches
							if (specialTileData.color == Config.COLOR_ALL || specialTileData.color == gems[stepX][floorY].type) {
								group.push(gems[stepX][floorY]);
							}
							stepX += directions[b][0];
							stepY += incYStep;
							floorY = Math.floor(stepY);
							if (incYStep < 0) {
								floorY = Math.ceil(stepY);
							}
						}
					}
					if (group.length > 0) {
						groups.push(group);
					}
				}
				//if dist < 0 and dir = all, search whole grid for color/type match
				//  loop through the entire grid size
				var tRowStart:int = 0;
				var tRowEnd:int = dimensionY;
				if (specialTileData.dist < 0 && specialTileData.dir <= Config.DIR_ALL) {
					for (b = 0; b < dimensionX; b++) {
						if (specialTileData.dir == Config.DIR_ROWS) {
							//gems[specialTileData.locX][specialTileData.locY]
							tRowStart = Math.max(specialTileData.locY - 1, 0);
							tRowEnd = Math.min(specialTileData.locY + 2, dimensionY);
						} else {
							tRowStart = 0;
							tRowEnd = dimensionY;
						}
						for (c = tRowStart; c < tRowEnd; c++) {
							if (specialTileData.color == Config.COLOR_ALL || gems[b][c].type == specialTileData.color) {
								group = new Array();
								group.push(gems[b][c]);
								groups.push(group);
							}
						}
					}
				}
				//
			}
			
			
			
			//now do normal destroy routine - allows us to customize this for score purposes for specials
			
			var scoreAwarded:int;
			var minX:Number, maxX:Number, minY:Number, maxY:Number;
			var i:int, j:int;
			
			if(!bIsColorBunch && groups.length == 0) return false;
			
			minX = dimensionX * Config.BLOCKSIZE;
			minY = dimensionY * Config.BLOCKSIZE;
			maxX = 0;
			maxY = 0;
			
			scoreAwarded = Config.SCORE_GROUP * groups.length;
			scoreAwarded += Config.SCORE_EXTRAGROUP * (groups.length - 1);
			
			destroyingGems = new Array();
			
			for(i=0;i<groups.length;i++) {
				if(groups[i].length > Config.GROUPSIZE) scoreAwarded += (groups[i].length - Config.GROUPSIZE) * Config.SCORE_EXTRAGEM;
				
				for(j=0;j<groups[i].length;j++) {
					if(getIndexInArray(destroyingGems, groups[i][j]) != -1) continue;
					
					if ((groups[i][j].indexX == specialTileData.locX && groups[i][j].indexY == specialTileData.locY) || groups[i][j].type < Config.BLOCK_TYPES || gems[specialTileData.locX][specialTileData.locY].type == Config.PUP_TYPE_9) {
						destroyingGems.push(groups[i][j]);
					}
				
					backgrounds[groups[i][j].indexX][groups[i][j].indexY].setFinished();
					
					if(groups[i][j].x < minX) minX = groups[i][j].x;
					if(groups[i][j].y < minY) minY = groups[i][j].y;
					if(groups[i][j].x > maxX) maxX = groups[i][j].x;
					if(groups[i][j].y > maxY) maxY = groups[i][j].y;
				}
			}
			
			scoreAwarded += Config.SCORE_COMBO * combo;
			
			score += scoreAwarded;
			
			createScorePopup((minX + maxX) / 2, (minY + maxY) / 2, scoreAwarded, combo);
			
			combo++;
			
			//soundGroup.play();
			
			prepDestroyGems();
			
			startGemsTime = NewTimer.getTimer();
			
			gemsTimer = new NewTimer(1, 0);
			gemsTimer.addEventListener(TimerEvent.TIMER, onDestroyTime);
			gemsTimer.start();
			
			return true;
			
		}
		
		
		
		private function getIndexInArray(theArray:Array, thing):int {
			var i:int;
			
			for(i=0;i<theArray.length;i++) {
				if(theArray[i] == thing) return i;
			}
			
			return -1;
		}
		
		private function createScorePopup(x:Number, y:Number, score:int, combo:int):void {
			var scorePopup:ScorePopup = new ScorePopup();
			
			scorePopup.initialize(x, y, score, combo);
			
			scoresHolder.addChild(scorePopup);
			//generateParticleEffect({layer:beamOverLayer, num:10, pace:0, x:scoresHolder.x+x, y:scoresHolder.y+y},true);
			generateParticleEffect({layer:beamOverLayer, num:2+Math.floor(Math.random() * 4), pace:1, x:scoresHolder.x+x, y:scoresHolder.y+y, useTypeColor:true, typeColor:9, gravity:2});
		}
		
		
		private function prepDestroyGems():void {
			if (destroyingGems.length > 0) {
				var i:int;
				var bTech:Boolean = false;
				for(i=0;i<destroyingGems.length;i++) {
					
					var tPartConfig:Object = new Object();
					tPartConfig.layer = beamOverLayer;
					tPartConfig.useTypeColor = true;
					tPartConfig.gravityXLoc = 680;
					tPartConfig.gravityYLoc = 200;
					
					tPartConfig.minSpeedX = 0//-20;
					tPartConfig.maxSpeedX =0// 1;
					tPartConfig.minSpeedY = 0//-10;
					tPartConfig.maxSpeedY = 0//10;
					tPartConfig.pace = 2;
					
					tPartConfig.gravityX = 1.3;
					tPartConfig.gravityY = 1.3;
					//insert gravity point of infinity fractal clip
					
					//tPartConfig.num = 2+Math.floor(Math.random()*4);
					tPartConfig.num = Math.floor((2+Math.floor(Math.random()*4)) * 0.75);
					tPartConfig.x = scoresHolder.x+destroyingGems[i].x;
					tPartConfig.y = scoresHolder.y+destroyingGems[i].y;
					//trace("gem " + i + "=" + tPartConfig.x + "," + tPartConfig.y);
					if (tPartConfig.x > tPartConfig.gravityXLoc) {
						tPartConfig.gravityX *= -1;
					}
					if (tPartConfig.y > tPartConfig.gravityYLoc) {
						tPartConfig.gravityY *= -1;
					}
					tPartConfig.typeColor = destroyingGems[i].type;
					generateParticleEffect(tPartConfig);
					if (destroyingGems[i].type == Config.BLOCK_TYPES-1) {
						bTech = true;
					}
					destroyingGems[i].destroyAnim();
				}
				if (bTech) {
					SoundManager.getInstance().play(SoundManager.TECH_POD_DESTROY);
				} else {
					SoundManager.getInstance().play(SoundManager.SHIP_FADE_OUT);
				}
			}
			
		}
		
		private function onDestroyTime(timerEvent:TimerEvent):void {
			var time:int = NewTimer.getTimer();
			var ratio:Number = (time - startGemsTime) / Config.GEMS_DESTROYTIME;
			var i:int;
			
			//trace("onDestroyTime");
			if(ratio > 1) ratio = 1;
			
			timerEvent.updateAfterEvent();
			
			for(i=0;i<destroyingGems.length;i++) {
				destroyingGems[i].scaleX = 1 - ratio;
				destroyingGems[i].scaleY = 1 - ratio;
				//destroyingGems[i].rotation = ratio * Config.GEMS_DESTROYROTATE;
			}
			
			if(ratio >= 1) {
				gemsTimer.stop();
				
				finishedDestroy();
			}
		}
		
		private function finishedDestroy():void {
			var x:int, y:int;
			var i:int;
			
			for(i=0;i<destroyingGems.length;i++) {
				x = destroyingGems[i].indexX;
				y = destroyingGems[i].indexY;
				
				if (gems[x][y].type == Config.BLOCK_TYPES-1) {
					nCurNumBlock--;
				}
				if (gems[x][y].type >= Config.BLOCK_TYPES) {
					nCurNumSpec--;
					nSpecUsed++;
				}
				
				gems[x][y] = null;
				
				gemsHolder.removeChild(destroyingGems[i]);
			}
			
			if (tutorial.bActive) {
				tutorial.actionTaken("destroy");
			}
			createNewGems();
			
			startGemsTime = NewTimer.getTimer();
			
			gemsTimer = new NewTimer(1, 0);
			gemsTimer.addEventListener(TimerEvent.TIMER, onFallTime);
			gemsTimer.start();
		}
		
		private function createNewGems():void {
			var noOfSteps:int;
			var gem:Gem;
			var i:int, j:int, k:int;
			
			fallingGems = new Array();
			
			var colOffset:Number = 0;
			
			for(i=0;i<dimensionX;i++) {
				noOfSteps = 0;
				
				if (i%2 > 0) {
					colOffset = 0.5;
				} else {
					colOffset = 0;
				}
				
				var rndType:Number;
				/*
				var nPointTotal:Number = 1;
				var nPointBase:Number = 1;
				var l:int;
				if (nLevelBlockFreq > 0) {
					nPointTotal += nLevelBlockFreq;
					nPointBase += nLevelBlockFreq;
				}
				if (nLevelSpecialMax > Config.BLOCK_TYPES) {
					for (l = 0; l < aLevelSpecialFreq.length; l++) {
						if (aLevelSpecialFreq[l] > 0) {
							nPointTotal += aLevelSpecialFreq[l];
						}
					}
				}
				*/
				var bError:Boolean = false;
				var tSpecMax:Number;
				var l:int;
				var tRndSpec:Number;
				var tSpecCur:Number;
				for(j=dimensionY-1;j>=-1;j--) {
					if(j == -1 || !backgrounds[i][j]) {
						if(noOfSteps > 0) {
							for(k=0;k<noOfSteps;k++) {
								gem = new Gem();
								gem.initialize(i, j + noOfSteps - k, noOfSteps - k);
								
								//new piece selection logic
								//	nLevelColorsMax = current highest color
								
								//  nLevelBlockFreq
								//  nPointBase
								//  aLevelSpecialFreq
								
								
								//FINAL PIECE LOGIC
								/*
								*/
								rndType = Math.random() * 1;
								if (nCurNumSpec < nMaxNumSpec && rndType < nLevelSpecialFreq) {
									//then if it's a hero, heroes should have individual frequency, also looking at level to make sure it's available.
									//  start with not adjusting hero frequency per level, see what happens.
									//gem.setType(Config.BLOCK_TYPES + l);
									//nLevelSpecialFreq
									//aLevelSpecialFreq
									//now scale the available special pieces into a max rnd number
									tSpecMax = 0;
									bError = true;
									for (l = 0; l < aLevelSpecialFreq.length; l++) {
										tSpecMax += aLevelSpecialFreq[l];
										if (aLevelSpecialFreq[l] <= 0) {
											break;
										}
									}
									tRndSpec = Math.random() * tSpecMax;
									tSpecCur = 0;
									for (l = 0; l < aLevelSpecialFreq.length; l++) {
										tSpecCur += aLevelSpecialFreq[l];
										if (tRndSpec < tSpecCur) {
											gem.setType(Config.BLOCK_TYPES + l, nLevelColorsMax);
											bError = false;
											break;
										}
										if (aLevelSpecialFreq[l] <= 0) {
											break;
										}
									}
									if (bError) {
										gem.setType(Config.BLOCK_TYPES + 0, nLevelColorsMax);
									}
									nCurNumSpec++;
								} else if (nCurNumBlock < nMaxNumBlock && rndType < nLevelSpecialFreq + nLevelBlockFreq) {
									//block and hero piece frequency should be overall for level
									//  each round we should know 1/10 pieces are blocker, etc.
									//  first, check for level, see that blockers are available.
									//  second, look at block frequency.
									//nLevelBlockFreq
									gem.setBlockType();
									nCurNumBlock++;
								} else {
									//normal piece
									gem.setRandomType(nLevelColorsMax);
								}
								
								
								
								//OLD
								//start, ramping piece selection
								/*
								rndType = Math.random() * nPointTotal;
								if (rndType <= 1.0) {
									//normal piece
									//pass info down to gem
									gem.setRandomType(nLevelColorsMax);
								} else if (nLevelBlockFreq > 0 && rndType < nPointBase) {
									//blocker
									gem.setBlockType();
								} else {
									//special
									//pass info down to gem
									//gem.setPowerupType();
									bError = true;
									for (l = 0; l < aLevelSpecialFreq.length; l++) {
										if (aLevelSpecialFreq[l] > 0) {
											if (rndType < nPointBase + aLevelSpecialFreq[l]) {
												gem.setType(Config.BLOCK_TYPES + l);
												bError = false;
												break;
											}
											nPointBase += aLevelSpecialFreq[l];
										}
									}
									if (bError) {
										gem.setBlockType();
									}
								}
								*/
								//end normal piece selection
								
		/*
			levelMatchesRequired = Config.LEVEL_MATCHES_REQ_BASE + ((level-1) * Config.LEVEL_MATCHES_REQ_MULT);
			nLevelColorsMax = Math.min(Config.LEVEL_COLORS_BASE + (level-1), Config.GEMS_TYPES);
			nLevelBlockFreq = (level-1) * Config.LEVEL_BLOCK_FREQ;
			nLevelSpecialMax = Math.min(Config.BLOCK_TYPES - 2 + level, Config.POWERUP_TYPES);
			aLevelSpecialFreq = [(level-1) * Config.SPEC_FREQ_1, (level-2) * Config.SPEC_FREQ_2, (level-3) * Config.SPEC_FREQ_3, (level-4) * Config.SPEC_FREQ_4, (level-5) * Config.SPEC_FREQ_5, (level-6) * Config.SPEC_FREQ_6, (level-7) * Config.SPEC_FREQ_7, (level-8) * Config.SPEC_FREQ_8, (level-9) * Config.SPEC_FREQ_9];
		*/
								//start display-debug piece selection
								/*
								//decide if we should be a blocker or a powerup.
								rndType = Math.random();
								//trace("test 1: " + rndType);
								if (rndType < nLevelBlockFreq) {
									gem.setBlockType();
								} else {
									rndType = Math.random();
									//trace("test 2: " + rndType);
									if (rndType < 0.2) {
										gem.setPowerupType();
									} else {
										gem.setRandomType(nLevelColorsMax);
									}
								}
								//end debug piece selection
								*/
								
								
								
								
								
								//trace("gem["+gem.indexX + "," + gem.indexY + "] x=" + gem.x);
								if (gem.type >= Config.BLOCK_TYPES) {
									gem.startFallX = Config.GEM_PUP_START_X;
								} else {
									gem.startFallX = Config.GEM_START_X;
								}
								gem.endFallX = gem.x;
								
								//gem.startFallY = (j - k) * Config.BLOCKSIZE + Config.BLOCKSIZE / 2 + Config.BLOCKSIZE * colOffset;
								if (gem.type >= Config.BLOCK_TYPES) {
									gem.startFallY = Config.GEM_PUP_START_Y;
								} else {
									gem.startFallY = Config.GEM_START_Y;
								}
								gem.endFallY = (j + noOfSteps - k) * Config.BLOCKSIZE + Config.BLOCKSIZE / 2 + Config.BLOCKSIZE * colOffset;
								
								gem.x = gem.startFallX;
								gem.y = gem.startFallY;
								
								gemsHolder.addChild(gem);
								
								fallingGems.push(gem);
							}
							
							noOfSteps = 0;
						}
					} else if(!gems[i][j]) {
						noOfSteps++;
						
					} else if(noOfSteps > 0) {
						gems[i][j].indexY += noOfSteps;
						
						gems[i][j].startFallX = gems[i][j].x;
						gems[i][j].endFallX = gems[i][j].x;
						
						gems[i][j].startFallY = gems[i][j].y;
						//gems[i][j].startFallY = gems[i][j].indexY * Config.BLOCKSIZE + Config.BLOCKSIZE / 2 + Config.BLOCKSIZE * colOffset;
						gems[i][j].endFallY = gems[i][j].indexY * Config.BLOCKSIZE + Config.BLOCKSIZE / 2 + Config.BLOCKSIZE * colOffset;
						
						fallingGems.push(gems[i][j]);
						
						gems[i][j] = null;
					}
				}
			}
			if (fallingGems.length > 0) {
				mothershipGlowClip.gotoAndPlay("on");
			}
		}
		
		private function onFallTime(timerEvent:TimerEvent):void {
			var time:int = NewTimer.getTimer();
			var dTime:int = time - startGemsTime;
			var distance:Number = Config.GEMS_ACCELERATION * dTime * dTime / 2000000;
			var x:Number;
			var y:Number;
			var i:int;
			var ratio:Number;
			
			timerEvent.updateAfterEvent();
			
			for(i=0;i<fallingGems.length;i++) {
				y = fallingGems[i].startFallY + distance;
				
				ratio = (fallingGems[i].endFallY - y) / (fallingGems[i].endFallY - fallingGems[i].startFallY);
				/*
				if (ratio > 0.5) {
					ratio *= 1.2;
					//ratio *= 0.8;
					//ratio += (1-ratio) * 0.2;
				} else {
					ratio *= 0.8;
					//ratio *= 1.2;
				}
				*/
				ratio *= ratio;
				x = fallingGems[i].startFallX + (fallingGems[i].endFallX - fallingGems[i].startFallX) * (1-ratio);
				
				if(y < fallingGems[i].y) continue;
				
				if(y < fallingGems[i].endFallY) {
					fallingGems[i].x = x;
					fallingGems[i].y = y;
					
				} else {
					fallingGems[i].x = fallingGems[i].endFallX;
					fallingGems[i].y = fallingGems[i].endFallY;
					gems[fallingGems[i].indexX][fallingGems[i].indexY] = fallingGems[i];
					
					fallingGems.splice(i, 1);
					i--;
				}
			}
			
			if(fallingGems.length == 0) {
				gemsTimer.stop();
				
				if(!checkDestroy()) {
					if(!checkWin()) {
						if(!checkNoMoreMoves()) {
							setControl();
						}
					}
				}
			}
		}
		
		private function checkNoMoreMoves():Boolean {
			if(getHasMoves()) return false;
			
			timer.stop();
			
			//message.showNoMoreMoves();
			
			startNoMoreMovesTime = NewTimer.getTimer();
			startGemsTime = startNoMoreMovesTime;
			
			gemsTimer = new NewTimer(1, 0);
			gemsTimer.addEventListener(TimerEvent.TIMER, onNoMoreMovesTime);
			gemsTimer.start();
			
			return true;
		}
		
		private function onNoMoreMovesTime(timerEvent:TimerEvent):void {
			var time:int = NewTimer.getTimer();
			var ratio:Number = (time - startGemsTime) / Config.GEMS_DESTROYTIME;
			
			if(ratio > 1) {
				gameOver();
			}
			
		}
			/*
			var ratio:Number = (time - startGemsTime) / Config.GEMS_DESTROYTIME;
			var i:int;
			
			if(ratio > 1) ratio = 1;
			*/
		/*
		private function onNoMoreMovesTime(timerEvent:TimerEvent):void {
			var time:int = NewTimer.getTimer();
			var dTime:int = time - startGemsTime;
			var distance:Number = Config.GEMS_ACCELERATION * dTime * dTime / 2000000;
			var i:int, j:int;
			
			timerEvent.updateAfterEvent();
			
			for(i=0;i<dimensionX;i++) {
				for(j=0;j<dimensionY;j++) {
					if(!gems[i][j]) continue;
					
					gems[i][j].y = j * Config.BLOCKSIZE + Config.BLOCKSIZE / 2 + distance;
				}
			}
			
			if(distance < dimensionY * Config.BLOCKSIZE) return;
			
			gemsTimer.stop();
			
			message.hide();
			
			generateInitialGemTypes();
			
			for(i=0;i<dimensionX;i++) {
				for(j=0;j<dimensionY;j++) {
					if(!gems[i][j]) continue;
					
					gems[i][j].y = j * Config.BLOCKSIZE + Config.BLOCKSIZE / 2 - dimensionY * Config.BLOCKSIZE;
				}
			}
			
			startGemsTime = NewTimer.getTimer();
			
			gemsTimer = new NewTimer(1, 0);
			gemsTimer.addEventListener(TimerEvent.TIMER, onNoMoreMovesGemTime);
			gemsTimer.start();
		}
		*/
		
		private function onNoMoreMovesGemTime(timerEvent:TimerEvent):void {
			timerEvent.updateAfterEvent();
			
			if(!doMoveInitialGems(startGemsTime)) return;
			
			gemsTimer.stop();
			
			startTime += NewTimer.getTimer() - startNoMoreMovesTime;
			
			timer = new NewTimer(1, 0);
			timer.addEventListener(TimerEvent.TIMER, onPlayTime);
			timer.start();
			
			setControl();
		}
		
		private function checkWin():Boolean {
			/*
			var i:int, j:int;
			for(i=0;i<dimensionX;i++) {
				for(j=0;j<dimensionY;j++) {
					if(!backgrounds[i][j]) continue;
					
					if(!backgrounds[i][j].finished) return false;
				}
			}
			*/
			if (matches < levelMatchesRequired) {
				return false;
			}
			
			trackFinalScoreEvent();
			Object(mcParent).trackLevelEvent(level, "complete", Math.floor((NewTimer.getTimer() - nTrackLevelStartTime)/1000));
			
			
			//score += (Config.SCORE_LEVEL * level);
			nWin_Level = (Config.SCORE_LEVEL * level);
			nWin_Hero = numHerosInGrid() * Config.SCORE_UNUSED_SPECIAL;
			message.showLevelClear(score, nWin_Level, nWin_Hero);
			SoundManager.getInstance().play(SoundManager.LEVEL_COMPLETE);
		
			//timeDisplay.setTime(1);
			//timeDisplay.setTimeText(1, levelTime);
			
			trackLevelWinEvent();
			
			//soundLevelClear.play();
			
			timer.stop();
			
			startTime = NewTimer.getTimer();
			
			timer = new NewTimer(1, 0);
			//timer.addEventListener(TimerEvent.TIMER, onLevelClearTime);
			timeDisplay.setFinalState();
			bFinalPlaying = false;
			bBeamFinalDone = false;
			bMotherShipFinalDone = false;
			timer.addEventListener(TimerEvent.TIMER, onLevelDoneWaitTime);
			timer.start();
			
			return true;
		}
		public function winDialogShowLevel():void {
		}
		public function winDialogShowHero():void {
		}
		public function winDialogShowTotal():void {
			score += (nWin_Level + nWin_Hero);
		}
		public function showPlayAgainMenu():void {
			bottomBar.showReplayMenu();
		}
		
		public function trackFinalScoreEvent():void {
			Object(mcParent).trackMiscEvent("score:" + score.toString());
			var mySo:SharedObject = SharedObject.getLocal(Main.MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME);
			if (mySo.data.highScore != undefined && mySo.data.highScore <= score) {
				Object(mcParent).trackAchievementEvent("highscore");
			}
			Object(mcParent).trackMiscEvent("hints_used:" + nHintsUsed.toString());
		}
		public function trackLevelWinEvent():void {
			Object(mcParent).trackMiscEvent("heroes_used:" + nSpecUsed.toString());
			Object(mcParent).trackMiscEvent("heroes_destroyed:" + nSpecDestroyed.toString());
			Object(mcParent).trackMiscEvent("heroes_bonus:" + numHerosInGrid().toString());
		}
		
		public function menuQuitGameEvent():void {
			trace("menuQuitGameEvent");
			//gameOver();
			gameOverFromQuit();
			timer.stop();
			trackFinalScoreEvent();
			Object(mcParent).trackLevelEvent(level, "quit");
			Object(parent).gotoTitlePage();
			
		}
		
		
		public function menuStartGameEvent():void {
			//has same functionality as "playAgainButton"
			playAgainEvent();
			Object(parent).gotoGamePage();
		}
		
		public function mothershipPlayFlyIn():void {
			SoundManager.getInstance().play(SoundManager.SHIP_FLY_IN);
		}
		public function mothershipPlayDoorsOpen():void {
			SoundManager.getInstance().play(SoundManager.SHIP_OPEN);
		}
		public function mothershipPlayDoorsClose():void {
			SoundManager.getInstance().play(SoundManager.SHIP_CLOSE);
		}
		
		public function beamFinalStarted():void {
			bFinalPlaying = true;
		}
		public function beamFinalDone():void {
			bBeamFinalDone = true;
			//have mothership play here
			mothershipClip.gotoAndPlay("leave");
		}
		public function motherShipFinalDone():void {
			bMotherShipFinalDone = true;
		}
		private function onLevelDoneWaitTime(timerEvent:TimerEvent):void {
			if (!bFinalPlaying) {
				//wait here while animations finish
				timerEvent.updateAfterEvent();
				var curTime:int = NewTimer.getTimer();
				tutorial.updateDisplay(curTime);
				timeDisplay.updateDisplay(curTime);
				particleFactory.updateDisplay();
			}
			if (bBeamFinalDone && bMotherShipFinalDone) {
				//and mothership done
				bBeamFinalDone = false;
				bMotherShipFinalDone = false;
				timer.stop();
				
				startTime = NewTimer.getTimer();
				
				timer = new NewTimer(1, 0);
				timer.addEventListener(TimerEvent.TIMER, onLevelClearTime);
				timer.start();
			}
		}
		
		private function onLevelClearTime(timerEvent:TimerEvent):void {
			var time:int = NewTimer.getTimer();
			//var ratio:Number = (time - startTime) / Config.GEMS_DESTROYTIME;
			var ratio:Number = (time - startTime) / Config.LEVEL_CLEAR_TIME;
			var i:int, j:int;
			
			timeDisplay.updateDisplay(time);
			
			if(ratio > 1) ratio = 1;
			
			timerEvent.updateAfterEvent();
			
			for(i=0;i<dimensionX;i++) {
				for(j=0;j<dimensionY;j++) {
					if(!gems[i][j]) continue;
					
					gems[i][j].scaleX = 1 - ratio;
					gems[i][j].scaleY = 1 - ratio;
					gems[i][j].rotation = ratio * Config.GEMS_DESTROYROTATE;
				}
			}
			
			if(ratio >= 1) {
				timer.stop();
			
				for(i=0;i<dimensionX;i++) {
					for(j=0;j<dimensionY;j++) {
						if(!gems[i][j]) continue;
						
						gemsHolder.removeChild(gems[i][j]);
					}
				}
				
				nHarnessWaitState = HARNESS_STATE_PRE;
				//timer = new NewTimer(Config.MESSAGE_LEVELCLEARTIME, 1);
				timer = new NewTimer(333, 0);
				timer.addEventListener(TimerEvent.TIMER, startNextLevel);
				timer.start();
			}
		}
		
		public function harnessContinue():void {
			nHarnessWaitState = HARNESS_STATE_DONE;
		}
		
		private function startNextLevel(timerEvent:TimerEvent):void {
			if (nHarnessWaitState == HARNESS_STATE_PRE) {
				tutorial.tutorialDone();
				
				var i:int, j:int;
				
				for(i=0;i<dimensionX;i++) {
					for(j=0;j<dimensionY;j++) {
						if(!backgrounds[i][j]) continue;
						
						backgroundsHolder.removeChild(backgrounds[i][j]);
					}
				}
				nHarnessWaitState = HARNESS_STATE_WAIT;
				SoundManager.getInstance().pauseMusic();
				Object(mcParent).endLevel(level);
				//Z DEBUG
				//skip to done
			} else if (nHarnessWaitState == HARNESS_STATE_DONE) {
				nHarnessWaitState = HARNESS_STATE_OFF;
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, startNextLevel);
				mothershipClip.gotoAndPlay("flyin");
				timeDisplay.setReadyState();
				
				SoundManager.getInstance().unpauseMusic();
				startLevel(level + 1);
			}
		}
		
		public function gameOverFromQuit():void {
			if(timer) timer.stop();
			if(gemsTimer) gemsTimer.stop();
			
			unsetControl();
			
			trackFinalScoreEvent();
			Object(mcParent).trackLevelEvent(level, "fail", Math.floor((NewTimer.getTimer() - nTrackLevelStartTime)/1000));
			
			tutorial.tutorialDone();
			//no message game over
			
			nHarnessWaitState = HARNESS_STATE_PRE;
			//timer = new NewTimer(Config.MESSAGE_GAMEOVERTIME, 1);
			timer = new NewTimer(333, 0);
			timer.addEventListener(TimerEvent.TIMER, showPlayAgain);
			timer.start();
		}
		
		private function gameOver():void {
			if(timer) timer.stop();
			if(gemsTimer) gemsTimer.stop();
			
			unsetControl();
			
			trackFinalScoreEvent();
			Object(mcParent).trackLevelEvent(level, "fail", Math.floor((NewTimer.getTimer() - nTrackLevelStartTime)/1000));
			
			tutorial.tutorialDone();
			message.showGameOver();
			
			//soundGameOver.play();
			
			nHarnessWaitState = HARNESS_STATE_PRE;
			//timer = new NewTimer(Config.MESSAGE_GAMEOVERTIME, 1);
			timer = new NewTimer(333, 0);
			timer.addEventListener(TimerEvent.TIMER, showPlayAgain);
			timer.start();
		}
		
		private function showPlayAgain(timerEvent:TimerEvent):void {
			if (nHarnessWaitState == HARNESS_STATE_PRE) {
				Object(mcParent).showEnterHighScore(score);
				nHarnessWaitState = HARNESS_STATE_WAIT;
				SoundManager.getInstance().pauseMusic();
				nEndGameWait = 1;
			} else if (nHarnessWaitState == HARNESS_STATE_WAIT) {
				if (nEndGameWait > 0) {
					nEndGameWait++;
					if (nEndGameWait > 8) {
						nEndGameWait = -1;
						Object(mcParent).endGame();
					}
				}
			} else if (nHarnessWaitState == HARNESS_STATE_DONE) {
				nHarnessWaitState = HARNESS_STATE_OFF;
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, showPlayAgain);
				SoundManager.getInstance().unpauseMusic();
				message.showPlayAgain();
			}
		}
		
		public function playAgainEvent():void {
			Object(mcParent).trackLevelEvent(level, "replay");
		}
		
	}
}