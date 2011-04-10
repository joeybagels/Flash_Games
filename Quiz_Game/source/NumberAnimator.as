package {

	import flash.display.MovieClip;
	import caurina.*; 
	import caurina.transitions.*; 
	import caurina.transitions.properties.FilterShortcuts;	
		
	public class NumberAnimator extends MovieClip { 
		
		var end;
		var start;
		var step = 54.65;
		var parentIcon;
		
		public function NumberAnimator(start:Number, end:Number, parentIcon:QuestionIcon) { 
			this.start = start +.01;
			this.end = end-.35; 
			this.parentIcon = parentIcon;
			FilterShortcuts.init();
			//trace(number_mc.y + "," + number_mc.height); 
			
			number_mc.y = -1*step * this.start;
			Tweener.addCaller(this, {onUpdate:tweenNumber, count:5, time:3, delay: 1,onComplete:completeBlur, transition: "linear"}); 
			Tweener.addTween(number_mc, {_Blur_blurY:10, time:1, delay:2, transition: "linear"}); 
		}
		
		function tweenNumber() { 
			//trace(number_mc.y + "," + number_mc.height + "," + start); 
			number_mc.y =  (-1*step * start);
			Tweener.addTween(number_mc, {y: (-1*step * start) -(number_mc.height/2), onOverwrite: function ()  { /*trace ("HELP!");*/ }, delay: 0, time: .5, transition: "linear"});		
		}
		
		function completeBlur() { 
			//trace ("COMPLETING"); 
			number_mc.y =  (-1*step * start);
			FilterShortcuts.init();		
			Tweener.addTween(number_mc, {_Blur_blurY:0, time:1, transition: "linear"});
			Tweener.addTween(number_mc, {y: ((-1*(number_mc.height/2) + (-1*end*step))), time: 1.5, transition: "EaseOutSine", onComplete:parentIcon.doneAnimating});
			
		}
	}
}