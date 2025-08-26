using UnityEngine;

namespace sutee.GameEvents2  {
    [CreateAssetMenu(fileName="New Int Game Event" , menuName ="Sutee/Game Events/Int Event", order = 0)][System.Serializable]
    public class IntEvent : BaseGameEvent<int>{}
}