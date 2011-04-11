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
package org.pranaframework.context.support {

	import org.pranaframework.context.IConfigurableApplicationContext;
	import org.pranaframework.ioc.factory.config.IObjectFactoryPostProcessor;
	import org.pranaframework.ioc.factory.config.IObjectPostProcessor;
	import org.pranaframework.ioc.factory.xml.XMLObjectFactory;
	import org.pranaframework.utils.Assert;

	/**
	 * The <code>XMLApplicationContext</code> is the object factory used in ActionScript projects, in Flex projects 
	 * you want to use the <code>FlexXMLApplicationContext</code> class.  
	 * <p />
	 * <p>
	 * <strong>Important: </strong> the schemeLocation within the application context xml file (in the example 
	 * <code>http://www.pranaframework.org/schema/objects/prana-objects-0.6.xsd</code>) 
	 * should contain the version of prana you are using.
	 * </p>
	 * <p />
	 * <em>Using the XMLApplicationContext</em>
	 * <p />
	 * The following example retrieves an object from the application context 
	 * <listing version="3.0">
	 * public class MyApplication {
	 * 
	 * 	private var _xmlApplicationContext:XMLApplicationContext;	
	 *   
	 * 	public function MyApplication() {
	 * 		_xmlApplicationContext = new XMLApplicationContext("applicationContext.xml");
	 * 		_xmlApplicationContext.addEventListener(Event.COMPLETE, _applicationContextCompleteHandler);
	 * 		_xmlApplicationContext.load();
	 * 	}
	 * 
	 * 	private function _applicationContextCompleteHandler(e:Event):void {
	 * 		var someObject:SomeObject = _xmlApplicationContext.getObject("someObject");
	 * 	}
	 * }
	 * </listing>
	 * <p />
	 * The <code>applicationContext.xml</code> could look something like this:
	 * <p />
	 * <em>A simple application context xml file</em>
	 * <p />
	 * An <code>applicationcontext.xml</code> file with one object defined
	 * <listing version="3.0">
	 * &lt;?xml version="1.0" encoding="utf-8"?&gt;
	 * &lt;objects xmlns="http://www.pranaframework.org/objects"
	 *          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	 *          xsi:schemaLocation="http://www.pranaframework.org/objects http://www.pranaframework.org/schema/objects/prana-objects-0.6.xsd"
	 * &gt;
	 * 	&lt;object id="someObject" class="package.SomeClass" /&gt;
	 * 	
	 * &lt;/objects&gt;
	 * </listing>
	 * <p />
	 * <em>Object post processors</em>
	 * <p />
	 * In order to manipulate instantiated objects before (or after) they are created you can use object 
	 * post processors. Post processors can be defined like this: 
	 * <p />
	 * <listing version="3.0">
	 * &lt;object class="org.pranaframework.factory.config.SpecialObjectPostProcessor" /&gt;
	 * </listing>
	 * <p />
	 * The <code>XMLApplicationContext</code> will automatically add them if they implement the 
	 * <code>IObjectPostProcessor</code> interface.
	 * 
	 * @see org.pranaframework.ioc.factory.config.IObjectPostProcessor
	 * @see #addObjectPostProcessor()
	 * 
	 * @author Christophe Herreman
	 * @author Erik Westra
	 */
	public class XMLApplicationContext extends XMLObjectFactory implements IConfigurableApplicationContext {

		private var _id:String = "";
		private var _displayName:String = "";
		private var _objectFactoryPostProcessors:Array = [];

		/**
		 * Creates a new XMLApplicationContext
		 */
		public function XMLApplicationContext(source:* = null) {
			super(source);
		}

		/**
		 * @private
		 * //TODO: what is this for?
		 */
		public function get id():String {
			return id;
		}

		/**
		 * @private
		 */
		public function set id(value:String):void {
			_id = value;
		}

		/**
		 * @private
		 * //TODO: what is this for?
		 */
		public function get displayName():String {
			return _displayName;
		}
		
		/**
		 * @private
		 */
		public function set displayName(value:String):void {
			_displayName = value;
		}

		/**
		 * @private
		 * //TODO: what is this for?
		 */
		public function addObjectFactoryPostProcessor(objectFactoryPostProcessor:IObjectFactoryPostProcessor):void {
			Assert.notNull(objectFactoryPostProcessor, "The object factory post-processor cannot be null");
			_objectFactoryPostProcessors.push(objectFactoryPostProcessor);
		}

		/**
		 * Hook method defined in XmlObjectFactory to add the <code>ApplicationContextAwareProcessor</code>.
		 * 
		 * @see ApplicationContextAwareProcessor
		 * @see #addObjectPostProcessor()
		 */
		override protected function beforeParse():void {
			addObjectPostProcessor(new ApplicationContextAwareProcessor(this));
		}

		/**
		 * Hook method defined in XmlObjectFactory overridden to invoke
		 * application context specific logic.
		 */
		override protected function afterParse():void {
			registerObjectPostProcessors();
			preInstantiateSingletons();
		}
		
		/**
		 * Will search all object definitions for implementations of IObjectPostProcessor.
		 * <p />
		 * If they are found they will be added using addObjectPostProcessor.
		 * <p />
		 * If the implementation also implements IObjectFactoryAware, it will receive a reference 
		 * to the XMLApplicationContext.
		 * 
		 * @see #addObjectPostProcessor()
		 */
		protected function registerObjectPostProcessors():void { 
			var postProcessorsNames:Array = getObjectNamesForType(IObjectPostProcessor);
			
			for (var i:int = 0; i<postProcessorsNames.length; i++) {
				addObjectPostProcessor(getObject(postProcessorsNames[i]));
			}		
		}
	}
}