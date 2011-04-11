package com.marvel.superherosquad.solitaire
{
	import com.zerog.components.buttons.BasicButton;
	import com.zerog.components.dialogs.AbstractDialog;
	
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;

	public class HeroesPage extends AbstractDialog
	{
		public var hulk:BasicButton;
		public var wolverine:BasicButton;
		public var thor:BasicButton;
		public var captainAmerica:BasicButton;
		public var ironMan:BasicButton;
		public var drDoom:BasicButton;
		public var msMarvel:BasicButton;
		public var close:BasicButton;
		public var arrowNext:SimpleButton;
		public var arrowBack:SimpleButton;
		
		public function HeroesPage() {
			super();
			
			this.hulk.addEventListener(MouseEvent.CLICK, onHulk);
			//this.hulk.buttonMode = true;
			
			this.wolverine.addEventListener(MouseEvent.CLICK, onWolverine);
			//this.wolverine.buttonMode = true;
			
			this.thor.addEventListener(MouseEvent.CLICK, onThor);
			//this.thor.buttonMode = true;
			
			this.captainAmerica.addEventListener(MouseEvent.CLICK, onCaptainAmerica);
			//this.captainAmerica.buttonMode = true;
			
			this.ironMan.addEventListener(MouseEvent.CLICK, onIronMan);
			//this.ironMan.buttonMode = true;
			
			this.drDoom.addEventListener(MouseEvent.CLICK, onDrDoom);
			//this.drDoom.buttonMode = true;
			
			this.msMarvel.addEventListener(MouseEvent.CLICK, onMsMarvel);
			//this.msMarvel.buttonMode = true;

			this.close.addEventListener(MouseEvent.CLICK, onClose);
			//this.close.buttonMode = true;
			gotoAndStop(1);
			
			arrowNext.addEventListener(MouseEvent.CLICK, onNext);
			arrowBack.addEventListener(MouseEvent.CLICK, onBack);
		}
		
		private function onNext(e:MouseEvent):void {
			if (currentFrame == 7) {
				gotoAndStop(1);
			}
			else {
			nextFrame();
			}
		}
		
		private function onBack(e:MouseEvent):void {
			if (currentFrame == 1) {
				gotoAndStop(7)}
			else {
				prevFrame();
			}
		}
		
		private function onClose(e:MouseEvent):void {
			removeDialog();
		}
		
		private function onHulk(e:MouseEvent):void {
			gotoAndStop("hulk");
		}
		
		private function onWolverine(e:MouseEvent):void {
			gotoAndStop("wolverine");
		}
		
		private function onThor(e:MouseEvent):void {
			gotoAndStop("thor");
		}
		
		private function onCaptainAmerica(e:MouseEvent):void {
			gotoAndStop("captainAmerica");
		}
		
		private function onIronMan(e:MouseEvent):void {
			gotoAndStop("ironMan");
		}

		private function onDrDoom(e:MouseEvent):void {
			gotoAndStop("drDoom");
		}
		
		private function onMsMarvel(e:MouseEvent):void {
			gotoAndStop("msMarvel");
		}
	}
}