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
 package org.pranaframework.ioc.serializer {
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	
	import org.pranaframework.reflection.AbstractMember;
	import org.pranaframework.reflection.Accessor;
	import org.pranaframework.reflection.AccessorAccess;
	import org.pranaframework.reflection.Type;
	
	/**
	 * 
	 */
	public class XmlObjectDefinitionsSerializer implements IObjectDefinitionsSerializer {
		
		private var _xml:XML;
		private var _unnamedItemsCounter:int = 0;
		private var _objectCache:Dictionary;
		
		public function XmlObjectDefinitionsSerializer() {
			_objectCache = new Dictionary();
		}
		
		public function serialize(name:String, object:*):XML {
			_xml = <beans/>;
			serializeObject(name, object);
			return _xml;
		}
		
		private function serializeObject(name:String, object:*):void {
			trace("serializeObject(" + name + ")");
			if (_xml..bean.(attribute("id")) == name) {
				trace("* object '" + name + "' already serialized");
				return;
			}
			
			var result:XML = <bean/>;
			_xml.appendChild(result);
			
			// cache
			_objectCache[object] = result;
			
			var type:Type = Type.forInstance(object);
			result.@id = name;
			result.@["class"] = type.fullName.replace("::", ".");
			var accessors:Array = type.accessors;
			var variables:Array = type.variables;
			var props:Array = accessors.concat(variables);
			
			for (var i:uint = 0; i<props.length; i++) {
				var prop:AbstractMember = props[i];
				var isTransient:Boolean = (prop is Accessor) && Accessor(prop).isTransient();
				//var isReadOnly:Boolean = (prop is Accessor) && (Accessor(prop).access == AccessorAccess.READ_ONLY);
				if (!prop.isStatic && !isTransient/* && !isReadOnly*/) {
					var propertyNode:XML = serializeProperty(object, prop.name);
					if (propertyNode != null) {
						result.appendChild(propertyNode);
					}
				}
			}
		}
		
		private function serializeProperty(object:*, name:String):XML {
			var result:XML;
			var value:* = object[name];
			
			if (value != null) {
				result = <property/>;
				result.@name = name;
				//result.appendChild(serializePropertyValue(value, name));
				result.appendChild(serializePropertyValue(value));	
			}
			
			return result;
		}
		
		private function serializePropertyValue(value:*, name:String = ""):XML {
			var result:XML;
			var valueType:String = typeof(value);
			
			switch (valueType) {
				case "string":
				case "boolean":
				case "number":
					result = <value>{value}</value>;
					break;
				case "object":
					result = serializeComplexProperty(name, value);
					break;	
			}
			
			return result;
		}
		
		private function serializeComplexProperty(name:String, value:*):XML {
			var result:XML;
			if (value is Array) {
				result = serializeArray(value);
			}
			else if (value is Dictionary) {
				result = serializeDictionary(value);
			}
			else if (value is ArrayCollection) {
				result = serializeArrayCollection(value);
			}
			else if (value is Object) {
				var type:Type = Type.forInstance(value);
				var isAnonymousObject:Boolean = ("Object" == type.name);
				if (isAnonymousObject)
					result = serializeAnonymousObject(value);
				else
					result = serializeCustomObject(name, value);
			}
			
			return result;
		}
		
		private function serializeArray(value:Array):XML {
			var result:XML = <list/>;
			for (var i:uint = 0; i<value.length; i++) {
				result.appendChild(serializePropertyValue(value[i]));
			}
			return result;
		}
		
		private function serializeDictionary(value:Dictionary):XML {
			var result:XML = <map/>;
			for (var p:Object in value) {
				var entryNode:XML = <entry key={p}/>;
				entryNode.appendChild(serializePropertyValue(value[p]));
				result.appendChild(entryNode);
			}
			return result;
		}
		
		private function serializeArrayCollection(value:ArrayCollection):XML {
			var result:XML = <list/>;
			for (var c:IViewCursor = value.createCursor(); !c.afterLast; c.moveNext()) {
				result.appendChild(serializePropertyValue(c.current));
			}
			return result;
		}
		
		private function serializeAnonymousObject(value:Object):XML {
			var result:XML = <object/>;
			for (var p:String in value) {
				result.appendChild(serializeProperty(value, p));
			}
			return result;
		}
		
		private function serializeCustomObject(name:String, value:Object):XML {
			var result:XML = <ref bean=""/>;
			
			if (_objectCache[value]) {
				result.@bean = _objectCache[value].@id;
			}
			else {
				// create a fake name if the object has no name specified
				if ("" == name)
					name = "__item" + _unnamedItemsCounter++;
				
				result.@bean = name;
				serializeObject(name, value);
			}
			return result;
		}
		
	}
}