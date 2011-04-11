package com.zerog.components.list {
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;	

	/**
	 * @author Chris 
	 * If a textfield with an instance name of 'label' is not a child of the 
	 * exported symbol, one will be created
	 */
	public class TextListItem extends AbstractListItem {
		private var labelField:TextField;
		
		public function TextListItem(label:String) {
			super();
			this.labelField = this.getChildByName("label") as TextField;
			
			if (this.labelField == null) {
				var tf:TextField = new TextField();
				tf.type = TextFieldType.DYNAMIC;
				tf.autoSize = TextFieldAutoSize.LEFT;
				tf.text = label;
				tf.name = "label";
				tf.selectable = false;
				this.addChild(tf);
				this.labelField = tf;
			}
			
			this.labelField.text = label;
		}

		public function setLabelText(labelText:String):void {
			this.labelField.text = labelText;
		}

		public function setTextFormat(format:TextFormat):void {
			this.labelField.setTextFormat(format);
		}

		public function setTextAutoSize(autoSize:String):void {
			this.labelField.autoSize = autoSize;
		}

		override public function getLabel():Object {
			return this.labelField;
		}
	}
}
