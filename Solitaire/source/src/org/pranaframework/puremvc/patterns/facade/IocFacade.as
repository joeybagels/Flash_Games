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
/*
 PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 United States License
*/
package org.pranaframework.puremvc.patterns.facade {
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.IEventDispatcher;
  import flash.utils.Dictionary;

  import org.pranaframework.context.IConfigurableApplicationContext;
  import org.pranaframework.context.support.XMLApplicationContext;
  import org.pranaframework.ioc.ObjectDefinitionNotFoundError;
  import org.pranaframework.ioc.factory.config.IObjectPostProcessor;
  import org.pranaframework.puremvc.core.controller.IocController;
  import org.pranaframework.puremvc.interfaces.IIocController;
  import org.pranaframework.puremvc.interfaces.IIocFacade;
  import org.pranaframework.puremvc.interfaces.IIocMediator;
  import org.pranaframework.puremvc.interfaces.IIocProxy;
  import org.pranaframework.puremvc.interfaces.IocConstants;
  import org.pranaframework.puremvc.ioc.IocConfigNameAwarePostProcessor;
  import org.pranaframework.utils.Assert;
  import org.puremvc.as3.interfaces.IMediator;
  import org.puremvc.as3.interfaces.IProxy;
  import org.puremvc.as3.patterns.facade.Facade;

  /**
   * IoC capable PureMVC facade which integrates functionalities of Prana and PureMVC frameworks.
   *
   * <p>
   * <b>Author:</b> Damir Murat<br/>
   * <b>Version:</b> $Revision: 773 $, $Date: 2008-06-15 00:05:58 +0200 (Sun, 15 Jun 2008) $, $Author: dmurat1 $<br/>
   * <b>Since:</b> 0.4
   * </p>
   */
  public class IocFacade extends Facade implements IIocFacade, IEventDispatcher {
    protected var m_proxyNamesMap:Dictionary;
    protected var m_mediatorNamesMap:Dictionary;
    protected var m_applicationContext:XMLApplicationContext;
    protected var m_dispatcher:EventDispatcher;

    /**
     * Constructor. <code>IocFacade</code> instance can be constructed with or without <code>p_configSource</code>
     * parameter. If parameter is supplied, instance represents IoC capable facade. Otherwise, it can be used only as
     * ordinary PureMVC facade. This means that all IoC specific methods will throw error.
     * <p>
     * If <code>p_configSource</code> parameter is not used with constructor, one can enable IoC specific
     * functionalities by invoking "one-time" <code>initializeIocContainer()</code> method. This can be useful in
     * scenarios when is needed to establish control over GUI before IoC container can be initialized, for example
     * during startup.
     * </p>
     *
     * @param p_configSource
     *        Optional path to the xml configuration file as a <code>String</code> or as an <code>Array</code>.
     * @throws Error Error Thrown if singleton instance has already been constructed.
     * @see #initializeIocContainer()
     */
    public function IocFacade(p_configSource:* = null) {
      super();

      m_proxyNamesMap = new Dictionary();
      m_mediatorNamesMap = new Dictionary();
      m_dispatcher = new EventDispatcher(this);

      if (p_configSource == null) {
        onObjectFactoryListenerComplete(null);
      }
      else {
        initializeIocContainer(p_configSource);
      }
    }

    /**
     * One time initialization of internal IoC container. This method can be used only once. Otherwise, it will throw an
     * error. When facade is instantiated with the constructor without parameter, this method should be used for
     * initialization of internal IoC container. If facade is instantiated with constructor and non null parameter, this
     * method will throw an error.
     *
     * @param p_configSource
     *        Optional path to the xml configuration file as a <code>String</code> or as an <code>Array</code>.
     * @throws org.pranaframework.errors.IllegalStateError Thrown if IoC conatiner is already initialized.
     * @throws org.pranaframework.errors.IllegalArgumentError Thrown if parameter <code>p_configSource</code>
     *         is <code>null</code>.
     * @see #IocFacade()
     */
    public function initializeIocContainer(p_configSource:*):void {
      var objectPostProcessorArray:Array = null;

      Assert.state(m_applicationContext == null, "IoC conatiner is already initialized.");
      Assert.notNull(p_configSource, "Parameter p_configSource can't be null.");

      m_applicationContext = new XMLApplicationContext(p_configSource);

      objectPostProcessorArray = getObjectPostProcessors();
      for (var i:int = 0; i < objectPostProcessorArray.length; i++) {
        if (objectPostProcessorArray[i] as IObjectPostProcessor) {
          m_applicationContext.addObjectPostProcessor(objectPostProcessorArray[i]);
        }
      }

      m_applicationContext.addEventListener(Event.COMPLETE, onObjectFactoryListenerComplete);
      m_applicationContext.load();
    }

    /**
     * Enables adding object postprocessors in internal prana container. This implementation adds just
     * <code>IocConfigNameAwarePostProcessor</code>. If this is not desired, one override this method in a subclass.
     *
     * @return Array containing all configured object postprocessors for internal prana container.
     * @see org.pranaframework.puremvc.ioc.IocConfigNameAwarePostProcessor
     */
    protected function getObjectPostProcessors():Array {
      return new Array(new IocConfigNameAwarePostProcessor());
    }

    protected function onObjectFactoryListenerComplete(p_event:Event):void {
      if (m_applicationContext != null) {
        m_applicationContext.removeEventListener(Event.COMPLETE, onObjectFactoryListenerComplete);
      }

      initializeIocFacade();

      if (container != null) {
        try {
          m_proxyNamesMap = container.getObject(IocConstants.PROXY_NAMES_MAP);
        }
        catch (error:ObjectDefinitionNotFoundError) {
          // do nothing since proxy names Map doesn't have to be used
        }

        try {
          m_mediatorNamesMap = container.getObject(IocConstants.MEDIATOR_NAMES_MAP);
        }
        catch (error:ObjectDefinitionNotFoundError) {
          // do nothing since mediator names Map doesn't have to be used
        }
      }

      dispatchEvent(new Event(Event.COMPLETE));
    }

    public function get container():IConfigurableApplicationContext {
      if (m_applicationContext != null) {
        return m_applicationContext;
      }
      else {
        return null;
      }
    }

    /**
     * This prevents super constructor from trying to initialize facade to early.
     */
    override protected function initializeFacade():void {
    }

    protected function initializeIocFacade():void {
      initializeModel();
      initializeController();
      initializeView();
    }

    override protected function initializeController():void {
      if (controller != null) {
        if (m_applicationContext == null) {
          (controller as IocController).initializeIocContainer(m_applicationContext);
        }
      }
      else {
        controller = IocController.getInstance(m_applicationContext);
      }
    }

    public function registerProxyByConfigName(p_proxyName:String):void {
      var proxy:IIocProxy = null;
      var targetConfigName:String = m_proxyNamesMap[p_proxyName];

      // First try to find an object by mapped name
      if (targetConfigName != null) {
        // This will thorw an error if the object definition can't be found
        proxy = container.getObject(targetConfigName);
      }
      // If there is no value for mapped name available, try with supplied name.
      else {
        // This will thorw an error if the object definition can't be found
        proxy = container.getObject(p_proxyName);
      }

      proxy.setProxyName(p_proxyName);
      model.registerProxy(proxy);
    }

    override public function removeProxy(p_proxyName:String):IProxy {
      var proxy:IProxy;

      if (model != null) {
        if (m_applicationContext != null) {
          var targetConfigName:String = m_proxyNamesMap[p_proxyName];
          if (targetConfigName != null) {
            m_applicationContext.clearObjectFromInternalCache(targetConfigName);
          }
          // If there is no value for mapped name available, try with supplied name.
          else {
            m_applicationContext.clearObjectFromInternalCache(p_proxyName);
          }
        }

        proxy = model.removeProxy(p_proxyName);
      }

      return proxy;
    }

    public function registerMediatorByConfigName(p_mediatorName:String, p_viewComponent:Object = null):void {
      var mediator:IIocMediator = null;
      var targetConfigName:String = m_mediatorNamesMap[p_mediatorName];

      if (targetConfigName != null) {
        if (p_viewComponent != null) {
          mediator = container.getObject(targetConfigName, [p_mediatorName, p_viewComponent]);
        }
        else {
          mediator = container.getObject(targetConfigName);
        }
      }
      else {
        if (p_viewComponent != null) {
          mediator = container.getObject(p_mediatorName, [p_mediatorName, p_viewComponent]);
        }
        else {
          mediator = container.getObject(p_mediatorName);
        }
      }

      mediator.setMediatorName(p_mediatorName);
      view.registerMediator(mediator);
    }

    override public function removeMediator(p_mediatorName:String):IMediator {
      var mediator:IMediator;
      if (view != null) {
        if (m_applicationContext != null) {
          var targetConfigName:String = m_mediatorNamesMap[p_mediatorName];

          if (targetConfigName != null) {
            m_applicationContext.clearObjectFromInternalCache(targetConfigName);
          }
          // If there is no value for mapped name available, try with supplied name.
          else {
            m_applicationContext.clearObjectFromInternalCache(p_mediatorName);
          }
        }

        mediator = view.removeMediator(p_mediatorName);
      }

      return mediator;
    }

    public function registerCommandByConfigName(p_noteName:String, p_configName:String):void {
      (controller as IIocController).registerCommandByConfigName(p_noteName, p_configName);
    }

    // IEventDispatcher implementation -- start
    public function addEventListener(
      p_type:String, p_listener:Function, p_useCapture:Boolean = false, p_priority:int = 0,
      p_useWeakReference:Boolean = false):void
    {
      m_dispatcher.addEventListener(p_type, p_listener, p_useCapture, p_priority);
    }

    public function dispatchEvent(p_event:Event):Boolean{
      return m_dispatcher.dispatchEvent(p_event);
    }

    public function hasEventListener(p_type:String):Boolean{
      return m_dispatcher.hasEventListener(p_type);
    }

    public function removeEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean = false):void {
      m_dispatcher.removeEventListener(p_type, p_listener, p_useCapture);
    }

    public function willTrigger(p_type:String):Boolean {
      return m_dispatcher.willTrigger(p_type);
    }
    // IEventDispatcher implementation -- end
  }
}
