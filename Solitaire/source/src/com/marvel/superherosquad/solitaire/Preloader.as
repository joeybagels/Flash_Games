package com.marvel.superherosquad.solitaire
{
	import flash.display.*;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.net.URLRequest;
	
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
			trace(this.root);
			trace(this.root.loaderInfo.parameters.loadingBrand);
			if (this.root.loaderInfo.parameters.loadingBrand != undefined) {
				var l:Loader = new Loader();
				l.x = this.root.loaderInfo.parameters.loadingBrandX;
				l.y = this.root.loaderInfo.parameters.loadingBrandY;
				l.contentLoaderInfo.addEventListener(Event.COMPLETE, brandLoaded);
				l.load(new URLRequest(this.root.loaderInfo.parameters.loadingBrand));
				//l);
				
			}
			else {
				showLoader();	
			}		
		}
		
		private function brandLoaded(e:Event):void {
			
			showLoader();
			this.preloadDialog.addBrand(e.currentTarget.loader as Loader);	
		}

		private function showLoader():void {
				
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
			var assets:String = "Assets.swf";
			var data:String = "http://174.129.22.44/data/";
			
			//if (this.root.loaderInfo.parameters.brand) {
			//	assets = this.root.loaderInfo.parameters.brand;
			//}
			
			if (this.root.loaderInfo.parameters.data) {
				data = this.root.loaderInfo.parameters.data;
			}
			
			
			var game:DisplayObject = new mainClass(assets, data) as DisplayObject;
	
			addChild(game);
			
		}
	}
}