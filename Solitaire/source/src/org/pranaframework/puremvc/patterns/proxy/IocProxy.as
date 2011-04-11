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
package org.pranaframework.puremvc.patterns.proxy {
  import org.pranaframework.puremvc.interfaces.IIocFacade;
  import org.pranaframework.puremvc.interfaces.IIocProxy;
  import org.puremvc.as3.patterns.proxy.Proxy;

  /**
   * Description wannabe.
   *
   * <p>
   * <b>Author:</b> Damir Murat<br/>
   * <b>Version:</b> $Revision: 792 $, $Date: 2008-06-25 17:26:23 +0200 (Wed, 25 Jun 2008) $, $Author: dmurat1 $<br/>
   * <b>Since:</b> 0.4
   * </p>
   */
  public class IocProxy extends Proxy implements IIocProxy {
    private var m_configName:String;

    public function IocProxy(p_proxyName:String = null, p_data:Object = null) {
      super(p_proxyName, p_data);
    }

    protected function get iocFacade():IIocFacade {
      return facade as IIocFacade;
    }

    public function getConfigName():String {
      return m_configName;
    }

    public function setConfigName(p_configName:String):void {
      m_configName = p_configName;
    }

    public function setProxyName(p_proxyName:String):void {
      proxyName = p_proxyName;
    }
  }
}
