package com.zerog.data.tree {
	import com.zerog.data.tree.ITreeNode;	

	/**
	 * @author Chris
	 */
	public class TreeNode implements ITreeNode {
		private var parent:ITreeNode;
		private var children:Array;
		private var data:*;

		public function TreeNode(parent:ITreeNode, children:Array, data:*) {
			this.parent = parent;
			this.children = children;
			this.data = data;
		}

		public function isLeaf():Boolean {
			if (this.children == null || this.children.length == 0) {
				return true;
			}
			else {
				return false;
			}
		}

		public function numChildren():uint {
			if (this.children == null) {
				return 0;
			}
			else {
				return this.children.length;
			}
		}

		public function getChild(index:uint):ITreeNode {
			return this.children[index];
		}

		public function getChildren():Array {
			return this.children;
		}

		public function setChildren(children:Array):void {
			for each (var child:ITreeNode in children) {
				child.setParent(this);
			}
			
			this.children = children;
		}

		public function addChild(child:ITreeNode):void {
			if (this.children == null) {
				this.children = new Array();
			}
			
			child.setParent(this);
			
			this.children.push(child);
		}

		public function setParent(parent:ITreeNode):void {
			this.parent = parent;
		}

		public function getParent():ITreeNode {
			return this.parent;
		}

		public function getDepth():uint {
			return depth(0, this); 
		}
		
		public function getData():* {
			return data;
		}
		
		private static function depth(start:uint, node:ITreeNode):uint {
			var parent:ITreeNode = node.getParent();
			
			//if no parent
			if (parent == null) {
				return start;
			}
			else {
				return depth(start + 1, parent);
			}
		}
	}
}
