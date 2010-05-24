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
		private var _useAbsolute							:Boolean;
		private var _nextScreen								:String;
		private var _currentScreen							:String;
		
		public static function getInstance():Model{	return __instance || (__instance = new Model());}
		
		public function initialize($loaderInfo:LoaderInfo=null):void {
			Out.status(this,"initialize();");
			
		 	if (Environment.IS_IN_BROWSER){
				_flashvars = $loaderInfo.parameters;
				_baseUrl = getFlashVar("baseUrl") ? unescape(getFlashVar("baseUrl")) : Constants.DEPLOY_DOMAIN;
				_useAbsolute	= false;
			}else{
				_baseUrl 		= Constants.PRODUCTION_DOMAIN;
				_useAbsolute 	= true;
			}	
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
		public function getFilePath($p:String, $t:String):String{
			var path:String = "";
			if (_useAbsolute) path += _baseUrl + Constants.WP_PATH;
			path += _configXml.settings.setting.(@id == "path_"+$t).@value.toString();
			path += $p;
			return path;
		}//end getFilePath Function
	}//end class model
}//end package 