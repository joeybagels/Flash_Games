package com.zerog.components.list {
	import flash.display.DisplayObject;
	import flash.display.Sprite;		

	/**
	 * @author Chris
	 */
	public interface IList {

		function getItemContainer():Sprite;

		function getNumItems():uint;
		
		function clear():void;
				
		function getItems():Array;
		
		function getItemAt(index:uint):IListItem;
		
		function selectItemAt(index:uint, dispatch:Boolean = true):void;
		
		function setItems(listItems:Array):void;
		
		function setMask(mask:DisplayObject):void;
		
		function getMask():DisplayObject;
		
		function getSingleSelect():Boolean;
		
		function setSingleSelect(singleSelect:Boolean):void;
		
		function getSelectedItem():IListItem;
		
		function setEnabled(enabled:Boolean):void;
		
		function update():void;
		
		function addItem(item:IListItem):void;
		
		function removeItem(item:IListItem):void;
		
		function removeAll():void;
		
		function containsItem(item:IListItem):Boolean;
	}
}
