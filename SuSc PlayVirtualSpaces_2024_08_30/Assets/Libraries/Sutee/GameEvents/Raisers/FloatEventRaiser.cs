using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace sutee.GameEvents2 { 
    public class FloatEventRaiser : BaseGameEventRaiser<float> {
        public override BaseGameEvent<float> GameEvent { get { return _gameEvent; } set { _gameEvent = (FloatEvent)value; } }
        [SerializeField]
        [Tooltip("The ScriptableObject Event to be Raised.")]
        private FloatEvent _gameEvent;

    }
}
