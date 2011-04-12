package com.zerog.invasion {
	import flash.display.*;
	import flash.events.*;
	/*
	import flash.text.*;
	import flash.media.*;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.*;
	*/
	import com.zerog.*;	

	public class Tutorial extends MovieClip {
		
		public var bActive:Boolean;
		private var nLevel:int;
		private var nLevelStartTime:int;
		private var nTutorialTriggerTime:int;
		
		private var aLevelTriggerOffsets:Array = [2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000];
		//private var aLevelActions:Array = [["destroy"],["destroy","special"],["special"],["special"],["special"],["special"],["special"],["special"],["special"],["special"],["special"]];
		private var aLevelActions:Array = [["destroy"],["special"],["special"],["special"],["special"],["special"],["special"],["special"],["special"],["special"],["special"]];
		
		private var nCurAction:int;
		private var nState:int;
		private var STATE_PRE:int = 0;
		private var STATE_MAIN:int = 1;
		private var STATE_OFF:int = 2;
		
		public var bShowHelp:Boolean;
		
		function Tutorial() {
			bActive = false;
			bShowHelp = true;
			this.tabEnabled = false;
			this.tabChildren = false;
		}
		
		
		public function init(level:int, time:int, tShowHelp:Boolean):void {
			//trace("init level=" + level + ", time=" + time + ", test=" + (level < aLevelTriggerOffsets.length + 1));
			if ((level-1) < aLevelTriggerOffsets.length + 1) {
				bShowHelp = tShowHelp;
				bActive = true;
				nLevel = level-1;
				nLevelStartTime = time;
				nCurAction = 0;
				//set timer for each level
				nTutorialTriggerTime = nLevelStartTime + aLevelTriggerOffsets[nLevel];
				//trace("  nTutorialTriggerTime=" + nTutorialTriggerTime);
				nState = STATE_PRE;
			} else {
				bActive = false;
			}
		}
		
		//general ticks.  
		public function updateDisplay(time:int):void {
			if (bShowHelp && bActive) {
				//trace("nState=" + nState + ", time=" + time + ", nTutorialTriggerTime=" + nTutorialTriggerTime);
				//when timer for level is up, display the tutorial
				if (nState == STATE_PRE && time > nTutorialTriggerTime) {
					nState = STATE_MAIN;
					this.gotoAndPlay("level_"+(nLevel+1));
				}
			}
		}
		
		public function pageFrame():void {
			//trace("pageFrame() nLevel=" + nLevel + ", nCurAction=" + nCurAction + ", aLevelActions[nLevel]=" + aLevelActions[nLevel]);
			//reached first stop frame of timeline
			this.stop();
			
			//trigger special effects here to highlight pieces
			if (nCurAction < aLevelActions[nLevel].length) {
				this.hideHelp.addEventListener(MouseEvent.CLICK,hideHelpClickEvent);
				if (aLevelActions[nLevel][nCurAction] == "destroy") {
					Object(parent).tutorialGemEffectDestroy();
				} else if (aLevelActions[nLevel][nCurAction] == "special") {
					Object(parent).tutorialGemEffectSpecial();
				}
			}
		}
		
		
		public function offFrame():void {
			this.stop();
		}
		
		
		public function actionTaken(action:String):void {
			/*
				tutorial.actionTaken("special");
				tutorial.actionTaken("destroy");
			*/
			//finish tutorial if action matches desired action for current level
			/*
			trace("actionTaken = " + action);
			trace("  bActive=" + bActive);
			trace("  nLevel=" + nLevel);
			trace("  aLevelActions=" + aLevelActions);
			trace("  nCurAction=" + nCurAction);
			trace("  aLevelActions[nLevel]=" + aLevelActions[nLevel]);
			trace("  this.hideHelp=" + this.hideHelp);
			*/
			if (bActive) {
				if (nLevel < aLevelActions.length) {
					if (nCurAction < aLevelActions[nLevel].length) {
						if (action == aLevelActions[nLevel][nCurAction]) {
							nCurAction++;
							if (action == "destroy") {
								if (this.hideHelp) {
									this.hideHelp.removeEventListener(MouseEvent.CLICK,hideHelpClickEvent);
								}
								if (bShowHelp) {
									this.gotoAndPlay("level_"+(nLevel+1)+"_"+nCurAction);
								}
							}
						}
					}
				}
			}
		}
		public function clearParticles():void {
				Object(parent).tutorialClear();
		}
		
		public function tutorialDone():void {
			//for now, any action taken just turns it off
			//later, as we implement messages
			//have it send a clip to specific frames for stages of messaging
			
			//when done
			this.gotoAndPlay("off");
			bActive = false;
			nState = STATE_OFF;
		}
		
		
		public function activateDialogClick():void {
			this.addEventListener(MouseEvent.CLICK,arrowNextClicked);
			this.hideHelp.addEventListener(MouseEvent.CLICK,hideHelpClickEvent);
			/*
			this.hideHelp.tabEnabled = false;
			this.hideHelp.tabChildren = false;
			*/
			this.stop();
		}
		
		public function arrowResponse():void {
			this.hideHelp.removeEventListener(MouseEvent.CLICK,hideHelpClickEvent);
			this.removeEventListener(MouseEvent.CLICK,arrowNextClicked);
			gotoAndPlay("level_" + (nLevel+1) + "_close");
			SoundManager.getInstance().play(SoundManager.SELECT_MENU);
		}
		
		public function arrowNextClicked(evt:MouseEvent):void {
			//trace("arrowResponse=" + arrowResponse);
			//Object(evt.target.parent).arrowResponse();
			arrowResponse();
		}
		
		public function hideHelpClickEvent(evt:MouseEvent):void {
			//trace("arrowResponse=" + arrowResponse);
			//Object(evt.target.parent).arrowResponse();
			//Object(evt.target.parent).hideResponse();
			hideResponse();
			arrowResponse();
		}
		
		public function hideResponse():void {
			bShowHelp = false;
			clearParticles();
			Object(parent).hideTutorial();
		}
			
			//level_10_close
		/*
		

this.addEventListener(MouseEvent.CLICK,arrowNext1Clicked);

function arrowNext1Clicked(evt:MouseEvent):void{ 
	evt.target.parent.removeEventListener(MouseEvent.CLICK,arrowNext1Clicked);
	gotoAndPlay("level_1_1_close");
};		
		*/

				
						
		
	}
}