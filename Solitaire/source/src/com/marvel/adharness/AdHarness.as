/* ©COPYRIGHT 2009 MARVEL ENTERTAINMENT

	This is the ad harness..
	
*/
package com.marvel.adharness
{
	
	import com.zerog.utils.net.URL;
	
	//import com.zgg.util.AssetLoader;
	
	import flash.display.MovieClip;
	import flash.display.Loader;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	// implements the AdHarnessInterface for overall compatibility
	public class AdHarness extends MovieClip implements AdHarnessInterface
	{
		//public var aLoader:AssetLoader;
		private var gameRef:MovieClip;
		private var harnessData:XML;
		private var _loader:URLLoader = new URLLoader();
		
		private var prerollList:Array = new Array();
		private var ingameList:Array = new Array();
		private var postrollList:Array = new Array();
		
		private var minuteTimer:Timer;
		private var startGameFlag:Boolean = false;
		
		public function AdHarness()
		{
			//check to see if marvel
			var url:URL = new URL(root.loaderInfo.url);
			if (url.host != null) {
				if (url.host.indexOf("marvel.com") > -1 || url.host.indexOf("zerog-corp.com") > -1) {
					var settings = loaderInfo.parameters.settings ? loaderInfo.parameters.settings : "adharness.xml";
					
					// pulling in configuration file
					loadXML(settings, xmlLoaded);
				}
			}
		}
		
		// processing configuration file
		public function xmlLoaded(e:Event):void
		{
			debug("xmlloaded");
			harnessData = new XML(_loader.data);
			
			// looping through nodes
			for(var x:int = 0;x < harnessData.ad.length();x++)
			{
				switch(String(harnessData.ad[x].type))
				{
					case 'preroll':
						prerollList.push({url: harnessData.ad[x].url,duration: harnessData.ad[x].duration });
						break;
					case 'ingame':
						ingameList.push({url: harnessData.ad[x].url,duration: harnessData.ad[x].duration });
						break;
					case 'postroll':
						postrollList.push({url: harnessData.ad[x].url,duration: harnessData.ad[x].duration });
						break;
				}
			}
			
			// loading game
			startHarness();
		}
		
		// starting teh preroll ad and calling init() to load the game
		private function startHarness():void
		{			debug("start hardness");
			startPreRoll(); // get ad going before game has loaded
			loadGame();  // get game loading
		}
		
		// starting preroll
		public function startPreRoll():void
		{
			debug("start pre rooll");
			loadAd(String(prerollList[0].url)); // loading ad
			
			// setting up and executing timer for getting game underway
			minuteTimer = new Timer(1000, Number(prerollList[0].duration));
			minuteTimer.addEventListener(TimerEvent.TIMER_COMPLETE, startGame);
			minuteTimer.start();
		}
		
		// loading game
		public function loadGame():void
		{
			var gameURL:String;
			
			if(harnessData.game.url != null)
				gameURL = harnessData.game.url;
			else
				gameURL = loaderInfo.parameters.gameURL ? loaderInfo.parameters.gameURL : "TestGame.swf";
			
			 var ldr:Loader = new Loader();
 
			 var urlReq:URLRequest = new URLRequest(gameURL);
			 ldr.load(urlReq);
			 ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onGameLoad);
			 addChild(ldr);
 
			// using loader object to pull in game
			//aLoader = new AssetLoader();
			//aLoader.addAssets(gameURL, 2, true, false, onGameLoad);
			//aLoader.loadAssets();
		}
		
		// callback for game loaded state
		public function onGameLoad(e:Event):void
		{
			if(e.target.content != null)
			{
				gameRef = e.target.content;
				
				gameRef.x = 0;
				gameRef.y = 0;
				
				if(harnessData.game.@x)
					gameRef.x = harnessData.game.@x;
					
				if(harnessData.game.@y)
					gameRef.y = harnessData.game.@y;
					
				//addChild(e.target.content); // placing game on stage
				
				gameRef.setAdHarnessRef(this); // sending game ref of Harness
				
				//if start game flag
				if(startGameFlag)
				{
					// cleaning up the browser
					callJS('clearAd','');
					callJS('showGame','');
					gameRef.startGame();
				}
			}
		}
		
		// called AFTER pre roll ad to start the game
		public function startGame(e:TimerEvent):void
		{
			debug('inside startGame');
			
			minuteTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,startGame);
						
			// cleaning up the browser
			callJS('clearAd','');
			callJS('showGame','');
			
			// getting the game started
			if(gameRef != null) {

				//start the game
				gameRef.startGame();
			}
			else
				startGameFlag = true; // if the game hasn't loaded yet, tell it - it can run when it does
		}
		
		// called by the game when a level ends
		public function endLevel():void
		{
			startInGameRoll();
		}
		
		// starts the in game ad
		public function startInGameRoll():void
		{
			loadAd(String(ingameList[0].url)); // loading ad
			
			// setting up timer for after in-game ad finishes
			minuteTimer = new Timer(1000, Number(ingameList[0].duration));
			minuteTimer.addEventListener(TimerEvent.TIMER_COMPLETE, contGame);
			minuteTimer.start();
		}
		
		// called AFTER the in-game ad has run
		public function contGame(e:TimerEvent):void
		{
			minuteTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,contGame);
			
			callJS('clearAd','');
			callJS('showGame','');
			
			gameRef.cont();
		}
		
		// called by the game when game over is ready
		public function endGame():void
		{
			startPostRoll();
		}
		
		// started post-game roll
		public function startPostRoll():void
		{
			loadAd(String(postrollList[0].url)); // loading ad
			
			///return; // temp ending
			
			// setting up and executing game cont timer
			minuteTimer = new Timer(1000, Number(postrollList[0].duration));
			minuteTimer.addEventListener(TimerEvent.TIMER_COMPLETE, contGame);
			minuteTimer.start();
		}
		
		// UTIL to load an ad 
		public function loadAd(url:String):void
		{
			callJS('showAd','');
			callJS('loadAd',url);
		}

		// UTIL - loads XML file
		public function loadXML(xmlPath:String, callback:Function)
		{
			_loader.dataFormat = URLLoaderDataFormat.TEXT;
			_loader.addEventListener(Event.COMPLETE, callback);
			var _request:URLRequest = new URLRequest(xmlPath);
			_loader.load(_request);
		}
				
		// UTIL - calls javascript funtions in parent page
		private function callJS(functonName:String,jsParams:String):void 
		{  
			if (ExternalInterface.available)   
				ExternalInterface.call(functonName, jsParams);
			else
				debug('no EI available');
		}
		import flash.text.TextField;
		private function debug(s:String):void {
			
			//output.appendText(s + "\n");
		}
		
	}
}