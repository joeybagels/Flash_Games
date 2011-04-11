package com.marvel.superherosquad.solitaire
{
	public class QuestionCategory
	{
		private var name:String;
		private var id:int;
		private var questions:Array;
		private var title:String;
		
		public function QuestionCategory(data:Object)
		{
			this.name = data.QuizCategoryName;
			this.id = data.QuizCategoryID;
			this.title = data.QuizCategoryTitle;
			this.questions = new Array();
				
			
			this.questions.push(new Question(data.QuizQuestion));
		
		}
		public function getTitle():String {
			return this.title;
		}
		public function getId():int {
			return this.id;
		}
		public function getQuestion():Question {
			return this.questions[0];
		}
		public function getRandomQuestion():Question {
			var rand:int = Math.round(Math.random() * (this.questions.length - 1));
			trace("question index " + rand + " out of " + this.questions.length);
			var q:Question = this.questions[rand];
			
			return q;
		}
	}
}