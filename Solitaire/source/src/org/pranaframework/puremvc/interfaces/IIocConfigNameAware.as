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
package org.pranaframework.puremvc.interfaces {
  /**
   * Defines setter and getter for a configuration name for ioc puremvc constructs. This enables ioc facade and its
   * containing prana container, to inject configuration names (values of id property) in ioc puremvc elements like
   * <code>IIocProxy</code>, <code>IIocMediator</code> and <code>IIocFacade</code>.
   * <p>
   * Setter method from this interface is intended to be used internally from ioc facade. It should not be used by
   * clients.
   * </p>
   *
   * <p>
   * <b>Author:</b> Damir Murat<br/>
   * <b>Version:</b> $Revision: 736 $, $Date: 2008-06-05 10:18:48 +0200 (Thu, 05 Jun 2008) $, $Author: dmurat1 $<br/>
   * <b>Since:</b> 0.6
   * </p>
   */
  public interface IIocConfigNameAware {
    /**
     * This function should not be used by clients. It is invoked internally by ioc facade when appropriate.
     */
    function setConfigName(p_proxyConfigName:String):void;

    function getConfigName():String;
  }
}
