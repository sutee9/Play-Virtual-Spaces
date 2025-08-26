using UnityEngine;
using System.Collections.Generic;

namespace sutee.GameEvents2 {

    [System.Serializable]
    public abstract class BaseGameEvent<T> : ScriptableObject {
        
        public bool logging = false;
        public string description;
        public readonly List<IGameEventListener<T>> eventListeners = new List<IGameEventListener<T>>();

        public void Raise (T item){
            if (logging)
            {
                Debug.Log("[GameEvent<" + typeof(T) + ">] "+ this.name + " was raised.");
            }
            for (int i = eventListeners.Count-1; i >= 0; i--){
                eventListeners[i].OnEventRaised(item);
            }
        }

        public void RegisterListener(IGameEventListener<T> listener){
            if (!eventListeners.Contains(listener)){
                if (logging)
                {
                    Debug.Log("[GameEvent<"+typeof(T)+">] "+name+" registered listener on " + listener);
                }
                eventListeners.Add(listener);
            }
        }

        public void UnregisterListener(IGameEventListener<T> listener){
            if (eventListeners.Contains(listener)){
                eventListeners.Remove(listener);
            }
        }
    }

    public abstract class BaseGameEvent<T0, T1> : ScriptableObject
    {

        public bool logging = false;

        public readonly List<IGameEventListener<T0, T1>> eventListeners = new List<IGameEventListener<T0, T1>>();

        public void Raise(T0 t0item, T1 t1item)
        {
            if (logging)
            {
                Debug.Log("[GameEvents2] Raised " + this.name);
            }
            for (int i = eventListeners.Count - 1; i >= 0; i--)
            {
                eventListeners[i].OnEventRaised(t0item, t1item);
            }
        }

        public void RegisterListener(IGameEventListener<T0, T1> listener)
        {
            if (!eventListeners.Contains(listener))
            {
                eventListeners.Add(listener);
            }
        }

        public void UnregisterListener(IGameEventListener<T0, T1> listener)
        {
            if (eventListeners.Contains(listener))
            {
                eventListeners.Remove(listener);
            }
        }
    }
}