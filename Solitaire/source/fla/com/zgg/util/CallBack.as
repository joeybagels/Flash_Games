package com.zgg.util
{
	public class Callback
	{
		// Create a wrapper for a callback function.
		// Allows addt'l args to be passed to the on event handler functions
		
		public static function create(handler:Function,...args):Function
			{
				return function():*
				{
					return handler.apply(this,innerArgs.concat(args));
				}
			}
	}
}