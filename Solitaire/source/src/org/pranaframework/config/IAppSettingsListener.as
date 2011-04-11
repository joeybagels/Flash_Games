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
package org.pranaframework.config {
	
	/**
	 * By implementing this interface, a type can be added as a listener to the
	 * AppSettings class and receive notifications when the keys or values are
	 * modified.
	 * 
	 * @author Christophe Herreman
	 */
	public interface IAppSettingsListener {
		
		/**
		 * Invoked when a new setting is added.
		 */
		function AppSettings_Add(event:AppSettingsEvent):void;
		
		/**
		 * Invoked when the value of a setting is changed.
		 */
		function AppSettings_Change(event:AppSettingsEvent):void;
		
		/**
		 * Invoked when all settings are removed.
		 */
		function AppSettings_Clear(event:AppSettingsEvent):void;
		
		/**
		 * Invoked when a setting is deleted.
		 */
		function AppSettings_Delete(event:AppSettingsEvent):void;
		
		/**
		 * Invoked when the settings are loaded from an external source.
		 */
		function AppSettings_Load(event:AppSettingsEvent):void;
	}
}