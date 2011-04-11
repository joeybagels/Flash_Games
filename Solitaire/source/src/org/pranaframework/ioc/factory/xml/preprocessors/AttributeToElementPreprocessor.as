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
 package org.pranaframework.ioc.factory.xml.preprocessors {

	import org.pranaframework.ioc.factory.xml.parser.IXMLObjectDefinitionsPreprocessor;
	import org.pranaframework.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	import org.pranaframework.ioc.factory.xml.prana_objects;
	import org.pranaframework.utils.XMLUtils;

	use namespace prana_objects;

	/**
	 * Converts an attribute to an element.
	 * 
	 * @author Christophe Herreman
	 */
	public class AttributeToElementPreprocessor implements IXMLObjectDefinitionsPreprocessor {

		/**
		 *
		 */
		public function AttributeToElementPreprocessor() {
		}

		/**
		 * @inheritDoc
		 */
		public function preprocess(xml:XML):XML {
			var objectNodes:XMLList = xml.descendants();
			for each (var node:XML in objectNodes) {
				node = preprocessNode(node);
			}
			return xml;
		}
		
		/**
		 * 
		 */
		private function preprocessNode(node:XML):XML {
			var attributes:Array = [XMLObjectDefinitionsParser.VALUE_ATTRIBUTE, XMLObjectDefinitionsParser.REF_ATTRIBUTE];
			
			for each (var attribute:XML in node.attributes()) {
				var name:String = attribute.localName();
				
				if (attributes.indexOf(name) != -1) {
					node = XMLUtils.convertAttributeToNode(node, name);
					
					// if we converted a "value" attribute, we move the "type" attribute
					// to the new element
					if (name == XMLObjectDefinitionsParser.VALUE_ATTRIBUTE) {
						if (node.@type != undefined) {
							node.value.@type = node.@type.toString();
							delete node.@type;
						}
					}
				}
				
			}
			return node;
		}

	}
}