package com.zerog.data.tree {
	import com.zerog.data.tree.ITree;		

	/**
	 * @author Chris
	 */
	public class Tree implements ITree {
		private var root:ITreeNode;
		
		public function Tree(root:ITreeNode) {
			this.root = root;
		}
		
		public function getRoot():ITreeNode {
			return this.root;	
		}
		
		public function setRoot(root:ITreeNode):void {
			this.root = root;
		}
		
		/*
		private function getDepth(node:ITreeNode):uint {
			if (node == this.root) {
				return 0;
			}
			else {
				return 1 + getDepth(node.getParent());
			}
		}
		*/
	}
}
