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
	 * Preprocesses a "method-invocation" tag to a MethodInvokingObject.
	 * 
	 * @author Christophe Herreman
	 * @author Bert Vandamme
	 */
	public class MethodInvocationPreprocessor implements IXMLObjectDefinitionsPreprocessor {
		
		/**
		 * Creates a new MethodInvocationPreprocessor.
		 */
		public function MethodInvocationPreprocessor() {
			
		}
		
		/**
		 * 
		 */
		public function preprocess(xml:XML):XML {
			var nodes:XMLList = xml.descendants("method-invocation");
			
			for each (var node:XML in nodes) {
				var parentID:String = node.parent().@id;
				var methodName:String = node.@name;
				var methodInvokingObjectXML:XML =	<object class="org.pranaframework.ioc.MethodInvokingObject">
														<property name="target" ref={parentID} />
														<property name="method" value={methodName} />
														<property name="arguments">
															<array/>
														</property>
													</object>;
				
				// add arguments
				var argumentsNode:XML = methodInvokingObjectXML.children()[2];
				for each (var argXML:XML in node.arg) {
					argumentsNode.children()[0].appendChild(argXML.children()[0]);
				}
				
				xml.appendChild(methodInvokingObjectXML);				
			}
			
			return xml;
		}
		
	}
}