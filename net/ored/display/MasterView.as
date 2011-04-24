package net.ored.display
{
	import com.bigspaceship.display.Standard;
	import com.bigspaceship.utils.SimpleSequencer;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import net.ored.model.Model;
	
	public class MasterView extends Standard
	{
		private var _m						:Model;
		private var _layers					:Vector.<Sprite>;
		private var _screens				:Dictionary;
		
		private var _ss						:SimpleSequencer;
		
		
		public function MasterView($mc:MovieClip, $useWeakReference:Boolean=false)
		{
			super($mc, $useWeakReference);
			_isInitialIn = false;
			
			//loosely couple model
			_m = Model.getInstance();
		}//end constructor
	}//end class
}//end package