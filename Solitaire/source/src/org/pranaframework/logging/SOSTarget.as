/**
 * Copyright (c) 2007-2008, the original author(s)
 * 
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 *     * Redistributions of source code must retain the above copyright notice,
 *       this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the Prana Framework nor the names of its contributors
 *       may be used to endorse or promote products derived from this software
 *       without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
package org.pranaframework.logging {
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.XMLSocket;
	
	import mx.core.mx_internal;
	import mx.logging.Log;
	import mx.logging.LogEventLevel;
	import mx.logging.targets.LineFormattedTarget;
	
	import org.pranaframework.events.XMLSocketEvent;

	use namespace mx_internal;

	/**
	 * Provides a logger that writes messages to the SOS console.
	 * 
	 * <p>In order to use this logger, add an instance to the <code>Log</code> as a target as follows:</p>
	 * 
	 * <p><code>var sosTarget:SOSTarget = new SOSTarget();
	 * Log.addTarget(sosTarget);</code></p>
	 * 
	 * @see http://sos.powerflasher.de
	 * @author Christophe Herreman
	 */
	public class SOSTarget extends LineFormattedTarget {
		
		public var foldMessages:Boolean = true;
		public var debugColor:Number = DEBUG_COLOR;
		public var infoColor:Number = INFO_COLOR;
		public var warningColor:Number = WARNING_COLOR;
		public var errorColor:Number = ERROR_COLOR;
		public var fatalColor:Number = FATAL_COLOR;
		
		private static var DEBUG_COLOR:Number = 0xFFFFFF;
		private static var INFO_COLOR:Number = 0xD9D9FF;
		private static var WARNING_COLOR:Number = 0xFFFFCE;
		private static var ERROR_COLOR:Number = 0xFFBBBB;
		private static var FATAL_COLOR:Number = 0xCC99CC;
		
		private var _socket:XMLSocket;
		private var _messageCache:Array;
		private var _host:String;
		private var _port:uint;
	
	    /**
		 * Creates a new <code>SOSTarget</code> instance.
		 * 
		 * @param host A fully qualified DNS domain name or an IP address in the form aaa.bbb.ccc.ddd. You can also specify null to connect to the host server on which the SWF file resides. If the SWF file issuing this call is running in a web browser, host must be in the same domain as the SWF file.
		 * @param port The TCP port number on the host used to establish a connection. The port number must be 1024 or greater, unless a policy file is being used.
	     */
	    public function SOSTarget(host:String = "localhost", port:uint = 4445) {
	        super();
	        _socket = new XMLSocket();
	        _host = host;
	        _port = port;
	        _messageCache = [];
	        init();
	    }
	    
	    /**
		 * 
		 */
		override mx_internal function internalLog(message:String):void {
			if (_socket.connected) {
				_socket.send(createMessage(getLogLevelFromMessage(message), message));
            }
            else {
				_messageCache.push(message);
            }
	    }
	    
		/**
		 * 
		 */
	    private function init():void {
			includeCategory = true;
			includeDate = true;
			includeLevel = true;
			includeTime = true;
			
			// listen for socket events
			//_socket.addEventListener(XMLSocketEvent.CLOSE, onXMLSocketClose);
			_socket.addEventListener(XMLSocketEvent.CONNECT, onXMLSocketConnect);
			//_socket.addEventListener(XMLSocketEvent.DATA, onXMLSocketData);
			_socket.addEventListener(XMLSocketEvent.IOERROR, onXMLSocketIOError);
			//_socket.addEventListener(XMLSocketEvent.SECURITY_ERROR, onXMLSocketSecurityError);
			
			// connect the socket
			_socket.connect(_host, _port);
			
			// set output colors
			_socket.send("<setKey><name>" + LogEventLevel.DEBUG + "</name><color>" + debugColor + "</color></setKey>");
			_socket.send("<setKey><name>" + LogEventLevel.INFO + "</name><color>" + infoColor + "</color></setKey>");
			_socket.send("<setKey><name>" + LogEventLevel.WARN + "</name><color>" + warningColor + "</color></setKey>");
			_socket.send("<setKey><name>" + LogEventLevel.ERROR + "</name><color>" + errorColor + "</color></setKey>");
			_socket.send("<setKey><name>" + LogEventLevel.FATAL + "</name><color>" + fatalColor + "</color></setKey>");
	    }
	    
	    /*public function onXMLSocketClose(event:Event):void {
	    	trace("onXMLSocketClose()");
	    }*/
	    
	    public function onXMLSocketConnect(event:Event):void {
	    	// send all messages that have been logged when the socket was not
	    	// yet connected
	    	while (_messageCache.length > 0) {
	    		internalLog(_messageCache.shift());
	    	}
	    }
	    
	    /*public function onXMLSocketData(event:Event):void {
	    	trace("onXMLSocketData()");
	    }*/
	    
	    public function onXMLSocketIOError(event:IOErrorEvent):void {
	    	trace("onXMLSocketIOError()");
	    	// TODO 
	    	//dispatchEvent(event);
	    }
	    
	    /*public function onXMLSocketSecurityError(event:Event):void {
	    	trace("onXMLSocketSecurityError()");
	    }*/
	    
		/**
		 * 
		 */
	    private function getLogLevelFromMessage(message:String):int {
	    	var result:int = LogEventLevel.ALL;
	    	
	    	if (message.indexOf("[DEBUG]") > -1) {
	    		result = LogEventLevel.DEBUG;
	    	}
	    	else if (message.indexOf("[INFO]") > -1) {
	    		result = LogEventLevel.INFO;
	    	}
	    	else if (message.indexOf("[WARN]") > -1) {
	    		result = LogEventLevel.WARN;
	    	}
	    	else if (message.indexOf("[ERROR]") > -1) {
	    		result = LogEventLevel.ERROR;
	    	}
	    	else if (message.indexOf("[FATAL]") > -1) {
	    		result = LogEventLevel.FATAL;
	    	}
	    	return result;
	    }
		
		/**
		 * 
		 */
		private function createMessage(level:int, message:String):String {
			var containsNewLine:Boolean = (message.indexOf("\n") != -1);
			var result:String;
			
			if (containsNewLine && foldMessages) {
				var levelIndex:int = message.indexOf("]");
				var title:String = (levelIndex == -1) ? "Folded Message" : message.substr(0, levelIndex+1);
				if (levelIndex != -1) 
					message = message.substring(levelIndex+1 + fieldSeparator.length, message.length);
				result = "<showFoldMessage key='" + level + "'>"
					+ "<title>" + title + "</title>"
					+ "<message>" + message + "</message>"
					+ "</showFoldMessage>";
			}
			else {
				result = "<showMessage key=\"" + level + "\">" + message + "</showMessage>\n";
			}
			
			return result;
		}

	}
}