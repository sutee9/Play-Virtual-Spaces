using UnityEngine;

namespace sutee.GameEvents2  {
    [CreateAssetMenu(fileName="New GameObject Game Event" , menuName = "Sutee/Game Events/GameObject Event", order = 0)][System.Serializable]
    public class GameObjectEvent : BaseGameEvent<GameObject>{}
}