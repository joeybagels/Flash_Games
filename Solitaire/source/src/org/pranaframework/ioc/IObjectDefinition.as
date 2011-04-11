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
 	
	/**
	 * Represents an object definition.
	 * 
	 * @author Christophe Herreman
	 * @author Damir Murat
	 */
	public interface IObjectDefinition {
		
		function equals(object:IObjectDefinition):Boolean;
		
		function get className():String;
		function set className(value:String):void;
		
		function get factoryMethod():String;
		function set factoryMethod(value:String):void;
		
		function get initMethod():String;
		function set initMethod(value:String):void;
		
		function get constructorArguments():Array;
		function set constructorArguments(value:Array):void;
		
		function get properties():Object;
		function set properties(value:Object):void;
		
		function get isSingleton():Boolean;
		function set isSingleton(value:Boolean):void;
		
		function get scope():ObjectDefinitionScope;
		function set scope(value:ObjectDefinitionScope):void;
		
		function get isLazyInit():Boolean;
		function set isLazyInit(value:Boolean):void;
			
	}
}