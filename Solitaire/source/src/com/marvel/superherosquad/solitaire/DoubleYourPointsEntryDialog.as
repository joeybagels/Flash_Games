package com.marvel.superherosquad.solitaire
{
	import com.zerog.components.dialogs.AbstractInputDialog;
	
	import fl.controls.ComboBox;
	
	import flash.text.TextField;
	
	import flash.events.MouseEvent;

	public class DoubleYourPointsEntryDialog extends AbstractInputDialog
	{
		public var breakfastGlucose:TextField;
		public var lunchGlucose:TextField;
		public var snackGlucose:TextField;
		public var dinnerGlucose:TextField;
		
		public var breakfastUnits:ComboBox;
		public var lunchUnits:ComboBox;
		public var snackUnits:ComboBox;
		public var dinnerUnits:ComboBox;
		
		public function DoubleYourPointsEntryDialog()
		{
			super();
			
			this.breakfastUnits.addItem({label:"mg/dL", data: "mg/dL"});
			this.breakfastUnits.addItem({label:"mmol/L", data: "mmol/L"});
			
			this.lunchUnits.addItem({label:"mg/dL", data: "mg/dL"});
			this.lunchUnits.addItem({label:"mmol/L", data: "mmol/L"});
			
			this.snackUnits.addItem({label:"mg/dL", data: "mg/dL"});
			this.snackUnits.addItem({label:"mmol/L", data: "mmol/L"});
			
			this.dinnerUnits.addItem({label:"mg/dL", data: "mg/dL"});
			this.dinnerUnits.addItem({label:"mmol/L", data: "mmol/L"});
		}
		
		public function getBreakfastGlucose():String {
			return this.breakfastGlucose.text;
		}
		
		public function getLunchGlucose():String {
			return this.lunchGlucose.text;
		}
		
		public function getSnackGlucose():String {
			return this.snackGlucose.text;
		}
		
		public function getDinnerGlucose():String {
			return this.dinnerGlucose.text;
		}
		
		public function getBreakfastUnits():String {
			return this.breakfastUnits.selectedItem.data;
		}
		
		public function getLunchUnits():String {
			return this.lunchUnits.selectedItem.data;
		}
		
		public function getSnackUnits():String {
			return this.snackUnits.selectedItem.data;
		}
		
		public function getDinnerUnits():String {
			return this.dinnerUnits.selectedItem.data;
		}

		override protected function onConfirm(e:MouseEvent):void {
			if (!isNaN(parseInt(this.breakfastGlucose.text)) || !isNaN(parseInt(this.lunchGlucose.text)) || !isNaN(parseInt(this.snackGlucose.text)) || !isNaN(parseInt(this.dinnerGlucose.text))) {
				super.onConfirm(e);
			}
		}
	}
}