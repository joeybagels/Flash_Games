/**
 * Copyright (c) 2007-2008, the original author(s)
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *		 * Redistributions of source code must retain the above copyright notice,
 *			 this list of conditions and the following disclaimer.
 *		 * Redistributions in binary form must reproduce the above copyright
 *			 notice, this list of conditions and the following disclaimer in the
 *			 documentation and/or other materials provided with the distribution.
 *		 * Neither the name of the Prana Framework nor the names of its contributors
 *			 may be used to endorse or promote products derived from this software
 *			 without specific prior written permission.
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

	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	
	import org.pranaframework.errors.ClassNotFoundError;
	import org.pranaframework.errors.PropertyTypeError;
	import org.pranaframework.errors.ResolveReferenceError;
	import org.pranaframework.ioc.IObjectDefinition;
	import org.pranaframework.ioc.ObjectDefinitionNotFoundError;
	import org.pranaframework.ioc.factory.IFactoryObject;
	import org.pranaframework.ioc.factory.IInitializingObject;
	import org.pranaframework.ioc.factory.IReferenceResolver;
	import org.pranaframework.ioc.factory.MethodInvokingObject;
	import org.pranaframework.ioc.factory.NoSuchObjectDefinitionError;
	import org.pranaframework.ioc.factory.config.IConfigurableObjectFactory;
	import org.pranaframework.ioc.factory.config.IObjectPostProcessor;
	import org.pranaframework.ioc.factory.config.ObjectFactoryAwarePostProcessor;
	import org.pranaframework.ioc.factory.support.referenceresolvers.ArrayReferenceResolver;
	import org.pranaframework.ioc.factory.support.referenceresolvers.DictionaryReferenceResolver;
	import org.pranaframework.ioc.factory.support.referenceresolvers.ObjectReferenceResolver;
	import org.pranaframework.objects.IPropertyEditor;
	import org.pranaframework.objects.IPropertyEditorRegistry;
	import org.pranaframework.objects.ITypeConverter;
	import org.pranaframework.objects.SimpleTypeConverter;
	import org.pranaframework.reflection.Method;
	import org.pranaframework.reflection.Type;
	import org.pranaframework.utils.Assert;
	import org.pranaframework.utils.ClassUtils;

	/**
	 * This is the basic implementation of IConfigurableObjectFactory. Manages object 
	 * definitions and creates new objects based on those definitions.
	 *
	 * @author Christophe Herreman
	 * @author Damir Murat
	 * @author Erik
	 * 
	 * @see org.pranaframework.ioc.factory.config.IConfigurableObjectFactory
	 */
	public class AbstractObjectFactory extends EventDispatcher implements IConfigurableObjectFactory {

		// static code block to force compilation of certain classes 
		{
			MethodInvokingObject
		}
	
		/**
		 * Contains the registered definitions of type IObjectDefinition. The keys are the 
		 * names/ids of the IObjectDefinitions.
		 */
		protected var objectDefinitions:Object = {};
		
		//contains instances of IObjectPostProcessor
		private var _objectPostProcessors:Array;
		
		//contains instances of IReferenceResolver
		private var _referenceResolvers:Array = [];
		
		private var _objectCache:Object = {};
		private var _typeConverter:ITypeConverter = new SimpleTypeConverter();
	
		/**
		 * Constructs a new <code>AbstractObjectFactory</code>.
		 * <p /> 
		 * The following post processors are added by default:
		 * <ul>
		 *	<li>ObjectFactoryAwarePostProcessor</li>
		 * </ul>
		 * 
		 * The following reference resolvers are added by default:
		 * <ul>
		 * 	<li>ObjectReferenceResolver</li>
		 * 	<li>ArrayReferenceResolver</li>
		 * 	<li>DictionaryReferenceResolver</li>
		 * </ul>
		 * 
		 * @see org.pranaframework.ioc.factory.config.ObjectFactoryAwarePostProcessor
		 * @see org.pranaframework.ioc.factory.support.referenceresolvers.ObjectReferenceResolver
		 * @see org.pranaframework.ioc.factory.support.referenceresolvers.ArrayReferenceResolver
		 * @see org.pranaframework.ioc.factory.support.referenceresolvers.DictionaryReferenceResolver
		 * @see #addReferenceResolver()
		 * @see #addObjectPostProcessor()
		 */
		public function AbstractObjectFactory() {
			super(this);
			
			_initialize();
		}
		
		private function _initialize():void {
			_objectPostProcessors = [new ObjectFactoryAwarePostProcessor(this)];
			
			addReferenceResolver(new ObjectReferenceResolver(this));
			addReferenceResolver(new ArrayReferenceResolver(this));
			addReferenceResolver(new DictionaryReferenceResolver(this));
		}

		// ========================================================================
		// IObjectFactory implementation
		// ========================================================================

		/**
		 * @inheritDoc 
		 */
		public function getObject(name:String, constructorArguments:Array = null):* {
			var result:*;
			var objectDefinition:IObjectDefinition = objectDefinitions[name];
		
			if (!objectDefinition) {
				// we don't have an object definition for the given name
				throw new ObjectDefinitionNotFoundError("An object definition for '" + name + "' was not found.");
			}

			if (constructorArguments && !objectDefinition.isLazyInit) {
				// dmurat: constructor parameters are only allowed for lazy instantiating objects (at least for now)
				throw new IllegalOperationError(
					"An object definition for '" + name + "' is not lazy. Constructor arguments can only be " + 
					"supplied for lazy instantiating objects.");
			}
			
			if (objectDefinition.isSingleton) {
				// if this is a singleton, try to get it from the cache
				result = _objectCache[name];
			}

			if (!result) {
				// create a new object if none was found in cache
				try {
					var clazz:Class = ClassUtils.forName(objectDefinition.className);
			
					if (constructorArguments) {
						objectDefinition.constructorArguments = constructorArguments;
					}

					// create the object via the constructor or a static factory method
					var resolvedConstructorArgs:Array = _resolveReferences(objectDefinition.constructorArguments);

					if (objectDefinition.factoryMethod) {
						var type:Type = Type.forClass(clazz);
						var factoryMethod:Method = type.getMethod(objectDefinition.factoryMethod);
						result = factoryMethod.invoke(clazz, resolvedConstructorArgs);
					}
					else {
						result = ClassUtils.newInstance(clazz, resolvedConstructorArgs);
					}
	
				
					/*
						set properties on the newly created object
					*/
					
					var reference:Object;
					var property:Object;
					
					for (property in objectDefinition.properties) {
						/*
							Using two try blocks in order to improve error reporting
						*/
						// resolve the reference to the property
						try {
							reference = resolveReference(objectDefinition.properties[property]);
						} catch (e:Error) {
							throw new ResolveReferenceError("The property '" + property + "' on the definition of '" + 
															name + "' could be resolved. Original error: \n" + 
															e.message);
						}
						
						// set the property on the created instance
						try {
							result[property] = reference;
						} catch (typeError:TypeError) {
							throw new PropertyTypeError("The property '" + property + "' on the definition of '" + 
														name + "' was given the wrong type. Original error: \n" + 
														typeError.message);
						} catch (e:Error) {
							throw e;
						}
					}

					_doPostProcessingBeforeInitialization(result, name);
	
					if (result is IInitializingObject) {
						IInitializingObject(result).afterPropertiesSet();
					}
	
					if (objectDefinition.initMethod) {
						result[objectDefinition.initMethod]();
					}
	
					_doPostProcessingAfterInitialization(result, name);
	
					if (result is IFactoryObject) {
						result = IFactoryObject(result).getObject();
					}
	
					if (objectDefinition.isSingleton) {
						// cache the object if its definition is a singleton
						_objectCache[name] = result;
					}
					
				} catch (e:ClassNotFoundError) {
					// TODO throw ObjectContainerError
					throw e;
				}
			}
	
			return result;
		}
	
		/**
		 * @inheritDoc
		 */
		public function containsObject(objectName:String):Boolean {
			return (objectDefinitions[objectName] != null);
		}
	
		/**
		 * @inheritDoc
		 */
		public function isSingleton(objectName:String):Boolean {
			var objectDefinition:IObjectDefinition = _getObjectDefinition(objectName);
			return objectDefinition.isSingleton;
		}
	
		/**
		 * @inheritDoc
		 */
		public function isPrototype(objectName:String):Boolean {
			return (!isSingleton(objectName));
		}
	
		/**
		 * @inheritDoc
		 */
		public function getType(objectName:String):Class {
			var objectDefinition:IObjectDefinition = _getObjectDefinition(objectName);
			return ClassUtils.forName(objectDefinition.className);
		}

		/**
		 * @inheritDoc
		 */
		public function resolveReference(property:Object):Object {
			var numReferenceResolvers:int = _referenceResolvers.length;
			
			for (var i:int = 0; i < numReferenceResolvers; i++) {
				var referenceResolver:IReferenceResolver = _referenceResolvers[i];
				
				if (referenceResolver.canResolve(property)) {
					property = referenceResolver.resolve(property);
					break;
				}
			}
			return property;
		}
		
		/**
		 * @inheritDoc
		 */
		public function clearObjectFromInternalCache(name:String):Object {
			var result:Object = _objectCache[name];
			delete _objectCache[name];
			return result;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addReferenceResolver(referenceResolver:IReferenceResolver):void {
			Assert.notNull("The reference resolver cannot not be null");
			_referenceResolvers.push(referenceResolver);
		}		
		
		// ========================================================================
		// IConfigurableObjectFactory implementation
		// ========================================================================
		
		/**
		 * @inheritDoc
		 */
		public function addObjectPostProcessor(objectPostProcessor:IObjectPostProcessor):void {
			Assert.notNull(objectPostProcessor, "The 'objectPostProcessor' must not be null");
			_objectPostProcessors.push(objectPostProcessor);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get numObjectPostProcessors():int {
			return _objectPostProcessors.length;
		}
		
		/**
		 * @inheritDoc
		 */
		public function isFactoryObject(objectName:String):Boolean {
			var objectDefinition:IObjectDefinition = objectDefinitions[objectName];
			var clazz:Class = ClassUtils.forName(objectDefinition.className);
			return ClassUtils.isImplementationOf(clazz, IFactoryObject);
		}
		
		/**
		 * @inheritDoc
		 */
		public function registerCustomEditor(requiredType:Class, propertyEditor:IPropertyEditor):void {
			if (_typeConverter is IPropertyEditorRegistry) {
				IPropertyEditorRegistry(_typeConverter).registerCustomEditor(requiredType, propertyEditor);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get typeConverter():ITypeConverter {
			return _typeConverter;
		}
		
		public function set typeConverter(value:ITypeConverter):void {
			Assert.notNull(typeConverter, "The type converter cannot be null");
			_typeConverter = value;
		}

	// ========================================================================
		
		/**
		 * Retrieves the definition with the given name.
		 * 
		 * @param objectName	The name/id of the definition that needs to be retrieved
		 * 
		 * @return an instance of IObjectDefinition
		 * 
		 * @throws org.pranaframework.ioc.factory.NoSuchObjectDefinitionError	The definition should exist
		 */
		private function _getObjectDefinition(objectName:String):IObjectDefinition {
			Assert.notNull(objectName, "The object name cannot be null");
			Assert.hasText(objectName, "The object name must have text");
			
			var result:IObjectDefinition = objectDefinitions[objectName];
			if (!result) {
				throw new NoSuchObjectDefinitionError(objectName);
			}
			
			return result;
		}
	
		/**
		 * Loops through the object post processors and calls the postProcessBeforeInitialization
		 */
		private function _doPostProcessingBeforeInitialization(object:Object, name:String):void {
			var o:IObjectPostProcessor;
			
			for (var i:int = 0; i < _objectPostProcessors.length; i++) {
				o = _objectPostProcessors[i];
				o.postProcessBeforeInitialization(object, name);
			}
		}
	
		/**
		 * Loops through the object post processors and calls the postProcessAfterInitialization
		 */
		private function _doPostProcessingAfterInitialization(object:*, name:String):void {
			var o:IObjectPostProcessor;
			
			for (var i:int = 0; i<_objectPostProcessors.length; i++) {
				o = _objectPostProcessors[i];
				o.postProcessAfterInitialization(object, name);
			}
		}
	
		/**
		 * Will resolve an array of properties using the resolveReference method.
		 * 
		 * @param properties	The properties to resolve
		 * 
		 * @return properties	An array containing the resolved properties
		 */
		private function _resolveReferences(properties:Array):Array {
			var result:Array = [];
			
			for each (var p:Object in properties) {
				result.push(resolveReference(p));
			}
			
			return result;
		}
	
	}
}