package com.bigspaceship.loading
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.ProgressEvent;
    import flash.events.IOErrorEvent;

    import flash.display.Loader;

    import flash.net.URLLoader;
    import flash.net.URLRequest;

    import com.bigspaceship.utils.Out;

	/**
	 *  A single item loader to be used with BigLoader (not instanciated directly).  It handles different media and
	 *	loads accordingly, dispatching events on loading checkpoints.  Meant to wrap loadding in general to provide 
	 *	common methods / events.
	 *    
	 *	@dispatches Event.COMPLETE
	 *	@dispatches ProgressEvent.PROGRESS
	 *	@dispatches IOErrorEvent.IO_ERROR
	 *	
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Charlie Whitney, Stephen Koch, Jamie Kosoy
	 *  @since  20.11.2009
	 */
    public class BigLoadItem extends EventDispatcher {

        public static const DATA    :String = "bssData";
        public static const MEDIA   :String = "bssMedia";

        public static const IDLE    :String = "idle";
        public static const LOADING :String = "loading";
        public static const LOADED  :String = "loaded";

        private static const __MAX_ATTEMPTS :int = 3;

        private var _url    :*;
        private var _id     :String;
        private var _type   :String;
        private var _state  :String;

        private var _weight :int;
        private var _loader :*;

        private var _attempts:int = 0;

        private var _pctLoaded:Number = 0.0;

        public function BigLoadItem($url:*, $id:String, $weight:int,$type:String = null){
            _url = $url;
            _id = $id;
            _weight = $weight;
			

            // extract file extension
			if($url is URLRequest) _type = DATA;
            else if($type != null) _type = $type;
            else
            {
                var ext:String = $url.substr($url.lastIndexOf(".")+1);
                // switch to determine what kind of loader to use
                switch(ext){
                    case "xml":             // text based content
                    case "txt":
                        _type = DATA;
                    break;
                    default:                // for all images and swfs
                        _type = MEDIA;
                    break;
                }
            }

            _state = IDLE;
            _setupLoader();
        };
		
		/**
		 *	Start the item load
		 */
        public function startLoad():void {
            if(_state == IDLE)
            {
                _state = LOADING;
				
				var req:URLRequest = (_url is URLRequest) ? _url : new URLRequest(_url);
                _loader.load(req);
            }
            else if(_state == LOADED) _onComplete();
            else Out.warning(this,"Item is currently loading.");
        };

        public function destroy():void
        {
            if(_state == LOADING) _loader.close();

            if(_type == BigLoadItem.DATA)
            {
                _loader.removeEventListener(IOErrorEvent.IO_ERROR,  _onFail);
                _loader.removeEventListener(ProgressEvent.PROGRESS, _onProgress);
                _loader.removeEventListener(Event.COMPLETE,         _onComplete);
            } else
            {
                _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,    _onFail);
                _loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,   _onProgress);
                _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,           _onComplete);
            }

            _loader = null;
        };

        // PRIVATE
        // ===================================================================
        private function _setupLoader():void {
            if(_type == BigLoadItem.DATA){
                _loader = new URLLoader();
                _loader.addEventListener(IOErrorEvent.IO_ERROR,     _onFail,     false, 0, true);
                _loader.addEventListener(ProgressEvent.PROGRESS,    _onProgress, false, 0, true);
                _loader.addEventListener(Event.COMPLETE,            _onComplete, false, 0, true);
            }else if(_type == BigLoadItem.MEDIA) {
                _loader = new Loader();
                _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,   _onFail,     false, 0, true);
                _loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,  _onProgress, false, 0, true);
                _loader.contentLoaderInfo.addEventListener(Event.COMPLETE,          _onComplete, false, 0, true);
            } else {
                Out.fatal(this,"Loading unknown type.");
            }
        };

        private function _onProgress($evt:ProgressEvent):void {
            _pctLoaded = $evt.bytesLoaded / $evt.bytesTotal;
            dispatchEvent($evt);
        };

        private function _onComplete($evt:Event = null):void {
            _state      = LOADED;
            _pctLoaded  = 1;
            dispatchEvent(new Event(Event.COMPLETE));
        };

        private function _onFail($evt:Event):void {
            _state = IDLE;
            _attempts++;
            if(_attempts >= __MAX_ATTEMPTS){
                _attempts = 0;
                dispatchEvent($evt);
            }
            else startLoad();
        }

        // OVERRIDE
        // ===================================================================
        override public function toString():String {
            return String("[BigLoadItem :: "+_id+"]");
        };

        // SET / GET
        // ===================================================================
        public function get type():String { return _type; };
        public function get id():String { return _id; };
        public function get url():String { 
			if(_url is URLRequest) return _url.url;
			return _url; 
		};
        public function get content():* {
            if(_type == BigLoadItem.DATA) return _loader.data;
            return _loader.content;
        };
        public function getWeightedPercentage($totalWeight:Number):Number {
            return ((_weight / $totalWeight) * _pctLoaded);
        };
    }
}
