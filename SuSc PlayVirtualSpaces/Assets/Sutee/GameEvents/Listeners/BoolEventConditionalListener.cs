using UnityEngine;

namespace sutee.GameEvents2 {

    public class BoolEventConditionalListener : BaseGameEventListener <bool, BoolEvent, UnityBoolEvent> {
        [SerializeField][Tooltip("While the standard responder only responds to requests when true, this responder responds only when false.")]
        private UnityBoolEvent falseEventResponse;

        public override void OnEventRaised(bool item)
        {
            if (item) { 
                base.OnEventRaised(!item);
            }
            else
            {
                if (falseEventResponse != null)
                {
                    falseEventResponse.Invoke(item);
                }
            }
        }
    }
}