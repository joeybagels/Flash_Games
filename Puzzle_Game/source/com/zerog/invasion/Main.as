/***************************************************************

	Copyright 2008, Zero G Games Limited.
	
	Redistribution of part or whole of this file and
	the accompanying files is strictly prohibited.
	
	Redistribution of modified versions of this file and
	the accompaying files is also strictly prohibited.
	
****************************************************************/

package com.zerog.invasion {
	import com.zerog.*;
	import flash.display.*;
	import flash.media.*;
	import flash.events.*;
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import com.marvel.adharness.AdHarnessGameInterface; // pull in custom Marvel interface
	
	public class Main extends com.zerog.MainDevelopment implements AdHarnessGameInterface {
		
		private var adHarness:MovieClip; // must add this variable for harness callbacks
		
		public static const MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME:String = "mshsm3";
		
		private var tracker:AnalyticsTracker;
		
		private var nLoadTime:int;
		
		private var bStartGame:Boolean;
		
		function Main() {
			super();
			bStartGame = false;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgressEvent);
			loaderInfo.addEventListener(Event.COMPLETE, onLoadCompleteEvent);
		}
		
		public function gameFrame():void {
			gotoTitlePage();
			stop();
		}
		/*
		override public function gotoTitlePage():void {
			super.removePage();
			
			this.title = new InvasionTitle() as Title;
			this.title.x = this.titleX;
			this.title.y = this.titleY;
			this.addChildAt(this.title, this.titleIndex);
		}
		*/
		public function harnessWaitFrame():void {
			//Load Complete at this point.  Loop to harness wait frame until ready to play
			if (bStartGame) {
				gotoAndPlay("game");
			} else {
				//Z - debug
				/*
				*/
				gotoAndPlay("game");
				bStartGame = true;

				/*
				//Normal - harness integrated:
				gotoAndPlay("harness_wait");
				*/
			}
		}
		
		//AD HARNESS
		// called by the harness to get the game started
		public function startGame():void
		{
			// start your game here
			bStartGame = true;
		}
		
		public function cont():void
		{
			// continue with your game from here
			
			/*
				NOTE:
				From this point you will either continue a level
				or restart the game after a game over state 
				has been reached. This function will be called
				infinitely until the player navigates away from 
				the game. 
			
			*/
			Object(game).harnessContinue();
		}
		
		// captures the AdHarness reference object
		public function setAdHarnessRef(mc:MovieClip):void
		{
			adHarness = mc;
		}
		
		// purely sample code for simulated delayed callbacks
		public function endLevel(tLevel:int):void
		{
			trace("harness - end level");
			if (adHarness) {
				if (tLevel == 7 || tLevel == 14 || tLevel == 21 || tLevel == 29) {
					adHarness.endLevel();
				} else {
					Object(game).harnessContinue();
				}
			}
			//Z - Debug
			Object(game).harnessContinue();
		}
		
		// tells the ad harness that the game has ended
		public function endGame():void
		{
			trace("harness - end game");
			if (adHarness) {
				adHarness.endGame();
			}
			//Z - Debug
			Object(game).harnessContinue();
		}
		//END AD HARNESS
		

		public function onLoadProgressEvent(event:ProgressEvent):void
		{
			var bl:uint = event.bytesLoaded;
			var bt:uint = event.bytesTotal;
			var percentLoaded:int = Math.floor((bl / bt) * 100);
			//preloadText.text = percentLoaded + "%";
			loadProgress.gotoAndStop(percentLoaded);
			//preloadText.text = percentLoaded.toString() + "%";
			//gotoAndPlay("preload"); 
			
			
		}
		/*
import flash.text.TextField;
trace("loaded=" + framesLoaded + ", total=" + totalFrames);
if (framesLoaded < totalFrames) {
	//preloadText.text = Math.floor((framesLoaded / totalFrames)*100) + "%";
	center_mc.gotoAndStop(Math.floor((Math.min(framesLoaded,15) / 15)*100));
	gotoAndPlay("preload");	
} else {
	gotoAndPlay("init");
}			
		*/
  
		public function onLoadCompleteEvent(event:Event):void
		{
			trackLoadEvent();
			//gotoAndPlay("game");
			gotoAndPlay("harness_wait");
		}
		override public function getTitle():InvasionTitle {
			return mcTitle;
		}
		override public function getGame():com.zerog.invasion.Game {
			return new com.zerog.invasion.Game(this);
		}
		/*
		*/
		/*
		override protected function getMusicGame():Sound {
			return new com.zerog.invasion.MusicGame();
		}
		*/
		
		private function onAddedToStage(e:Event):void {
			trace(">> START TRACKER");
			tracker = new GATracker(this.stage, "UA-273913-11", "AS3", false);
			try {
				stage.showDefaultContextMenu = false;
			} catch(e) {
			}
			
			
		}
		
		public function trackTitleView():void {
			trace(">> TITLE VIEW");
			//this.tracker.trackPageview(MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME + "/game/index");
		}
		
		public function trackLinkOutEvent(page:String = "moreGames"):void {
			trace(">> LINK OUT");
			/*
			gameName  	linkOut  	marvelLogo  
										sponsorLogo  
										moreGames  
										share  
										otherLinkName  	n/a  
			*/
			this.tracker.trackEvent(MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME, "linkOut", page);
		}
		
		public function trackMenuEvent(button:String = "instructions"):void {
			trace(">> MENU EVT = " + button);
			/*
			gameName  	menu  	instructions  
								characters  
									achievements  
								credits  
								otherMenuItem  	n/a  
			*/
			this.tracker.trackEvent(MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME, "menu", button);
		}
		
		public function startLoadTime():void {
			nLoadTime = NewTimer.getTimer();
		}
		public function trackLoadEvent():void {
			var tLoadTime:String = Math.floor((NewTimer.getTimer() - nLoadTime) / 1000).toString();
			trace(">> LOAD EVT  time = " + tLoadTime);
			//gameName  	load  	gameIndex  	time  (in  seconds)  
			this.tracker.trackEvent(MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME, "load", tLoadTime);
		}
		
		public function trackPauseEvent(bIsPaused:Boolean = true):void {
			trace(">> PAUSE = " + bIsPaused);
			//gameName  	pauseGame  	on  
			//			off  	n/a  
			this.tracker.trackEvent(MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME, "pauseGame", bIsPaused ? "on" : "off");
		}
		public function trackSoundEvent(bSoundOn:Boolean = true):void {
			trace(">> SOUND = " + bSoundOn);
			//gameName  	toggleSFX  	on  
			//			off  	n/a  
			this.tracker.trackEvent(MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME, "toggleSFX", bSoundOn ? "on" : "off");
		}
		public function trackMusicEvent(bSoundOn:Boolean = true):void {
			trace(">> MUSIC = " + bSoundOn);
			//gameName  	toggleMusic  	on  
			//			off  	n/a  
			this.tracker.trackEvent(MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME, "toggleMusic", bSoundOn ? "on" : "off");
		}
		public function trackAchievementEvent(achieve:String = ""):void {
			trace(">> ACHIEVEMENT = " + achieve);
			//gameName  	achievements  	achievementName01  
			//				achievementName02  
			this.tracker.trackEvent(MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME, "achievements", achieve);
		}
		
		public function trackMiscEvent(miscEvent:String = ""):void {
			trace(">> MISC EVT = " + miscEvent);
			//-	tracker.trackEvent(“MRD_Escape”,  “miscellaneous”,  “robotsDestroyed”)  
			this.tracker.trackEvent(MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME, "miscellaneous", miscEvent);
		}
		
		public function trackLevelEvent(level:int = 1, eventName:String = "start", param:int = -1):void {
			trace(">> LEVEL EVT = " + level + " : " + eventName + " - " + param);
			/*
			-	tracker.trackEvent(“MRD_Escape”,  “level02”,  “start”)  
			-	tracker.trackEvent(“MRD_Escape”,  “level02”,  “complete”,  60)  
			-	tracker.trackEvent(“MRD_Escape”,  “level02”,  “fail”,  25)  
			-	tracker.trackEvent(“MRD_Escape”,  “level02”,  “replay”)  
			-	tracker.trackEvent(“MRD_Escape”,  “level02”,  “quit”,  132)  
			*/
			var tLevelFormat:String = level < 10 ? "0" + level.toString() : level.toString();
			if (param < 0) {
				this.tracker.trackEvent(MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME, "level" + tLevelFormat, eventName);
			} else {
				this.tracker.trackEvent(MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME, "level" + tLevelFormat, eventName, param);
			}
		}

		
		
		override public function gotoGamePage():void {
			trace(">> GAME PAGE");
			//gameName/game/index/start  	upon  the  player  electing  to  start  the  game  from  the  game’s  main  menu  
			//this.tracker.trackPageview(MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME + "/game/index/start");
			super.gotoGamePage();
		}
		
		public function trackLevelView(level:int = 1):void {
			trace(">> LEVEL VIEW");
			//gameName/game/level/levelNum  	upon  the  start  of  each  level  (NOT  counting  replays  after  completing  the  level).   levelNum  should  follow  the  format  of  “level02”.  
			//-	tracker.trackPageview(“MRD_Escape/game/level/level02”)  
			
			//var tFormatLevel:String = level < 10 ? "0" + level.toString() : level.toString();
			//this.tracker.trackPageview(MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME + "/game/level/level" + tFormatLevel);
		}
		
		public function trackHeroPageView(hero:String = ""):void {
			trace(">> HERO VIEW = " + hero);
			/*
			gameName/menu/characters/pageName  	Upon  the  first,  and  each  subsequent,  page  of  the  game’s  mutant/character  bio  pages.   The  pageName  value  should  be  the  name  of  the  mutant/character  featured  on  that  page.  
			-	tracker.trackPageview(“MRD_Escape/menu/characters/Wolverine”)  
			-	tracker.trackPageview(“MRD_Escape/menu/characters/IronMan”)
			*/
			//this.tracker.trackPageview(MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME + "/menu/characters/" + hero);
		}
		
		public function trackAdPrerollView():void {
			trace(">> AD PREROLL");
			//gameName/ads/preroll  
			//this.tracker.trackPageview(MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME + "/ads/preroll");
		}
		public function trackAdIntersticialView():void {
			trace(">> AD INTERSTICIAL");
			//gameName/ads/interstitial  
			//this.tracker.trackPageview(MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME + "/ads/interstitial");
		}
		public function trackAdPostrollView():void {
			trace(">> AD POSTROLL");
			//gameName/ads/postroll  	Upon  stopping  the  game  to  show  an  ad  at  any  point  in  the  game  flow  (use  “interstitial”  only  for  ads  breaking  up  levels  or  breaking  based  on  game  time)  
			//this.tracker.trackPageview(MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME + "/ads/postroll");
		}
		
		
		
		
	}
}