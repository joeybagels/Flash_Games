package com.marvel.superherosquad.solitaire
{
	import com.zerog.events.AbstractDataEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.rubyamf.remoting.ssr.*;
	
	public class DatabaseAPI extends EventDispatcher
	{
		private var username:String;
		private var myService:RemotingService;
		private var loggedIn:Boolean;
		private var playSessionId:int;
		private var sessionActivityId:int;
		private var nc:NetConnection;
		private var consentForm:String;
		//private var questionCategories:Array;
		private var questionCategory:QuestionCategory;
		private var gn:String; 
		private var terms:String;
		
		public static const DOUBLE_POINTS:String = "double points";		
		public static const REGISTER_FAIL:String = "reg fail";		
		public static const LOGGED_IN_FAIL:String = "logged in fail";
		public static const LOGGED_IN:String = "logged in";
		public static const NEW_GAME:String = "new game";
		public static const RECEIVED_QUESTION:String = "received question";
		public static const RECEIVED_TOS:String = "received tos";
		public static const REGISTER_SUCCESS:String = "register success";
		
		public function DatabaseAPI(parameters:Object)
		{
		
			var gateway1:String = null;
            var gateway2:String = null;
            var gn:String = null;
			
			
			if (parameters.gateway1 == undefined) {
				gateway1 = "http://174.129.22.44/rubyamf_gateway"; 
			}
			else {
				gateway1 = parameters.gateway1;
			}
			
			if (parameters.gateway2 == undefined) {
				gateway2 = "http://www.glymetrix.com/amfphp/gateway.php"; 
			}
			else {
				gateway2 = parameters.gateway2;
			}
			
			if (parameters.gameName == undefined) {
				gn = "Zero G Solitaire";
			}
			else {
				gn = parameters.gameName;
			}
			
			if (parameters.termsUrl == undefined) {
				this.terms = "terms.html";
				
			}
			else {
				this.terms = parameters.termsUrl;
			}
			
			this.myService = new RemotingService(gateway1, "Glymetrix", ObjectEncoding.AMF3);
			this.nc = new NetConnection();
			this.nc.connect(gateway2);
			this.loggedIn = false;
			this.gn = gn;
			
		}
		private function onSubmitGlucose(e:ResultEvent):void {
			dispatchEvent(new Event(DOUBLE_POINTS));
			
		} 
		public function submitGlucose(healthRecords:Array):void {
			this.myService.collect_glucose(new Array( { RecordInputDate:new Date().toUTCString(), RecordProvider:"Zero G Solitaire", HealthRecordItemDetails:healthRecords }, this.username), onSubmitGlucose);
		}
		public function submitScore(score:Number):void {
			this.myService.update_score(new Array(this.playSessionId, score),onSuccess);
		}
		public function endGame():void {
			var params:Array = new Array();
			params.push(this.playSessionId);
			this.myService.end_game(params,onSuccess,onFail);
		}
		public function registerUser(u:String, p:String, g:String):void {
			this.myService.register_user(new Array({EducationLevel:null, Password:p, Gender:g, UserName:u}), onRegister, onRegisterFail);
		}
		
		private function onRegister(res:ResultEvent):void {
			trace("on register");
			dispatchEvent(new Event(REGISTER_SUCCESS));
		}
		
		private function onRegisterFail(fe:FaultEvent):void {
			trace("register fail " + fe.fault.faultString);
			dispatchEvent(new AbstractDataEvent(REGISTER_FAIL, fe.fault.faultString));
		}
		
		public function queryTermsOfService():void {
			//var responder:Responder = new Responder(onGetConsent, failFunction);
			//this.nc.call("Glymetrix.getConsentForm", responder);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onGetConsent);
			urlLoader.load(new URLRequest(this.terms));
			
		}
                
		private function onGetConsent(e:Event):void {
			this.consentForm = e.target.data
			dispatchEvent(new Event(RECEIVED_TOS));
		}

		public function getTermsOfService():String {
			return this.consentForm;
		}                

		private function failFunction(fault:Object):void {
			trace(String(fault.description));
		}
                
		public function submitAnswer(answerId:int, startDate:Date, score:int, correct:Boolean, questionId:int):void {
			this.myService.submit_question_choice(new Array(
                                {ChoiceSelectedID: answerId,
                                 EnterQuestionTime: startDate.toUTCString(),
                                 EndQuestionTime: (new Date()).toUTCString(),
                                 EarnedScore: score,
                                 AnsweredCorrectly: correct},
                                 this.sessionActivityId , questionId), onSubmitAnswer, onFail);
		}
		
		private function onSubmitAnswer(re:ResultEvent):void {
			trace("on sub answer");
		}
		public function queryQuestion(id:int):void {
	
			var s:String = "";
			switch(id) {
				case Game.COPING_CAT:
				s = "Shuffle";
				break;
				
				case Game.DIET_CAT:
				s = "Move to Blank";
				break;
				
				case Game.EXCERCISE_CAT:
				s = "Find King"; 
				break;
				
				case Game.FOOT_CARE_CAT:
				s = "Reveal Cards";
				break;
				
				case Game.GLUCOSE_MONITORING_CAT:
				s = "Find Ace";
				break;
				
				case Game.MED_COMPLIANCE_CAT:
				s = "Find Next";
				break;
			}		

			this.myService.choose_answer_bonus_question_activity(new Array(this.playSessionId, s), onGetQuestion, onFail);
		}
		//public function queryQuestions():void {
		//	this.myService.choose_answer_question_activity(new Array(this.playSessionId, new Array()), onGetQuestions, onFail);	
		//}
		
		public function getQuestionsCategory():QuestionCategory {
			return this.questionCategory;
		}
				
		private function onGetQuestion(re:ResultEvent):void {
			this.questionCategory = new QuestionCategory(re.result.QuizCategory);
			
			this.sessionActivityId = re.result.SessionActivityID as int;
		
			dispatchEvent(new Event(RECEIVED_QUESTION));	
		}
		
		public function newGame():void {
			//var gameName:String =
			
			this.myService.new_game(new Array(this.gn), onNewGame, onFail);
			
		}

		private function onNewGame(re:ResultEvent):void {
			trace(re.result.PlaySession.PlaySessionID);
			this.playSessionId = re.result.PlaySession.PlaySessionID as int;
			trace(this.playSessionId);
			dispatchEvent(new Event(NEW_GAME));
		}
		
		public function login(username:String, password:String):void {
			//var responder:Responder = new Responder(loginResult, fail);
			this.myService.login(new Array(username, password), loginResult, onLoginFail);
		}
		
		private function onLoginFail(o:Object):void {
			dispatchEvent(new Event(LOGGED_IN_FAIL));
		}
		
		private function loginResult(re:ResultEvent):void {
			this.loggedIn = true;
			this.username = re.result.UserName;
			dispatchEvent(new Event(LOGGED_IN));
		}
		public function isLoggedIn():Boolean {
			return this.loggedIn;
		}
		private function onSuccess(re:ResultEvent):void {
			trace("on success !" + re);
		}
		private function onFail(fe:FaultEvent):void {
			trace("on fail !" + fe);
		}
	}
}