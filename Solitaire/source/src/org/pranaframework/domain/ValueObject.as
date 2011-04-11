package org.pranaframework.domain {
	import mx.collections.IList;
	
	import org.pranaframework.reflection.Accessor;
	import org.pranaframework.reflection.AccessorAccess;
	import org.pranaframework.reflection.Type;
	import org.pranaframework.utils.ClassUtils;
	import org.pranaframework.utils.ObjectUtils;
	
	
	/**
	 * Base implementation of the IValueObject interface.
	 * 
	 * @author Christophe Herreman
	 */
	public class ValueObject implements IValueObject {
		
		protected static const PROPERTY_PROTOTOYPE:String = "prototype";
		
		/**
		 * Creates a new ValueObject
		 */
		public function ValueObject() {
		}

		/**
		 * 
		 */
		public function clone():* {
			var clazz:Class = ClassUtils.forInstance(this);
			var result:* = new clazz();
			result.copyFrom(this);
			return result;
		}
		
		/**
		 * 
		 */
		public function copyFrom(other:*):void {
			var type:Type = Type.forInstance(this);
			for each (var acc:Accessor in type.accessors) {
				if (acc.access == AccessorAccess.READ_WRITE) {
					var newValue:* = other[acc.name];
					if (newValue is IList) {
						this[acc.name].removeAll();
						for each (var item:* in newValue) {
							var clonedItem:* = clonePropertyValue(item);
							this[acc.name].addItem(clonedItem);
						}
					}
					else {
						this[acc.name] = clonePropertyValue(newValue, acc.name);
					}
				}
			}
		}
		
		/**
		 * 
		 */
		protected function clonePropertyValue(property:*, name:String = ""):* {
			var result:*;
			
			if (property is IValueObject) {
				result = property.clone();
			}
			else if (property is IList) {
				result.removeAll();
				
				/*if (property is TypedCollection) {
					result = new TypedCollection((property as TypedCollection).type);
				}
				else {
					var clazz:Class = ClassUtils.forInstance(property);
					result = ClassUtils.newInstance(clazz);
				}*/
				
				for each (var item:* in property) {
					result.addItem(clonePropertyValue(item));
				}
			}
			else {
				result = ObjectUtils.clone(property);
			}
			return result;
		}
		
		/**
		 * 
		 */
		public function equals(other:*):Boolean {
			return doEquals(other, [PROPERTY_PROTOTOYPE]);
		}
		
		/**
		 * 
		 */
		protected function doEquals(other:*, ignoredProperties:Array):Boolean {
			if (this == other) {
				return true;
			}
			
			if (!(other is ClassUtils.forInstance(this))) {
				return false;	
			}
			
			var type:Type = Type.forInstance(this);
			for each (var acc:Accessor in type.accessors) {
				var isIgnoredProperty:Boolean = (ignoredProperties.indexOf(acc.name) != -1);
				if (!isIgnoredProperty) {
					if (this[acc.name] != other[acc.name]) {
						return false;
					}	
				}
			}
			
			return true;
		}
		
	}
}