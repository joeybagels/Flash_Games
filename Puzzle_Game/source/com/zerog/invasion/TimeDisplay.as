/***************************************************************

	Copyright 2008, Zero G Games Limited.
	
	Redistribution of part or whole of this file and
	the accompanying files is strictly prohibited.
	
	Redistribution of modified versions of this file and
	the accompaying files is also strictly prohibited.
	
****************************************************************/
	
	
	
package com.zerog.invasion {
	import flash.display.*;
	import flash.text.TextField;
	
	public class TimeDisplay extends MovieClip {
		//private var radius:Number;
		/*
		private var nMaxProgress:Number;
		private var nCurProgress:Number;
		
		private var nAmtProgress:Number;
		private var nProgCurVel:Number;
		private var nProgVelStart:Number;
		private var nProgAccelPerc:Number;
		private var nProgDecelPerc:Number;
		
		private var nBeamStart:Number;
		private var nBeamEnd:Number;
		
		private var nDir:Number;
		private var nLastTime:int;
		*/
		
		//lightpatch.light0
		private var nNumLights:int = 16;
		
		private var nMaxProgress:Number;
		private var nCurProgress:Number;
		private var nAmtProgress:Number;
		
		private var nLastTime:int;
		private var nUpdatePace:int = 200;
		
		private var nStepAmt:Number;
		private var nLastLight:int;
		private var nFrameStepAmt:Number;
		private var aLightsOn:Array;
		
		private var nNextLightEffect:int;
		private var nLightCallKillCount:int;
		private var callCount:int;
		
		private var bFinalAnimRdy:Boolean;
		private var nFinalAnimCount:Number;
		
		function TimeDisplay() {
			//radius = Math.max(width, height);
			//nProgVelStart = -0.01;
			/*
			nProgVelStart = -1;
			nProgAccelPerc = 1.06;
			//nProgDecelPerc = 0.94;
			nProgDecelPerc = 0.98;
			nProgCurVel = 0;
			
			nBeamStart = 0;
			//nBeamEnd = -285;
			nBeamEnd = -440;//-464;
			
			beamClip.beamLoop.gotoAndStop(1);
			*/
			nNextLightEffect = 0;
			nLightCallKillCount = 0;
			callCount = 0;
			aLightsOn = new Array();
			bFinalAnimRdy = false;
			nFinalAnimCount = 30;
		}
		
		public function shutdown():void {
			var x:int;
			for (x = 0; x < nNumLights; x++){
				lightpatch["light"+x].stop();
			}
			for (x = 0; x < 10; x++){
				this["charge" + x].stop();
			}
		}
		
		public function setTimeText(ratio:Number, time:int):void {
			/*
			this.setTime(ratio);
			var sec:int = Math.floor((time * ratio) / 1000);
			var min:int = Math.floor(sec / 60);
			sec = Math.floor(sec % 60);
			var strSec:String;
			if (sec < 0) sec = 0;
			if (min < 0) min = 0;
			if (sec < 10) {
				strSec = "0" + sec.toString();
			} else {
				strSec = sec.toString();
			}
			
			this.timeText.text = min.toString() + ":" + strSec;
			*/
		}
		
		public function setMaxProgress(prog:Number):void {
			/*
			nAmtProgress = 0;
			nProgCurVel = 0;
			beamClip.y = nBeamStart;
			*/
			//trace("setMaxProgress(prog=" + prog + ")");
			/*
			nMaxProgress = prog;
			nAmtProgress = prog;
			beamClip.y = nBeamEnd;
			nCurProgress = prog;
			*/
			aLightsOn = new Array();
			for (var x:int = 0; x < nNumLights; x++){
				lightpatch["light"+x].gotoAndPlay("off");
				aLightsOn.push(false);
			}
			
			nMaxProgress = prog;
			nCurProgress = 0;
			nAmtProgress = 0;
			nStepAmt = nNumLights / prog;//prog / nNumLights;
			nFrameStepAmt = prog / nNumLights;
			nLastLight = 0;
			bFinalAnimRdy = false;
			nFinalAnimCount = 30;
		}
		
		public function setCurProgress(prog:Number):void {
			//trace("setCurProgress(prog=" + prog + ") nAmtProgress=" + nAmtProgress + ", nCurProgress=" + nCurProgress);
			/*
			if (nAmtProgress != nCurProgress) {
				nProgCurVel = nProgVelStart - ((nCurProgress - nAmtProgress)/10);
			} else {
				nProgCurVel = nProgVelStart;
			}
			*/
			
			/*
			if (prog < nCurProgress) {
				if (nAmtProgress != nCurProgress) {
					nProgCurVel = (-nProgVelStart) + ((nCurProgress-prog)/10);
				} else {
					nProgCurVel = -nProgVelStart;
				}
			} else {
				if (nAmtProgress != nCurProgress) {
					nProgCurVel = nProgVelStart - ((nCurProgress - nAmtProgress)/10);
				} else {
					nProgCurVel = nProgVelStart;
				}
			}
			trace("  nProgCurVel=" + nProgCurVel);
			nCurProgress = prog;
			*/
			
			
			
			/*
			//keep track of direction variable, depending if prog is >< current
			if (prog > nCurProgress) {
				nDir = 1;
				//beamClip.beamLoop.play();
			} else if (prog < nCurProgress) {
				nDir = -1;
				//beamClip.beamLoop.play();
			} else {
				nDir = 0;
			}
			
			nCurProgress = prog;
			*/
			
			nAmtProgress = prog;
			nLastTime = -1;
		}
		
		public function updateDisplay(time:int):void {
			/*
			if (nAmtProgress != nCurProgress) {
				*/
				//update the display
				//beamClip
				//285 height
				/*
				if (nProgCurVel == 0) {
					nProgCurVel = nProgVelStart;
				}
				*/
				//trace("amt=" + nAmtProgress + ", nCurProgress=" + nCurProgress + ", vel=" + nProgCurVel);
				
				//affect nProgCurVel based on position in the current movement
				//find mid point of current movement.
				/*
				var startPt:Number = nBeamEnd*(nAmtProgress/nMaxProgress);
				var endPt:Number = nBeamEnd*(nCurProgress/nMaxProgress);
				var midPt:Number = startPt + ((endPt - startPt) / 2);
				*/
				
				//trace("  start=" + startPt + ", mid=" + midPt + ", end=" + endPt);
				//trace("  beam=" + beamClip.y);
				//if (beamClip.y < midPt * 1.2) {
				/*
				if (beamClip.y < midPt) {
					nProgCurVel *= nProgDecelPerc;
				} else {
					nProgCurVel *= nProgAccelPerc;
				}
				if (nProgCurVel > -0.01) {
					nProgCurVel = -0.01;
				}
				*/
				
				/*
				nProgCurVel *= nProgDecelPerc;
				if (nProgCurVel < 0 && nProgCurVel > -0.02) {
					nProgCurVel = -0.02;
				} else if (nProgCurVel > 0 && nProgCurVel < 0.02) {
					nProgCurVel = 0.02;
				}
				//move beam
				beamClip.y = beamClip.y + nProgCurVel;
				*/
				//if (nProgCurVel < 0 && beamClip.y < endPt + 0.25) {
				/*
				if (beamClip.y < endPt + 0.25) {
					beamClip.y = endPt;
					nAmtProgress = nCurProgress;
					nProgCurVel = 0;
				}
				*/
				/*
				if (nProgCurVel < 0) {
					if (beamClip.y < endPt + 0.25) {
						beamClip.y = endPt;
						nAmtProgress = nCurProgress;
						nProgCurVel = 0;
					}
				} else {
					if (beamClip.y > endPt + 0.25) {
						beamClip.y = endPt;
						nAmtProgress = nCurProgress;
						nProgCurVel = 0;
					}
				}
				*/
				/*
				if (nProgCurVel <= 0) {
					if (Math.abs(beamClip.y - endPt) < 0.25) {
						beamClip.y = endPt;
						nAmtProgress = nCurProgress;
						nProgCurVel = 0;
					}
				} else {
					if (Math.abs(beamClip.y - startPt) < 0.25) {
						beamClip.y = startPt;
						nAmtProgress = nCurProgress;
						nProgCurVel = 0;
					}
				}
				*/
				/*
				if (Math.abs(beamClip.y - endPt) < 0.25) {
					beamClip.y = endPt;
					nAmtProgress = nCurProgress;
					nProgCurVel = 0;
				}
			}
			*/
			
			
			//each frame
			//if dir is not zero
			//increment amtProgress
			//determine ratio of current progress to total
			//draw beam at current ratio
			
			//if we've reached the destination, dir = 0
			//check this by looking at direction and if we've passed or come within rnd of destination
			
			
			//nAmtProgress = where it is
			//nCurProgress = where we want it to be
			//overall max setting nMaxProgress
			//var ratio:Number = nCurProgress / nMaxProgress;
			//beamClip.y = ratio * nBeamEnd;
			/*
			if (nDir != 0) {
				//trace("updateDisplay(" + time + ") nDir=" + nDir + ", nLastTime=" + nLastTime);
				if (isNaN(nLastTime)) {
					nLastTime = time;
				}
				if (time - nLastTime > 300) {
					nLastTime = time;
				}
				//var distance:Number = Config.GEMS_ACCELERATION * dTime * dTime / 2000000;
				//trace("  t=" + (time - nLastTime) + " v=" + (0.01 * (time - nLastTime)));
				var vel:Number;
				if (nDir < 0) {
					vel = 0.01;
				} else {
					vel = 0.001;
				}
				nAmtProgress += (vel * (time - nLastTime)) * nDir;
				var ratio:Number = nAmtProgress / nMaxProgress;
				//trace("  amtProgress=" + nAmtProgress + ", ratio=" + ratio);
				//ratio = ratio * ratio;
				beamClip.y = ratio * nBeamEnd;
				beamClip.scaleX = 1 - (ratio * ratio);
				if (nDir < 0 && nAmtProgress <= nCurProgress) {
					nDir = 0;
					beamClip.beamLoop.stop();
				} else if (nDir > 0 && nAmtProgress >= nCurProgress) {
					nDir = 0;
					beamClip.beamLoop.stop();
				}
			}
			nLastTime = time;
			*/
			
			if (nLastTime < 0) {
				nLastTime = time;
				return;
			}
			
			if (time - nLastTime > nUpdatePace) {
				nLastTime = time;
				if (nCurProgress < nAmtProgress) {
					//lightpatch["light"+nCurProgress].gotoAndPlay("on");
					//nCurProgress++;
					/*
					trace("update() nMaxProgress=" + nMaxProgress + ", nCurProgress=" + nCurProgress + ", nAmtProgress=" + nAmtProgress);
					trace("  cur light=" + (nCurProgress / nNumLights));
					trace("  cur light=" + (nCurProgress / nStepAmt));
					trace("  cur light=" + (nCurProgress * nStepAmt));
					*/
					var tTarget:int = Math.min(Math.floor((nCurProgress * nStepAmt)),nNumLights-1);
					for (var x:int = nLastLight; x <= tTarget; x++){
						if (!aLightsOn[x]) {
							aLightsOn[x] = true;
							if (x < nNumLights-1) {
								lightpatch["light"+x].gotoAndPlay("on");
							} else {
								lightpatch["light"+x].gotoAndPlay("on2");
							}
						}
					}
					nLastLight = tTarget;
					nCurProgress += nFrameStepAmt;//nStepAmt;
				}
				
			}
			
			if (bFinalAnimRdy && nCurProgress >= nMaxProgress) {
				nFinalAnimCount -= 0.3;
				//trace("final anim playing=" + nFinalAnimCount);
				if (nFinalAnimCount < 0) {
					//trace("START FINAL ANIM!");
					bFinalAnimRdy = false;
					Object(parent).beamFinalStarted();
					this.gotoAndPlay("finalShot");
				}
			}
			
		}
		
		public function setTime(ratio:Number):void {
			/*
			foregroundMask.graphics.clear();
			
			foregroundMask.graphics.beginFill(0);
			foregroundMask.graphics.moveTo(0, -radius);
			
			if(ratio > 1 / 4) foregroundMask.graphics.lineTo(radius, 0);
			if(ratio > 1 / 2) foregroundMask.graphics.lineTo(0, radius);
			if(ratio > 3 / 4) foregroundMask.graphics.lineTo(-radius, 0);
			
			foregroundMask.graphics.lineTo(radius * Math.sin(Math.PI * 2 * ratio), -radius * Math.cos(Math.PI * 2 * ratio));
			
			foregroundMask.graphics.lineTo(0, 0);
			foregroundMask.graphics.lineTo(0, -radius);
			
			foregroundMask.graphics.endFill();
			*/
		}
		
		public function beamChargeEnd():void {
			/*
			if (bFinalAnimRdy) {
				nFinalAnimCount++;
				//trace("nFinalAnimCount++* = " + nFinalAnimCount);
			}
			*/
		}
		
		public function playGemPowerAnim():void {
			//if (nLightCallKillCount > 190) {
			if (nLightCallKillCount > 90) {
				//trace("calls=" + callCount);
				//callCount++;
				if (nNextLightEffect > 9) {
					nNextLightEffect = 0;
				}
				//trace("here");
				if (this["charge" + nNextLightEffect] != null) {
					this["charge" + nNextLightEffect].gotoAndPlay("power");
				}
				nLightCallKillCount = 0;
				nNextLightEffect++;
				if (bFinalAnimRdy) {
					nFinalAnimCount++;
					//trace("nFinalAnimCount++ = " + nFinalAnimCount);
				}
			}
			nLightCallKillCount++;
		}
		
		public function setFinalState():void {
			//trace("setFinalState");
			for (var x:int = 0; x < aLightsOn.length; x++){
				if (!aLightsOn[x]) {
					lightpatch["light"+x].gotoAndPlay("on2");
				}
			}
			
			nFinalAnimCount = 30;
			bFinalAnimRdy = true;
		}
		public function beamFinalDone():void {
			Object(parent).beamFinalDone();
			//this.stop();
		}
		public function setReadyState():void {
			this.gotoAndPlay("ready");
		}
		
		public function playChargeSound():void {
			SoundManager.getInstance().play(SoundManager.END_LEVEL_BEAM);
		}
		public function playShootSound():void {
			SoundManager.getInstance().play(SoundManager.ENERGY_BEAM);
		}
		public function playLightSound():void {
			SoundManager.getInstance().play(SoundManager.ENERGY_THERMOMETER);
		}
		public function playMidLightSound():void {
			SoundManager.getInstance().play(SoundManager.SPARKLE_GEM);
		}
		
	}
}