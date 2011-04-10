package { 
	
	import flash.display.*;
	import flash.text.*;
	
	public class QuestionIcon extends Question { 
		
		static var icons:Array;
		var id; 
		var format; 
		var na; 
		var xOffset = 8;
		var question;
		
		public function QuestionIcon(question, category) {
			if (QuestionIcon.icons == null) QuestionIcon.icons = new Array();
			QuestionIcon.icons.push(this);
			trace ("qi: " + icons.length); 
			this.points_txt.text = question.Score;
			this.points = question.Score;
			this.id = question.QuestionID;
			this.category = category; 
			this.question = question; 
			format= new TextFormat();
			format.font = "Myriad Pro";
			//format.color = 0xFFFFFF;
			format.size = 42;
			format.bold = true;
			format.align = "center";
			points_txt.setTextFormat(format);
		}
		
		public function setPoints(points) { 
			this.points_txt.text = points; 
			points_txt.setTextFormat(format);
			this.points = points;
		}
		
		public function doublePoints() { 
			na = new NumberAnimator(Math.floor(this.points/10), Math.floor((this.points*2)/10), this); 
			//trace ( "HAY: " + Math.floor(this.points/10) + "," + Math.floor((this.points*2)/10));
			this.addChild(na); 
			na.x = this.points_txt.x+12 + xOffset;
			na.y = this.points_txt.y+0;
			this.points_txt.x += xOffset; 
			this.points_txt.text = " " + String(points%10);
			points_txt.setTextFormat(format);		
		}
		
		public function doneAnimating() { 
			this.points *=2;
			this.points_txt.x -= xOffset; 
			this.points_txt.text = this.points; 
			points_txt.setTextFormat(format);		
			removeChild(na); 
		}
	}
}