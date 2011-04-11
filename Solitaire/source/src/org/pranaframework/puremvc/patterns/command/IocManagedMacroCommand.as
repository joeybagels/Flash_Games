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

package org.pranaframework.puremvc.patterns.command {
  import org.pranaframework.puremvc.interfaces.IIocCommand;
  import org.pranaframework.puremvc.interfaces.IIocFacade;
  import org.puremvc.as3.interfaces.INotification;
  import org.puremvc.as3.patterns.observer.Notifier;

  /**
   * This class exists to provide a macro command that can have its subcommands injected into it.
   * <p>
   * The MacroCommand in PureMVC is not open for extension in this way, which requires us to make this
   * clone of it to use it in an IoC way.
   * </p>
   *
   * <p>
   * <b>Author:</b> Ryan Gardner<br/>
   * <b>Version:</b> $Revision: 743 $, $Date: 2008-06-06 00:15:18 +0200 (Fri, 06 Jun 2008) $, $Author: dmurat1 $<br/>
   * <b>Since:</b> 0.6
   * </p>
   */
  public class IocManagedMacroCommand extends Notifier implements IIocCommand {
    private var m_subCommands:Array;
    private var m_configName:String;

    public function getConfigName():String {
      return m_configName;
    }

    public function setConfigName(p_configName:String):void {
      m_configName = p_configName;
    }

    public function IocManagedMacroCommand() {
      super();

      m_subCommands = new Array();
      initializeMacroCommand();
    }

    protected function get iocFacade():IIocFacade {
      return facade as IIocFacade;
    }

    protected function initializeMacroCommand():void {
    }

    protected function addSubCommand(commandInstance:IIocCommand):void {
      m_subCommands.push(commandInstance);
    }

    public final function execute(p_note:INotification):void {
      while (m_subCommands.length > 0) {
        var commandInstance:IIocCommand = m_subCommands.shift();
        commandInstance.execute(p_note);
      }
    }
  }
}
