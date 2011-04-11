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
 package org.pranaframework.ioc.factory 
 {

 	import flash.events.IEventDispatcher;
 	
 	/**
	 * Defines the most basic object factory. Most object factories will implement the 
	 * <code>IConfigurableObjectFactory</code> interface.
	 * 
	 * @see org.pranaframework.ioc.factory.config.IConfigurableObjectFactory
	 *
	 * @author Christophe Herreman
	 * @author Erik Westra
	 */
	public interface IObjectFactory extends IEventDispatcher {
		/**
		 * Will retrieve an object by it's name/id If the definition is a singleton it will be retrieved from 
		 * cache if possible. If the definition defines an init method, the init method will be called after 
		 * all properties have been set.
		 * <p />
		 * If any object post processors are defined they will be run against the newly created instance.
		 * <p />
		 * The class that is instantiated can implement the following interfaces for a special treatment: <br />
		 * <ul>
		 * 	<li><code>IInitializingObject</code>: The method defined by the interface will called after the 
		 * 										  properties have been set
		 * 	<li><code>IFactoryObject</code>:	  The actual object will be retrieved using the getObject method 
		 * </ul>
		 * 
		 * @param name						The name of the object as defined in the object definition
		 * @param constructorArguments		The arguments that should be passed to the constructor. Note that
		 * 									the constructorArguments can only be passed if the object is
		 * 									defined as lazy.
		 *
		 * @return An instance of the requested object
		 * 
		 * @see #resolveReference()
		 * @see org.pranaframework.ioc.IObjectDefinition
		 * @see org.pranaframework.ioc.factory.config.IObjectPostProcessor
		 * @see org.pranaframework.ioc.factory.IInitializingObject
		 * @see org.pranaframework.ioc.factory.IFactoryObject
		 * 
		 * @throws org.pranaframework.ioc.ObjectDefinitionNotFoundError		The name of the given object should be 
		 * 																	present as an object definition
		 * @throws flash.errors.IllegalOperationError						An object definition that is not lazy 
		 * 																	can not be given constructor arguments
		 * @throws org.pranaframework.errors.PropertyTypeError				The type of a property definition should 
		 * 																	match the type of property on the instance 
		 * @throws org.pranaframework.errors.ClassNotFoundError				The class set on the definition should 
		 * 																	be compiled into the application
		 * @throws org.pranaframework.errors.ResolveReferenceError			Indicating a problem resolving the 
		 * 																	references of a certain property
		 * 
		 * @example The following code retrieves an object from the object factory:
		 * <listing version="3.0">
		 * 	var myPerson:Person = objectFactory.getObject("myPerson") as Person;
		 * </listing>
		 */
		function getObject(name:String, constructorArguments:Array = null):*;

		/**
		 * Determines if the object factory contains a definition with the given name.
		 * 
		 * @param objectName	The name/id	of the object definition
		 * 
		 * @return true if a definition with that name exists
		 * 
		 * @see org.pranaframework.ioc.IObjectDefinition
		 */
		function containsObject(objectName:String):Boolean;

		/**
		 * Determines if the definition with the given name is a singleton.
		 * 
		 * @param objectName	The name/id	of the object definition
		 * 
		 * @return true if the definitions is defined as a singleton
		 * 
		 * @see org.pranaframework.ioc.IObjectDefinition
		 */
		function isSingleton(objectName:String):Boolean;

		/**
		 * Determines if the definition with the given name is a prototype.
		 * 
		 * @param objectName	The name/id	of the object definition
		 * 
		 * @return true if the definitions is defined as a prototype
		 * 
		 * @see org.pranaframework.ioc.IObjectDefinition
		 */
		function isPrototype(objectName:String):Boolean;

		/**
		 * Returns the type that is defined on the object definition.
		 * 
		 * @param objectName	The name/id	of the object definition
		 * 
		 * @return the class that is used to construct the object
		 * 
		 * @see org.pranaframework.ioc.IObjectDefinition
		 */
		function getType(objectName:String):Class;
	
		/**
		 * Removes an object from the internal object definition cache. This cache is used 
		 * to cache singletons.
		 *
		 * @param name 		The name/id	of the object to remove
		 * 
		 * @return 			the removed object
		 */
		function clearObjectFromInternalCache(name:String):Object;
		
		/**
		 * Resolves a property in an object definition. If the property could not 
		 * be resolved, the given property is returned. This means that the property 
		 * will be checked against all reference resolvers. If a reference resolver 
		 * can process it, it will do so.
		 * <p />
		 * This method is used to resolve implementations of IObjectReference. In 
		 * order to capture nested references container types like Array and 
		 * Dictionary are checked as well.
		 * 
		 * @param property 		the property that possibly that might contain references
		 * 
		 * @returns 			the property with all its references resolved
		 * 
		 * @see org.pranaframework.ioc.factory.config.IObjectReference
		 */
		function resolveReference(property:Object):Object;
		
		/**
		 * This method adds a reference resolver that will be used to resolve property 
		 * references.
		 * 
		 * @param referenceResolver		The implementation of IReferenceResolver that should be added
		 * 
		 * @see #resolveReference()
		 */
		function addReferenceResolver(referenceResolver:IReferenceResolver):void;
	}
}