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
 package org.pranaframework.cairngorm.business {
	
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import mx.rpc.http.HTTPService;
	import mx.rpc.remoting.RemoteObject;
	import mx.rpc.soap.WebService;
	
	/**
	 * Allows programmatic manipulation of the services inside Cairngorm's
	 * ServiceLocator. This enabled the IoC Container to configure the
	 * ServiceLocator at runtime.
	 * 
	 * <p>Here's an example of a service locator xml definition:<br/>
	 * <listing version="3.0"> &lt;object id="serviceLocator" class="org.pranaframework.ioc.util.CairngormServiceLocator" factory-method="getInstance"&gt;
	 *   &lt;property name="productService"&gt;
	 *     &lt;ref&gt;productService&lt;/ref&gt;
	 *   &lt;/property&gt;
	 * &lt;/object&gt;</listing></p>
	 * 
	 * <p>The <code>productService</code> is defined as:<br/>
	 * <listing version="3.0"> &lt;object id="productService" class="com.renaun.rpc.RemoteObjectAMF0">
	 *   &lt;property name="id" value="productService"/>
	 *   &lt;property name="endpoint" value="http://localhost/amfphp/gateway.php"/>
	 *   &lt;property name="source" value="com.adobe.cairngorm.samples.store.business.ProductDelegate"/>
	 *   &lt;property name="showBusyCursor" value="true"/>
	 *   &lt;property name="makeObjectsBindable" value="true"/>
	 * &lt;/object>
	 * </listing></p>
	 * 
	 * @author Christophe Herreman
	 */
	dynamic public class CairngormServiceLocator extends ServiceLocator {
		
		/**
		 * Creates a new <code>CairngormServiceLocator</code> object.
		 * Note: this constructor should never be called. To obtain an instance
		 * of this class, call the static <code>getInstance</code> method.
		 */
		public function CairngormServiceLocator() {
			
		}
		
		/**
		 * Returns the sigleton instance of the
		 * <code>CairngormServiceLocator</code>.
		 */
		public static function getInstance():CairngormServiceLocator {
			if (_instance == null)
				_instance = new CairngormServiceLocator();
			return _instance;
		}
		
		public override function getHTTPService(name:String):HTTPService {
			return this[name];
		}
		
		public override function getRemoteObject(name:String):RemoteObject {
			return this[name];
		}
		
		public override function getWebService(name:String):WebService {
			return this[name];
		}
		
		private static var _instance:CairngormServiceLocator;
	}
}