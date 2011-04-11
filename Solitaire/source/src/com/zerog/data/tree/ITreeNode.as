package com.zerog.data.tree {

	/**
	 * @author Chris
	 */
	public interface ITreeNode {
		function isLeaf():Boolean;

		function numChildren():uint;

		function getChild(index:uint):ITreeNode;

		function addChild(child:ITreeNode):void;

		function getChildren():Array;

		function setChildren(children:Array):void;

		function setParent(parent:ITreeNode):void;

		function getParent():ITreeNode;

		function getDepth():uint;

		function getData():*;
	}
}
