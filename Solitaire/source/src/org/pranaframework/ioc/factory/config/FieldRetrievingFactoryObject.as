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
	
	import org.pranaframework.errors.IllegalArgumentError;
	import org.pranaframework.ioc.factory.IInitializingObject;
	import org.pranaframework.reflection.Field;
	import org.pranaframework.reflection.Type;
	import org.pranaframework.utils.ClassUtils;
	import org.pranaframework.utils.StringUtils;
	
	/**
	 * 
	 */
	public class FieldRetrievingFactoryObject extends AbstractFactoryObject implements IInitializingObject {
		
		private var _field:Field;
		
		/**
		 * 
		 */
		public function FieldRetrievingFactoryObject() {
			// nothing
		}
		
		// targetClass property
		private var _targetClass:Class;
		public function get targetClass():Class {
			return _targetClass;
		}
		public function set targetClass(value:Class):void {
			_targetClass = value;
		}
		
		// targetObject property
		private var _targetObject:*;
		public function get targetObject():* {
			return _targetObject;
		}
		public function set targetObject(value:*):void {
			_targetObject = value;
		}
		
		// targetField property
		private var _targetField:String = "";
		public function get targetField():String {
			return _targetField;
		}
		public function set targetField(value:String):void {
			_targetField = StringUtils.trim(value);
		}
		
		// staticField property
		private var _staticField:String = "";
		public function get staticField():String {
			return _staticField;
		}
		public function set staticField(value:String):void {
			_staticField = StringUtils.trim(value);
		}
		
		//=====================================================================
		// IFactoryObject - AbstractFactoryObject
		//=====================================================================
		override public function getObject():* {
			return _field.getValue(targetObject);
		}
		
		override public function getObjectType():Class {
			return ((_field) ? _field.declaringType.clazz : null);
		}
		
		//=====================================================================
		// IInitializingObject
		//=====================================================================
		public function afterPropertiesSet():void {
			if (targetClass != null && targetObject != null) {
				throw new IllegalArgumentError("Specify either targetClass or targetObject, not both");
			}
			
			if (targetClass == null && targetObject == null) {
				if (targetField != "") {
					throw new IllegalArgumentError("Specify targetClass or targetObject in combination with targetField");
				}
	
				// Try to parse static field into class and field.
				var lastDotIndex:int = staticField.lastIndexOf(".");
				if (-1 == lastDotIndex)
					throw new IllegalArgumentError("The staticField argument must be the full path to a static property e.g. 'mx.logging.LogEventLevel.DEBUG'");
				var className:String = staticField.substring(0, lastDotIndex)
				var fieldName:String = staticField.substring(lastDotIndex + 1);
				targetClass = ClassUtils.forName(className);
				targetField = fieldName;
			}
			else if (targetField == "") {
				// Either targetClass or targetObject specified.
				throw new IllegalArgumentError("targetField is required");
			}
	
			// Try to get the exact method first.
			targetClass = (targetObject != null) ? ClassUtils.forInstance(targetObject) : targetClass;
			var type:Type = Type.forClass(targetClass);
			_field = type.getField(targetField);
		}
		
	}
}