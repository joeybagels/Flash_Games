package com.zerog.utils.format {

	/**
	 * @author Jacob
	 */
	public class NumberFormat {
		public static function addCommas(n:Number):String {
			var output:String = "";
			
			var s:String = n.toString();
			
			var a:Array = s.split(".");
			var aOutput:Array = new Array();
			var len:int = a[0].length;
			var c:int = 0;
			for(var i:int = len;i > 0; i -= 3) {
				var piece:String;
				if(i > 2) {
					piece = a[0].substr(i - 3, 3);
				}
				else {
					piece = a[0].substr(0, i);
				}
				aOutput[c] = i > 3 ? "," + piece : piece;
				c++;
			}
			for(i = aOutput.length - 1;i >= 0; i--) {
				output += aOutput[i];
			}
			
			if(a[1] != undefined && a[1] != null)
				output += '.' + a[1];
				
			return output;
		}

		public static function prependZero(n:Number):String {
			if (n < 10) {
				return "0" + n.toString();
			}
			else {
				return n.toString();
			}
		}
		
		public static function addSuffix(n:Number):String {
			var sNum:String = n.toString();
			var sLastNum:String = sNum.substr(sNum.length - 1, 1);
			var sSecondToLasNum:String = sNum.substr(sNum.length - 2, 1);
			var suffix:String = "";
			
			if(sSecondToLasNum == "1" && sNum.length > 1) {
				suffix = "th";
			}
			else {
				if(sLastNum == "1" ) {
					suffix = "st";
				}
				else if(sLastNum == "2") {
					suffix = "nd";
				}
				else if(sLastNum == "3") {
					suffix = "rd";
				}
				else {
					suffix = "th";
				}
			}
			
			return sNum + suffix;
		}
	}
}