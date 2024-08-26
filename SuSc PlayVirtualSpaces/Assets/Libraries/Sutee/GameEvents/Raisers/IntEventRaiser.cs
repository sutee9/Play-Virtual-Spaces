using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace sutee.GameEvents2 { 
    public class IntEventRaiser : BaseGameEventRaiser<int> {
        public override BaseGameEvent<int> GameEvent { get { return _gameEvent; } set { _gameEvent = (IntEvent)value; } }
        [Tooltip("The ScriptableObject Event to be Raised.")] [SerializeField]
        public IntEvent _gameEvent;
    }
}
