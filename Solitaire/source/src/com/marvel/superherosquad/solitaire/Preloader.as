package com.marvel.superherosquad.solitaire
{
	import flash.display.*;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;

 	[SWF(width="760", height="610", backgroundColor="#000000", frameRate="30")]
	public class Preloader extends MovieClip {

		[Embed(source="../../../../../bin-debug/com/marvel/superherosquad/solitaire/Assets.swf#Loading")]
 		private var PreloadDisplay:Class;
 		private var preloadDisplay:Sprite = new PreloadDisplay();
		private var preloadDialog:LoadingDisplay;
		
		public function Preloader() {
			//stop timeline
			stop();

			this.preloadDialog = new LoadingDisplay;
			this.preloadDialog.setDisplay(this.preloadDisplay);
			this.preloadDialog.setParent(this);
			this.preloadDialog.setPercent(0);
			this.preloadDialog.setStatus("Loading game...");
			this.preloadDialog.showDialog(0,0);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ENTER_FRAME, checkFrame); 			
		}

		private function onAddedToStage(e:Event):void {
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
		}
		
		override public function get width():Number {
			return 760;
		}
		
		override public function get height():Number {
			return 610;
		}

		private function checkFrame(e:Event):void {
			var percent:Number = this.root.loaderInfo.bytesLoaded / this.root.loaderInfo.bytesTotal;
			this.preloadDialog.setPercent(percent);
			
			if (this.framesLoaded == this.totalFrames) {
				trace("done1");
				this.preloadDialog.removeDialog();
				removeEventListener(Event.ENTER_FRAME, checkFrame);
				nextFrame();
				init();
			}
			else {
				percent = this.root.loaderInfo.bytesLoaded / this.root.loaderInfo.bytesTotal;
				this.preloadDialog.setPercent(percent);
			}
		}

		private function init():void {
					
			//Hides Preloader
			var mainClass:Class = getDefinitionByName("com.marvel.superherosquad.solitaire.Game") as Class;
			var game:DisplayObject = new mainClass(this.root.loaderInfo.parameters.brand) as DisplayObject;
	
			addChild(game);
			
		}
	}
}