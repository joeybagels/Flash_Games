package com.zerog.invasion {
	import flash.net.*;	
	import flash.events.MouseEvent;	
	
	import com.zerog.Title;	
	
	import flash.display.MovieClip;
	import flash.events.Event;	

	import com.zerog.components.buttons.*;

	import flash.display.SimpleButton;

	/**
	 * @author Chris
	 */
	public class InvasionTitle extends Title {
		private var heroesPage:HeroesPage;
		private var options:OptionsMenu;
		
		public function InvasionTitle() {
			//startButton.addEventListener(MouseEvent.CLICK, startButtonClicked);
			//highScoresButton.addEventListener(MouseEvent.CLICK, highScoresButtonClicked);
			//moreGamesButton.addEventListener(MouseEvent.CLICK, moreGamesButtonClicked);
			//addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			heroesPage = new HeroesPage();
			heroesPage.setParent(this);
			
			options = new OptionsMenu();
			options.addEventListener(OptionsMenu.OK_EVENT, onOptionsOk);
			options.setParent(this);
			var sm:SoundManager = SoundManager.getInstance();
			var mySo:SharedObject = SharedObject.getLocal(Main.MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME);
			
			if (mySo.data.sounds == undefined || mySo.data.sounds == true) {
				options.selectSounds(true);
				
				sm.setIsSound(true);
				
			}
			else {
				options.selectSounds(false);
				
				sm.setIsSound(false);
			}
			
			if (mySo.data.music == undefined || mySo.data.music == true) {
				options.selectMusic(true);
				
				sm.play(SoundManager.GAME_MUSIC);
			}
			else {
				options.selectMusic(false);
			}
			
			if (mySo.data.tutorial == undefined || mySo.data.tutorial == true) {
				options.selectTutorial(true);
			
				trace("SET TUT TRUE")
			}
			else {
				options.selectTutorial(false);
				
				trace("SET TUT falsE")
			}
			
			bottomBar.options.addEventListener(MouseEvent.CLICK, onOptions);
			bottomBar.howToPlay.addEventListener(MouseEvent.CLICK, onHowToPlay);
			bottomBar.moreGames.addEventListener(MouseEvent.CLICK, onMoreGames);
			bottomBar.heroes.addEventListener(MouseEvent.CLICK, onHeroes);
			bottomBar.startGame.addEventListener(MouseEvent.CLICK, startButtonClicked);
			bottomBar.gotoAndStop(1);
			
			creditsButton.addEventListener(MouseEvent.CLICK, onCredits)
			
		}
	
		private function onCloseHowToPlay(event:MouseEvent):void {
			event.target.parent.removeDialog();
		}
		private function onCredits(event:MouseEvent):void {
			var c:CreditsPage = new CreditsPage()
			c.setParent(this);
			c.addEventListener(MouseEvent.CLICK, onCloseCredits);
			c.showDialog();
		}
		
		private function onCloseCredits(event:MouseEvent):void {
			event.target.removeDialog();
		}
		
		private function onHowToPlay(e:Event):void {
			Object(parent).trackMenuEvent("instructions");
					var h:HowToPlay = new HowToPlay();
			h.setParent(empty);
			h.showDialog(0,0);
			h.closeButton.addEventListener(MouseEvent.CLICK, onCloseHowToPlay);
		}
	
		private function onOptionsOk(e:Event):void {
			var mySo:SharedObject = SharedObject.getLocal(Main.MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME);
			if(mySo.data.sounds != undefined) {
				SoundManager.getInstance().setIsSound(mySo.data.sounds);
				
				Object(parent).trackSoundEvent(mySo.data.sounds);
			}
			
			if (mySo.data.music == true) {
				SoundManager.getInstance().play(SoundManager.GAME_MUSIC);
			}
			else {
				SoundManager.getInstance().stopSound(SoundManager.GAME_MUSIC);
			}
		}
			override public function get width():Number {
			return 760;
		}
		override public function get height():Number {
			return 600;
		}
		
		private function onMoreGames(e:Event):void {
			//this.tracker.trackEvent(MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME, "linkOut", "moreGames");
			
			var request:URLRequest = new URLRequest("http://marvelkids.marvel.com/games");
			try {
  				navigateToURL(request, '_blank'); 
			}
			catch (e:Error) {
			}	
			
			Object(parent).trackLinkOutEvent("moreGames");
			
			//tracker.trackEvent(MARVEL_SUPERHERO_SQUAD_MATCH_THREE_NAME, "linkOut", "moreGames");
		}
		
		private function onHeroes(e:MouseEvent):void {
			Object(parent).trackMenuEvent("characters");
			heroesPage.setParent(this);
			heroesPage.showDialog(0,0);
		}
		
		private function onOptions(e:MouseEvent):void {
			Object(parent).trackMenuEvent("otherMenuItem");
			options.showDialog();
		}
		
		override protected function onAddedToStage(e:Event):void {
			//Object(parent).trackTitleView();
			super.onAddedToStage(e);
			trace("bottom bar play")
			bottomBar.play();
		}
	}
}
