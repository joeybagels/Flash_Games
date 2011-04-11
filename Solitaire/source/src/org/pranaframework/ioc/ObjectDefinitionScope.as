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
 package org.pranaframework.ioc {
	
	import org.pranaframework.errors.IllegalArgumentError;
	import org.pranaframework.utils.Assert;
	import org.pranaframework.utils.StringUtils;
	
	/**
	 * Enumeration for the scopes of an object definition.
	 * 
	 * @author Christophe Herreman
	 */
	public class ObjectDefinitionScope {
		
		public static const PROTOTYPE:ObjectDefinitionScope = new ObjectDefinitionScope(PROTOTYPE_NAME);
		public static const SINGLETON:ObjectDefinitionScope = new ObjectDefinitionScope(SINGLETON_NAME);
		
		public static const PROTOTYPE_NAME:String = "prototype";
		public static const SINGLETON_NAME:String = "singleton";
		
		private static var _enumCreated:Boolean = false;
		
		private var _name:String;
		 {
			_enumCreated = true;
		}
		
		/**
		 * Creates a new ObjectDefintionScope object.
		 * This constructor is only used internally to set up the enum and all
		 * calls will fail.
		 * 
		 * @param name the name of the scope
		 */
		public function ObjectDefinitionScope(name:String) {
			Assert.state((false == _enumCreated), "The ObjectDefinitionScope enum has already been created.");
			_name = name;
		}
		
		/**
		 * 
		 */
		public static function fromName(name:String):ObjectDefinitionScope {
			var result:ObjectDefinitionScope;
			
			// check if the name is a valid value in the enum
			switch (StringUtils.trim(name.toLowerCase())) {
				case PROTOTYPE_NAME:
					result = PROTOTYPE;
					break;
				case SINGLETON_NAME:
					result = SINGLETON;
					break;
				default:
					result = SINGLETON;
			}
			return result;
		}
		
		/**
		 * Returns the name of the scope.
		 * 
		 * @returns the name of the scope
		 */
		public function get name():String {
			return _name;
		}
		
	}
}