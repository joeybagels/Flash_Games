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
 package org.pranaframework.cairngorm {
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * 
	 */
	public class PendingCommandRegistry extends EventDispatcher {
		
		private static var _instance:PendingCommandRegistry;
		
		private var _pendingCommands:Dictionary;
		
		/**
		 * 
		 */
		public function PendingCommandRegistry() {
			_pendingCommands = new Dictionary();
		}
		
		public static function getInstance():PendingCommandRegistry {
			if (!_instance)
				_instance = new PendingCommandRegistry();
			return _instance;
		}
		
		public function register(cmd:ICommand, event:CairngormEvent):void {
			_pendingCommands[event] = cmd;
			dispatchEvent(new PendingCommandRegistryEvent(PendingCommandRegistryEvent.REGISTER, cmd, event));
		}
		
		public function unregister(cmd:ICommand):void {
			for (var e:* in _pendingCommands) {
				if (_pendingCommands[e] === cmd) {
					dispatchEvent(new PendingCommandRegistryEvent(PendingCommandRegistryEvent.UNREGISTER, cmd, e));
					delete _pendingCommands[e];
				}
			}
		}
		
	}
}