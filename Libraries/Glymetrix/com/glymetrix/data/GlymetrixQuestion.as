package com.glymetrix.data
{
	public class GlymetrixQuestion
	{
		private var id:int;
		private var content:String;
		private var score:int;
		private var difficulty:int;
		private var choices:Array;
		
		public function GlymetrixQuestion(data:Object)
		{
			this.id = data.QuizQuestionID;
			this.content = data.Content;
			this.score = data.Score;
			this.difficulty = data.DifficultyLevel;
			this.choices = new Array();
			
			
			trace("GLYMETRIX QUESTION CONSTRUCT");
			trace(data.Choices);
			trace(data.Choices.length);
			for (var i:int = 0; i < data.Choices.length; i++) {
				trace("pushing new choice");
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