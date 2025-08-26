using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShortcutToggleActive : MonoBehaviour
{
    public GameObject[] objectsToToggleActive;
    bool[] _toggleStates;
    bool _init = false;
    private void Awake()
    {
        RefreshState();
    }

    public void RefreshState()
    {
        if (objectsToToggleActive != null)
        {
            _toggleStates = new bool[objectsToToggleActive.Length];
        }
        for (int i = 0; i < objectsToToggleActive.Length; i++)
        {
            _toggleStates[i] = objectsToToggleActive[i].activeSelf;
        }
        _init = true;
    }

    public void Toggle()
    {
        Debug.Log("Toggle");
        if (!_init)
        {
            RefreshState();
        }

        for (int i = 0; i < objectsToToggleActive.Length; i++)
        {
            _toggleStates[i] = !_toggleStates[i];
            objectsToToggleActive[i].SetActive(_toggleStates[i]);
        }
    }
}
