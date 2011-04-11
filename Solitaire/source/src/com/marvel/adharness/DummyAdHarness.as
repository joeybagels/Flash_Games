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
	public class DummyAdHarness extends MovieClip implements AdHarnessInterface
	{
		//public var aLoader:AssetLoader;
		private var gameRef:MovieClip;
		private var harnessData:XML;
		private var _loader:URLLoader = new URLLoader();
		
		public function DummyAdHarness()
		{
			var settings = loaderInfo.parameters.settings ? loaderInfo.parameters.settings : "adharness.xml";
					
			// pulling in configuration file
			loadXML(settings, xmlLoaded);
		}
		
		// processing configuration file
		private function xmlLoaded(e:Event):void
		{
			debug("xmlloaded");
			harnessData = new XML(_loader.data);
			
			// loading game
			loadGame();  // get game loading
		}
		
		
		// loading game
		private function loadGame():void
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
		private function onGameLoad(e:Event):void
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
				
				gameRef.startGame();
				
			}
		}

		// called by the game when a level ends
		public function endLevel():void
		{
			if (gameRef != null) {
				gameRef.cont();
			}
		}
		
		
		// called by the game when game over is ready
		public function endGame():void
		{
			if (gameRef != null) {
				gameRef.cont();
			}
		}
		
		// UTIL - loads XML file
		private function loadXML(xmlPath:String, callback:Function)
		{
			trace("load xml " + xmlPath)
			_loader.dataFormat = URLLoaderDataFormat.TEXT;
			_loader.addEventListener(Event.COMPLETE, callback);
			var _request:URLRequest = new URLRequest(xmlPath);
			_loader.load(_request);
		}
		
		private function debug(s:String):void {
			trace(s);
			//output.appendText(s + "\n");
		}
	}
}