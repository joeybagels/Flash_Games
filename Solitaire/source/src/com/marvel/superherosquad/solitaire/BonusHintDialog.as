package com.marvel.superherosquad.solitaire
{
	import com.zerog.components.buttons.AbstractButton;
	import com.zerog.components.dialogs.AbstractDialog;
	
	import flash.events.MouseEvent;
	import flash.ui.Mouse;

	public class BonusHintDialog extends AbstractDialog
	{
		public var closeButton:AbstractButton;
			
		public function BonusHintDialog()
		{
			super();
			
			this.closeButton.addEventListener(MouseEvent.CLICK, onClose);
		}
		private function onClose(e:MouseEvent):void {
			removeDialog();
		}
		override public function get width():Number {
			return 760;
		}
		override public function get height():Number {
			return 610;
		}
	}
}