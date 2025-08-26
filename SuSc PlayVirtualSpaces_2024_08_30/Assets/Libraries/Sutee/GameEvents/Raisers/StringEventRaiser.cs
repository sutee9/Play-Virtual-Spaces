using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace sutee.GameEvents2 { 
    public class StringEventRaiser : BaseGameEventRaiser<string> {
        public override BaseGameEvent<string> GameEvent { get { return _gameEvent; } set { _gameEvent = (StringEvent)value; } }
        [Tooltip("The ScriptableObject Event to be Raised.")] [SerializeField]
        public StringEvent _gameEvent;
    }
}
