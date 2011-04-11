package org.pranaframework.cairngorm.commands {
	
	import com.adobe.cairngorm.commands.ICommand;
	
	import org.pranaframework.utils.ClassUtils;

	public class CommandFactory implements ICommandFactory {
		
		public function CommandFactory() {			
		}
		
		public function canCreate(clazz:Class):Boolean {
			return ClassUtils.isImplementationOf(clazz, ICommand);
		}

		public function createCommand(clazz:Class):ICommand {
			var result:ICommand = new clazz();			
			return result;
		}
		
	}
}