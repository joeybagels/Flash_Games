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
package org.pranaframework.ioc.factory.config {
	import flash.utils.getQualifiedClassName;
	
	import org.pranaframework.errors.IllegalArgumentError;
	import org.pranaframework.ioc.IObjectDefinition;
	import org.pranaframework.ioc.factory.IObjectFactory;
	import org.pranaframework.ioc.factory.IObjectFactoryAware;
	import org.pranaframework.ioc.factory.support.IObjectDefinitionRegistry;
	import org.pranaframework.utils.Assert;
	import org.pranaframework.utils.MetadataUtils;
	
	/**
	 * ObjectPostProcessor implementation that enforces required properties to have been configured. A 
	 * property is marked as required by adding [Required] metadata to the property definition:
	 * <listing version="3.0"> 
	 * [Required]
	 * public var myProperty:Type;
	 * </listing>
	 * <p />
	 * In order to add this post processor to you configuration add the following line to the xml: 
	 * <p />
	 * <code>
	 * &lt;object class="org.pranaframework.ioc.factory.config.RequiredMetadataObjectPostProcessor" /&gt;
	 * </code>
	 */
	public class RequiredMetadataObjectPostProcessor implements IObjectPostProcessor, IObjectFactoryAware {
		private var _requiredPropertiesCache:Object;
		private var _objectFactory:IObjectFactory;
		
		/**
		 * Constructs <code>RequiredMetadataObjectPostProcessor</code>
		 */
		public function RequiredMetadataObjectPostProcessor() {
			_requiredPropertiesCache = new Object();
		}

		/**
		 * Will check the metadata of the given object to see if any property contains [Required] metadata.
		 * If it has this type of metadata and is not available in the object definition an error 
		 * will be thrown.
		 * 
		 * @param object		The object that has been instantiated
		 * @param objectName	The name of the object
		 * 
		 * @throws org.pranaframework.errors.IllegalArgumentError		If the property was required but not defined.
		 */
		public function postProcessBeforeInitialization(object:*, objectName:String):* {
			var properties:XMLList;
			var className:String = getQualifiedClassName(object); 
			
			if (_requiredPropertiesCache.hasOwnProperty(className)) {
				properties = _requiredPropertiesCache[className];
			}
			else {
				var description:XML = MetadataUtils.getFromObject(object);
				
				//Get a list of all variable declarations that contain metadata
				properties = description.factory.variable.(hasOwnProperty("metadata") && metadata.@name == "Required");
				//Add a list of all accessors (getters and setters)
				properties += description.factory.accessor.(hasOwnProperty("metadata") && metadata.@name == "Required");
				
				//properties are cached with className and not objectName, as objectName is unique 
				_requiredPropertiesCache[className] = properties;
			}
			
			var property:XML;
			var propertyDefinition:Object;
			
			if (_objectFactory is IObjectDefinitionRegistry) {
				var objectDefinition:IObjectDefinition = IObjectDefinitionRegistry(_objectFactory).getObjectDefinition(objectName);
			
				for each (property in properties) {
					propertyDefinition = objectDefinition.properties[property.@name.toString()];
					Assert.notNull(propertyDefinition, "Could not find property description of '" + property.@name + "' in description of '" + objectName + "', the class '" + getQualifiedClassName(object) + "' has it marked as required."); 
				}
			}
			
		}
		
		/**
		 * This method has not been implemented
		 */
		public function postProcessAfterInitialization(object:*, objectName:String):* {
		}
		
		/**
		 * @inheritDoc
		 */
		public function set objectFactory(objectFactory:IObjectFactory):void {
			_objectFactory = objectFactory;
		}
	}
}