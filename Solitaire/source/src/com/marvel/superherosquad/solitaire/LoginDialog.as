package com.marvel.superherosquad.solitaire
{
	import com.zerog.components.buttons.BasicButton;
	import com.zerog.components.dialogs.AbstractDialog;
	import com.zerog.events.DialogEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.net.*;

	public class LoginDialog extends AbstractDialog
	{
		public var username:TextField;
		public var password:TextField;
		public var loginButton:BasicButton;
		public var signUpButton:BasicButton;
		public var signUpDialog:SignUpDialog;
		public var status:TextField;
		
		public static const SEND_SIGN_UP:String = "send sign up";
		
		public function LoginDialog()
		{
			super();
			
			this.signUpDialog.addEventListener(DialogEvent.DIALOG_CONFIRM, onSignUpSend);
			this.signUpButton.addEventListener(MouseEvent.CLICK, onSignUpOpen);
			
			this.signUpDialog.setParent(this);
			removeSignUp();
		}
		public function setRegisterStatus(s:String):void {
			this.signUpDialog.setStatus(s);
		}
		public function getRegisterUsername():String {
			return this.signUpDialog.getUsername();
		}
		
		public function getRegisterPass():String {
			return this.signUpDialog.getPass();
		}
		
		public function getRegisterGender():String {
			return this.signUpDialog.getGender();
		}
		
		public function removeSignUp():void {
			this.signUpDialog.removeDialog();
		}
		
		public function setStatus(stat:String):void {
			this.status.text = stat;
		}
		
		public function onSignUpSend(e:Event):void {
			dispatchEvent(new Event(SEND_SIGN_UP));
		}

		public function onSignUpOpen(e:Event):void {
trace("send sign up");
			if (this.root.loaderInfo.parameters.registerURL != undefined) {
				    var targetURL:URLRequest = new URLRequest(this.root.loaderInfo.parameters.registerURL);
				    navigateToURL(targetURL, "_blank");
			}
			else {
				this.signUpDialog.showDialog();	
			}
			
		}
		
		public function getUsername():String {
			return this.username.text;
		}
		
		public function getPassword():String {
			return this.password.text;
		}
	}
}