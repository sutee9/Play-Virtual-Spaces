using UnityEngine;

namespace sutee.GameEvents2  {
    [CreateAssetMenu(fileName="New Float Game Event" , menuName ="Sutee/Game Events/Float Event", order = 0)][System.Serializable]
    public class FloatEvent : BaseGameEvent<float>{}
}