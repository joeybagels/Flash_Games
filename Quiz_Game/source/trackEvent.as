package { 
	
	import flash.display.*;
	import flash.external.ExternalInterface;
	import flash.utils.*;
	import flash.events.*;
	// required to send/recieve data over AMF
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	public class trackEvent extends MovieClip { 
		
		var timer;
		var resolvedTimer;
		var questionID; 
		var correct;
		var answer;
		var user_id; 
		var connection; 
		var tracking;
		var surveyTracking;
		var questionTracking;
		
		public function trackEvent() {	}
		
		public function startTimer() { 
			this.timer = getTimer(); 
		}
		
		public function stopTimer() { 
			//trace("HAY" + getTimer() + "," + this.timer); 
			this.resolvedTimer = getTimer() - this.timer;
		}
	
		public function sendEvent() { // Sends event data to Javascript Object
		
			var params:Object = new Object;
			params.time = this.resolvedTimer;
			params.question_id = this.questionID;
			params.answer = this.answer;
			params.user_id = this.user_id; 
			params.correct = this.correct; 
			
			var trackString = "i" + this.questionID + "t" + this.resolvedTimer + "a" + this.answer + "c" + this.correct;
			//trace ("trackStr=" + trackString);
			
			if (ExternalInterface.available && tracking == true) { 
				//ExternalInterface.call("addTracking", trackString);
			}
		
			if (questionTracking) { 
				var trash = new Responder(null);
				//trace("trackin gthis question: " + params.question_id + "," + params.answer + "," + params.time);
				//connection.call("Glymetrix.answerQuestion", trash, params);			
			}
			
			if (surveyTracking && this.correct == "X") { 
				//trace("tracking this survey: " + params.user_id);
				//connection.call("Glymetrix.surveyQuestion", null, params);
			}
		}
		
		public static function endTrackingQuit () { 
			if (ExternalInterface.available) { 
				//ExternalInterface.call("endTrackingQuit");
			}
		}
		
		public static function endTrackingWin() { 
			if (ExternalInterface.available) { 
				//ExternalInterface.call("endTrackingWin");
			}
		}
	}
}