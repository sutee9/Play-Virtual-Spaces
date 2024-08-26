using UnityEngine;

namespace sutee.GameEvents2  {
    [CreateAssetMenu(fileName="New Int Int Game Event" , menuName = "Sutee/Game Events/Int Int Event", order = 1)][System.Serializable]
    public class IntIntEvent : BaseGameEvent<int, int>{}
}