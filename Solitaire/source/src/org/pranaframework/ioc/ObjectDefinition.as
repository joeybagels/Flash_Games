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
	
	import org.pranaframework.utils.Assert;
	
	/**
	 * Describes an object that can be created by an <code>ObjectContainer</code>.
	 * 
	 * @author Christophe Herreman
	 * @author Damir Murat
	 */
	public class ObjectDefinition implements IObjectDefinition {
		
		/**
		 * Constructs a new ObjectDefinition
		 */
		public function ObjectDefinition(className:String) {
			this.className = className;
			this.constructorArguments = [];
			this.properties = {};
			this.scope = ObjectDefinitionScope.SINGLETON;
			this.isLazyInit = false;
		}
		
		/**
		 * TODO add check for properties and constructorarguments
		 */
		public function equals(object:IObjectDefinition):Boolean {
			var result:Boolean = (className == object.className)
								&& (isSingleton == object.isSingleton);
			
			return result;
		}
		
		public function toString():String {
			var result:String = "[ObjectDefinition('" + className + "', factoryMethod: " + factoryMethod + ", constructorArguments: '" + constructorArguments + "', properties: " + properties + ")]";
			return result;
		}
		
		// --------------------------------------------------------------------
		// Properties
		// --------------------------------------------------------------------
		
		// className
		private var _className:String;
		public function get className():String { return _className; }
		public function set className(value:String):void { _className = value; }
		
		// factoryMethod
		private var _factoryMethod:String;
		public function get factoryMethod():String { return _factoryMethod; }
		public function set factoryMethod(value:String):void { _factoryMethod = value; }
		
		// initMethod
		private var _initMethod:String;
		public function get initMethod():String { return _initMethod; }
		public function set initMethod(value:String):void { _initMethod = value; }
		
		// constructorArguments
		private var _constructorArguments:Array;
		public function get constructorArguments():Array { return _constructorArguments; }
		public function set constructorArguments(value:Array):void { _constructorArguments = value; }
		
		// properties
		private var _properties:Object;
		public function get properties():Object { return _properties; }
		public function set properties(value:Object):void { _properties = value; }
		
		// isSingleton
		public function get isSingleton():Boolean { return (scope == ObjectDefinitionScope.SINGLETON); }
		public function set isSingleton(value:Boolean):void {
			scope = (value) ? ObjectDefinitionScope.SINGLETON : ObjectDefinitionScope.PROTOTYPE;
		}
		
		// scope
		private var _scope:ObjectDefinitionScope;
		public function get scope():ObjectDefinitionScope { return _scope; }
		public function set scope(value:ObjectDefinitionScope):void {
			Assert.notNull(value, "The scope cannot be null");
			_scope = value;
		}
		
		// isLazyInit
		private var _isLazyInit:Boolean;
		public function get isLazyInit():Boolean {
			return _isLazyInit;
		}
		public function set isLazyInit(value:Boolean):void {
			_isLazyInit = value;
		}
		
	}
}