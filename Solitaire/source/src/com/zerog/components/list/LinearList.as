package com.zerog.components.list {
	import com.zerog.components.buttons.ButtonEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;		

	/**
	 * @author Chris
	 */
	public class LinearList extends AbstractList {
		public static const VERTICAL:uint = 0;
		public static const HORIZONTAL:uint = 1;

		public var background:DisplayObject;

		protected var direction:uint;
		protected var maxIndex:uint;
		protected var spacing:uint;

		/*
		 * @param background - the background to pass in.  Not supported!
		 */
		public function LinearList(background:DisplayObject = null, 
			direction:uint = VERTICAL) {
			
			if (background == null) {
				this.background = getChildByName("background");
			}
			else {
				this.background = background;
			}
			/*
			if (this.background != null) {
			addChild(this.background);
			}
			 */

			this.spacing = 0;
			this.direction = direction;
			this.singleSelect = false;
			
			//make a container for the items and add to the display list
			this.itemContainer = new Sprite();
			addChild(this.itemContainer);
		}

		public function getBackground():DisplayObject {
			return this.background;
		}

		public function setBackground(background:DisplayObject):void {
			this.background = background;
		}

		public function getDirection():uint {
			return this.direction;
		}

		public function setDirection(direction:uint):void {
			this.direction = direction;
		}

		override public function clear():void {
			//remove current items from display list
			while(itemContainer.numChildren > 0) {
				itemContainer.removeChildAt(0);
			}
			
			//remove event listeners
			for each (var item:IListItem in this.listItems) {
				item.removeEventListener(ButtonEvent.SELECTED, onSelectItem);
				item.removeEventListener(ButtonEvent.DESELECTED, onDeselectItem);
			}
			
			//reset index
			this.maxIndex = 0;
		}

		override public function removeAll():void {
			if (this.listItems != null) {
				while (this.listItems.length > 0) {
					var item:IListItem = this.listItems[0] as IListItem;
					
					removeItem(item);
				}
			}
		}
		
		override public function removeItem(item:IListItem):void {
			super.removeItem(item);
			
			//remove an event listener to it
			item.removeEventListener(ButtonEvent.SELECTED, onSelectItem);
			item.removeEventListener(ButtonEvent.DESELECTED, onDeselectItem);
				
			//remove from display list
			if (itemContainer.contains(item as DisplayObject)) {
				itemContainer.removeChild(item as DisplayObject);
			}
			
			//decrease index
			this.maxIndex--;
			
			arrangeList();
			arrangeBackground();
		}

		override public function addItem(listItem:IListItem):void {
			super.addItem(listItem);
			
			//add an event listener to it
			listItem.addEventListener(ButtonEvent.SELECTED, onSelectItem);
			listItem.addEventListener(ButtonEvent.DESELECTED, onDeselectItem);
				
			//set the index
			listItem.setIndex(this.maxIndex);
				
			//add to the display list
			itemContainer.addChild(listItem as DisplayObject);
				
			//increase the max index
			this.maxIndex++;
					
			arrangeList();
			arrangeBackground();
		}

		override public function setItems(listItems:Array):void {
			clear();
			this.selectedItem = null;
			this.listItems = listItems;
			
			update();
			arrangeList();
			arrangeBackground();
		}

		override public function update():void {
			if (this.listItems != null) {
				//for each item
				for each (var listItem:IListItem in this.listItems) {
					//add an event listener to it
					listItem.addEventListener(ButtonEvent.SELECTED, onSelectItem);
					listItem.addEventListener(ButtonEvent.DESELECTED, onDeselectItem);
				
					//set the index
					listItem.setIndex(this.maxIndex);
				
					//add to the display list
					itemContainer.addChild(listItem as DisplayObject);
				
					//increase the max index
					this.maxIndex++;
				}
			}
		}

		protected function arrangeList():void {
			var yCoord:uint = 0;
			var xCoord:uint = 0;
			
			for each (var item:DisplayObject in this.listItems) {
				if (this.direction == VERTICAL) {
					item.y = yCoord;
					yCoord += item.height + this.spacing;
				}
				else if (this.direction == HORIZONTAL) {
					item.x = xCoord;
					xCoord += item.width + this.spacing;
				}
			}
		}

		protected function arrangeBackground():void {
			if (this.background != null) {
				this.background.x = 0;
				this.background.y = 0;
				this.background.width = this.itemContainer.width; 
				this.background.height = this.itemContainer.height;
			}
		}

		protected function onSelectItem(e:ButtonEvent):void {
			if (this.singleSelect) {
				//set the selected item immediately
				this.selectedItem = e.currentTarget as IListItem;
				
				//deselect all items that were not selected
				for each (var item:IListItem in this.listItems) {
					//deselect if it was not the one clicked and selected
					if (e.currentTarget != item) {
						if (item.isSelected()) {
							item.setSelected(false);
							
							//escape since only one selected
							break;
						}
					}
				}
			}
		}

		private function onDeselectItem(e:ButtonEvent):void {
			//deselect
			//only set to null if target is currently selected
			//this is to avoid race conditions that happen 
			//during the onSelect
			if (e.currentTarget === this.selectedItem) {
				this.selectedItem = null;
			}
		}
	}
}