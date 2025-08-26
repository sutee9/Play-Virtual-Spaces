using UnityEngine;

namespace sutee.GameEvents2  {
    [CreateAssetMenu(fileName="New String Float Game Event" , menuName = "Sutee/Game Events/String-Float Event", order = 100)][System.Serializable]
    public class StringFloatEvent : BaseGameEvent<string, float>{}
}