package com.glymetrix.modules.survey
{
	import com.zerog.components.dialogs.AbstractDialog;
	import com.zerog.events.AbstractDataEvent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.net.*;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.utils.getQualifiedClassName;
	import flash.events.Event;
	
	import com.zerog.components.dialogs.AbstractDialog;
	import com.zerog.events.DialogEvent;
	import com.glymetrix.data.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.events.IOErrorEvent;

 import org.rubyamf.remoting.ssr.*;
 import flash.errors.IOError;



	public class SurveyDialog extends AbstractDialog
	{
		public var errorDialog:MovieClip;
		private var questionCount:int = 0;
		public var countText:TextField;
		private var service:RemotingService;
		public static const ANSWER:String = "answer";
		public static const SURVEY_COMPLETE = "survey complete";
		private static const SOUNDS_URL:String = "http://174.129.22.44/data/";
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
		
		private var answers:Array;
		private var q:GlymetrixQuestion;
		private var start:Date;
		private var playSessionID:int;
		private var playSessionIDSubmit:int;
		
		public function SurveyDialog() {
			super();
			this.errorDialog.visible = false;
		}
		public function setService(service:RemotingService):void {
			this.service = service;
			this.playSessionID = playSessionID;
		}
		public function setSessionId(id:int):void {
			this.playSessionID = id;
		}
		override public function showDialog(x:Number = Number.NaN, y:Number = Number.NaN):void {
			trace("show dialog in survey");
			resetAnswers();
			this.start = new Date();
			
			
			addAllListeners();
			trace(this.parentContainer);
			showDialogAt(x, y, this.parentContainer.numChildren);
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
		private function increaseCount():void {
			this.questionCount++;
			this.countText.text = this.questionCount + "/5";
		}
		public function showError():void {
			this.errorDialog.visible = true;
			this.errorDialog.cancel.addEventListener(MouseEvent.CLICK, onErrorCancel);
		}
		private function onErrorCancel(e:MouseEvent):void {
			this.removeDialog();
		}
		public function loadQuestion():void {
			if (this.questionCount < 5) {
			increaseCount();
			this.service.choose_answer_bonus_question_activity(new Array(playSessionID, "Survey"), onGetBonusQuestion, onFail);
			}
			else {
				this.showDialog(0,0);
				this.showError();
			}
		}
				function onGetBonusQuestion(re:ResultEvent) {

					trace("SESSION ID " + (re.result.SessionActivityID as int));
					this.playSessionIDSubmit = (re.result.SessionActivityID as int);
					
					var questionCategory:GlymetrixQuestionCategory = new GlymetrixQuestionCategory(re.result.QuizCategory);
			
					setQuestionCategory(questionCategory);
					
					
				}
				
		private function selectAnswer(i:int):void {
			resetAnswers();
			var sc:SoundChannel;
			
			try {
				switch (i) {
					case 1:
					trace("ANSWER ONE");
					this.answer1.textColor = 0xffff00;
					sc = this.answer1Sound.play();
	
					break;
					
					case 2:
					this.answer2.textColor = 0xffff00;
					sc = this.answer2Sound.play();
	
					break;
					
					case 3:
					this.answer3.textColor = 0xffff00;
					sc = this.answer3Sound.play();
	
					break;
				}
				if (this.questionSoundChannel != null) {
					this.questionSoundChannel.stop();
				}
				
				sc.addEventListener(Event.SOUND_COMPLETE, onAnswerSoundComplete);
			}
			catch(e) {
				trace("HERE");
				onAnswerSoundComplete(null);
			}
			
			trace("here after catch");
			
			trace(this.answers[i]);
			trace(this.start);
			trace(getQuestion());
			
			if (this.answers[i] == undefined) {
				onSubmitAnswer();
			}
			else {
						this.service.submit_question_choice(new Array(
                                {ChoiceSelectedID: this.answers[i].getId(),
                                 EnterQuestionTime: this.start.toUTCString(),
                                 EndQuestionTime: (new Date()).toUTCString(),
                                 EarnedScore: getQuestion().getScore(),
                                 AnsweredCorrectly: this.answers[i].isAnswer()},
                                 this.playSessionIDSubmit , getQuestion().getId()), onSubmitAnswer, onSubmitAnswer);
			
			}
			
		}
		
		private function onSubmitAnswer(re:Event=null):void {
			trace("on sub answer");
			if (this.questionCount >= 5) {
				trace("remove dialog");
				this.removeDialog();
				dispatchEvent(new Event(SURVEY_COMPLETE));
			}
			else {
				trace("load questrion");
				this.loadQuestion();
			}
			
		}
		private function onFail(fe:FaultEvent):void {
			trace("on sub answerfail");
			
			
		}
private var questionSound:Sound;
private var answer1Sound:Sound;
private var answer2Sound:Sound;
private var answer3Sound:Sound;
private var questionSoundChannel:SoundChannel;

		private function questionSoundReady(e:Event):void {
			this.questionSoundChannel = this.questionSound.play();
			
			showLoading(false);
			
		}
		
		private function onAnswerSoundComplete(e:Event):void {
			//removeDialog();
			trace("answer copmplete");
		}
		
		public function setQuestionCategory(questionCategory:GlymetrixQuestionCategory):void {
trace("Questio cat " + questionCategory);
					//this.sessionActivityId = re.result.SessionActivityID as int;
		
					this.q = questionCategory.getQuestion();
			trace("got question");
					setCategory(questionCategory.getTitle());
					trace("set cat");
					setQuestion(this.q);
			trace("set quest");
					showLoading(true);
					trace("show loading");
					showDialog(0,0);
			trace("question "+this.q);
			trace(this.q.getAnswers());
					var answers:Array = q.getAnswers();
					trace("answers " + q.getAnswers());
			
					var qURL:URLRequest = new URLRequest(SOUNDS_URL + q.getId() + "q.mp3");
			
					var a1URL:URLRequest = new URLRequest(SOUNDS_URL + (answers[0] as AnswerChoice).getId() + "a.mp3");
					var a2URL:URLRequest = new URLRequest(SOUNDS_URL + (answers[1] as AnswerChoice).getId() + "a.mp3");
					var a3URL:URLRequest = new URLRequest(SOUNDS_URL + (answers[2] as AnswerChoice).getId() + "a.mp3");
                        
					if (this.questionSound != null) {
						this.questionSound.removeEventListener(Event.COMPLETE,questionSoundReady);
					}
						
						this.questionSound = new Sound();
                        this.questionSound.addEventListener(Event.COMPLETE,questionSoundReady);
						this.questionSound.addEventListener(IOErrorEvent.IO_ERROR, questionSoundReady);
						
                        this.answer1Sound = new Sound();
                        this.answer2Sound = new Sound();
                        this.answer3Sound = new Sound();
                        
						this.answer1Sound.addEventListener(IOErrorEvent.IO_ERROR, onAnswerSoundLoadError);
						this.answer2Sound.addEventListener(IOErrorEvent.IO_ERROR, onAnswerSoundLoadError);
						this.answer3Sound.addEventListener(IOErrorEvent.IO_ERROR, onAnswerSoundLoadError);
						
                        this.questionSound.load(qURL);
                        
                        this.answer1Sound.load(a1URL);
                        this.answer2Sound.load(a2URL);
                        this.answer3Sound.load(a3URL);
		}
		private function onAnswerSoundLoadError(e:IOErrorEvent):void {
			
		}
		public function setCategory(s:String):void {
			trace("title is " + s);
			this.category.text = s.toUpperCase();
		}
		public function getQuestion():GlymetrixQuestion {
			return this.q;
		}
		public function getStart():Date {
			return this.start;
		}
		public function showLoading(en:Boolean):void { 
			this.loading.visible = en;
		}
		public function setQuestion(q:GlymetrixQuestion):void {
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