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
package org.pranaframework.ioc.factory.support {

	import org.pranaframework.ioc.IObjectDefinition;

	/**
	 * Defines the interface for an object definition registry. This interface contains add methods 
	 * needed to work with object definitions.
	 *
	 * @author Christophe Herreman
	 * @author Erik Westra
	 */
	public interface IObjectDefinitionRegistry {
		/**
		 * Will register the given objectDefinition with the given name. If the 
		 * allowObjectDefinitionOverriding has been set to true, this method will 
		 * remove the existing object.
		 * 
		 * @param objectName		The name under which the object definition should be stored
		 * @param objectDefinition	The object definition that should be stored
		 */
		function registerObjectDefinition(objectName:String, obectDefinition:IObjectDefinition):void;
		
		/**
		 * Removes the definition with the given name from the registry
		 * 
		 * @param objectName	The name/id of the definition to remove
		 */
		function removeObjectDefinition(objectName:String):void;
		
		/**
		 * Returns the object definition registered with the given name. If the object 
		 * definition does not exist <code>undefined</code> will be returned.
		 * 
		 * @param objectName	The name/id of the definition to retrieve
		 * 
		 * @return The registered object definition, or <code>undefined</code> if the 
		 * 		   definition has not been registered.
		 */
		function getObjectDefinition(objectName:String):IObjectDefinition;
		
		/**
		 * Determines if an object definition with the given name exists
		 * 
		 * @param objectName	The name/id of the object definition
		 */
		function containsObjectDefinition(objectName:String):Boolean;
		
		/**
		 * Whether to allow re-registration of a different definition with the same name
		 * 
		 * @default true
		 */		
		function get allowObjectDefinitionOverriding():Boolean;
		function set allowObjectDefinitionOverriding(value:Boolean):void;
	}
}