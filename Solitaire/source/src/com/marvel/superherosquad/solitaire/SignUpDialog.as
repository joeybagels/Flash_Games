package com.marvel.superherosquad.solitaire
{
	import com.zerog.components.buttons.BasicButton;
	import com.zerog.components.buttons.ButtonEvent;
	import com.zerog.components.dialogs.AbstractInputDialog;
	import com.zerog.events.DialogEvent;
	
	import fl.controls.CheckBox;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	public class SignUpDialog extends AbstractInputDialog
	{
		public var username:TextField;
		public var pass1:TextField;
		public var pass2:TextField;
		public var terms:CheckBox
		public var maleButton:BasicButton;
		public var femaleButton:BasicButton;
		public var status:TextField;
		
		public function SignUpDialog()
		{
			super(); 
			
			this.maleButton.addEventListener(ButtonEvent.SELECTED, onGenderSelect);
			this.femaleButton.addEventListener(ButtonEvent.SELECTED, onGenderSelect);
		}
		
		override protected function onConfirm(e:MouseEvent):void {
			if (getUsername() != null && getUsername().length > 0 && getPass() != null && getPass().length > 0 && getGender() != null && terms.selected) {
				dispatchEvent(new DialogEvent(DialogEvent.DIALOG_CONFIRM));	
			} 
		}
		
		public function getUsername():String {
			return this.username.text;
		}
		
		public function getPass():String {
			return this.pass1.text;
		}
		
		public function getGender():String {
			if (maleButton.isSelected() || femaleButton.isSelected()) {
				if (maleButton.isSelected()) {
					return "m";
				}
				else {
					return "f";
				}
			}
			else {
				return null;
			}
		}
		public function setStatus(s:String):void {
			this.status.text = s;
		}
		private function onGenderSelect(e:ButtonEvent):void {
			trace(e.currentTarget);
			trace(e.target);
			if (e.currentTarget == this.maleButton) {
				this.maleButton.setSelectOnClick(false);
				
				this.femaleButton.setSelectOnClick(true);
				this.femaleButton.setSelected(false, false);
			}
			else if (e.currentTarget == this.femaleButton) {
				this.femaleButton.setSelectOnClick(false);

				this.maleButton.setSelectOnClick(true);
				this.maleButton.setSelected(false, false);
			}
		}
	}
}