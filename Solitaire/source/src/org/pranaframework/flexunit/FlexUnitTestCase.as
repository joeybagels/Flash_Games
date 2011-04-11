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
package org.pranaframework.flexunit {
	
	import flash.utils.Dictionary;
	
	import flexunit.framework.AssertionFailedError;
	import flexunit.framework.TestCase;
	
	import org.pranaframework.errors.IllegalArgumentError;
	import org.pranaframework.utils.Assert;
	
	/**
	 * Extends the FlexUnit TestCase with extra assertions.
	 * 
	 * @author Christophe Herreman
	 */
	public class FlexUnitTestCase extends TestCase {
		
		/**
		 * Creates a new FlexUnitTestCase.
		 */
		public function FlexUnitTestCase(methodName:String=null) {
			super(methodName);
		}
		
		// --------------------------------------------------------------------
		// assertLength
		// --------------------------------------------------------------------
		public function assertLength(... rest):void {
			if (rest.length == 3)
				assertEquals(rest[0], rest[1], rest[2].length);
			else
				assertEquals("", rest[0], rest[1].length);
		}
		
		// --------------------------------------------------------------------
		// assertArrayContains
		// --------------------------------------------------------------------
		public function assertArrayContains(... rest):void {
			if (rest.length == 3)
				failArrayContains(rest[0], rest[1], rest[2]);
			else
				failArrayContains("", rest[0], rest[1]);
		}
		
		private static function failArrayContains(message:String, item:*, array:Array):void {
			try {
				Assert.arrayContains(array, item);
			}
			catch (e:IllegalArgumentError) {
				failWithUserMessage(message, "the array does not contain the item <" + item + ">");
			}
		}
		
		// --------------------------------------------------------------------
		// assertDictionaryKeysOfType
		// --------------------------------------------------------------------
		public function assertDictionaryKeysOfType(... rest):void {
			if (rest.length == 3)
				failDictionaryKeysOfType(rest[0], rest[1], rest[2]);
			else
				failDictionaryKeysOfType("", rest[0], rest[1]);
		}
		
		private static function failDictionaryKeysOfType(message:String, dictionary:Dictionary, type:Class):void {
			try {
				Assert.dictionaryKeysOfType(dictionary, type);
			}
			catch (e:IllegalArgumentError) {
				failWithUserMessage(message, "not all keys of dictionary are of type <" + type + ">");
			}
		}
		
		// copied from flexunit.framework.TestCase because private
		private static function failWithUserMessage(userMessage:String, failMessage:String):void {
			if (userMessage.length > 0)
				userMessage = userMessage + " - ";
			throw new AssertionFailedError(userMessage + failMessage);
        }

	}
}