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
package org.pranaframework.domain {
	
	import flash.utils.describeType;
	
	import mx.collections.IList;
	
	import org.pranaframework.reflection.Accessor;
	import org.pranaframework.reflection.AccessorAccess;
	import org.pranaframework.reflection.Type;
	import org.pranaframework.utils.ClassUtils;
	import org.pranaframework.utils.ObjectUtils;
	
	/**
	 * Default implementation of the IEntity interface.
	 * 
	 * @author Christophe Herreman
	 */
	[Bindable]
	public class Entity extends ValueObject implements IEntity {
		
		private static const PROPERTY_ID:String = "id";
		
		private var _id:* = -1;
		
		/**
		 * Creates a new Entity.
		 */
		public function Entity(id:* = -1) {
			this.id = id;
		}

		public function get id():* {
			return _id;
		}
		
		public function set id(value:*):void {
			_id = value;
		}
		
		/**
		 * 
		 */
		public function equalsWithoutIdentity(other:IEntity):Boolean {
			return doEquals(other, [PROPERTY_PROTOTOYPE, PROPERTY_ID]);
		}
		
	}
}