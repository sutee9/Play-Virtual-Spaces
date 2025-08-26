using UnityEngine;

namespace sutee.GameEvents2 {

    public class VoidEventToggleListener : BaseGameEventListener <Void, VoidEvent, UnityVoidEvent> {
        public bool initialToggle = false;
        [SerializeField][Tooltip("Whenever a Void Event of this type occurs, this listener runs the either the On or the off event. The toggle is flipped BEFORE running the response. It also always runs the standard event response.")]
        private UnityBoolEvent toggleOnEventResponse;
        [SerializeField]
        [Tooltip("Whenever a Void Event of this type occurs, this listener runs the either the On or the off event. The toggle is flipped BEFORE running the response. It also always runs the standard event response.")]
        private UnityBoolEvent toggleOffEventResponse;

        public override void OnEventRaised(Void item)
        {
            initialToggle = !initialToggle;
            base.OnEventRaised(item);
            if (initialToggle)
            {
                if (toggleOnEventResponse != null)
                {
                    toggleOnEventResponse.Invoke(initialToggle);
                }
            }
            else
            {
                if (toggleOffEventResponse != null)
                {
                    toggleOffEventResponse.Invoke(initialToggle);
                }
            }
        }
    }
}