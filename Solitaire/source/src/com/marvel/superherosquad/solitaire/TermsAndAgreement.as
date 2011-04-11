package com.marvel.superherosquad.solitaire
{
	import com.zerog.components.dialogs.AbstractAlertDialog;
	import com.zerog.components.scroller.BasicScroller;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	public class TermsAndAgreement extends AbstractAlertDialog
	{
		public var terms:TextField;
		public var thumb:MovieClip;
		public var gutter:MovieClip;
		public var upButton:MovieClip;
		public var downButton:MovieClip;
		private var scroller:BasicScroller;
		private var shown:Boolean;
		
		public function TermsAndAgreement()
		{
			super();
			
			this.scroller = new BasicScroller(this.upButton, this.downButton, this.thumb, this.gutter);
			this.scroller.setTarget(this.terms);
		}
		public function hasBeenShown():Boolean {
			return this.shown;
		}
		public function setTOS(termsText:String):void {
			this.terms.htmlText = termsText;
			this.scroller.update();
		}

		override public function showDialog(x:Number = Number.NaN, y:Number = Number.NaN):void {
			super.showDialogAt(x, y, this.parentContainer.numChildren);
			this.shown = true;
			this.scroller.setThumbOutside(this.stage);
		}
	}
}