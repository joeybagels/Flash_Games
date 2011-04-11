package com.marvel.superherosquad.solitaire
{
	public class Question
	{
		private var id:int;
		private var content:String;
		private var score:int;
		private var difficulty:int;
		private var choices:Array;
		
		public function Question(data:Object)
		{
			this.id = data.QuizQuestionID;
			this.content = data.Content;
			this.score = data.Score;
			this.difficulty = data.DifficultyLevel;
			this.choices = new Array();
			
			for (var i:int = 0; i < data.Choices.length; i++) {
				this.choices.push(new AnswerChoice(data.Choices[i]));
			}
		}
		
		public function getId():int {
			return this.id;
		}
		
		public function getQuestion():String {
			return this.content;
		}
		
		public function getAnswers():Array {
			return this.choices;
		}
		
		public function getScore():int {
			return this.score;
		}
	}
}