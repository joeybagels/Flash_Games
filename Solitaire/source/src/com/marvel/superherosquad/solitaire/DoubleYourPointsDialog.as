package com.marvel.superherosquad.solitaire
{
	import com.zerog.components.dialogs.AbstractInputDialog;
	import flash.events.MouseEvent;
	public class DoubleYourPointsDialog extends AbstractInputDialog
	{
		private var shown:Boolean;
		public function DoubleYourPointsDialog()
		{
			super();
			this.shown = false;
		}
		
		public function hasBeenShown():Boolean {
			return this.shown;
		}
		
		override protected function onConfirm(e:MouseEvent):void {
			super.onConfirm(e);
			
			this.shown = true;
		}
	}
}