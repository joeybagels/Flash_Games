package {

        import flash.events.*;
        import flash.media.SoundChannel;
        import flash.net.NetConnection;
        import flash.net.Responder;
        import flash.display.*;
        import flash.text.*;
        import flash.net.*;
        import flash.media.Sound;
        import caurina.*;
        import caurina.transitions.*;
        import org.rubyamf.remoting.ssr.*;
        import flash.utils.*;
		import com.glymetrix.data.*;
		import com.glymetrix.modules.survey.SurveyDialog;
		
        public class Glymetrix extends MovieClip {
var surveyDialog:SurveyDialog;
                public static var firstQuestion = true;
                var playSessionID;
                var sessionActivityID;
                var currentQEvent:trackEvent;
                var tracking = true;
                var questionTracking = true;
                var surveyTracking = true;
                var connection:NetConnection;
				var gameName = "Trivia Challenge";
                var soundFolder = "http://174.129.22.44/data/";
				var gateway:String = "http://www.glymetrix.com/amfphp/gateway.php";
                var rubyGateway:String = "http://ec2-50-17-251-132.compute-1.amazonaws.com/rubyamf_gateway";//"http://50.17.251.132/rubyamf_gateway";
                var currentQuestion:Object = {points: 0, correct_answer: -1, qIconId: -1, qSound: new Sound(), a1Sound: new Sound(), a2Sound: new Sound(), a3Sound: new Sound(), qSoundChannel: null, correct: false};
                var qiWidth = 136.5;
                var qiHeight = 96.33;
                var qiXOffset = 0;
                var qiYOffset = 0;
                var qiStartX = 8;
				var qiStartY = 107.33;
                var user_id;
                var termsOfService = "Failed to retrieve TOS";
                var chingSound = new CashRegisterSound();
                static var enteredGlucose = false;
                // var responder:Responder;
                var categories:Array = new Array();
                var categoryTexts:Array = new Array();
                var questions:Array = new Array();
                var lock = 0;
                var myPoints:int = 0;
                var lastAnswer = -1;
                var nuts = "a";
                var noImageWidth = 200;
                var yesImageWidth = 200;
                var service;
                var quizData;
                var gamePlayer:Object = new Object();
                static var gamePlayer;
                static var traceRecurseLog = "result";
                static var myUsername;
				var loader:Loader;
				var questionImage:QuestionImage;
				
                function Glymetrix():void {
					
		
					questionImage = new QuestionImage();

					questionImage.hideButton.addEventListener(MouseEvent.CLICK, onHideImage);
					loader= new Loader();
                        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, resizeImage);
                        loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, checkHTTP);
                        loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageError);
                        //addEventListener(Event.ENTER_FRAME, tellme);
                        //function tellme(e) { if (startHelp_mc) trace(startHelp_mc.x); }
                        var paramObj:Object = LoaderInfo(this.root.loaderInfo).parameters;
						
						if (paramObj.gateway1)
							rubyGateway = paramObj.gateway1;
						if (paramObj.data)
							soundFolder = paramObj.data;
						if (paramObj.gameName)
							gameName = paramObj.gameName;

                        service = new RemotingService(rubyGateway, "Glymetrix", 3);
                        connection = new NetConnection;
                        // Gateway.php url for NetConnection
                        connection.connect(gateway);
                        connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
                        trace("logging in");
                        //if (paramObj != null && String(paramObj.username) != "undefined") {
                                //Glymetrix.myUsername = "toasty";

                        //trace("already Logged in: " + Glymetrix.myUsername );
                        //Glymetrix.myUsername = LoaderInfo(this.root.loaderInfo).parameters.username;
                        //Glymetrix.gamePlayer.UserName
                        //}
                        // else {
                        //trace("not Loggedin!");
						
						
						//if password is not set
						if (!paramObj.password) {
							paramObj.username = "zerog";
							paramObj.password = "746d4b622637292b26fc7a778dd744c8015ac008";
						}
							
							
						if (paramObj.username) {
							service.login(new Array(paramObj.username, paramObj.password),
								function(re:ResultEvent) { trace("Login Forced");
									Glymetrix.myUsername = re.result.UserName;
									trace(Glymetrix.myUsername)}, onFault);
							
						} else {
  		              		service.logged_in(new Array(),
								function(re:ResultEvent) {
									Glymetrix.myUsername = re.result.UserName }, onFault);
						}
						
						
                }
				
				function onAnswerBonusQuestion(e:Event):void {
					trace("answer bonus");
				}
                function onSuccess(re:ResultEvent):void
                {
                        trace("Success!" + re.result);
                        traceRecurse(re.result);

                }
                function traceRecurse(o) {
                        var originalTRL = Glymetrix.traceRecurseLog;
                        var count = 0;
                        for (var i in o) {
                                count += 1;
                                if (o[i] is Object) {
                                        Glymetrix.traceRecurseLog += "." + i;
                                        traceRecurse(o[i]);
                                        Glymetrix.traceRecurseLog = originalTRL;
                                } else
                                        trace(Glymetrix.traceRecurseLog + "." + i + ": " + o[i]);
                        }
                        if (count == 0)
                                trace(Glymetrix.traceRecurseLog + ": " + o);
                        Glymetrix.traceRecurseLog = originalTRL;
                }

                function onFault(fe:FaultEvent):void
                {
                        trace(getTimer() + ": " + fe.fault.faultString);

                }
                function securityErrorHandler(event:SecurityErrorEvent):void {
                        trace("securityErrorHandler: " + event);
                }

                function getTermsOfService() {
                        var responder = new Responder(handleConsent, failFunction);
                        connection.call("Glymetrix.getConsentForm", responder);
                }

                function handleConsent(result:Object) {
                        this.termsOfService = result;
                        gotoAndStop("informedConsent");
                }

                function begin(e:Event):void {
					trace("BEGIN()");
                        var params = "nothin";
                        service.new_game(new Array(gameName),
                                function(re) {
                                        //onSuccess(re);
                                        //playSessionID = re.result.PlaySession.PlaySessionID;
                                        //traceRecurse(re.result.PlaySession);
                                        playSessionID = String(re.result.PlaySession.PlaySessionID);
                                        //service.get_categories(new Array(playSessionID),
                                                //function(rre) {
                                                //      onSuccess(rre);
                                                        var categoryNames = new Array();
                                                        trace("Got my result");
                                                        /* for (var i = 0; i < rre.result.length; i++) {
                                                                trace("Adding: " + rre.result[i].QuizCategoryName);
                                                                categoryNames.push(rre.result[i].QuizCategoryName);
                                                        }*/
                                                        categoryNames = new Array();
                                                        service.choose_answer_question_activity(new Array(playSessionID, categoryNames), handleQuizData, onFault);

                                                //}, onFault);
                                        }, onFault);

                        //var responder = new Responder(handleCategories, failFunction);
                        //connection.call("Glymetrix.getCategories", responder);
                        //trace("cows go what");
                }

                function sendGlucose(e:MouseEvent) {
                        trace("SG1: " + Glymetrix.myUsername);
                        if ((int(data_mc.glucose1_txt.text) ==0 && int(data_mc.glucose2_txt.text) ==0 &&
                        int(data_mc.glucose3_txt.text) ==0 && int(data_mc.glucose4_txt.text) ==0) /*&& int(data_mc.weight_txt.text) ==0*/) {
                                return;
                        }
                        trace("Sg2");
                        //var params:Object = new Object();
                        //params.user_id = this.user_id;
                        var glucoseArr = new Array(data_mc.glucose1_txt.text, data_mc.glucose2_txt.text, data_mc.glucose3_txt.text, data_mc.glucose4_txt.text);
                        var measureArr = new Array(data_mc.measure1_mc.currentLabel, data_mc.measure2_mc.currentLabel, data_mc.measure3_mc.currentLabel, data_mc.measure4_mc.currentLabel);
                        //var sourceArr = new Array(data_mc.source1_txt.text, data_mc.source2_txt.text, data_mc.source3_txt.text, data_mc.source4_txt.text);
                        //Glucose entry names
                        var glucoseNamesArr = new Array("GlucoseBeforeBreakfast", "GlucoseBeforeLunch", "GlucoseAfterSnack", "GlucoseBeforeDinner");
                        var healthRecords = new Array();
                        trace("sg3: " + measureArr);
                        //params.weight = data_mc.weight_txt.text;
                        //myPoints_txt.text = this.nuts;
                        trace("sg4");
                        for (var p = 0; p < glucoseArr.length; p++) {
                                if (Number(glucoseArr[p]) != 0 && glucoseArr[p] != 0 && glucoseArr[p] != "")
                                healthRecords.push( { RecordItemName:glucoseNamesArr[p], Value: glucoseArr[p], Measure: measureArr[p], Source: "user" } );
                        }
                        trace("sg5" + healthRecords);
                        /*
                        if (int(data_mc._weight_txt.text) != 0) {
                                healthRecords.push( { RecordItemName:"weight", value: int(data_mc._weight_txt.text), Measure: "", Source:"" } );
                        }*/
                        //trace("GL: " + params.glucose + " X " + params.weight);
                        //params.glucose = glucose_txt.text;
                        trace("Sending hxre: " +  Glymetrix.myUsername);

                        //connection.call("Glymetrix.addGlucose", null, params);
                        //traceRecurse(healthRecords);
                        service.collect_glucose(new Array( { RecordInputDate:new Date().toUTCString(), RecordProvider:gameName, HealthRecordItemDetails:healthRecords }, myUsername), onSuccess, onFault);
                        traceRecurse(new Array( { RecordInputDate:new Date().toUTCString(), RecordProvider:gameName, HealthRecordItemDetails:healthRecords }, myUsername));
                        trace("SCG!");
                        enteredGlucose = true;
                        doublePoints();
                        //trace("haaaaaaay");
                        //begin();
                        data_mc.gotoAndStop("finish");
                        cleanScreen(false);
                        startHelp();
                }

                function popupCancel(e:MouseEvent) {
                        data_mc.gotoAndStop(2);
                        startHelp();
                }

                function startHelp() {
                        if (firstQuestion == true && startHelp_mc.alpha == 0) {
                                startHelp_mc.visible = true;
                                Tweener.addTween(startHelp_mc, {alpha: 1.0, delay: 3.0, time: 2,
                                onStart:function() { if (getChildIndex(data_mc) > getChildIndex(startHelp_mc)) swapChildren(startHelp_mc, data_mc);},
                                onComplete:function() { startHelp_mc.addEventListener(MouseEvent.CLICK, function() {
                                Tweener.addTween(startHelp_mc, {alpha: 0.0, time: 2, onComplete: function() {
                                startHelp_mc.visible = false; }});})}
                                });
                        }
                };

                function gotoGlucose(e:MouseEvent) {
                        //trace("WHAT");
                        //cleanScreen(false);
                        if (getChildIndex(data_mc) < getChildIndex(startHelp_mc)) swapChildren(startHelp_mc, data_mc)
                        data_mc.gotoAndStop("getGlucose");
                        //data_mc.swapDepths(
                        data_mc.sendGlucose = sendGlucose;
                        data_mc.cancelGlucose = cancelGlucose;
                        if (firstQuestion == true) {
                                Tweener.removeTweens(startHelp_mc, "alpha");
                        }
                        startHelp_mc.alpha = 0;
                        startHelp_mc.visible = false;
                }

                function cancelGlucose(e:MouseEvent) {
                        cleanScreen(false);
                        data_mc.gotoAndStop(2);
                        startHelp();
                }
/*
                function handleCategories(result:Object):void {
                        var responder = new Responder(handleQuestions, failFunction);
                        trace(" I handle categories!");
                        for (var i = 0; i < result.length; i++) {

                                categories.push(result[i].QuizCategoryName);
                                var params = result[i].QuizCategoryID;
                                this.lock+=1;
                                connection.call("Glymetrix.getQuestions", responder, params);
                                trace("handlin' category " + i);
                        }
                }

                function handleQuestions(result:Object):void {
                        if (result) {
                                for (var i = 0; i < result.length; i++) {
                                        this.questions.push(result[i]);
                                }
                                this.lock -=1;
                                //trace("tl: " + this.lock);
                                if (this.lock <= 0) {
                                        gotoAndStop("beginGame");
                                }
                        }
                }
                */
                function handleQuizData(re:ResultEvent) {
					trace("handle quiz data");
					trace(categories.length);
					
					trace(re.result.QuizCategories);
                        if (categories.length != 0 ) return;
                        if (re.result.QuizCategories == undefined || re.result.QuizCategories == null) {
                                return;
                        }
                        var skipped = 0;
                        sessionActivityID = String(re.result.SessionActivityID);
                        trace ("IMPORTANT TRACE RECURSE!" + re.result.SessionActivityID + ","+sessionActivityID);
                        //traceRecurse(re.result);
                        for (var i = 0; i < re.result.QuizCategories.length && i < 4; i++) {
                                trace ("Category: " + re.result.QuizCategories[i]['QuizCategoryName']);
                                /* if (skipped < 1 && !(re.result.QuizCategories[i]['QuizCategoryName'] == "Sports" || re.result.QuizCategories[i]['QuizCategoryName'] == "Living Well" || re.result.QuizCategories[i]['QuizCategoryName'] == "TV & Movies")) {
                                                re.result.QuizCategories.splice(i, 1);
                                                i--;
                                                skipped+=1;
                                                trace("Skipping...");
                                                continue;

                                }*/
                                categories.push(re.result.QuizCategories[i]);

                        var myQAnswers;
                        var myQ;
                        
                                for (var j = 0; j < categories[i]['QuizQuestions'].length; j++ ) {
                        
                                        categories[i]['QuizQuestions'][j]['libertyQuestion'] = false;
                                   
                                        this.questions.push(categories[i]['QuizQuestions'][j]);

                                }
                        }

                        trace("HQD3" + categories.length + "," + questions.length);

                        beginGame();
						//gotoAndStop("win");
						
                }
				function onHideImage(e) {
					
					Tweener.addTween(questionImage, { x:623,y:109, width:62, height:62, time:1, onComplete:onHideImageComplete} );
				}
				
				function loadSurvey() {
					if (this.surveyDialog == null) {
						this.surveyDialog = new SurveyDialog();
						trace("ON GET BONUS QUESTION " + this);
						this.surveyDialog.setParent(this);
						this.surveyDialog.setService(this.service)
						this.surveyDialog.addEventListener(SurveyDialog.ANSWER, onAnswerBonusQuestion);
						this.surveyDialog.addEventListener(SurveyDialog.SURVEY_COMPLETE, onSurveyComplete);
						
					}
					
					this.surveyDialog.setSessionId(this.playSessionID);
					this.surveyDialog.loadQuestion();
					
					
				}
				
private function onSurveyComplete(e:Event):void {
	                                myPoints += 500;
                                myPoints_txt.text = String(myPoints);
                                trace("Right!" + currentQuestion.points + "," + myPoints + "," + myPoints_txt.text);
                                chingSound.play();
}
				
				function onHideImageComplete() {
					questionImage.buttonMode = true;
					questionImage.addEventListener(MouseEvent.CLICK, onClickSmallImage);
				}
				function onClickSmallImage(e) {
					questionImage.removeEventListener(MouseEvent.CLICK, onClickSmallImage);
					Tweener.addTween(questionImage, { x:82,y:73, width:636, height:456, time:1} );
				}
                function beginGame() {
                        gotoAndStop("beginGame");

								
                        startHelp_mc.visible = false;
                        trace("Beginning game!");
                        var fontSize = 24;
                        var yOffset = 11;
                        var q:QuestionIcon;
						
                        for (var i = 0; i < this.categories.length; i++) {
								/*
                                //trace(categories[i]);
                                var categoryText:TextField = new TextField();
                                this.categoryTexts.push(categoryText);
                                categoryText.x = Math.floor (i  * (qiWidth+qiXOffset)) + (qiStartX -5);
                                categoryText.y = yOffset;
                                categoryText.width = qiWidth+10;
                                categoryText.text = categories[i].QuizCategoryName;
								*/
                                var format:TextFormat = new TextFormat();
                                format.font = "Myriad Pro";
                              	format.color = 0xFFFFFF;
								fontSize = 24;
                                format.size = fontSize;
                                format.bold = true;
                               
                                format.align = "center";
                                
								
								var c = new CategoryIcon();
								trace("C is " + c.categoryText);
								c.categoryText.text = categories[i].QuizCategoryName;
								c.x = qiStartX + (i * (qiWidth + qiXOffset));
								c.y = 11;// + (i * (qiWidth + qiXOffset));
								addChild(c);
								this.categoryTexts.push(c);
								
                               while (c.categoryText.textWidth +10 > c.categoryText.width || c.categoryText.textHeight + 10> c.categoryText.height) {
                                        fontSize -=1;
                                        //yOffset+=1.5;
                                        //categoryText.y +=2;
                                        format.size = fontSize;
                                        //for (var t = 0; t < this.categoryTexts.length; t++) {
                                                c.categoryText.setTextFormat(format);
                                                c.categoryText.y = Math.round(qiHeight - c.categoryText.textHeight)/2;
                                        //}
                                        //categoryText.setTextFormat(format);
                                }
                                this.addChild(c);
								
								quit_btn.addEventListener(MouseEvent.CLICK, function () {;
                                gotoAndStop("quit");
                                });
																
																
                        for (var k = 0; k < categories[i].QuizQuestions.length; k++) {
                                var xpos = qiStartX + (i * (qiWidth + qiXOffset));
                                var ypos = qiStartY + (Math.floor(k % 5) * (qiHeight + qiYOffset));
                                q = new QuestionIcon(categories[i].QuizQuestions[k], categories[i]); //int(this.questions[i]["id"]));
  //                              q.width = qiWidth;
//                                q.height = qiHeight;
                                q.addEventListener(MouseEvent.CLICK, function(re) {
                                gotoAndStop("loadQuestion");
                                respondLoadQuestion(re) });
                                this.addChild(q);
                                q.x = xpos;
                                q.y = ypos;
                                //trace(xpos + "," + ypos);
                        }

                                }
                        gotoAndStop("jeopardy");
                        swapChildren(q, data_mc);
                }
function showLiberty(evt:MouseEvent) {
        navigateToURL(new URLRequest("http://www.libertymedical.com"), "_blank");
}

function showBlog(evt:MouseEvent) {
        navigateToURL(new URLRequest("http://www.glymetrix.com/blogtalk2.html"), "_blank");
}
function showRewards(evt:MouseEvent) {
        navigateToURL(new URLRequest("http://glymetrix.com/libertyrewards8.html"), "_blank");
}
                function loadQuestion(e:MouseEvent) {
                        var responder = new Responder(respondLoadQuestion, failFunction);
                        var params = e.currentTarget.id;
                        //params = 183;
                        gotoAndStop("loadQuestion");
                        if (firstQuestion == true) {
                                Tweener.removeTweens(startHelp_mc, "alpha");
                        }
                        startHelp_mc.alpha = 0;
                        startHelp_mc.visible = false;
                        respondLoadQuestion(e);
                }



                function checkHTTP(evt:HTTPStatusEvent) {
                        if (evt.status == 404) trace("httpd");
                }



                function imageError(evt:IOErrorEvent) {
					trace("IMAGE ERROR NO IMAGE");
                        //questionBackground_mc.width = noImageWidth;
                        //imgContainer_mc.visible = false;
						
                }

                function loadImage(url) {
                  
						//loader.load(new URLRequest("http://www.google.com/images/logos/ps_logo2.png"));
						loader.load(new URLRequest(url));
                }

                function resizeImage(evt:Event) {
					questionImage.question_txt.text = currentQuestion.question.Content;
					questionImage.buttonMode = false;
					questionImage.x = 82;
					questionImage.y = 73;
					questionImage.scaleX = 1;
					questionImage.scaleY = 1;
					addChild(questionImage);
					questionImage.addChild(loader);
					loader.mask = questionImage.imageMask;
					questionImage.addChild(questionImage.hideButton);
					//questionImage.addChild(questionImage.text_bg);
					questionImage.addChild(questionImage.question_txt);
					trace("RESIZE IMAGE");
                       
                        var targ = evt.currentTarget.content;
						trace(evt.currentTarget);
						trace(evt.currentTarget.content.width);
						//loader.x = 82;
						//loader.y = 73
						//loader.mask = loaderMask;
                       loader.width = 636;
                       loader.height = 456;
                }


                function respondLoadQuestion(result:MouseEvent):void {
                        trace ("currentFrame: " + currentLabel);
                        if (firstQuestion == true) {
                                Tweener.removeTweens(startHelp_mc, "alpha");
                        }
                        startHelp_mc.alpha = 0;
                        startHelp_mc.visible = false;

                        trace("rlq1: " + result.currentTarget);
                        if (enteredGlucose == true) {
                                        result.currentTarget.question.Score *= 2;
                        }
                        var question = result.currentTarget.question;
                        question.Choices.sortOn('ChoiceSelection');
                        currentQuestion.question = question;

                        currentQuestion.points = question.Score;
                        currentQuestion.category = result.currentTarget.category;
                        cleanScreen(true);
                        var imageNum = question.QuizQuestionID;
						
						startHelp_mc.visible = false;
                        firstQuestion = false;
                        currentQuestion.qIconID = question.QuizQuestionID;
                        var points = question.Score;
                                points*=2;
								
								

                        lock+=4;


                        // Debug Sound
                        //currentQuestion.qSound = new Sound(new URLRequest(siteRoot + "sounds/0q.mp3"));
                        //currentQuestion.qSound.addEventListener(Event.COMPLETE, soundLoadComplete);

                        //lock += 1;
                        trace("rlq8: " + lock);



                        //if (tracking == true) {
                        currentQEvent = new trackEvent();
                        //currentQEvent.connection = this.connection;
                        currentQEvent.tracking = this.tracking;
                        currentQEvent.questionTracking = this.questionTracking;
                        currentQEvent.surveyTracking = this.surveyTracking;
                        currentQEvent.questionID = question.QuizQuestionID;
                        //currentQEvent.user_id = this.user_id;
                        //}
                        //lock+=4;
						
								
                        loadImage(soundFolder + imageNum + "i.jpg");
						
                        
                        var soundNum = (currentQuestion.question.QuizQuestionID);

                        var qURL = new URLRequest(soundFolder + question.QuizQuestionID + "q.mp3");
                        var a1URL = new URLRequest(soundFolder + question.Choices[0].ChoiceID + "a.mp3");
                        var a2URL = new URLRequest(soundFolder + question.Choices[1].ChoiceID + "a.mp3");
                        var a3URL = new URLRequest(soundFolder + question.Choices[2].ChoiceID + "a.mp3");
                        currentQuestion.qSound = new Sound(qURL);
                        currentQuestion.a1Sound = new Sound(a1URL);
                        currentQuestion.a2Sound = new Sound(a2URL);
                        currentQuestion.a3Sound = new Sound(a3URL);
						trace("a34 url " + soundFolder + question.Choices[2].ChoiceID + "a.mp3");
                        currentQuestion.a1Sound.addEventListener(Event.COMPLETE, soundLoadComplete);
                        currentQuestion.a1Sound.addEventListener(IOErrorEvent.IO_ERROR, function () {
                                soundCheck(currentQuestion.a1Sound, a1URL);
                        });

                        currentQuestion.a2Sound.addEventListener(Event.COMPLETE, soundLoadComplete);
                        currentQuestion.a2Sound.addEventListener(IOErrorEvent.IO_ERROR, function () {
                                soundCheck(currentQuestion.a2Sound, a2URL);
                        });
                        currentQuestion.a3Sound.addEventListener(Event.COMPLETE, soundLoadComplete);
                currentQuestion.a3Sound.addEventListener(IOErrorEvent.IO_ERROR, function () {
                                soundCheck(currentQuestion.a3Sound, a3URL);
                        });
                        currentQuestion.qSound.addEventListener(Event.COMPLETE, soundLoadComplete);
                        currentQuestion.qSound.addEventListener(IOErrorEvent.IO_ERROR, function () {
                                soundCheck(currentQuestion.qSound, qURL);
                        });
                }
				
				

                function soundCheck(sound, url) {
                        trace("check!");
                        sound = new Sound(url);
                        sound.addEventListener(IOErrorEvent.IO_ERROR, function() { trace("Double Error!");  soundLoadComplete(null); } );
                }
                function stretchButton(btn, txt) {
                        var format:TextFormat = new TextFormat();
                        format.font = "Myriad Pro";
                        format.color = 0xD9FBFF;
                        format.bold = true;
                        format.leading = 1;
                        var fontSize = 23;
                        format.size = fontSize;
                        txt.setTextFormat(format);
                        txt.visible = false;
                        btn.x = txt.x - 50;
                        btn.y = txt.y;
                        btn.scaleX = txt.scaleX;
                        btn.scaleY = txt.scaleY;
                        btn.width = Math.round(txt.textWidth + 10) + 50;
                        btn.height = txt.textHeight + 10;
                        btn.enabled = false;
                        btn.visible = false;
                        //trace("JIMMY - " + btn.width);
                        //trace("JIMMY - " + btn.height);
                }

                function jtest(e) {
                        trace("BALLS");
                }

                function answer1(e:MouseEvent) {
						
                        answerQuestion(1);
                        if (currentQuestion.a1Sound.bytesLoaded > 0) {
                        var channel = currentQuestion.a1Sound.play();
                        channel.addEventListener(Event.SOUND_COMPLETE, answerComplete);
                        } else {
                                answerComplete(null);
                        }
                }

                function answer2(e:MouseEvent) {

                        answerQuestion(2);
						
						try {
                       	 var channel = currentQuestion.a2Sound.play();
						 channel.addEventListener(Event.SOUND_COMPLETE, answerComplete);
						}
						catch(e:Error) {
							answerComplete(null);
						}
                        
                }
function restart(e) {
categories = new Array();
begin(null);
}
                function answer3(e:MouseEvent) {

                        answerQuestion(3);
						try {
                       	 var channel = currentQuestion.a3Sound.play();
						 channel.addEventListener(Event.SOUND_COMPLETE, answerComplete);
						}
						catch(e:Error) {
							answerComplete(null);
						}
                }

                function answerQuestion(answerNum) {
                        currentQuestion.qSoundChannel.stop();
                        //currentQEvent.stopTimer();
                        currentQEvent.answer = answerNum;
                        answer1_btn.enabled = false;
                        answer1_btn.visible = false;
                        answer2_btn.enabled = false;
                        answer2_btn.visible = false;
                        answer3_btn.enabled = false;
                        answer3_btn.visible = false;
                        trace("AQ1");
                        if (currentQuestion.question.Choices[answerNum-1].IsAnswer == true) {
							check.visible = true;
							if (answerNum==1) {
								check.x = number1_txt.x - check.width;
								check.y = number1_txt.y;
								
								number1_txt.textColor = 0x00ff00;
								answer1_txt.textColor = 0x00ff00;
							}
							else if (answerNum ==2) {
								check.x = number2_txt.x - check.width;
								check.y = number2_txt.y;
								
								number2_txt.textColor = 0x00ff00;
								answer2_txt.textColor = 0x00ff00;
							}
							else {
								check.x = number3_txt.x - check.width;
								check.y = number3_txt.y;
								
								number3_txt.textColor = 0x00ff00;
								answer3_txt.textColor = 0x00ff00;
							}
                                trace("correct!");
							currentQuestion.correct = "T";
                        } else {
							ex.visible = true;
							if (answerNum==1) {
								ex.x = number1_txt.x - ex.width;
								ex.y = number1_txt.y;
								
								number1_txt.textColor = 0xff0000;
								answer1_txt.textColor = 0xff0000;
							}
							else if (answerNum ==2) {
								ex.x = number2_txt.x - ex.width;
								ex.y = number2_txt.y;
								
								number2_txt.textColor = 0xff0000;
								answer2_txt.textColor = 0xff0000;
							}
							else {
								ex.x = number3_txt.x - ex.width;
								ex.y = number3_txt.y;
								
								number3_txt.textColor = 0xff0000;
								answer3_txt.textColor = 0xff0000;
							}
                                trace("correct!");
							currentQuestion.correct = "F";
							currentQuestion.points = 0;
                        }
                        trace("Aq!");
                        service.submit_question_choice(new Array(
                                {ChoiceSelectedID: currentQuestion.question.Choices[answerNum - 1].ChoiceID,
                                 EnterQuestionTime: currentQuestion.date.toUTCString(),
                                 EndQuestionTime: new Date().toUTCString(),
                                 EarnedScore: currentQuestion.points,
                                AnsweredCorrectly: (currentQuestion.correct != "F")},
                                 sessionActivityID , currentQuestion.question.QuizQuestionID), onSuccess, onFault);
                }

                function answerComplete(e:Event) {
                        //startHelp_mc.visible = true;
                        startHelp_mc.x = 1000;
                        if (currentQuestion.correct != "F") {
                                // add some points
                                myPoints += int(currentQuestion.points);
                                myPoints_txt.text = String(myPoints);
                                trace("Right!" + currentQuestion.points + "," + myPoints + "," + myPoints_txt.text);
                                chingSound.play();
                        } else {
                                trace("Wrong!" + currentQuestion.correct_answer);
                        }
                        currentQEvent.correct = currentQuestion.correct;
                        currentQEvent.sendEvent();
						
						if (contains(questionImage))
	                        removeChild(questionImage);
							
                        gotoAndStop("jeopardy");
                        cleanScreen(false);
                }

                // Handle a successful AMF call. This method is defined by the responder.
                function onResult(result:Object):void {

                }

                // Handle an unsuccessfull AMF call. This is method is dedined by the responder.
                function failFunction(fault:Object):void {
                        trace(String(fault.description));
                }

                function soundLoadComplete(event:Event):void {
                        this.lock -= 1;
                        if (lock == 0) {
                                gotoAndStop("askQuestion");
// start
        var question = currentQuestion.question;
                        trace("rlq3");
                        trace ("currentFrame: " + currentLabel);
                        trace ("CatText: " + category_txt);
                        category_txt.text = currentQuestion.category.QuizCategoryName; //result.category;
                        trace("rlq3.1");
                        points_txt.text = currentQuestion.points + " points";
                        currentQuestion.points = currentQuestion.points;
                        currentQuestion.multiline = true;
                        question_txt.text = currentQuestion.question.Content;
                        trace("rlq4");


                        trace("rlq5");

                        answer1_txt.text = currentQuestion.question.Choices[0].ChoiceContent;
                        if (question.Choices[0].isAnswer == true) currentQuestion.correct_answer = 1;
                        answer2_txt.text = currentQuestion.question.Choices[1].ChoiceContent;
                        if (question.Choices[1].isAnswer == true) currentQuestion.correct_answer = 2;
                        answer3_txt.text = currentQuestion.question.Choices[2].ChoiceContent;
                        if (question.Choices[2].isAnswer == true) currentQuestion.correct_answer = 3;

                        trace("rlq6");

                        answer1_btn.addEventListener(MouseEvent.CLICK, answer1);
                        answer1_btn.addEventListener(MouseEvent.MOUSE_OVER, jtest);
                        stretchButton(answer1_btn, answer1_txt);
                        answer2_btn.addEventListener(MouseEvent.CLICK, answer2);
                        stretchButton(answer2_btn, answer2_txt);
                        answer3_btn.addEventListener(MouseEvent.CLICK, answer3);
                        stretchButton(answer3_btn, answer3_txt);
                        trace("rlq7");
                        answer1_txt.visible = true;
                        number1_txt.visible = true;
                        answer2_txt.visible = true;
                        number2_txt.visible = true;
                        answer3_txt.visible = true;
                        number3_txt.visible = true;
                        trace("rlq9");
// stop
                                var channel = new SoundChannel();
                                if (currentQuestion.qSound.bytesLoaded > 0) {
                                        channel = currentQuestion.qSound.play();
                                }
                                currentQuestion.qSoundChannel = channel;
                                answer1_btn.enabled = true;
                                answer1_btn.visible = true;
                                //swapChildren(answer1_btn, answer1_txt);
                                answer2_btn.enabled = true;
                                answer2_btn.visible = true;
                                answer3_btn.enabled = true;
                                answer3_btn.visible = true;
                                currentQEvent.startTimer();
                                currentQuestion.date = new Date();
                        }
                }

                function cleanText(e:MouseEvent):void {
                        e.target.text = "";
                }

                function doublePoints():void {
                        for (var i = 0; i < QuestionIcon.icons.length; i++) {
                                QuestionIcon.icons[i].doublePoints();
                        }
                        chingSound.play();
                }
                function end_game() {
                                service.end_game(new Array(playSessionID), onSuccess, onFault);

                }
                function cleanScreen(opt):void {// True to hide them, false to view them
				
                        for (var i = 0; i < QuestionIcon.icons.length; i++) {
                                QuestionIcon.icons[i].visible = !opt;
                                //trace("Howdy: " + currentQuestion);
                                if (opt == true && currentQuestion.question != null  && QuestionIcon.icons[i].question.QuizQuestionID == currentQuestion.question.QuizQuestionID) {  // Remove an Answered Question
                                        this.removeChild(QuestionIcon.icons[i]);
                                        QuestionIcon.icons.splice(i, 1);
                                        currentQuestion.qIconID = -1;
                                        continue;
                                }
                        }
                        for (i = 0; i < categoryTexts.length; i++) {
                                categoryTexts[i].visible = !opt;
                        }
                        //trace ("QIIL: " + QuestionIcon.icons.length);
                        if (QuestionIcon.icons.length <= 0 && opt == false) {
                                gotoAndStop("win");
                        }
                }
        }
}