using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace sutee.GameEvents2 { 
    public class VoidEventRaiser : BaseGameEventRaiser<Void> {
        public override BaseGameEvent<Void> GameEvent { get { return _gameEvent; } set { _gameEvent = (VoidEvent)value; } }
        [Tooltip("The ScriptableObject Event to be Raised.")] [SerializeField]
        public VoidEvent _gameEvent;

        public void Raise()
        {
            GameEvent.Raise(new Void());
        }

        public override void RaiseConfigured()
        {
            Raise();
        }
    }
}
