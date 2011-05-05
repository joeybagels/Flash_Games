package com.glymetrix.data
{
	public class AnswerChoice
	{
		private var answer:Boolean;
		private var content:String;
		private var selection:int;
		private var id:int;
		
		public function AnswerChoice(data:Object)
		{
			this.answer = data.IsAnswer;
			this.content = data.ChoiceContent;
			this.selection = data.ChoiceSelection;
			this.id = data.ChoiceID;
		}
		public function getSelection():int {
			return this.selection;
		}
		public function getId():int {
			return this.id;
		}
		
		public function getAnswer():String {
			return this.content;
		}
		
		public function isAnswer():Boolean {
			return this.answer;
		}
	}
}