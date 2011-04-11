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
package org.pranaframework.ioc.factory.xml.parser.support {
	
	import org.pranaframework.ioc.factory.xml.IXMLObjectFactory;
	import org.pranaframework.ioc.factory.xml.parser.support.nodeparsers.ArrayCollectionNodeParser;
	
	/**
	 * An extension to the XMLObjectDefinitionsParser to support flex framework
	 * specific classes like ArrayCollection.
	 * 
	 * @author Christophe Herreman
	 * @author Erik Westra
	 */
	public class FlexXMLObjectDefinitionsParser extends XMLObjectDefinitionsParser {
		
		/**
		 * Constructs a new <code>FlexXMLObjectDefinitionsParser</code>.
		 * An optional objectFactory can be passed to store the definitions. If no
		 * container is passed then a new instance will be created of type XMLObjectFactory.
		 * <p />
		 * Will add the following node parsers:
		 * <ul>
		 * 	<li>ArrayCollectionNodeParser</li>
		 * </ul>
		 *
		 * @param objectFactory 	the objectFactory where the object definitions will be stored
		 * 
		 * @see org.pranaframework.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser
		 * @see org.pranaframework.ioc.factory.xml.parser.support.nodeparsers.ArrayCollectionNodeParser
		 */
		public function FlexXMLObjectDefinitionsParser(objectFactory:IXMLObjectFactory = null) {
			super(objectFactory);
			
			_initialize();
		}
		
		private function _initialize():void {
			addNodeParser(new ArrayCollectionNodeParser(this));
		}
		
	}
}