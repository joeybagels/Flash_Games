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
 package org.pranaframework.ioc.factory.config {
	
	import mx.logging.ILoggingTarget;
	import mx.logging.targets.LineFormattedTarget;
	
	import org.pranaframework.ioc.factory.IInitializingObject;
	import org.pranaframework.utils.Assert;
	
	/**
	 * Creates a new <code>LoggingTargetFactoryObject</code>.
	 * 
	 * <p>The logging target this factory creates will automatically be added to
	 * the Log manager class.</p>
	 * 
	 * @example
	 * 
	 * <pre>
	 * &lt;object id="traceTarget" class="org.pranaframework.ioc.factory.config.LoggingTargetFactoryObject"&gt;
	 *  &lt;property name="loggingTargetClass" value="mx.logging.targets.TraceTarget"/&gt;
	 *  &lt;property name="includeCategory" value="true"/&gt;
	 * 	&lt;property name="includeDate" value="true"/&gt;
	 *  &lt;property name="includeLevel" value="true"/&gt;
	 *  &lt;property name="includeTime" value="true"/&gt;
	 * 	&lt;property name="level" value="2"/&gt;
	 * 	&lt;property name="filters"&gt;
	 *   &lt;array&gt;
	 *    &lt;value&gt;com.domain.model.&#42;&lt;/value&gt;
	 *    &lt;value&gt;com.domain.view.&#42;&lt;/value&gt;
	 *   &lt;/array&gt;
	 *  &lt;/property&gt;
	 * &lt;/object&gt;
	 * </pre>
	 * 
	 * @author Christophe Herreman
	 */
	public class LoggingTargetFactoryObject extends AbstractFactoryObject implements IInitializingObject {
		
		private var _loggingTarget:ILoggingTarget;
		private var _loggingTargetClass:Class;
		private var _includeCategory:Boolean = true;
		private var _includeDate:Boolean = true;
		private var _includeLevel:Boolean = true;
		private var _includeTime:Boolean = true;
		private var _level:uint = 0;
		private var _filters:Array = [];
		
		/**
		 * 
		 */
		public function LoggingTargetFactoryObject() {
			super();
		}

		public override function getObject():* {
			return _loggingTarget;
		}
		
		public override function getObjectType():Class {
			return loggingTargetClass;
		}
		
		/**
		 * Create the logging target after all properties have been set.
		 */
		public function afterPropertiesSet():void {
			_loggingTarget = new loggingTargetClass();
			if (_loggingTarget is LineFormattedTarget) {
				var lft:LineFormattedTarget = _loggingTarget as LineFormattedTarget;
				lft.includeCategory = includeCategory;
				lft.includeDate = includeDate;
				lft.includeLevel = includeLevel;
				lft.includeTime = includeTime;
			}
			_loggingTarget.filters = filters;
			// setting the level will add the logging target to the Log manager
			_loggingTarget.level = level;
		}
		
		public function get loggingTargetClass():Class {
			return _loggingTargetClass;
		}
		
		public function set loggingTargetClass(value:Class):void {
			Assert.notNull(value, "The loggingTargetClass must not be null");
			_loggingTargetClass = value;
		}
		
		public function get includeCategory():Boolean {
			return _includeCategory;
		}
		
		public function set includeCategory(value:Boolean):void {
			_includeCategory = value;
		}
		
		public function get includeDate():Boolean {
			return _includeDate;
		}
		
		public function set includeDate(value:Boolean):void {
			_includeDate = value;
		}
		
		public function get includeLevel():Boolean {
			return _includeLevel;
		}
		
		public function set includeLevel(value:Boolean):void {
			_includeLevel = value;
		}
		
		public function get includeTime():Boolean {
			return _includeTime;
		}
		
		public function set includeTime(value:Boolean):void {
			_includeTime = value;
		}
		
		public function get level():uint {
			return _level;
		}
		
		public function set level(value:uint):void {
			_level = value;
		}
		
		public function get filters():Array {
			return _filters;
		}
		
		public function set filters(value:Array):void {
			_filters = value;
		}
	}
}