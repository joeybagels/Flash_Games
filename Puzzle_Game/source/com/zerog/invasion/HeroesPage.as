package com.zerog.invasion
{
	import com.zerog.components.buttons.BasicButton;
	import com.zerog.components.dialogs.AbstractDialog;
	
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;

	public class HeroesPage extends AbstractDialog
	{
		
		private var aHeroTags:Array = ["Hulk", "Wolverine", "Thor", "CaptainAmerica", "IronMan", "DrDoom", "Thing", "SilverSurfer", "Galactus"];
		
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
			
			this.thing.addEventListener(MouseEvent.CLICK, onThing);
			this.silverSurfer.addEventListener(MouseEvent.CLICK, onSilverSurfer);
			this.galactus.addEventListener(MouseEvent.CLICK, onGalactus);
			//this.msMarvel.buttonMode = true;

			this.close.addEventListener(MouseEvent.CLICK, onClose);
			//this.close.buttonMode = true;
			gotoAndStop(1);
			arrowNext.addEventListener(MouseEvent.CLICK, onNext);
			arrowBack.addEventListener(MouseEvent.CLICK, onBack);
		}

		override public function showDialog(x:Number = Number.NaN, y:Number = Number.NaN):void {
			super.showDialog(x, y);
			//Object(getParentContainer().parent).trackMenuEvent("characters");
			Object(getParentContainer().parent).trackHeroPageView(aHeroTags[currentFrame-1]);
		}
		
		private function onNext(e){
			if (currentFrame == 9) {
				Object(getParentContainer().parent).trackHeroPageView(aHeroTags[0]);
				gotoAndStop(1);
			}else {
				Object(getParentContainer().parent).trackHeroPageView(aHeroTags[currentFrame]);
				nextFrame();
			}
		}
		private function onBack(e){
			if (currentFrame == 1) {
				Object(getParentContainer().parent).trackHeroPageView(aHeroTags[8]);
				gotoAndStop(9);
			} else {
				Object(getParentContainer().parent).trackHeroPageView(aHeroTags[currentFrame-2]);
				prevFrame();
			}
		}
		
		private function onClose(e:MouseEvent):void {
			removeDialog();
		}
		
		private function onHulk(e:MouseEvent):void {
			Object(getParentContainer().parent).trackHeroPageView(aHeroTags[0]);
			gotoAndStop("hulk");
		}
		
		private function onWolverine(e:MouseEvent):void {
			Object(getParentContainer().parent).trackHeroPageView(aHeroTags[1]);
			gotoAndStop("wolverine");
		}
		
		private function onThor(e:MouseEvent):void {
			Object(getParentContainer().parent).trackHeroPageView(aHeroTags[2]);
			gotoAndStop("thor");
		}
		
		private function onCaptainAmerica(e:MouseEvent):void {
			Object(getParentContainer().parent).trackHeroPageView(aHeroTags[3]);
			gotoAndStop("captainAmerica");
		}
		
		private function onIronMan(e:MouseEvent):void {
			Object(getParentContainer().parent).trackHeroPageView(aHeroTags[4]);
			gotoAndStop("ironMan");
		}

		private function onDrDoom(e:MouseEvent):void {
			Object(getParentContainer().parent).trackHeroPageView(aHeroTags[5]);
			gotoAndStop("drDoom");
		}
		
		private function onThing(e:MouseEvent):void {
			Object(getParentContainer().parent).trackHeroPageView(aHeroTags[6]);
			gotoAndStop("thing");
		}
		
		private function onSilverSurfer(e:MouseEvent):void {
			Object(getParentContainer().parent).trackHeroPageView(aHeroTags[7]);
			gotoAndStop("silverSurfer");
		}
		
		private function onGalactus(e:MouseEvent):void {
			Object(getParentContainer().parent).trackHeroPageView(aHeroTags[8]);
			gotoAndStop("galactus");
		}
	}
}