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
package org.pranaframework.ioc.factory.support.referenceresolvers {
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	
	import org.pranaframework.ioc.factory.IObjectFactory;
	import org.pranaframework.ioc.factory.support.AbstractReferenceResolver;
	
	/**
	 * Resolves the references in an array-collection.
	 * 
	 * @author Christophe Herreman
	 * @author Erik Westra
	 */
	public class ArrayCollectionReferenceResolver extends AbstractReferenceResolver {
		
		/**
		 * Constructs <code>ArrayCollectionReferenceResolver</code>.
		 * 
		 * @param factory		The factory that uses this reference resolver
		 */
		public function ArrayCollectionReferenceResolver(factory:IObjectFactory) {
			super(factory);
		}
		
		/**
		 * Checks if the object is an ArrayCollection
		 * <p />
		 * @inheritDoc
		 */
		override public function canResolve(property:Object):Boolean {
			return (property is ArrayCollection);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function resolve(property:Object):Object {
			for (var c:IViewCursor = ArrayCollection(property).createCursor(); !c.afterLast; c.moveNext()) {
				c.insert(factory.resolveReference(c.current));
				c.remove();
				c.movePrevious();
			}
			
			return property;
		}
	
	}
}