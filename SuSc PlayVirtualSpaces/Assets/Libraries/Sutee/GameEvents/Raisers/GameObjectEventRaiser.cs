using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace sutee.GameEvents2 { 
    public class GameObjectEventRaiser : BaseGameEventRaiser<GameObject> {
        public override BaseGameEvent<GameObject> GameEvent { get { return _gameEvent; } set { _gameEvent = (GameObjectEvent)value; } }
        [SerializeField]
        [Tooltip("The ScriptableObject Event to be Raised.")]
        private GameObjectEvent _gameEvent;

    }
}
