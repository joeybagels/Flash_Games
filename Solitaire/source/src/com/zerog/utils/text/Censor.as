package com.zerog.utils.text {

	/**
	 * @author Chris
	 */
	public class Censor {
		 // word, hold, add variations, replace, special find, single word
	    private static const words:Array = [
	        "@$$:false:true:@*$:true:false", "$#!+:false:true::true:false",
	        "anal:false:true:an*l:true:true", "anus:false:false::true:true",
	        "ass:false:true:a*s:true:true", "asshole:false:true::true:true",
	        "assface:false:true::true:true", "bastard:false:true:b*st*rd:true:false",
	        "bitch:false:true::true:false", "btch:false:true::true:false",
	        "blowjob:true:true::true:false", "breasts:true:false::true:false",
	        "carpetmuncher:true:false::true:false", "chink:true:true::true:false",
	        "clit:false:true::true:false", "cock:false:false::true:false",
	        "coon:false:true:c***:true:false", "cornhole:true:true::true:false",
	        "cum:false:false::true:false", "cunt:false:false::true:true",
	        "dick:false:false:d**k:false:false", "dike:false:false::false:false",
	        "douchebag:false:false::true:false", "fag:true:false::true:false",
	        "faggot:true:true::true:false", "fck:false:false::true:false",
	        "foreskin:true:true::true:false", "fuck:false:true::true:false",
	        "f*u*c*k:false:true::true:false", "fucking:false:true::true:false",
	        "fuq:false:false::true:false", "fuyouck:true:false::true:false",
	        "gook:true:true::true:false", "guzzling:true:false::true:false",
	        "herpes:true:false::true:false", "hoe:false:true:h*e:true:false",
	        "homo:true:true::true:false", "honky:true:true::true:false",
	        "jap:false:false::true:false", "jiz:true:true::true:false",
	        "jizz:true:true::true:false", "junglebunny:true:false::true:false",
	        "k*k*k*:true:false::true:false", "kike:true:true::true:false",
	        "kkk:true:false::true:false", "labia:true:true::true:false",
	        "lesbian:true:true::true:false", "nazi:true:false::false:false",
	        "nigger:true:true::true:false", "orgies:true:true::true:false",
	        "orgy:true:true::true:false", "pecker:false:true:p*cker:true:false",
	        "penis:true:true::true:false", "prick:false:true::true:false",
	        "pubic:true:true::true:false", "pussy:true:true::true:false",
	        "queer:true:true::true:false", "shit:false:true::false:false",
	        "shit:false:true::true:true", "slut:true:false::true:false",
	        "spic:false:false::true:false", "spook:true:true::true:false",
	        "sux:false:false:su*:true:false", "suck:false:false:s*ck:true:false",
	        "testes:true:true::true:false", "tit:false:false:t*t:false:true",
	        "vagina:true:true::true:false", "wetback:true:false::true:false",
	        "whore:true:true::true:false", "wop:false:false::true:false",
	        "twat:false:true::true:true"];
		
	    private static const replacements:Array = [
	        "f:ph", "f:gh", "i:!", "i:1", "o:0", "ck:k", "gg:g", "er:a", "s:z",
	        "a:4", "e:3", "s:5", "a:@", "s:$", "ck:c", "ch:sh", "u:o", "i:eo", "i:y",
	        "wh:h", "i:io", "y:i", "z:s", "u:0", "i:a", "sh:ch", "i:ia", "ck:gg",
	        "i:l", "u:v"];
	    
	    private static var checkWords:Array;// = prepCensorWords();
	    
	    {
	    	checkWords = prepCensorWords();
	    }
	    
	    public static function censor(word:String, checking:Boolean):String {		
	        var result:String = censorText(word, false, checking);
					
	        return result;
	    }
	
	    private static function prepCensorWords():Array {
											
	        var wordPadding:String = "********************";
	        var newWord:String = "";
	        var checkWords:Array = new Array();
					
	        // loop thru all possible words
	        for each(var word:String in words) {
	            // split out params
	            var wordAttr:Array = word.split(":");
						
	            // create a * pad version of the word
	            var replaceWord:String = wordPadding.substring(0, wordAttr[0].length);
						
	            // if we are replace it with a specific phrase, then make that change now
	            if (wordAttr[3].length > 0) {
	                replaceWord = wordAttr[3];
	            }
							
	            // push that altered initial word into the stack
	            checkWords.push(
	                    wordAttr[0] + ":" + replaceWord + ":" + wordAttr[1] + ":"
	                    + wordAttr[4] + ":" + wordAttr[5]);
						
	            // if we are to create variants, loop through and create those now
	            if (wordAttr[2] == "true") {
	                for each (var r:String in replacements) {
	                    var elements:Array = r.split(":");
							
	                    // if the variant phrase exists inside the root word, start replacing
	                    if (wordAttr[0].indexOf(elements[0]) > -1) {
	                        newWord = wordAttr[0].replace(elements[0], elements[1]); 
													
	                        // push new variant onto the stack
	                        checkWords.push(
	                                newWord + ":" + replaceWord + ":" + wordAttr[1]
	                                + ":" + wordAttr[4] + ":" + wordAttr[5]);
	                    }
	                }
	            }
						
	        }
					
	        return checkWords;
	    }
				
	    // [0] word
	    // [1] replace
	    // [2] hold
	    // [3] specialFind
	    // [4] wordFind);
				
	    // this is a dual purpose method that performs two functions
	    // checks to see if a violating word is inside
	    // if so, it can censor the sentence containing the word
	    private static function censorText(sentence:String, matchCase:Boolean, checking:Boolean):String {
	        var stopFlag:String;
	        var searchSentence:String;
			var attr:Array;
			var w:String;
			
	        if (!matchCase) // convert to lowercase if need be
	        {
	            searchSentence = sentence.toLowerCase();
	        } // /TODO BUG?
	        else {
	            searchSentence = sentence;
	        }
					
	        if (checking) // just checking for a word
	        {
	            for each (w in checkWords) {			
	                attr = w.split(":");
							
	                // make sure the first letter of the search word exists in the sentence
	                // if(strpos($searchSentence,substr($attr[0],0,1)) > -1 
	                // && strpos($searchSentence,substr($attr[0],strlen($attr[0])-1,1)) > -1
	                // && strlen($attr[0]) <= strlen($searchSentence))
	                if (searchSentence.indexOf(attr[0].charAt(0)) > -1
	                        && searchSentence.indexOf(
	                                attr[0].charAt(attr[0].length - 1))
	                                        > -1
	                                        && attr[0].length
	                                                <= searchSentence.length
	                                                ) {
	                    stopFlag = censorReplace(sentence, attr[0], attr[1],
	                            matchCase, checking, attr[2], attr[3], attr[4]);
	                    if (stopFlag != null) {
	                        return stopFlag;
	                        // break;
	                    }
	                }
	            }
						
	            return null;
	        } else {
	            for each (w in checkWords) {
	                attr = w.split(":");
						
	                if (searchSentence.indexOf(attr[0].charAt(0)) > -1 
	                        && searchSentence.indexOf(
	                                attr[0].charAt(attr[0].length - 1))
	                                        > -1
	                                        && attr[0].length
	                                                <= searchSentence.length) {
	                    // if(strpos($searchSentence,substr($attr[0],0,1)) > -1
	                    // && strpos($searchSentence,substr($attr[0],strlen($attr[0])-1,1)) > -1
	                    // && strlen($attr[0]) <= strlen($searchSentence))
	                    sentence = censorReplace(sentence, attr[0], attr[1],
	                            matchCase, checking, attr[2], attr[3], attr[4]);
	                }
														
	            }
	        }
					
	        return sentence;
	    }
				
	    // this is the mother of all censor procedures and the brains
	    // of the outfit
	    private static function censorReplace(sentence:String,
	            word:String,
	            replace:String,
	            matchCase:Boolean,
	            checking:Boolean,
	            hold:String,
	            specialFind:String,
	            wordFind:String):String {
	        
	        var letterCounter:int = 0;
	        var replaceLength:int = 0;
	        var validChars:String = "abcdefghijklmnopqrstuvwxyzABCEDFGHIJKLMNOPQRSTUVWXYZ";
	        
	        var searchSentence:String = sentence;
					
	        if (!matchCase) // convert to lowercase if need be
	        {
	            searchSentence = searchSentence.toLowerCase();
	            word = word.toLowerCase();
	        }
	
	        // test to see if we"re to do the special find 
	        if (specialFind == "true") {
	            var wordStart:int = searchSentence.indexOf(word.charAt(0)); 	
					
	            // check to see if the first letter even exists inside the string
	            if (wordStart > -1) {
	                // looping through every char in the sentence
	                for (var l:int = wordStart; l < searchSentence.length; l++) {
	                    // checking to see if the chars match
	                    if (searchSentence.charAt(l) == word.charAt(letterCounter)) {
	                        letterCounter++;
	                    } // check to see if the letter is a dup, or an invalid spacer
	                    else if (searchSentence.charAt(l)
	                            == word.charAt(letterCounter - 1)
	                                    || validChars.indexOf(
	                                            searchSentence.charAt(l))
	                                                    == -1) {
	                        replaceLength++;
	                    } // check for a wild character, not currently being used, allows any number of chars
	                    else if (word.charAt(letterCounter) == '*') {
	                        letterCounter++;
	                    } else // jump to the next valid letter, speed it up!
	                    {
	                        letterCounter = 0;
	                        replaceLength = 0;
									
	                        if (searchSentence.substring(l).indexOf(word.charAt(0))
	                                > -1) {
	                            l += searchSentence.substring(l).indexOf(
	                                    word.charAt(0))
	                                            - 1; 
	                            wordStart = l + 1;
	                        } else {
	                            break;
	                        }
										
	                    }

	                    // if a word has been found, replace it
	                    if (letterCounter == word.length 
	                            && searchSentence.charAt(l + 1)
	                                    != word.charAt(letterCounter - 1) 
	                                    && checking == false) {
									
	                        if (!hold == "false") {
	                            // print "hold: $hold word: $word<br>";
	                            return null;
	                        }
									
	                        if (wordFind == "false" || validWordFind(searchSentence, wordStart, word.length)) {
									
	                            // looking for a single match to divert, if not allowed
	                            if (checking == true && hold == "true") {
	                                return null;
	                            }
											
	                            replaceLength += letterCounter;
										
	                            sentence = replaceWord(sentence, word, replace,
	                                    wordStart, replaceLength);
	                            searchSentence = sentence;
										
	                            if (!matchCase) {
	                                searchSentence = searchSentence.toLowerCase();
	                            }
										
	                            l -= (replaceLength - replace.length);
										
	                            var nextStart:int = searchSentence.substring(l + 1).indexOf(
	                                    word.charAt(0));
										
	                            if (nextStart > -1) {
	                                l += nextStart;
	                                wordStart = l + 1;
	                                replaceLength = 0;
	                            } else {
	                                break;
	                            }
										
	                            letterCounter = 0;
	                        } else {
	                            letterCounter = 0;
	                            replaceLength = 0;
										
	                            if (searchSentence.substring(l).indexOf(
	                                    word.charAt(0))
	                                            > -1) {
	                                l += searchSentence.substring(l).indexOf(
	                                        word.charAt(0)); 
	                                wordStart = l + 1;
	                            } else {
	                                break;
	                            }
	                        }
	                    } else if (letterCounter == word.length
	                            && searchSentence.charAt(l + 1)
	                                    != word.charAt(letterCounter - 1)
	                                    && checking == true) {
	                        return null;
	                    }
	                }
	            }
						
	            if (checking == true) {
	                return null;
	            } else {
	                return sentence;
	            }
	        } else {
	            if (checking == true && sentence.indexOf(word) > -1
	                    && hold == "true") {
	                return null;
	            } else if (checking == true) {
	                return null;
	            }
						
	            return sentence.replace(word, replace);
						
	        }
	    }
				
	    private static function validWordFind(sentence:String, letterStart:int, replaceLength:int):Boolean {
	        // check to see if the current word has failed to be a individual
	        // word, and if so, reject the flag
	        if ((letterStart == 0 || sentence.charAt(letterStart - 1) == ' ')) { 
	            if (sentence.charAt(letterStart + replaceLength) == ' '
	                    || letterStart + replaceLength == sentence.length) {
	                return true;
	            } else {
	                return false;
	            }
	        } else {
	            return false;
	        }
	    }
				
	    private static function replaceWord(sentence:String, word:String, replace:String, wordStart:int, replaceLength:int):String {
	        if (wordStart == 0) {
	            sentence = replace + sentence.substring(wordStart + replaceLength);
	        } else if (wordStart > 0) {
	            sentence = sentence.substring(0, wordStart) + replace
	                    + sentence.substring(wordStart + replaceLength);
	        }
	        return sentence;
	    }
	}
}
