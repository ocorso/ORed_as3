package com.bigspaceship.loading
{
	import flash.display.Loader;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	
	import flash.utils.Dictionary;
	
	import com.bigspaceship.utils.Out;
	
	/**
	 *  Multiple file loader.
	 *	Basic syntax requires creation of an instance of BigLoader. To which assets can then be added.  
	 *	Loader is started with "start" after all assets are queued.  All events dispatched are in relation to global load.
	 *	<code>
	 *		var l:BigLoader = new BigLoader();
	 *		l.add("assets/myImage.jpg", "assetID", 234);	// parameters are (asset path, uniquie id [not required], weight in bytes [not required])
	 *		l.add("assets/audioLib.swf", null, 2700);
	 *		l.start();
	 *  </code>
	 *	
	 *	Additionally <code>loader.add()</code> will return an instance of BigLoadItem which will also dispatch PROGRESS and COMPLETE events for itself.
	 *	
	 *	@dispatches Event.COMPLETE
	 *	@dispatches ProgressEvent.PROGRESS
	 *	
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 10.0.0
	 *
	 *  @author Charlie Whitney
	 *  @since  18.08.2009
	 */
	public class BigLoader extends EventDispatcher {
		public static var verbose		:Boolean = true;

		private const MAX_CONNECTIONS	:int = 2;

		private var _itemsToLoad	:Vector.<BigLoadItem>;
		private var _itemsComplete	:Dictionary = new Dictionary(true);
		private var _curLoadIndex	:int = 0;
		private var _activeLoads	:int = 0;
		private var _numComplete	:int = 0;
		private var _loaderActive	:Boolean = false;
		
		private var _totalWeight	:int;


		public function BigLoader() {
			_totalWeight = 0;
			_itemsToLoad = new Vector.<BigLoadItem>();
		};

		public function add($url:*, $id:String=null, $weight:int=1):BigLoadItem {
			if(_loaderActive){ _log("You can't add anything after the loader is started.");	return null; }
			if($id == null) $id = $url;
			
			var _loadItem:BigLoadItem = new BigLoadItem($url, $id, $weight);
			_loadItem.addEventListener(ProgressEvent.PROGRESS, _onItemProgress, false, 999, true);
			_loadItem.addEventListener(IOErrorEvent.IO_ERROR, _onItemLoadError, false, 999, true);
			_loadItem.addEventListener(Event.COMPLETE, _onItemLoadComplete, false, 999, true);
			
			_itemsToLoad.push(_loadItem);
			
			_totalWeight += $weight;
			
			return _loadItem;
		};
		
		public function destroy():void
		{
			for(var i:int=0;i<_itemsToLoad.length;i++) { _itemsToLoad[i].destroy(); }

			_itemsToLoad = null;
			_itemsComplete = null;
		};
		
		public function start():void {
			if(_loaderActive){ _log("Loader is already started."); return; }
			_log("Starting load of "+_itemsToLoad.length+" items.");
			
			_loaderActive = true;
			
			// load the maximum number possible
			var numToLoad:int = (_itemsToLoad.length < MAX_CONNECTIONS) ? _itemsToLoad.length : MAX_CONNECTIONS;
			while(_activeLoads < numToLoad){
				_loadItem(_curLoadIndex);
			}
		};
		
		/**
		 *	Returns the BigLoadItem instance for the passed ID.
		 */
		public function getLoadedItemById($id:String):* {
			if(_itemsComplete[$id] == null) _log("Warning: Asset not loaded yet.");
			return _itemsComplete[$id];
		};
		
		/**
		 *	Returns the asset from the BigLoadItem instance for the passed ID
		 */
		public function getLoadedAssetById($id:String):* {
			if(_itemsComplete[$id] == null) _log("Warning: Asset not loaded yet.");
			return BigLoadItem(_itemsComplete[$id]).content;
		};
		
		// ---------------------------
		// PRIVATE
		// ---------------------------
		private function _loadItem($index:int):void {
			var nextItem:BigLoadItem = _itemsToLoad[$index];
			nextItem.startLoad();
			
			_log("Starting load of "+nextItem);
			
			++_activeLoads;
			++_curLoadIndex;
		};
		
		private function _onItemProgress($evt:Event):void {
			var totalPercent:Number = 0;
			var i:int=_itemsToLoad.length;
			while(--i > -1){
				totalPercent += _itemsToLoad[i].getWeightedPercentage(_totalWeight);
			}
			
			// totalPercent will be a number between 0-1
			// ProgressEvent acts weird when you give it floats, so multiply by 100
			dispatchEvent( new ProgressEvent(ProgressEvent.PROGRESS, false, false, totalPercent*100, 100) );
		};
		
		private function _onItemLoadError($evt:IOErrorEvent):void {
			_log("Error loading item. "+$evt);
			
			_itemLoadedCleanup($evt);
		};
		
		// when a single item completes its load
		private function _onItemLoadComplete($evt:Event):void {
			_log("Completed load of :: "+$evt.target);
			// store content of loader
			_itemsComplete[$evt.target.id] = $evt.target;
			
			// dispatch complete event
			
			
			_itemLoadedCleanup($evt);
		};
		
		// remove listeners, update counters
		private function _itemLoadedCleanup($evt:Event):void {
			// remove events
			$evt.target.removeEventListener(ProgressEvent.PROGRESS, _onItemProgress);
			$evt.target.addEventListener(IOErrorEvent.IO_ERROR, _onItemLoadError);
			$evt.target.removeEventListener(Event.COMPLETE, _onItemLoadComplete);
			
			// reduce number of loads
			--_activeLoads;
			
			// check if it should start another load
			++_numComplete;
			if(_numComplete == _itemsToLoad.length){
				_allLoadsComplete();
			}else if(_curLoadIndex < _itemsToLoad.length){
				_loadItem(_curLoadIndex);
			}
		};
		
		private function _allLoadsComplete():void {
			_loaderActive = false;
			
			// dispatch all complete event
			dispatchEvent( new Event(Event.COMPLETE) );
		};
		
		// tracing
		override public function toString():String {
			return "[BigLoader: "+_itemsToLoad.length+" items]";
		};
		
		// logging
		private function _log($str:String):void {
			if(verbose) Out.info(this, $str);
		};
	}
}
