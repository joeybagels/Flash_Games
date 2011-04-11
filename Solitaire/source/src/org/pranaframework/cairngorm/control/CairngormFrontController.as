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
 package org.pranaframework.cairngorm.control {

	import com.adobe.cairngorm.CairngormError;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.FrontController;
	
	import org.pranaframework.cairngorm.PendingCommandRegistry;
	import org.pranaframework.cairngorm.commands.CommandFactory;
	import org.pranaframework.cairngorm.commands.CommandProxy;
	import org.pranaframework.cairngorm.commands.ICommandFactory;
	import org.pranaframework.errors.ClassNotFoundError;
	import org.pranaframework.utils.Assert;
	import org.pranaframework.utils.ClassUtils;
	
	/**
	 * The <code>CairngormFrontController</code> extends Cairngorm's
	 * <code>FrontController</code> and adds the ability to pass in commands to
	 * the constructor.
	 * 
	 * <p>The object with the command definitions must have the following form:</p>
	 * 
	 * <listing version="3.0">var commands:Object = {
	 *   "myFirstEvent": "com.domain.command.MyFirstCommand",
	 *   "mySecondEvent": "com.domain.command.MySecondCommand"
	 * };
	 * 
	 * // instantiate a front controller and pass in the commands objects
	 * var controller:FrontController = new CairngormFrontController(commands);</listing>
	 * 
	 * <p>...where the key in the <code>commands</code> object is the name of the
	 * event that the frontcontroller will listen to and the value is the
	 * fully qualified class name of the command that will be executed.</p>
	 * 
	 * <p>Notice that the constructor takes a second optional argument specifying
	 * the package where the commands reside. By passing in this argument it is
	 * not needed to specify fully qualified classnames for the command classes.
	 * Only the classnames themselves need to be specified then.</p>
	 * 
	 * <listing version="3.0">var commands:Object = {
	 *   "myFirstEvent": "MyFirstCommand",
	 *   "mySecondEvent": "MySecondCommand"
	 * };
	 * 
	 * var controller:FrontController = new CairngormFrontController(commands, "com.domain.command");</listing>
	 * 
	 * The following is the xml definition of the <code>controller</code> instance:
	 * 
	 * <listing version="3.0"> &lt;object id="controller" class="org.pranaframework.ioc.util.CairngormFrontController">
	 *   &lt;constructor-arg>
	 *     &lt;object>
	 *       &lt;property name="myFirstEvent" value="MyFirstCommand"/>
	 *       &lt;property name="mySecondEvent" value="MySecondCommand"/>
	 *     &lt;/object>
	 *   &lt;/constructor-arg>
	 *   &lt;constructor-arg value="com.domain.command"/>
	 * &lt;/object></listing>
	 * 
	 * @author Christophe Herreman
	 */
	public class CairngormFrontController extends FrontController {
		
		private static var _instance:CairngormFrontController;
		
		//private var _pendingCommands:Dictionary;
		private var _commandFactories:Array = [];
		
		/**
		 * Creates a new <code>CairngormFrontController</code> instance.
		 * 
		 * @param commands an object containing key/value pairs with the event names and the command classes
		 * @param commandPackage the package where the commands reside
		 */
		/*public function CairngormFrontController() {
			_commandPackage = "";
			_pendingCommands = new Dictionary();
		}*/
		public function CairngormFrontController(commands:Object = "", commandPackage:String = "") {
			_commands = commands;
			_commandPackage = commandPackage;
			//_pendingCommands = new Dictionary();
			init();
			addCommandFactory(new CommandFactory());
		}
		
		public static function getInstance():CairngormFrontController {
			if (!_instance)
				_instance = new CairngormFrontController();
			return _instance;
		}
		
		public function set commandMap(value:Object):void {
			_commands = value;
			init();
		}
		
		public function get commandPackage():String {
			return _commandPackage;
		}
		
		public function set commandPackage(value:String):void {
			_commandPackage = value;
		}
				
		public function get throwCairngormErrors():Boolean { 
			return _throwCairngormErrors;
		}
		public function set throwCairngormErrors(value:Boolean):void { 
			_throwCairngormErrors = value; 
		}
		
		public function addCommandFactory(factory:ICommandFactory):void {
			Assert.notNull(factory, "The command factory cannot be null");
			_commandFactories.unshift(factory);
		}
		
		/*public function registerPendingCommand(cmd:ICommand, event:CairngormEvent):void {
			_pendingCommands[event] = cmd;
		}*/
		
		/**
		 * Adds an extra check to see if the command class implements ICommand.
		 */
		override public function addCommand(commandName:String, commandRef:Class, useWeakReference:Boolean=true):void {
			var implementsICommand:Boolean = ClassUtils.isImplementationOf(commandRef, ICommand);
			if (!implementsICommand)
				throw new Error("The commandRef argument '" + commandRef + "' should implement the ICommand interface");
			try {
				super.addCommand(commandName, commandRef, useWeakReference);	
			}
			catch (e:CairngormError) {
				// re-throw the error if necessary
				if (throwCairngormErrors) {
					throw e;
				}
			}
		}
		
		override protected function executeCommand(event:CairngormEvent):void {
			var cmdClass:Class = getCommand(event.type);
			//var cmd:ICommand = new cmdClass();
			
			// var cmd:ICommand = commandFactory.createCommand();
			
			var cmd:ICommand = createCommand(cmdClass);
			
			var cmdProxy:CommandProxy = new CommandProxy(cmd);
			//cmdProxy.addEventListener("commandExecuted");
			PendingCommandRegistry.getInstance().register(cmd, event); // register the pending command
			cmdProxy.execute(event);
		}
		
		protected function createCommand(cmdClass:Class):ICommand {
			var result:ICommand;
			
			for (var i:int = 0; i<_commandFactories.length; i++) {
				var factory:ICommandFactory = _commandFactories[i];
				if (factory.canCreate(cmdClass)) {
					result = factory.createCommand(cmdClass);
					break;
				}
			}
			
			return result;
		}
		
		/**
		 * Initializes the frontcontroller.
		 */
		private function init():void {
			var commandPackage:String = _commandPackage;
			var commandClass:Class;
			
			// add an extra "." to the package name if one was specified
			if (commandPackage != "")
				commandPackage += ".";
			
			// add all commands to the frontcontroller
			for (var commandName:String in _commands) {
				try {
					commandClass = ClassUtils.forName(commandPackage + _commands[commandName]);
					
					// TODO look into this, should this be caught in Cairngorm?
					if (ClassUtils.isImplementationOf(commandClass, ICommand) == false)
						throw new Error("The command " + commandClass + " does not implement the ICommand interface");
					
					addCommand(commandName, commandClass);
				}
				catch (e:ClassNotFoundError) {
					throw e;
				}
			}
		}
		
		private var _commands:Object;
		private var _commandPackage:String;
		private var _throwCairngormErrors:Boolean = true;
		private var _commandFactory:ICommandFactory;
	}
}