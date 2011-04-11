package com.zerog.components.list {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.utils.getQualifiedClassName;		
	
	import com.adobe.utils.ArrayUtil;

	/**
	 * @author Chris
	 */
	public class AbstractList extends MovieClip implements IList {
		protected var singleSelect:Boolean;
		protected var itemContainer:Sprite;
		protected var selectedItem:IListItem;
		
		/*
		 * An array of IListItem objects
		 */
		protected var listItems:Array;
		
		public function AbstractList() {
			if (getQualifiedClassName(this) == "com.zerog.components.list::AbstractList") {
				throw new ArgumentError("AbstractList can't be instantiated directly");
			}
			
			this.listItems = new Array();
		}
		
		public function containsItem(item:IListItem):Boolean {
			return ArrayUtil.arrayContainsValue(this.listItems, item);
		}
		
		public function getItemContainer():Sprite {
			return this.itemContainer;
		}
		
		public function getItems():Array {
			return this.listItems;
		}

		public function getNumItems():uint {
			if (this.listItems == null) {
				return 0;
			}
			else {
				return this.listItems.length;
			}
		}
		
		public function clear():void {
			throw new IllegalOperationError("operation not supported");
		}
		
		public function addItem(item:IListItem):void {
			this.listItems.push(item);
		}
		
		public function removeAll():void {
			this.listItems = new Array();
		}
		
		public function removeItem(item:IListItem):void {
			ArrayUtil.removeValueFromArray(this.listItems, item);
		}
		
		public function setItems(listItems:Array):void {
			this.listItems = listItems;
		}
		
		public function setMask(mask:DisplayObject):void {
			this.itemContainer.mask = mask;
		}
		
		public function getMask():DisplayObject {
			return this.itemContainer.mask;
		}
		
		public function getSingleSelect():Boolean {
			return this.singleSelect;
		}

		public function setSingleSelect(singleSelect:Boolean):void {
			this.singleSelect = singleSelect;
		}

		public function getSelectedItem():IListItem {
			return this.selectedItem;
		}
		
		public function getItemAt(index:uint):IListItem {
			return this.listItems[index];
		}

		public function selectItemAt(index:uint, dispatch:Boolean = true):void {
			(this.listItems[index] as IListItem).setSelected(true, dispatch);
		}
		
		public function setEnabled(enabled:Boolean):void {
			for each(var i:IListItem in this.listItems) {
				i.setEnabled(enabled);
			}
		}
		
		public function update():void {
			throw new IllegalOperationError("operation not supported");
		}
	}
}
