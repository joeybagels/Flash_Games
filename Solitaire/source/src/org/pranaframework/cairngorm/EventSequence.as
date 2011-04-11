/**
 * Copyright (c) 2007-2008, the original author(s)
 * 
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 *     * Redistributions of source code must retain the above copyright notice,
 *       this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the Prana Framework nor the names of its contributors
 *       may be used to endorse or promote products derived from this software
 *       without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
 package org.pranaframework.cairngorm {
	
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.events.PropertyChangeEvent;
	import mx.utils.ArrayUtil;
	
	import org.pranaframework.utils.Assert;
	import org.pranaframework.utils.Property;
	
	/**
	 * An <code>EventSequence</code> represents a sequence of events to be chained.
	 * This allows you to chain commands by chaining the events that are dispatched
	 * to the <code>FrontController</code> in order to execute a command.
	 * 
	 * <p>Using an event sequence, the commands must not extend
	 * <code>SequenceCommand</code> and hence should not set up a <code>nextEvent</code> and
	 * dispatch it. This means that your commands can be used in a number of different
	 * sequence scenarios without letting the commands know they are chained.
	 * 
	 * <p>The sequencing works by setting up a trigger for an event, based on a
	 * property change in an object. This property change will normally be
	 * executed by a command.</p>
	 * 
	 * @example The following example sets up an event sequence and dispatches it:
	 * 
	 * <listing version="3.0">var sequence:EventSequence = new EventSequence();
	 * 
	 * sequence.addSequenceEvent(LoadSessionEvent, ["4562-54289778-56985412"]);
	 * 
	 * sequence.addSequenceEvent(LoadExamEvent,
	 *  [new Property(ModelLocator.getInstance(), "session", "examId")],
	 *  [new Property(ModelLocator.getInstance(), "session")]);
	 * 
	 * sequence.addSequenceEvent(LoadCandidateEvent,
	 *  [new Property(ModelLocator.getInstance(), "session", "candidateId")],
	 *  [new Property(ModelLocator.getInstance(), "exam")]);
	 * 
	 * sequence.dispatch();</listing>
	 * 
	 * <p>In this example, 3 events are chained. (This sequence is used to load
	 * the session of an exam, the exam itself and the candidate)</p>
	 * 
	 * <p>The first event is the <code>LoadSessionEvent</code> that gets
	 * the id of a session as its constructor argument. The command that is
	 * executed by this event will fetch an exam session and store it in the
	 * <code>session</code> property of the <code>ModelLocator</code>. Since
	 * this is the first event, it does not define any triggers for the next event.</p>
	 * 
	 * <p>The second event is the <code>LoadExamEvent</code>. This event takes
	 * the id of the exam as its constructor argument, fetches an exam and stores
	 * it in the <code>exam</code> property of the <code>ModelLocator</code>.
	 * Notice the 3rd argument that defines the trigger for this event. It is
	 * defined a <code>Property</code> object that contains a reference to the
	 * <code>session</code> property in the <code>ModelLocator</code>. This means
	 * that this event will be dispatched when the <code>session</code> property has been set.
	 * The examId is also passed in as a property and will be evaluated when the
	 * sequence creates the next event.</p>
	 * 
	 * <p>The third event is the <code>LoadCandidateEvent</code>. This event takes
	 * the <code>session.candidateId</code> as its constructor argument and will be dispatched
	 * when the <code>exam</code> property is set on the <code>ModelLocator</code>.</p>
	 * 
	 * @author Christophe Herreman
	 * @author Tony Hillerson
	 */
	public class EventSequence {
		
		private var _sequenceEvents:Array;
		private var _currentSequenceEvent:SequenceEvent;
		private var _currentWatcher:ChangeWatcher;
		
		/**
		 * Creates a new EventSequence
		 */
		public function EventSequence() {
			_sequenceEvents = new Array();
		}
		
		/**
		 * Starts dispatching this event sequence.
		 */
		public function dispatch():void {
			if (_sequenceEvents.length == 0) {
				throw new Error("Cannot start event sequence because sequence has no events");
			}
			var firstSequenceEvent:SequenceEvent = _sequenceEvents[0];
			dispatchSequenceEvent(firstSequenceEvent);
		}
		
		/**
		 * Adds an event to this sequence.
		 * 
		 * @param eventClass the class of the event (must be a subclass of CairngormEvent)
		 * @param parameters the arguments that will be passed to the event's constructor
		 * @param triggers the triggers that will cause the next event to be dispatched
		 */
		public function addSequenceEvent(eventClass:Class, parameters:Array = null, triggers:Array = null):void {
			Assert.notNull(eventClass, "The eventClass argument must not be null");
			Assert.subclassOf(eventClass, CairngormEvent);
			_sequenceEvents.push(new SequenceEvent(eventClass, parameters, triggers));
		}
		
		/**
		 * In case of failure, this cancels the 'on deck' sequence 
		 */		
		public function cancel():void {
			_currentWatcher.unwatch();
		}
		
		/**
		 * Dispatches a sequence event.
		 * If we detect an event after the one we are about to dispatch, we set
		 * up a changewatcher so that we know when to trigger the next event.
		 * 
		 * @param sequenceEvent the event to dispatch
		 */
		private function dispatchSequenceEvent(sequenceEvent:SequenceEvent):void {
			_currentSequenceEvent = sequenceEvent;
			var event:CairngormEvent = sequenceEvent.createEvent();
			var nextSequenceEvent:SequenceEvent = getNextSequenceEvent();
			
			if (nextSequenceEvent) {
				if (nextSequenceEvent.nextEventTriggers) {
					// setup a changewatcher so that we know when to fire the next event
					for (var i:int = 0; i<nextSequenceEvent.nextEventTriggers.length; i++) {
						var p:Property = nextSequenceEvent.nextEventTriggers[i];
						_currentWatcher = ChangeWatcher.watch(p.host, p.chain[0], onTriggerChange);
					}
				}
			}
			
			event.dispatch();
		}
		
		/**
		 * Returns the next sequence event.
		 */
		private function getNextSequenceEvent():SequenceEvent {
			var currentIndex:int = ArrayUtil.getItemIndex(_currentSequenceEvent, _sequenceEvents);
			return _sequenceEvents[currentIndex + 1];
		}
		
		/**
		 * Handles the PropertyChangeEvent of the trigger for the next event.
		 * This trigger is normally a property of an object being set/changed.
		 */
		private function onTriggerChange(pce:PropertyChangeEvent):void {
			var nextSequenceEvent:SequenceEvent = getNextSequenceEvent();
			if (_currentWatcher) {
				_currentWatcher.unwatch();
			}
			if (nextSequenceEvent) {
				dispatchSequenceEvent(nextSequenceEvent);
			}
		}
		
	}
}