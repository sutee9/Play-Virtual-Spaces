using UnityEngine;

namespace sutee.GameEvents2  {
    [CreateAssetMenu(fileName="New String Game Event" , menuName = "Sutee/Game Events/String Event", order = 0)][System.Serializable]
    public class StringEvent : BaseGameEvent<string>{}
}