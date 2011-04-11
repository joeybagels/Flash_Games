package as3cards.visual
{
	import com.zerog.events.AbstractDataEvent;

	public class CardEvent extends AbstractDataEvent
	{
		public static const CARD_IN_MOTION:String = "card in motion";
		public static const CARD_MOTION_COMPLETE:String = "card motion complete";
		
		public function CardEvent(type:String, data:Object=null, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, data, bubbles, cancelable);
		}
		
	}
}