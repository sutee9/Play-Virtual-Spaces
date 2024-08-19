using UnityEngine;
using UnityEngine.Events;

namespace sutee.GameEvents2 
{
    public abstract class BaseGameEventListener<T, E, UER> : MonoBehaviour, IGameEventListener<T>  
        where E : BaseGameEvent<T>
        where UER : UnityEvent<T> 
    {

        public string description;
        [SerializeField] private E _gameEvent;
        public E GameEvent { get { return _gameEvent; } set { _gameEvent = value; } }

        [SerializeField] private UER unityEventResponse;

        protected void OnEnable(){
            if (_gameEvent == null) {
                return;
            }
            GameEvent.RegisterListener(this);
        }

        protected void OnDisable(){
            if (_gameEvent == null){ return; }

            GameEvent.UnregisterListener(this);
        }

        public virtual void OnEventRaised(T item){
            if (unityEventResponse != null){
                unityEventResponse.Invoke(item);
            }
        }
    }

    public abstract class BaseGameEventListener<T0, T1, E, UER> : MonoBehaviour, IGameEventListener<T0, T1>
     where E : BaseGameEvent<T0, T1>
     where UER : UnityEvent<T0, T1>
    {

        public string description;
        [SerializeField] private E _gameEvent;
        public E GameEvent { get { return _gameEvent; } set { _gameEvent = value; } }

        [SerializeField] private UER unityEventResponse;

        private void OnEnable()
        {
            if (_gameEvent == null)
            {
                return;
            }
            GameEvent.RegisterListener(this);
        }

        private void OnDisable()
        {
            if (_gameEvent == null) { return; }

            GameEvent.UnregisterListener(this);
        }

        public virtual void OnEventRaised(T0 t0item, T1 t1item)
        {
            if (unityEventResponse != null)
            {
                unityEventResponse.Invoke(t0item, t1item);
            }
        }
    }
}