// Copyright (c) 2007 rubyamf.org (aaron@rubyamf.org)
// License - http://www.gnu.org/copyleft/gpl.html

package org.rubyamf.remoting.ssr
{

	import flash.events.ErrorEvent;
	
	public class FaultEvent extends ErrorEvent
	{
		
		public static const FAULT:String = "FAULT";
		public static const CONNECTION_ERROR:String = "CONNECTION_ERROR";
		public static const AUTHENTICATION_FAILED:String = "AUTHENTICATION_FAILED";
		public var fault:Object;
		
		/*
		 * Constructor
		 * @param type:String
		 * @param bubbles:Boolean
		 * @param cancelable:Boolean
		 * @param result:Object
		 */
		public function FaultEvent(type:String, bubbles:Boolean, cancelable:Boolean, fault:Object)
		{
			super(type, bubbles, cancelable, "");
			this.fault = fault;
		}
		
		/*
		 * toString - duh
		 */
		public override function toString():String 
		{
			return "org.rubyamf.remoting.ssr.FaultEvent";
		}
	}
}