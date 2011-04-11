// Copyright (c) 2007 rubyamf.org (aaron@rubyamf.org)
// License - http://www.gnu.org/copyleft/gpl.html

package org.rubyamf.remoting.ssr
{

	import flash.net.Responder;
	import flash.events.EventDispatcher;
	import flash.events.ErrorEvent;
	import flash.utils.*;
	import org.rubyamf.remoting.ssr.RemotingConnection;
	import org.rubyamf.remoting.ssr.RemotingService;
	import org.rubyamf.remoting.ssr.ResultEvent;
	import org.rubyamf.remoting.ssr.FaultEvent;
	
	public class RemotingCall extends EventDispatcher
	{
		
		private var connection:RemotingConnection;			//the remoting connection
		private var operationPath:String;								//the operation
		private var responder:Responder;								//a call responder
		private var onresult:Function;									//result handler
		private var onfault:Function;										//fault handler
		private var args:Array;													//call arguments
		private var meta:Object;												//operation meta (timeout, maxAttempts, returnArgs)
		private var attempt:uint = 0;										//number of attemts
		private var busyInt:Number;											//busy interval
		private var timeoutInt:Number;									//timeout interval
		private var completed:Boolean = false;					//complete flag
		
		/*
		 * Constructor
		 * @param remotingConnection:RemotingConnection
		 * @param operation:String
		 * @param onresult:Function
		 * @param onfault:Function
		 * @param arguments:Array
		 * @param meta:Object
		 */
		public function RemotingCall(ct:RemotingConnection, op:String, onres:Function, onfau:Function, ar:Array, met:Object) 
		{			
			connection = ct;
			operationPath = op;
			args = ar;
			onresult = onres;
			onfault = onfau;
			meta = met;
		}
		
		/*
		 * onResult - result of a remoting call. The result propogates through this method 
		 * and is turned into a ResultEvent, then the onresult callback is called.
		 * @param obj:Object
		 */
		private function onResult(resObj:Object):void
		{			
			if(!completed)
			{
				completed = true;
				trace("onResult: " + operationPath);
				clearIntervals();
				var re:ResultEvent = new ResultEvent(ResultEvent.RESULT, false, true, resObj);
				var fe:FaultEvent = new FaultEvent(FaultEvent.FAULT, false, true, resObj);
				try
				{
					if(resObj == null || resObj == undefined as Object)
					{
						RemotingService.removePendingCall();
						(meta.returnArgs) ? onresult(re,args) : onresult(re);
					}
					else if(typeof(resObj) != 'object')
					{
						RemotingService.removePendingCall();
						(meta.returnArgs) ? onresult(re,args) : onresult(re);
					}
					else if(resObj.faultCode != null && resObj.faultString != null)
					{
						if(resObj.faultString == 'Authentication Failed' && this.hasEventListener(FaultEvent.AUTHENTICATION_FAILED))
						{
							dispatchEvent(new ErrorEvent(FaultEvent.AUTHENTICATION_FAILED, false,false)); //dispatch to the service
						}
						else
						{
							trace("Forwarding to onFault handler")
							RemotingService.removePendingCall();
							(meta.returnArgs) ? onfault(fe,args) : onfault(fe);
						}
					}
					else
					{
						RemotingService.removePendingCall();
						(meta.returnArgs) ? onresult(re,args) : onresult(re);
					}
				}
				catch(e:*)
				{
						RemotingService.removePendingCall();
						if (onresult != null) {
							(meta.returnArgs) ? onresult(re,args) : onresult(re);
						}
				}
			}
		}
		
		/*
		 * onFault - fault of a remoting call. The fault propogates through this method 
		 * and is turned into a FaultEvent, then the onfault callback is called.
		 * @param obj:Object
		 */
		private function onFault(resObj:Object):void
		{
			completed = true;
			trace("onFault : " + operationPath)
			clearIntervals();
			
			try
			{
				if(resObj.faultString == 'Authentication Failed' && this.hasEventListener(FaultEvent.AUTHENTICATION_FAILED))
				{
					dispatchEvent(new ErrorEvent(FaultEvent.AUTHENTICATION_FAILED, false,false)); //dispatch to the service
					return;
				}
			}catch(e:*){} //do nothing. will forward to onFault handler if not dispatched correctly
			var fe:FaultEvent = new FaultEvent(FaultEvent.FAULT, false, true, resObj);
			try
			{
				RemotingService.removePendingCall();
				(meta.returnArgs) ? onfault(fe,args) : onfault(fe);
			}
			catch(e:*){}
		}
		
		/*
		 * execute - execute the remoting call
		 */
		public function execute():void
		{
			if(!completed)
			{
				trace("Executing: " + operationPath);
				var responder:Responder = new Responder(onResult, onFault);
				var callArgs:Array = new Array(operationPath, responder);
				connection.call.apply(null, callArgs.concat(args));
				if(attempt == 0)
				{
					if(meta.maxAttempts) busyInt = setInterval( handleBusy, RemotingService.BUSY_TIMEOUT);
					if(meta.timeout) timeoutInt = setInterval( handleTimeout, meta.timeout);
				}
				RemotingService.addPendingCall();
				attempt++;
			}
		}
		
		/*
		 * handleBusy - when a busy timeout happens
		 */
		private function handleBusy():void
		{
			if(attempt >= meta.maxAttempts)
			{
				completed = true;
				clearIntervals();
				RemotingService.removePendingCall();
				trace(operationPath + " was busy on all attempts.");
				var fo:Object = {faultString:"" + operationPath + " was busy on all attempts.", faultCode:"SSR_SERVER_BUSY_TIMEOUT"};
				var fe:FaultEvent = new FaultEvent(FaultEvent.FAULT, false, true, fo);
				(meta.returnArgs) ? onfault(fe,args) : onfault(fe);
			}
			else
			{
				trace("remotingCall: " + operationPath + " was busy on attempt " + attempt + ", trying again.");
				execute();
			}
		}
		
		/*
		 * handleTimeout - when a timeout happens (from meta.timeout)
		 */
		private function handleTimeout():void
		{
			if(!completed)
			{
				if(attempt > meta.maxAttempts)
				{
					completed = true;
					clearIntervals();
					RemotingService.removePendingCall();
					trace("remotingTimeout: " + operationPath + " timed out completely over " + meta.maxAttempts + " attempts.");
					var fo:Object = {
						faultString:"faultString: " + operationPath + " timed out completely over " + meta.maxAttempts + " attempts.",
						faultCode:"faultCode: SSR_COMPLETE_TIMEOUT"
					}
					var fe:FaultEvent = new FaultEvent(FaultEvent.FAULT, false, true, fo);
					(meta.returnArgs) ? onfault(fe,args) : onfault(fe);
				}
				else
				{
					trace("remotingTimeout: " + operationPath + " timed out on attempt " + attempt + ", trying again.");
					execute();
				}
			}
		}
		
		/*
		 * clearIntervals - clears timeout intervals
		 */
		private function clearIntervals():void
		{
			clearInterval(busyInt);
			clearInterval(timeoutInt);
		}
		
		/*
		 * toString
		 */
		//public function toString():String 
		//{
		//	return "org.rubyamf.remoting.ssr.RemotingCall";
		//}
	}
}
