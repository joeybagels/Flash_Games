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
 package org.pranaframework.ioc.factory.xml.parser.support.nodeparsers {
	
	import org.pranaframework.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	import org.pranaframework.objects.ITypeConverter;
	import org.pranaframework.utils.ClassUtils;
	import org.pranaframework.utils.XMLUtils;
	
	/**
	 * Parses a key and value node.
	 * 
	 * @author Christophe Herreman
	 * @author Erik Westra
	 */
	public class KeyValueNodeParser extends AbstractNodeParser {
		/**
		 * Constructs the KeyValueNodeParser.
		 * 
		 * @param xmlObjectDefinitionsParser	The definitions parser using this NodeParser
		 * 
		 * @see org.pranaframework.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser.#KEY_ELEMENT
		 * @see org.pranaframework.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser.#VALUE_ELEMENT
		 */		
		public function KeyValueNodeParser(xmlObjectDefinitionsParser:XMLObjectDefinitionsParser) {
			super(xmlObjectDefinitionsParser, XMLObjectDefinitionsParser.KEY_ELEMENT);
			addNodeNameAlias(XMLObjectDefinitionsParser.VALUE_ELEMENT);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function parse(node:XML):Object {
			var result:*;
			var child:XML = node.children()[0];
			
			if (XMLUtils.isElementNode(child)) {
				result = xmlObjectDefinitionsParser.parsePropertyValue(child);
			}
			else {
				var typeConverter:ITypeConverter = xmlObjectDefinitionsParser.objectFactory.typeConverter;
				var clazz:Class = _retrieveType(node);
				var value:String = child.toString();
				
				result = typeConverter.convertIfNecessary(value, clazz);
			}
			
			return result;
		}
		
		/**
		 * Will try to retrieve the type of a node. If no type was found, it will return null.
		 */
		private function _retrieveType(node:XML):Class {
			var result:Class;
			
			try {
				result = ClassUtils.forName(node.@type);
			} catch (e:Error) {
			}
			
			return result;
		}
		
	}
}