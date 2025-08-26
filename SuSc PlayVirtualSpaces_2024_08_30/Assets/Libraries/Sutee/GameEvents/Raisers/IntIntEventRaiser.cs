using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace sutee.GameEvents2 { 
    public class IntIntEventRaiser : BaseGameEventRaiser<int, int> {
        public override BaseGameEvent<int, int> GameEvent { get { return _gameEvent; } set { _gameEvent = (IntIntEvent)value; } }
        [SerializeField] [Tooltip("The ScriptableObject Event to be Raised.")]
        public IntIntEvent _gameEvent;
    }
}
