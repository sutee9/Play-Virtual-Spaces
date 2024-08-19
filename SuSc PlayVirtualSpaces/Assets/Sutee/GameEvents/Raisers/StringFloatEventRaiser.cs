using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace sutee.GameEvents2 { 
    public class StringFloatEventRaiser : BaseGameEventRaiser<string, float> {
        public override BaseGameEvent<string, float> GameEvent { get { return _gameEvent; } set { _gameEvent = (StringFloatEvent)value; } }
        [SerializeField]
        [Tooltip("The ScriptableObject Event to be Raised.")]
        public StringFloatEvent _gameEvent;
    }
}
