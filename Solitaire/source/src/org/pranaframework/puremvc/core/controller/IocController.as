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
package org.pranaframework.puremvc.core.controller {
  import flash.utils.Dictionary;

  import org.pranaframework.ioc.ObjectDefinitionNotFoundError;
  import org.pranaframework.ioc.factory.support.AbstractObjectFactory;
  import org.pranaframework.puremvc.interfaces.IIocController;
  import org.pranaframework.puremvc.interfaces.IocConstants;
  import org.pranaframework.utils.Assert;
  import org.puremvc.as3.core.View;
  import org.puremvc.as3.interfaces.ICommand;
  import org.puremvc.as3.interfaces.INotification;
  import org.puremvc.as3.interfaces.IView;
  import org.puremvc.as3.patterns.observer.Observer;

  /**
   * Description wannabe.
   *
   * <p>
   * <b>Author:</b> Damir Murat<br/>
   * <b>Version:</b> $Revision: 773 $, $Date: 2008-06-15 00:05:58 +0200 (Sun, 15 Jun 2008) $, $Author: dmurat1 $<br/>
   * <b>Since:</b> 0.4
   * </p>
   */
  public class IocController implements IIocController {
    protected static const SINGLETON_MSG:String = "Controller Singleton already constructed!";
    protected static var m_instance:IIocController;

    protected var m_view:IView;
    protected var m_commandMap:Array;
    protected var m_iocCommandMap:Array;
    protected var m_iocFactory:AbstractObjectFactory;
    protected var m_commandNamesMap:Dictionary;

    public static function getInstance(p_iocFactory:AbstractObjectFactory):IIocController {
      if (m_instance == null) {
        m_instance = new IocController(p_iocFactory);
      }

      return m_instance;
    }

    public function IocController(p_iocFactory:AbstractObjectFactory) {
      super();

      if (m_instance != null) {
        throw Error(SINGLETON_MSG);
      }
      m_instance = this;
      m_commandMap = new Array();
      m_iocFactory = p_iocFactory;
      m_iocCommandMap = new Array();

      try {
        m_commandNamesMap = m_iocFactory.getObject(IocConstants.COMMAND_NAMES_MAP);
      }
      catch (error:ObjectDefinitionNotFoundError) {
        m_commandNamesMap = new Dictionary();
      }

      initializeController();
    }

    public function initializeIocContainer(p_iocFactory:AbstractObjectFactory):void {
      Assert.state(m_iocFactory == null, "IoC container is already initialized.");

      m_iocFactory = p_iocFactory;

      try {
        m_commandNamesMap = m_iocFactory.getObject(IocConstants.COMMAND_NAMES_MAP);
      }
      catch (error:ObjectDefinitionNotFoundError) {
        m_commandNamesMap = new Dictionary();
      }
    }

    protected function initializeController():void {
      m_view = View.getInstance();
    }

    public function executeCommand(p_note:INotification):void {
      var commandClassRef:Class = m_commandMap[p_note.getName()];

      if (commandClassRef != null) {
        var commandInstance:ICommand = new commandClassRef();
        commandInstance.execute(p_note);

        return;
      }

      var commandName:String = m_iocCommandMap[p_note.getName()];
      if (commandName != null) {
        var iocCommandInstance:ICommand;
        var commandTargetName:String = m_commandNamesMap[commandName];

        if (commandTargetName != null) {
          iocCommandInstance = m_iocFactory.getObject(commandTargetName);
        }
        else {
          iocCommandInstance = m_iocFactory.getObject(commandName);
        }

        iocCommandInstance.execute(p_note);

        return;
      }
    }

    public function registerCommand(p_notificationName:String, p_commandClassRef:Class):void {
      var isAlreadyRegistered:Boolean = false;

      // First clear ioc command if it is registered for specified notification name.
      if (m_iocCommandMap[p_notificationName] != null) {
        m_iocFactory.clearObjectFromInternalCache(m_iocCommandMap[p_notificationName]);
        m_iocCommandMap[p_notificationName] = null;
        isAlreadyRegistered = true;
      }

      if (m_commandMap[p_notificationName] == null && !isAlreadyRegistered) {
        m_view.registerObserver(p_notificationName, new Observer(executeCommand, this));
      }

      m_commandMap[p_notificationName] = p_commandClassRef;
    }

    public function registerCommandByConfigName(p_notificationName:String, p_commandName:String):void {
      var isAlreadyRegistered:Boolean = false;

      // First clear "normal" command if it is registered for specified notification name.
      if (m_commandMap[p_notificationName] != null) {
        m_commandMap[p_notificationName] = null;
        isAlreadyRegistered = true;
      }

      if (m_iocCommandMap[p_commandName] == null && !isAlreadyRegistered) {
        m_view.registerObserver(p_notificationName, new Observer(executeCommand, this));
      }

      m_iocCommandMap[p_notificationName] = p_commandName;
    }

    public function removeCommand(p_notificationName:String):void {
      var commandTargetName:String;
      var commandName:String;

      if (m_commandMap[p_notificationName] != null) {
        m_commandMap[p_notificationName] = null;
      }

      if (m_iocCommandMap[p_notificationName] != null) {
        commandTargetName = m_commandNamesMap[p_notificationName];

        if (commandTargetName != null) {
          m_iocFactory.clearObjectFromInternalCache(commandTargetName);
        }
        else {
          commandName = m_iocCommandMap[p_notificationName];
          m_iocFactory.clearObjectFromInternalCache(commandName);
        }

        m_iocCommandMap[p_notificationName] = null;
      }

      m_view.removeObserver(p_notificationName, this);
    }

    public function hasCommand(p_notificationName:String):Boolean {
      var retval:Boolean = false;
      if (m_commandMap[p_notificationName] != null || m_iocCommandMap[p_notificationName] != null) {
        retval = true;
      }

      return retval;
    }
  }
}
