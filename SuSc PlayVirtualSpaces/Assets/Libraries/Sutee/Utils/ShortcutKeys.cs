using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.Events;

namespace sutee.Utils { 
    public class ShortcutKeys : MonoBehaviour {

        public ShortcutKeyBinding[] keyBindings;
        // Update is called once per frame
        void Update () {
            foreach (ShortcutKeyBinding keyBinding in keyBindings)
            {
                if (Input.GetKeyDown(keyBinding.key))
                {
                    if (keyBinding.active) {
                        //Debug.Log("HEY");
                        keyBinding.action.Invoke();
                    }
                }
                if (Input.GetKeyUp(keyBinding.key))
                {
                    if (keyBinding.active)
                    {
                        keyBinding.actionRelease.Invoke();
                    }
                }
            }
        }
    }
}