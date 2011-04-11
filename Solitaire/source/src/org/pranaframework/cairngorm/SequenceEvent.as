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
	
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import org.pranaframework.utils.ClassUtils;
	import org.pranaframework.utils.Property;
	
	/**
	 * 
	 */
	public class SequenceEvent {
		
		private var _eventClass:Class;
		private var _parameters:Array;
		private var _nextEventTriggers:Array;
		
		/**
		 * Creates a new SequenceEvent object.
		 */
		public function SequenceEvent(eventClass:Class, parameters:Array = null, nextEventTriggers:Array = null) {
			_eventClass = eventClass;
			_parameters = parameters;
			_nextEventTriggers = nextEventTriggers;
		}
		
		public function get eventClass():Class {
			return _eventClass;
		}
		
		public function get parameters():Array {
			return _parameters;
		}
		
		public function get nextEventTriggers():Array {
			return _nextEventTriggers;
		}
		
		public function createEvent():CairngormEvent {
			return ClassUtils.newInstance(eventClass, getParameterValues());
		}
		
		private function getParameterValues():Array {
			var result:Array = [];
			
			if (parameters) {
				for (var i:int = 0; i<parameters.length; i++) {
					var p:* = parameters[i];
					if (p is Property) {
						result.push(p.getValue());
					}
					else {
						result.push(p);
					}
				}
			}
			
			return result;
		}
	}
}