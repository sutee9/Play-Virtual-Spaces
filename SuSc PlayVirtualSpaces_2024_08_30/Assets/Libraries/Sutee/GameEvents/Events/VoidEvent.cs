using UnityEngine;
using UnityEngine.Events;

namespace sutee.GameEvents2  {
    [CreateAssetMenu(fileName="New Void Game Event" , menuName = "Sutee/Game Events/Void Event", order = 0)][System.Serializable]
    public class VoidEvent : BaseGameEvent<Void>{
        public void Raise() => Raise(new Void());
    }
}