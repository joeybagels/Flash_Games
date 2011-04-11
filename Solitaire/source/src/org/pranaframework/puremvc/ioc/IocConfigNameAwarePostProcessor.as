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
package org.pranaframework.puremvc.ioc {
  import org.pranaframework.ioc.factory.config.IObjectPostProcessor;
  import org.pranaframework.puremvc.interfaces.IIocConfigNameAware;

  /**
   * Object post processor which injects configuration name in all <code>IIocConfigNameAware</code> instances available
   * in container.
   * <p>
   * This post processor is used by default in IocFacade implementation. If this is not desired, one can override
   * <code>IocFacade.getObjectPostProcessors()</code> method.
   * </p>
   *
   * <p>
   * <b>Author:</b> Damir Murat<br/>
   * <b>Version:</b> $Revision: 736 $, $Date: 2008-06-05 10:18:48 +0200 (Thu, 05 Jun 2008) $, $Author: dmurat1 $<br/>
   * <b>Since:</b> 0.6
   * </p>
   *
   * @see org.pranaframework.puremvc.interfaces.IIocConfigNameAware
   * @see org.pranaframework.puremvc.patterns.facade.IocFacade#getObjectPostProcessors()
   */
  public class IocConfigNameAwarePostProcessor implements IObjectPostProcessor {
    public function IocConfigNameAwarePostProcessor() {
    }

    public function postProcessBeforeInitialization(p_object:*, p_objectName:String):* {
      if (p_object is IIocConfigNameAware) {
        (p_object as IIocConfigNameAware).setConfigName(p_objectName);
      }

      return p_object;
    }

    public function postProcessAfterInitialization(p_object:*, p_objectName:String):* {
      return p_object;
    }
  }
}

