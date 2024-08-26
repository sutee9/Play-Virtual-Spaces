using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace sutee.GameEvents2
{
    public abstract class BaseGameEventRaiser<T> : EventRaiser
    {
        //NOTE: IN UNITY 2020 and ABOVE, you can directly implement gameEvent as a field here, because the inspector can serialize it. You can then remove all direct implementations in subclasses.
        //In 2019 this is not yet possible.... had to revert to this fallback.
        public abstract BaseGameEvent<T> GameEvent { get; set; }
        [Tooltip("You can raise an event with this parameter with the context menu. Besides this function, the Event Parameter is only of importance if the Event Raiser is called with the RaiseConfigured() method. Else it has no use.")]
        public T eventParameter;
        [Tooltip("Just describe what this raiser does, who uses it, etc. Only for your documentation, not used by any functionality.")]
        public string description;

        public void RaiseEvent(T item)
        {
            GameEvent.Raise(item);
        }

        public override void RaiseConfigured()
        {
            GameEvent.Raise(eventParameter);
        }
    }

    public abstract class BaseGameEventRaiser<T0, T1> : EventRaiser
    {
        
        public abstract BaseGameEvent<T0, T1> GameEvent { get; set; }
        [Tooltip("You can raise an event with this parameter with the context menu. Besides this function, the Event Parameter is only of importance if the Event Raiser is called with the RaiseConfigured() method. Else it has no use.")]
        public T0 eventParameter0;
        [Tooltip("You can raise an event with this parameter with the context menu. Besides this function, the Event Parameter is only of importance if the Event Raiser is called with the RaiseConfigured() method. Else it has no use.")]
        public T1 eventParameter1;
        [Tooltip("Just describe what this raiser does, who uses it, etc. Only for your documentation, not used by any functionality.")]
        public string description;

        public void RaiseEvent( T0 item0, T1 item1)
        {
            GameEvent.Raise(item0, item1);
        }

        public override void RaiseConfigured()
        {
            RaiseEvent(eventParameter0, eventParameter1);
        }
    }

    public abstract class EventRaiser : MonoBehaviour {
        [ContextMenu("Raise Configured Event")]
        public abstract void RaiseConfigured();
    }
}