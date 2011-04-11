package com.marvel.superherosquad.solitaire
{
	import com.zerog.components.dialogs.AbstractDialog;
	import com.zerog.components.buttons.BasicButton;
	import com.zerog.events.DialogEvent;
	
	import flash.events.MouseEvent;
	
	public class AutoConfirmDialog extends AbstractDialog
	{
		public var dismissButton:BasicButton;
		public var proceedButton:BasicButton;
		
		public function AutoConfirmDialog()
		{
			super();
			this.dismissButton.addEventListener(MouseEvent.CLICK, onDismiss);
			this.proceedButton.addEventListener(MouseEvent.CLICK, onProceed);
		}
		
		protected function onDismiss(e:MouseEvent):void {
			removeDialog();
		}
		
		protected function onProceed(e:MouseEvent):void {
			dispatchEvent(new DialogEvent(DialogEvent.DIALOG_CONFIRM));
			
			removeDialog();
		}
	}
}