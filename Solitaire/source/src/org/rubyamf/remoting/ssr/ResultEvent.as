// Copyright (c) 2007 rubyamf.org (aaron@rubyamf.org)
// License - http://www.gnu.org/copyleft/gpl.html

package org.rubyamf.remoting.ssr
{
	
	import flash.events.Event;
	
	/*
	 * ResultEvent - stores results of a service call
	 */
	public class ResultEvent extends Event 
	{
		
		public static const RESULT:String = "RESULT";
		public var result:Object;
		
		/*
		 * Constructor
		 * @param type:String
		 * @param bubbles:Boolean
		 * @param cancelable:Boolean
		 * @param result:Object
		 */
		public function ResultEvent(type:String, bubbles:Boolean, cancelable:Boolean, result:Object) 
		{
			super(type, bubbles, cancelable);
			this.result = result;
		}
		
		/*
		 * toString - duh
		 */
		public override function toString():String 
		{
			return "org.rubyamf.remoting.ssr.ResultEvent";
		}
	}
}