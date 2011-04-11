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
	import org.pranaframework.ioc.factory.xml.prana_objects;

	use namespace prana_objects;

	/**
	 * The <code>TemplatePreprocessor</code> is used to apply all templates
	 * to the xml context. The parser nor the container should be aware of
	 * templates.
	 *
	 * @author Christophe Herreman
	 */
	public class TemplatePreprocessor implements IXMLObjectDefinitionsPreprocessor {

		private static const TEMPLATE_BEGIN:String = "${";
		private static const TEMPLATE_END:String = "}";

		/**
		 * Creates a new <code>TemplatePreprocessor</code>
		 */
		public function TemplatePreprocessor() {
		}

		/**
		 * @inheritDoc
		 */
		public function preprocess(xml:XML):XML {
			// the nodes that use a template
			var nodes:XMLList = xml..*.(attribute("template") != undefined);

			// loop through each node that uses a template and apply the template
			for each (var node:XML in nodes) {
				var template:XML = xml.template.(attribute("id") == node.@template)[0];
				var templateText:String = template.children()[0].toXMLString();

				// replace all parameters
				for each (var param:XML in node.param) {
					var key:String = TEMPLATE_BEGIN + param.@name + TEMPLATE_END;
					// replace the key with the value of the parameter
					templateText = templateText.replace(key, param.value.toString());
					// remove the param node from the main node
					delete node.param[0];
				}
				
				// fill the object with the result of the template
				// if the node is an object node, we fill it
				// if the node is a property node, we append it
				var newNodeXML:XML = new XML(templateText);
				var nodeName:QName = node.name();
				
				if (nodeName.localName == "object") {
					node.@["class"] = newNodeXML.attribute("class").toString();
					for each (var n:XML in newNodeXML.children()) {
						node.appendChild(n);
					}
				}
				else {
					node.text()[0] = newNodeXML;
				}
				
				// remove the template attribute
				delete node.@template;
			}

			return xml;
		}

	}
}