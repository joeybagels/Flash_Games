// Copyright (c) 2007 rubyamf.org (aaron@rubyamf.org)
// License - http://www.gnu.org/copyleft/gpl.html

package org.rubyamf.remoting.ssr
{

	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;

	/*
	 * RemotinConnection - a child of NetConnection that adds methods to support AppendToGatewayUrl, AddHeader, setCredentials and ReplaceGatewayUrl
	 */
	public class RemotingConnection extends NetConnection
	{
		/*
		 * AppendToGatewayUrl - AMF0
		 */
		public function AppendToGatewayUrl(s:String):void{}
		
		/*
		 * AddHeader - add a persistent header. After adding a header it get's sent with every request
		 */
		public function AddHeader(name:String, mustUnderstand:Boolean, value:Object ):void
		{
			super.addHeader(name, mustUnderstand, value);
		}
		
		/*
		 * ReplaceGatewayUrl - Replace the current gateway url
		 */
		public function ReplaceGatewayUrl():void{}
		
		/*
		 * setCredentials - implements authentication
		 * @param username:String
		 * @param password:String
		 */
		public function setCredentials( username:String, password:String ):void
		{    
			super.addHeader( "Credentials", false, { userid:username, password:password } );
		}
	
		public override function toString():String 
		{
			return "org.rubyamf.remoting.ssr.ResultEvent";
		}
	}
}

