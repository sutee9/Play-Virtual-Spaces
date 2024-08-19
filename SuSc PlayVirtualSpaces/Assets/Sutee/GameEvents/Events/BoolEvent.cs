using UnityEngine;

namespace sutee.GameEvents2  {
    [CreateAssetMenu(fileName="New Bool Game Event" , menuName ="Sutee/Game Events/Bool Event", order = 0)][System.Serializable]
    public class BoolEvent : BaseGameEvent<bool>{}
}