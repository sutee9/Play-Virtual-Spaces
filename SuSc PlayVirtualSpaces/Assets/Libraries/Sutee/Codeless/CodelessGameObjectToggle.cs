using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/**
 * Toggles a Game Object Active, Inactive depending on it's current state.
 */
public class CodelessGameObjectToggle : MonoBehaviour
{
    public GameObject objectToToggle;

    [Space]
    public bool log = true;

    public void Toggle()
    {
        if (objectToToggle.activeSelf)
        {
            if (log) Debug.Log(name + " toggles On");
            objectToToggle.SetActive(false);
        }
        else{
            if (log) Debug.Log(name + " toggles Off");
            objectToToggle.SetActive(true);
        }
    }
}
