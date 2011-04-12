/***************************************************************

	Copyright 2007, Zero G Games Limited.
	
	Redistribution of part or whole of this file and
	the accompanying files is strictly prohibited.
	
	Redistribution of modified versions of this file and
	the accompaying files is also strictly prohibited.
	
****************************************************************/



package com.zerog {
	import flash.system.System;
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.external.*;
	import flash.net.*;
	import com.zerog.*;
	import com.zerog.invasion.*;
	
	public class MainDevelopment extends MovieClip {
		public var mcTitle:InvasionTitle;
		public var instructions:Instructions;
		public var game:com.zerog.invasion.Game;
		public var musicGame:Sound;
		public var musicGameSoundChannel:SoundChannel;
		
		public var titleX:Number;
		public var titleY:Number;
		public var titleIndex:int;
		
		
		function MainDevelopment() {
			checkMute();
			
			try {
				ExternalInterface.addCallback("onRightMouseDown", onRightMouseDown);
				ExternalInterface.addCallback("onRightMouseUp", onRightMouseUp);
				ExternalInterface.addCallback("onMiddleMouseDown", onMiddleMouseDown);
				ExternalInterface.addCallback("onMiddleMouseUp", onMiddleMouseUp);
			} catch(e) {
			}
			
			
			this.addEventListener(Event.ENTER_FRAME, checkTitle);
		}
		
		
		public function gotoTitlePage():void {
			removePage();
			
			mcTitle = new InvasionTitle();
			//mcTitle.x = titleX;
			//mcTitle.y = titleY;
			mcTitle.x = 0;
			mcTitle.y = 0;
			//this.addChildAt(mcTitle, titleIndex);
			this.addChild(mcTitle);
		}
		
		public function gotoInstructionsPage():void {
			removePage();
			
			instructions = new Instructions();
			instructions.x = titleX;
			instructions.y = titleY;
			//this.addChildAt(instructions, titleIndex);
			this.addChild(instructions);
		}
		
		public function gotoGamePage():void {
			//Game.gameStage = stage;
			//com.zerog.invasion.Game.gameStage = stage;
			com.zerog.Game.gameStage = stage;
			trace("gotoGamePage() stage=" + stage + ", com.zerog.Game.gameStage=" + com.zerog.Game.gameStage);
			removePage();
			
			game = getGame();
			game.x = titleX;
			game.y = titleY;
			//this.addChildAt(game, titleIndex);
			this.addChild(game);
			/*
			musicGame = getMusicGame();
			musicGameSoundChannel = musicGame.play(0, int.MAX_VALUE);
			*/
		}
		
		public function showInstructionsFromGame():void {
			game.pause();
			game.visible = false;
			
			instructions = new Instructions(true);
			instructions.x = titleX;
			instructions.y = titleY;
			//this.addChildAt(instructions, titleIndex + 1);
			this.addChild(instructions);
		}
		
		public function hideInstructionsFromGame():void {
			this.removeChild(instructions);
			instructions = null;
			
			game.visible = true;
			game.unpause();
		}
		
		public function showHighScores():void {
			trace("showHighScores()");
		}
		
		public function showEnterHighScore(score:int):void {
			trace("showEnterHighScore(" + score + ")");
		}
		
		public function gotoMoreGamesURL():void {
			navigateToURL(new URLRequest("http://www.zeroggames.com"), "_blank");
		}
		
		
		public function onRightMouseDown():void {
			if(game) game.onRightMouseDown();
		}
		
		public function onRightMouseUp():void {
			if(game) game.onRightMouseUp();
		}
		
		public function onMiddleMouseDown():void {
			if(game) game.onMiddleMouseDown();
		}
		
		public function onMiddleMouseUp():void {
			if(game) game.onMiddleMouseUp();
		}
		
		/*
		public function getTitle():InvasionTitle {
			return null;
		}
		
		public function getGame():Game {
			return null;
		}
		*/
		public function getTitle():InvasionTitle {
			return mcTitle;
		}
		public function getGame():com.zerog.invasion.Game {
			//return new com.zerog.invasion.Game(this);
			return null;
		}
		
		public function getMusicGame():Sound {
			return null;
		}
		
		
		public function checkMute():void {
			var sharedObject:SharedObject = SharedObject.getLocal("mute", '/');
			var soundTransform:SoundTransform;
			
			sharedObject.objectEncoding = ObjectEncoding.AMF0;
			
			if(sharedObject.data.isMute) {
				soundTransform = new SoundTransform();
				soundTransform.volume = 0;
				SoundMixer.soundTransform = soundTransform;
			}
		}
		
		public function checkTitle(event:Event):void {
			if(!(mcTitle = getTitle())) return;
			
			/*
			titleX = mcTitle.x;
			titleY = mcTitle.y;
			*/
			titleX = 0;
			titleY = 0;
			
			this.removeEventListener(Event.ENTER_FRAME, checkTitle);
			
			stop();
			
			//titleIndex = this.getChildIndex(mcTitle);
			titleIndex = 1;
		}
		
		public function removePage():void {
			trace("removePage() mcTitle=" + mcTitle);
			if(mcTitle) {
				removeChild(mcTitle);
				mcTitle = null;
			}
			if(instructions) {
				removeChild(instructions);
				instructions = null;
			}
			if(game) {
				Object(game).prepareQuit();
				removeChild(game);
				game = null;
			}
			if(musicGame) {
				musicGameSoundChannel.stop();
				musicGame = null;
				musicGameSoundChannel = null;
			}
			if (System.gc != null) {
				System.gc();
			}
		}
	}
}