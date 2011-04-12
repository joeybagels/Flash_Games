package com.zerog.invasion {
	import flash.display.MovieClip;
	import flash.net.SharedObject;
    import flash.net.SharedObjectFlushStatus;
	import ascb.util.ArrayUtilities;

	public class Score {
		// TODO: It doesn't seem appropriate for this singleton to be launching windows. 
		// Perhaps another helper class for the management of windows, and this one maintains data
		
		static private const GAME_NAME = "SkrullInvasion";
			
		static private var instance:Score;
		static private var baseMC:MovieClip;
		static private var scores:Array;
		static private var scoreSO:SharedObject;
	
		
		public function Score (singletonEnforcer:SingletonEnforcer) {}
		
		public static function getInstance(tBaseMC:MovieClip = null):Score {
			if(Score.instance == null) {
				// Singleton not yet initialized. do it now.
				// Will only happen once. 
				trace("initializing Singleton Class with tBaseMC: " + tBaseMC);
				if(tBaseMC != null){
					// initializing class, verified receipt of base MC
					
					Score.instance = new Score(new SingletonEnforcer());
					
					baseMC = tBaseMC;
					scoreSO = SharedObject.getLocal(GAME_NAME);
					if (scoreSO.data.scores == undefined || scoreSO.data.scores == null){
						populateDefaultScoresArray();
						setScoresToSO();
					} else {
						getScoresFromSO();
					}
				} else {
					// error. no base mc specified on class initializer
					// trace message and return null
					// would be better to throw an error and handle it if we were doing something bigger
					trace("base mc not yet defined. You must pass the base mc on the first getInstance call");
					return null;
				}
			}
			return Score.instance;	
			
			/*
			traditional Singleton getInstance below.  modified to support passing of base MC reference. 
			if(Singleton.instance == null) {
				Singleton.instance = new Singleton(new SingletonEnforcer());
			}
			return Singleton.instance;	
			*/
		}
		
		// debug
		public function doSomething():void {
			baseMC.taDebug.appendText("\ndoSomething()");
		}
		
		
		
		// call from external
		
		public static function gameStart(){
			baseMC.taDebug.appendText("\ngameStart()");
		};
		
		// these functions cannot be static. Because the class was instantiated into var *instance*?
		// why can gameStart be public?
		
		public function levelComplete(tLevel:Number){
			baseMC.taDebug.appendText("\nlevelComplete(), tLevel: " + tLevel);
		};
		
		public function newLevel(tLevel:Number){
			baseMC.taDebug.appendText("\nnewLevel(), tLevel: " + tLevel);
		};
		
		public function gameOver(tName,tScore){
			baseMC.taDebug.appendText("\nScore Class--gameOver(), tName, tScore: " + tName + ", " + tScore);
			var scoreObj = {name:tName, score:tScore};
			scores.push(scoreObj);
			sortScores();
			setScoresToSO();
			showScores();
		};
		
		public function isHighScore(tScore:uint){
			// return 1 for sample score is HIGHER than existing score
			// return 0 for sample score is NOT higher than existing score
			// return 2 for sample score is EQUAL to existing score
			baseMC.taDebug.appendText("\nisHighScore(), tScore: " + tScore);
			sortScores();
			var currentHighScore = scores[0].score;
			var returnResults;
			if (  tScore > currentHighScore){
				returnResults = 1;
			} else if (tScore < currentHighScore){
				returnResults = 0;
			} else if (tScore == currentHighScore){
				returnResults = 2;
			}
			baseMC.taDebug.appendText("\nisHighScore, submitted: " + tScore + ", results: " + returnResults);
			return returnResults;
		};
		
		public function showScores(){
			baseMC.taDebug.appendText("\nshowScores()");
			// tried adding this conditional to catch instances where score is cleared and the array is empty
			if (scores.length>=0){
			sortScores();
			}
			var scoresDialog = new HighScoresDialog("test");
			scoresDialog.x = -30;
			scoresDialog.y = -30;
			baseMC.addChild(scoresDialog);
		};
		
		public function clearScoreSO(){
			scores = new Array();
			// empty array caused problems, so I use this one with empty strings as values instead.  
			scores = 
			[
			{name:"",score:""},
			{name:"",score:""},
			{name:"",score:""},
			{name:"",score:""},
			{name:"",score:""},
			{name:"",score:""},
			{name:"",score:""},
			{name:"",score:""},
			{name:"",score:""},
			{name:"",score:""}	
			];
		
			trace(ArrayUtilities.toString(scoreSO.data.scores));
			setScoresToSO();
			trace(ArrayUtilities.toString(scoreSO.data.scores));
			baseMC.taDebug.appendText("\nscoreSO cleared");
		}
		
		public function deleteScoreSO(){
			scoreSO.clear();
			baseMC.taDebug.appendText("\nscoreSO deleted (cleared)");
		}
		
		
		// functions called from internal
		
		private static function populateDefaultScoresArray(){
			scores = 
			[
			{name:"name1",score:"100"},
			{name:"name2",score:"90"},
			{name:"name3",score:"80"},
			{name:"name4",score:"70"},
			{name:"name6",score:"50"},
			{name:"name5",score:"60"},
			{name:"name7",score:"40"},
			{name:"name8",score:"30"},
			{name:"name9",score:"20"},
			{name:"name10",score:"10"}	
			];
		}
		
		private static function getScoresFromSO(){
			scores = ascb.util.ArrayUtilities.duplicate(scoreSO.data.scores,true) as Array;
		}
		
		private static function setScoresToSO(){
			scoreSO.data.scores = ascb.util.ArrayUtilities.duplicate(scores,true);
			scoreSO.flush();
		}
		
		public function getScoresArray():Array{
			sortScores();
			return scores;
		}
		
		private static function sortScores(){
			baseMC.taDebug.appendText("\nsortScores()");
			scores.sortOn("score", Array.NUMERIC | Array.DESCENDING ); 
		}


		
	}
	
}

class SingletonEnforcer {}