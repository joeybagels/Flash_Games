package  {
	import com.zerog.components.dialogs.AbstractDialog;
	import flash.text.TextField;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import com.zerog.events.DialogEvent;
	import flash.display.MovieClip;
	
	public class AnswerTextDialog extends AbstractDialog {
		public var dismissButton:SimpleButton;
		public var answerText:TextField;
		public var check:MovieClip;
		public var ex:MovieClip;
		
		public function AnswerTextDialog() {
			this.dismissButton.addEventListener(MouseEvent.CLICK, onDismiss);
		}
		override public function showDialogAt(x:Number = Number.NaN, y:Number = Number.NaN, index:int = -1):void {

			super.showDialogAt(x, y, index);
		}
		
		public function setAnswerText(s:String, correct:Boolean):void {
			this.answerText.text = "";
			this.check.visible = false;
			this.ex.visible = false;
			
			if (s!=null)
				this.answerText.text = s;
			
			this.check.visible = correct;
			this.ex.visible = !correct;
		}
		private function onDismiss(e:MouseEvent):void {
			dispatchEvent(new DialogEvent(DialogEvent.DIALOG_DISMISS));
			removeDialog();
			
		}

	}
	
}
