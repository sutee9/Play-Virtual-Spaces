
namespace sutee.GameEvents2 {

    public class BoolEventListener : BaseGameEventListener <bool, BoolEvent, UnityBoolEvent> {
        public bool invertResponse = false;

        public override void OnEventRaised(bool item)
        {
            if (invertResponse)
            {
                base.OnEventRaised(!item);
            }
            else
            {
                base.OnEventRaised(item);
            }
           
        }
    }
}