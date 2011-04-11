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

	import flash.utils.Dictionary;
	
	import org.pranaframework.ioc.IObjectDefinition;
	import org.pranaframework.ioc.factory.config.IConfigurableListableObjectFactory;
	import org.pranaframework.utils.Assert;
	import org.pranaframework.utils.ClassUtils;
	import org.pranaframework.utils.ObjectUtils;

	/**
	 * Default implementation of the IConfigurableListableObjectFactory and
	 * the IObjectDefinitionRegistry interfaces.
	 *
	 * @author Christophe Herreman
	 * @author Erik Westra
	 */
	public class DefaultListableObjectFactory extends AbstractObjectFactory
		implements IConfigurableListableObjectFactory, IObjectDefinitionRegistry {

		private var _allowBeanDefinitionOverriding:Boolean = true;

		/**
		 * Contructs <code>DefaultListableObjectFactory</code>
		 */
		public function DefaultListableObjectFactory() {
			super();
		}

		// ====================================================================
		// IListableObjectFactory implementation
		// ====================================================================

		/**
		 * @inheritDoc
		 */
		public function get numObjectDefinitions():int {
			return ObjectUtils.getNumProperties(objectDefinitions);
		}

		/**
		 * @inheritDoc
		 */
		public function get objectDefinitionNames():Array {
			var result:Array = [];
			
			for (var key:String in objectDefinitions) {
				result.push(key);
			}
			
			return result;
		}

		/**
		 * @inheritDoc
		 */ 
		public function getObjectNamesForType(type:Class):Array {
			var result:Array = [];
			var objectDefinition:IObjectDefinition;
			
			for (var key:String in objectDefinitions) {
				objectDefinition = objectDefinitions[key];
				
				if (ClassUtils.isImplementationOf(ClassUtils.forName(objectDefinition.className), type)) {
					result.push(key);
				}
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function getObjectsOfType(type:Class):Dictionary {
			var result:Dictionary = new Dictionary();
			var objectDefinition:IObjectDefinition;
			
			for (var key:String in objectDefinitions) {
				objectDefinition = objectDefinitions[key];				
				
				if (ClassUtils.isImplementationOf(ClassUtils.forName(objectDefinition.className), type)) {
					result[key] = objectDefinitions[key];
				}
			}
			return result;
		}

		// ====================================================================
		// IConfigurableListableObjectFactory implementation
		// ====================================================================

		/**
		 * @inheritDoc
		 */
		public function preInstantiateSingletons():void {
			for (var objectName:String in objectDefinitions) {
				var objectDefinition:IObjectDefinition = objectDefinitions[objectName];
				
				if (objectDefinition.isSingleton && !objectDefinition.isLazyInit) {
					getObject(objectName);
				}
			}
		}

		// ====================================================================
		// IObjectDefinitionRegistry implementation
		// ====================================================================
		/**
		 * @inheritDoc
		 */
		public function registerObjectDefinition(objectName:String, objectDefinition:IObjectDefinition):void {
			Assert.hasText(objectName, "objectName must have text");
			Assert.notNull(objectDefinition, "objectDefinition must not be null");

			if (_allowBeanDefinitionOverriding) {
				// TODO: this does not seem correct. The property is called allowObjectDefinitionOverriding
				// and we remove the object itself
				clearObjectFromInternalCache(objectName) 
			}

			objectDefinitions[objectName] = objectDefinition;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeObjectDefinition(objectName:String):void {
			delete objectDefinitions[objectName];
		}
		
		/**
		 * @inheritDoc
		 */
		public function containsObjectDefinition(objectName:String):Boolean {
			return Boolean(objectDefinitions[objectName] as IObjectDefinition);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getObjectDefinition(objectName:String):IObjectDefinition {
			return objectDefinitions[objectName];
		}
		
		/**
		 * @inheritDoc
		 */
		public function get allowObjectDefinitionOverriding():Boolean {
			return _allowBeanDefinitionOverriding;
		}
		
		public function set allowObjectDefinitionOverriding(value:Boolean):void {
			_allowBeanDefinitionOverriding = value;
		}
		
	}
}