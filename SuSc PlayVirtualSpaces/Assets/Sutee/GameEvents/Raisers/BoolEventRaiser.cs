using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace sutee.GameEvents2 {
    public class BoolEventRaiser : BaseGameEventRaiser<bool> {
        public override BaseGameEvent<bool> GameEvent { get { return _gameEvent; } set { _gameEvent = (BoolEvent)value;  } }
        [SerializeField][Tooltip("The ScriptableObject Event to be Raised.")]
        public BoolEvent _gameEvent;
    }
}
