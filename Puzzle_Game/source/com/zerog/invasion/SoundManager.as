package com.zerog.invasion
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	/*
	import com.zerog.invasion.RolloverSound;
	import com.zerog.invasion.SelectShipSound;
	import com.zerog.invasion.ShipOpenSound;
	import com.zerog.invasion.ShipCloseSound;
	import com.zerog.invasion.ShipFadeOutSound;
	import com.zerog.invasion.ShipFlyInSound;
	import com.zerog.invasion.ShipsFlyInSound;
	import com.zerog.invasion.SelectMenuSound;
	import com.zerog.invasion.ClickTechPodSound;
	import com.zerog.invasion.EndLevelBeamSound;
	import com.zerog.invasion.EnergyBeamSound;
	import com.zerog.invasion.EnergyThermometerSound;
	import com.zerog.invasion.IncorrectSwapSound;
	*/
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class SoundManager 
	{
		private static var _instance:SoundManager;
		private var trans:SoundTransform;
		
		private var _rollover:* = new RolloverSound();
		private var selectShip:* = new SelectShipSound();
		private var shipOpen:* = new ShipOpenSound();
		private var shipClose:* = new ShipCloseSound();
		private var shipFadeOut:* = new ShipFadeOutSound();
		private var shipFlyIn:* = new ShipFlyInSound();
		private var shipsFlyIn:* = new ShipsFlyInSound();
		private var selectMenu:* = new SelectMenuSound();
		private var clickTechPod:* = new ClickTechPodSound();
		private var endLevelBeam:* = new EndLevelBeamSound();
		private var energyBeam:* = new EnergyBeamSound();
		private var energyThermometer:* = new EnergyThermometerSound();
		private var incorrectSwap:* = new IncorrectSwapSound();
		private var gameMusic:* = new GameMusicSound();
		private var levelComplete:* = new LevelCompleteSound();
		private var techPodDestroy:* = new TechPodDestroySound();
		private var sparkleGem:* = new SparkleGemSound();
		
		private var cap:* = new CapSound();
		private var doom:* = new DoomSound();
		private var galac:* = new GalacSound();
		private var hulk:* = new HulkSound();
		private var iron1:* = new Iron1Sound();
		private var iron2:* = new Iron2Sound();
		private var iron3:* = new Iron3Sound();
		private var iron4:* = new Iron4Sound();
		private var ss:* = new SSSound();
		private var thing:* = new ThingSound();
		private var thor:* = new ThorSound();
		private var wolv:* = new WolvSound();
		
		private var aChannels:Array;
		
		public static const ROLLOVER:uint = 1;
		public static const SELECT_SHIP:uint = 2;
		public static const SHIP_OPEN:uint = 3;
		public static const SHIP_CLOSE:uint = 4;
		public static const SHIP_FADE_OUT:uint = 5;
		public static const SHIP_FLY_IN:uint = 6;
		public static const SHIPS_FLY_IN:uint = 7;
		public static const SELECT_MENU:uint = 8;
		public static const CLICK_TECH_POD:uint = 9;
		public static const END_LEVEL_BEAM:uint = 10;
		public static const ENERGY_BEAM:uint = 11;
		public static const ENERGY_THERMOMETER:uint = 12;
		public static const INCORRECT_SWAP:uint = 13;
		public static const GAME_MUSIC:uint = 14;
		public static const CAP:uint = 15;
		public static const DOOM:uint = 16;
		public static const GALAC:uint = 17;
		public static const HULK:uint = 18;
		public static const IRON1:uint = 19;
		public static const IRON2:uint = 20;
		public static const IRON3:uint = 21;
		public static const IRON4:uint = 22;
		public static const SS:uint = 23;
		public static const THING:uint = 24;
		public static const THOR:uint = 25;
		public static const WOLV:uint = 26;
		public static const LEVEL_COMPLETE:uint = 27;
		public static const TECH_POD_DESTROY:uint = 28;
		public static const SPARKLE_GEM:uint = 29;
		
		private var bSoundOn:Boolean = true;
		private var gameMusicOn:Boolean = false;
		
		
		public function pauseMusic():void {
			if (this.gameMusicOn) {
				stopSound(SoundManager.GAME_MUSIC);
				this.gameMusicOn = true;
			}
			trace("pauseMusic() this.gameMusicOn=" + this.gameMusicOn);
		}
		public function unpauseMusic():void {
			trace("unpauseMusic() this.gameMusicOn=" + this.gameMusicOn);
			if (this.gameMusicOn) {
				this.gameMusicOn = false;
				play(SoundManager.GAME_MUSIC);
			}
			trace("  " + this.gameMusicOn);
		}

		public function setIsSound(isOn:Boolean):void {
			//trace("SET IS SOUND " + isOn)
			bSoundOn = isOn;
			//if (!bSoundOn) {
			//	this.play(GAME_MUSIC);
			//} 
			//else {
			//	this.stopSound(GAME_MUSIC);
			//}
		}
		public function stopSound(soundType:uint):void {
			
			if (aChannels[soundType] != null) {
				aChannels[soundType].stop();
				
				if (soundType == GAME_MUSIC) {
					trace("set game mus on to false")
					this.gameMusicOn = false;
				}
			}
		}
		public function play(soundType:uint) {		
			//if game music
			if (soundType == GAME_MUSIC) {
				if (!this.gameMusicOn) {
					trace("set game mus on to true")
					this.gameMusicOn = true;
					aChannels[soundType] = this.gameMusic.play(0,99999,trans);
				}
			}
			//for all others
			else {
				//trace("PLAY SOUND " + bSoundOn);	
				if (bSoundOn) {
					
					if (soundType != GAME_MUSIC)
						stopSound(soundType);
						
					switch(soundType) {
						case LEVEL_COMPLETE:
							aChannels[soundType] = this.levelComplete.play();
							break;
						//case GAME_MUSIC:
							//break;
						case ROLLOVER:
							aChannels[soundType] = this._rollover.play();
							break;
						case SELECT_SHIP:
							aChannels[soundType] = this.selectShip.play();
							break;
						case SHIP_OPEN:
							aChannels[soundType] = this.shipOpen.play();
							break;
						case SHIP_CLOSE:
							aChannels[soundType] = this.shipClose.play();
							break;
						case SHIP_FADE_OUT:
							aChannels[soundType] = this.shipFadeOut.play();
							break;
						case SHIP_FLY_IN:
							aChannels[soundType] = this.shipFlyIn.play();
							break;
						case SHIPS_FLY_IN:
							aChannels[soundType] = this.shipsFlyIn.play();
							break;
						case SELECT_MENU:
							aChannels[soundType] = this.selectMenu.play();
							break;
						case CLICK_TECH_POD:
							aChannels[soundType] = this.clickTechPod.play();
							break;
						case END_LEVEL_BEAM:
							aChannels[soundType] = this.endLevelBeam.play();
							break;
						case ENERGY_BEAM:
							aChannels[soundType] = this.energyBeam.play();
							break;
						case ENERGY_THERMOMETER:
							aChannels[soundType] = this.energyThermometer.play();
							break;
						case INCORRECT_SWAP:
							aChannels[soundType] = this.incorrectSwap.play();
							break;
						case TECH_POD_DESTROY:
							aChannels[soundType] = this.techPodDestroy.play();
							break;
						case SPARKLE_GEM:
							aChannels[soundType] = this.sparkleGem.play();
							break;
							
							
						case CAP:
							aChannels[soundType] = this.cap.play();
							break;
						case DOOM:
							aChannels[soundType] = this.doom.play();
							break;
						case GALAC:
							aChannels[soundType] = this.galac.play();
							break;
						case HULK:
							aChannels[soundType] = this.hulk.play();
							break;
						case IRON1:
							aChannels[soundType] = this.iron1.play();
							break;
						case IRON2:
							aChannels[soundType] = this.iron2.play();
							break;
						case IRON3:
							aChannels[soundType] = this.iron3.play();
							break;
						case IRON4:
							aChannels[soundType] = this.iron4.play();
							break;
						case SS:
							aChannels[soundType] = this.ss.play();
							break;
						case THING:
							aChannels[soundType] = this.thing.play();
							break;
						case THOR:
							aChannels[soundType] = this.thor.play();
							break;
						case WOLV:
							aChannels[soundType] = this.wolv.play();
							break;
					}
				}
			}
		}

		//-----------------------------------------------------------
		public static function getInstance():SoundManager {
			if (null == _instance) {
				_instance = new SoundManager(new InnerClass);
			}
			return _instance;
		}
		
		public function SoundManager(arg:InnerClass) 
		{
			init();
		}
		//----------------------------------------------------------
		private function init():void {
			aChannels = new Array();
			//trans = new SoundTransform(0.75, 0);
			trans = new SoundTransform(0.5, 0);
		}
		//-----------------------------------------------------------
//		public function stop(soundType:String) {
//			switch(soundType) {
//				/*
//				case WINNER_LOOP:
//					if (_winnerSoundChannel != null) {
//						_winnerSoundChannel.stop();
//					}
//					break;
//				case MUSIC_GAME:
//					if (_musicGameSoundChannel != null) {
//						_musicGameSoundChannel.stop();
//					}
//					break;
//				case DIALOG_OVER_SOUND:
//					if (_dialogOverSoundChannel != null) {
//						_dialogOverSoundChannel.stop();
//					}
//					break;
//				case DIALOG_DOWN_SOUND:
//					if (_dialogDownSoundChannel != null) {
//						_dialogDownSoundChannel.stop();
//					}
//					break;
//				case TRAFFIC_SOUND:
//					if (_trafficSoundChannel != null) {
//						_trafficSoundChannel.stop();
//					}
//					break;
//			}
//			*/
//		}

		
	}
	
	
}
class InnerClass{}