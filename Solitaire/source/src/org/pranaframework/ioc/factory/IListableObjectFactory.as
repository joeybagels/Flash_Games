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
package org.pranaframework.ioc.factory {

	import flash.utils.Dictionary;

	/**
	 * Provides an object factory with list type methods of accessing defintions.
	 *
	 * @author Christophe Herreman
	 * @author Erik Westra
	 */
	public interface IListableObjectFactory extends IObjectFactory {
		/**
		 * Returns the number of definitions present in the object definition registry
		 */
		function get numObjectDefinitions():int;

		/**
		 * Returns an array containing all object definition names.
		 */
		function get objectDefinitionNames():Array;

		/**
		 * Returns all object definitions names that implement the given type. To check the type, the 
		 * <code>ClassUtils.isImplementationOf</code> method is used.
		 * 
		 * @param type		The type that is searched for
		 * 
		 * @return an array containing definition names that implement the given type
		 * 
		 * @see org.pranaframework.utils.ClassUtils.#isImplementationOf()
		 */
		function getObjectNamesForType(type:Class):Array;

		/**
		 * Returns all object definitions that implement the given type. To check the type, the 
		 * <code>ClassUtils.isImplementationOf</code> method is used.
		 * 
		 * @param type		The type that is searched for
		 * 
		 * @return A dictionary containing definitions that implement the given type. Definition 
		 * 		   names are used as key.
		 * 
		 * @see org.pranaframework.utils.ClassUtils.#isImplementationOf()
		 */
		function getObjectsOfType(type:Class):Dictionary;
	}
}