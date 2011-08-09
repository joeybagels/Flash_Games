package com.marvel.superherosquad.solitaire
{
	import com.zerog.components.dialogs.AbstractAlertDialog;
	import com.zerog.events.AbstractDataEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;


	public class QuestionDialog extends AbstractAlertDialog
	{
		
		public static const ANSWER:String = "answer";
		public static const CLOSE_ANSWER_DIALOG:String = "answer dialog close";
		public var question:TextField;
		public var category:TextField;
		//public var score:TextField;
		public var answer1:TextField;
		public var answer2:TextField;
		public var answer3:TextField;
		public var answer1Click:MovieClip;
		public var answer2Click:MovieClip;
		public var answer3Click:MovieClip;
		public var loading:MovieClip;
		private var selected:int;
		public var answerQuestionDialog:MovieClip;
		public function QuestionDialog()
		{
			super();
			
			this.answerQuestionDialog.visible = false;
			this.answerQuestionDialog.closeButton.addEventListener(MouseEvent.CLICK, onAnswerTextDialogClose);

		}
		
		private function onAnswerTextDialogClose(e:MouseEvent):void {
			this.answerQuestionDialog.visible = false;
			this.answerQuestionDialog.answerText.text = "";
			dispatchEvent(new AbstractDataEvent(CLOSE_ANSWER_DIALOG));
		}
		public function showAnswerText(s:String):void {
			if (s!=null) {
			this.answerQuestionDialog.answerText.text = s;
			}
			this.answerQuestionDialog.visible = true;
		}
		override public function showDialog(x:Number = Number.NaN, y:Number = Number.NaN):void {
			super.showDialogAt(x, y, this.parentContainer.numChildren);
			
			resetAnswers();
			this.start = new Date();
			
			this.dismissButton.visible = true;
			addAllListeners();
		}
		private function removeAllListeners():void {
			this.answer1Click.removeEventListener(MouseEvent.CLICK, onAnswer1Click);
			this.answer2Click.removeEventListener(MouseEvent.CLICK, onAnswer2Click);
			this.answer3Click.removeEventListener(MouseEvent.CLICK, onAnswer3Click);			
		}
		private function addAllListeners():void {
			this.answer1Click.addEventListener(MouseEvent.CLICK, onAnswer1Click);
			this.answer2Click.addEventListener(MouseEvent.CLICK, onAnswer2Click);
			this.answer3Click.addEventListener(MouseEvent.CLICK, onAnswer3Click);			
		}
		public function getSelected():int {
			return this.selected;
		}
		
		private function onAnswer1Click(e:MouseEvent):void {
			selectAnswer(1);
			this.selected = 1;
			removeAllListeners();
			dispatchEvent(new AbstractDataEvent(ANSWER,this.answers[0]));
		}
		
		private function onAnswer2Click(e:MouseEvent):void {
			selectAnswer(2);
			this.selected = 2;
			removeAllListeners();
			dispatchEvent(new AbstractDataEvent(ANSWER,this.answers[1]));
		}

		private function onAnswer3Click(e:MouseEvent):void {
			selectAnswer(3);
			this.selected = 3;
			removeAllListeners();
			dispatchEvent(new AbstractDataEvent(ANSWER,this.answers[2]));
		}

		private function resetAnswers():void {
			this.answer1.textColor = 0x000000;
			this.answer2.textColor = 0x000000;
			this.answer3.textColor = 0x000000;
		}
		private function selectAnswer(i:int):void {
			resetAnswers();
			
			switch (i) {
				case 1:
				this.answer1.textColor = 0xff0000;
				break;
				
				case 2:
				this.answer2.textColor = 0xff0000;
				break;
				
				case 3:
				this.answer3.textColor = 0xff0000;
				break;
			}
			
			this.dismissButton.visible = false;
		}
		
		private var answers:Array;
		private var q:Question;
		private var start:Date;
		public function setCategory(s:String):void {
			this.category.text = s.toUpperCase();
		}
		public function getQuestion():Question {
			return this.q;
		}
		public function getStart():Date {
			return this.start;
		}
		public function showLoading(en:Boolean):void { 
			this.loading.visible = en;
		}
		public function setQuestion(q:Question):void {
			this.answers = new Array();
			
			this.q = q;
			this.question.text = q.getQuestion();
			//this.score.text = new String(q.getScore());
			
			var a:Array = q.getAnswers();
			
			if (a != null) {
				var ac:AnswerChoice;
				
				if (a.length > 0) {
					ac = a[0];
					
					this.answer1.text = ac.getAnswer();
					this.answers.push(ac);
				}
				
				if (a.length > 1) {
					ac = a[1];
					
					this.answer2.text = ac.getAnswer();
					this.answers.push(ac);
				}
				
				if (a.length > 2) {
					ac = a[2];
					
					this.answer3.text = ac.getAnswer();
					this.answers.push(ac);
				}
			}
			
		}
		
	}
}