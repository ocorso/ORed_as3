package net.ored.model
{
	import com.bigspaceship.utils.Environment;
	import com.bigspaceship.utils.Out;
	
	import flash.display.LoaderInfo;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class Model extends EventDispatcher
	{
		private static var __instance						:Model;
		
		private var _configXml								:XML;
		private var _baseUrl								:String;
		private var _flashvars								:Object;
		private var _nextScreen								:String;
		private var _currentScreen							:String;
		
		public static const CONFIG_SETTING					:String	= "setting";
		public static const CONFIG_COMPONENTS				:String = "components";
		public static const CONFIG_COMPONENT				:String = "component";
		public static const CONFIG_SCREEN					:String = "screens";
		public static const CONFIG_LOADABLES				:String = "loadables";
		
		public function Model(target:IEventDispatcher=null)
		{
			super(target);
		}//end constructor
		
		public static function getInstance():Model{	return __instance || (__instance = new Model());}
		
		public function initialize($loaderInfo:LoaderInfo=null):void {
			Out.status(this,"initialize();");
			
		 	
			/*if(Environment.IS_IN_BROWSER){
				_flashvars = $loaderInfo.parameters;
				_baseUrl =  unescape(getFlashVar("baseUrl")); 
				
			}
			else  */_baseUrl = "http://www.ored.net/";
			
			Out.info(this, "Here is the base URL: "+ _baseUrl);
			
		}//end function
		
		public function getFlashVar($id:String):String {
			if(_flashvars[$id] && _flashvars[$id] != "") return _flashvars[$id];
			return null;
		}//end function
		
		//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		//--------------GETTERS SETTERS-------------------------------
		//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		
		public function getBaseUrl():String{ return _baseUrl;}
		public function set configXml($xml:XML):void{ _configXml = $xml;}
		public function getNodeByType($node:String, $att:String):XMLList{ return _configXml.child($node).(@type == $att);}
	}//end class model
}//end package 