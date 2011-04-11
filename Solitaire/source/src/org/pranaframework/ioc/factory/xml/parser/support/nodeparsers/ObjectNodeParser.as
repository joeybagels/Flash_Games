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
	import org.pranaframework.ioc.factory.config.RuntimeObjectReference;
	import org.pranaframework.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	import org.pranaframework.utils.XMLUtils;
	
	/**
	 * Parses an object node.
	 * 
	 * @author Christophe Herreman
	 * @author Erik Westra
	 */
	public class ObjectNodeParser extends AbstractNodeParser {
		
		/**
		 * Constructs the ObjectNodeParser.
		 * 
		 * @param xmlObjectDefinitionsParser	The definitions parser using this NodeParser
		 * 
		 * @see org.pranaframework.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser.#OBJECT_ELEMENT
		 */		
		public function ObjectNodeParser(xmlObjectDefinitionsParser:XMLObjectDefinitionsParser) {
			super(xmlObjectDefinitionsParser, XMLObjectDefinitionsParser.OBJECT_ELEMENT);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function parse(node:XML):Object {
			var result:Object;
			var isInnerObjectDefinition:Boolean = (node.attribute(XMLObjectDefinitionsParser.CLASS_ATTRIBUTE) != undefined);
			
			if (isInnerObjectDefinition) {
				var id:String = xmlObjectDefinitionsParser.parseAndRegisterObjectDefinition(node);
				result = new RuntimeObjectReference(id);
			}
			else {
				result = new Object();
				for each (var n:XML in node.children()) {
					n = XMLUtils.convertAttributeToNode(n, XMLObjectDefinitionsParser.VALUE_ATTRIBUTE);
					result[n.@name.toString()] = xmlObjectDefinitionsParser.parseProperty(n);
				}
			}
			
			return result;
		}
	}
}