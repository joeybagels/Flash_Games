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

	import org.pranaframework.ioc.ObjectDefinitionScope;
	import org.pranaframework.ioc.factory.xml.parser.IXMLObjectDefinitionsPreprocessor;
	import org.pranaframework.ioc.util.Constants;

	import org.pranaframework.ioc.factory.xml.prana_objects;

	use namespace prana_objects;

	/**
	 * The ScopeAttributePrepocessor makes sure that all object definitions
	 * have a valid scope attribute.
	 *
	 * If no scope attribute is found, a default scope="singleton" will be added.
	 * If a singleton attribute is found, it will be converted to the
	 * corresponding scope attribute.
	 *
	 * @author Christophe Herreman
	 * @see org.pranaframework.ioc.ObjectDefinitionScope
	 */
	public class ScopeAttributePrepocessor implements IXMLObjectDefinitionsPreprocessor {

		/**
		 * Creates a new <code>ScopeAttributePreprocessor</code>.
		 */
		public function ScopeAttributePrepocessor() {
			// nothing
		}

		/**
		 * @inheritDoc
		 */
		public function preprocess(xml:XML):XML {
			// nodes without scope attribute
			var nodes:XMLList = xml..object.(attribute(Constants.SCOPE_ATTRIBUTE) == undefined);

			for each (var node:XML in nodes) {
				// no singleton attribute
				if (node.@[Constants.SINGLETON_ATTRIBUTE] == undefined) {
					node.@[Constants.SCOPE_ATTRIBUTE] = ObjectDefinitionScope.SINGLETON_NAME;
				}
				else {
					// singleton attribute found
					// if true, change to scope="singleton"
					// else scope="prototype"
					if (node.@[Constants.SINGLETON_ATTRIBUTE] == false) {
						node.@[Constants.SCOPE_ATTRIBUTE] = ObjectDefinitionScope.PROTOTYPE_NAME;
					}
					else {
						node.@[Constants.SCOPE_ATTRIBUTE] = ObjectDefinitionScope.SINGLETON_NAME;
					}
				}
			}
			return xml;
		}

	}
}