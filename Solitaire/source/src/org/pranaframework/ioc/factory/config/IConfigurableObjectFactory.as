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
package org.pranaframework.ioc.factory.config {

	import org.pranaframework.ioc.factory.IObjectFactory;
	import org.pranaframework.objects.IPropertyEditor;
	import org.pranaframework.objects.ITypeConverter;
	
	/**
	 * Defines the methods for configuring object factories.
	 * 
	 * @author Christophe Herreman
	 * @author Erik Westra
	 */
	public interface IConfigurableObjectFactory extends IObjectFactory {
		
		/**
		 * Adds an object postprocessor to this object factory.
		 *
		 * @param objectPostProcessor 	the object postprocessor to add
		 */
		function addObjectPostProcessor(objectPostProcessor:IObjectPostProcessor):void;
		
		/**
		 * Returns the number of object post processors.
		 */
		function get numObjectPostProcessors():int;
		
		/**
		 * Determines if an object is a IFactoryObject implementation.
		 * 
		 * @param objectName	The name of the object that should be tested
		 * 
		 * @return true if the corresponding object is an IFactoryObject implementation 
		 */
		function isFactoryObject(objectName:String):Boolean;
		
		/**
		 * Registers a custom property editor. This method will only have effect if the 
		 * typeConverter is an implementation of IPropertyEditorRegistry.
		 * 
		 * @param requiredType		the type of the property
		 * @param propertyEditor 	the property editor to register
		 * 
		 * @see #typeConverter
		 * @see org.pranaframework.objects.IPropertyEditorRegistry
		 */
		function registerCustomEditor(requiredType:Class, propertyEditor:IPropertyEditor):void;
		
		/**
		 * The current type converter implementation
		 * 
		 * @default an instance of SimpleTypeConverter
		 * 
		 * @see org.pranaframework.objects.SimpleTypeConverter
		 */
		function get typeConverter():ITypeConverter;
		
		function set typeConverter(value:ITypeConverter):void;
		
	}
}