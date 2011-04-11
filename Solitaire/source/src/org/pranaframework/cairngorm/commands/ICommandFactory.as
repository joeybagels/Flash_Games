package org.pranaframework.cairngorm.commands {
	
	import com.adobe.cairngorm.commands.ICommand;
	
	public interface ICommandFactory {
		
		/**
		 * 
		 */
		function canCreate(clazz:Class):Boolean;
		
		/**
		 * Creates a command for the passed command type
		 *   
		 * @param clazz The Command Type
		 * 
		 * @return The new ICommand instance 
		 */		
		function createCommand(clazz:Class):ICommand;
		
	}
}