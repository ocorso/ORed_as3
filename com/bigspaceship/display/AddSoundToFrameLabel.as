/**
 * AddSoundToFrameLabel by Big Spaceship. 2009
 *
 * To contact Big Spaceship, email info@bigspaceship.com or write to us at 45 Main Street #716, Brooklyn, NY, 11201.
 * Visit http://labs.bigspaceship.com for documentation, updates and more free code.
 *
 *
 * Copyright (c) 2009 Big Spaceship, LLC
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 **/
package com.bigspaceship.display
{
	import com.bigspaceship.audio.AudioManager;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class AddSoundToFrameLabel extends EventDispatcher
	{
		
		private var _stndrd:IStandard;
		private var _eventToSoundId_obj:Object;
		
		public function AddSoundToFrameLabel($standardDisplayObject:IStandard, $eventToSoundId:Object)
		{
			_stndrd = $standardDisplayObject;
			_eventToSoundId_obj = $eventToSoundId;
			for (var keyEvent:String in _eventToSoundId_obj) { 
				trace("keyEvent."+keyEvent+" = "+_eventToSoundId_obj[keyEvent]); 
				$standardDisplayObject.addEventListener(keyEvent, _onTimelineEvent_handler);
			} 
		}
		
		private function _onTimelineEvent_handler($evt:Event):void 
		{
			trace('play Sound');
			if(_eventToSoundId_obj.hasOwnProperty($evt.type)){
				if(_eventToSoundId_obj[$evt.type] is Array){
					AudioManager.getInstance().playEffectSound.apply(null, _eventToSoundId_obj[$evt.type]);
				}else{
					AudioManager.getInstance().playEffectSound(_eventToSoundId_obj[$evt.type]);
				}
				
			}
		}
	}
}