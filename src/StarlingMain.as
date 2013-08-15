package  src
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Sprite;
	import starling.core.Starling;
	import starling.display.Sprite;

	public class StarlingMain extends Sprite 
	{
		private var _starling:Starling;
		
		
		public function StarlingMain():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);

			_starling = new Starling(StarlingAnimation, stage);
			_starling.showStats = true;
			_starling.start();
		}
		
		
		public function getChild():starling.display.Sprite 
		{
			return new StarlingAnimation();//Game extends a Starling Sprite as per normal
		}
		
	}
}
