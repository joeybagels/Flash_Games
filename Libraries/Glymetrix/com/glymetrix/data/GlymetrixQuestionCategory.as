package com.glymetrix.data
{
	
	public class GlymetrixQuestionCategory
	{
		private var name:String;
		private var id:int;
		private var questions:Array;
		private var title:String;
		
		public function GlymetrixQuestionCategory(data:Object)
		{
			this.name = data.QuizCategoryName;
			this.id = data.QuizCategoryID;
			this.title = data.QuizCategoryTitle;
			this.questions = new Array();
				
				trace(title);
				trace(data.QuizQuestion);
			
			this.questions.push(new GlymetrixQuestion(data.QuizQuestion));
			
			trace(this.questions);
		
		}
		public function getTitle():String {
			return this.title;
		}
		public function getId():int {
			return this.id;
		}
		public function getQuestion():GlymetrixQuestion {
			return this.questions[0];
		}
		public function getRandomQuestion():GlymetrixQuestion {
			var rand:int = Math.round(Math.random() * (this.questions.length - 1));
			trace("question index " + rand + " out of " + this.questions.length);
			var q:GlymetrixQuestion = this.questions[rand];
			
			return q;
		}
	}
}