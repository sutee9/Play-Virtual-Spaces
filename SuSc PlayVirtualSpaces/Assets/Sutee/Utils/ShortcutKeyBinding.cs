using UnityEngine;
using UnityEngine.Events;

namespace sutee.Utils { 
[System.Serializable]
    public class ShortcutKeyBinding
    {
        public KeyCode key;
        [Tooltip("Action executed when key is pressed")]
        public UnityEvent action;
        [Tooltip("Action executed when key is released")]
        public UnityEvent actionRelease;
        [Tooltip("Use this shortcut. Useful for temporarily deactivating shortcuts which cause problems.")]
        public bool active = true;
    }
}