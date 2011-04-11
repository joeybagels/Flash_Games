package org.pranaframework.cairngorm.commands {

	import com.adobe.cairngorm.commands.ICommand;
	
	import flash.utils.Dictionary;
	
	import org.pranaframework.cairngorm.business.IBusinessDelegateFactory;

	public class ResponderCommandFactory extends CommandFactory implements IResponderCommandFactory {

		private var _businessDelegateFactories:Dictionary = new Dictionary();

		/**
		 *
		 */
		public function ResponderCommandFactory() {
		}

		public function addBusinessDelegateFactory(factory:IBusinessDelegateFactory, commandClasses:Array):void {
			for (var i:int = 0; i<commandClasses.length; i++) {
				_businessDelegateFactories[commandClasses[i]] = factory;
			}
		}

		override public function canCreate(clazz:Class):Boolean {
			return (lookupBusinessDelegateFactory(clazz) != null);
		}

		override public function createCommand(clazz:Class):ICommand {
			var result:AbstractResponderCommand = super.createCommand(clazz) as AbstractResponderCommand;
			var delegateFactory:IBusinessDelegateFactory = lookupBusinessDelegateFactory(clazz);
			delegateFactory.responder = result;
			result.businessDelegate = delegateFactory.createBusinessDelegate();
			return result;
		}

		protected function lookupBusinessDelegateFactory(commandClass:Class):IBusinessDelegateFactory {
			return _businessDelegateFactories[commandClass];
		}


	}
}