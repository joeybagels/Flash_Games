package com.zerog.components.list {
	import flash.events.IEventDispatcher;		

	/**
	 * @author Chris
	 */
	public interface IListItem extends IEventDispatcher {
		/*
		 * Gets the data object
		 */
		function getData():Object;
		
		/*
		 * @param data
		 * Sets a data object
		 */
		function setData(data:Object):void
		
		/*
		 * Gets the label
		 */
		function getLabel():Object;
		
		/*
		 * Gets the index
		 */
		function getIndex():uint;
		
		/*
		 * @param index
		 * Sets the index
		 */
		function setIndex(index:uint):void;
		
		/*
		 * @param select sets the item as selected or unselected
		 * @param dispatch dispatches an event if set to true
		 */
		function setSelected(select:Boolean, dispatch:Boolean = true):void;
		
		/*
		 * @param enabled enables or disables the list item
		 */
		function setEnabled(enabled:Boolean):void;
		
		function isSelected():Boolean;
	}
}