using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

[RequireComponent(typeof(Rigidbody))]
public class CodelessInteractable : MonoBehaviour
{
    [Tooltip("Show this explanation in the player HUD when the crosshair is over this interactable")]
    public string text;
    [Space]
    [Tooltip("Perform these actions when the configured collision event occurs (all at once).")]
    public UnityEvent OnInteract;
    [Space]
    UnityEvent OnFocus;
    UnityEvent OnFocusLost;

    [Space]
    public bool log = true;

    [TextArea]
    public string HowToUse = "Interactables sind Komponenten, mit denen Spieler per Mausklick interagieren können, falls es im Crosshair ist.\n" +
        "Sie benötigen: Einen Rigidbody + Einen Collider.";

    private Collider _coll;

    // Start is called before the first frame update
    void Awake()
    {
        Init();
    }

    /// <summary>
    /// If this Interactable is focused by the player. The InteractablePlayerComponent
    /// calls this method when the interactable comes into focus.
    /// </summary>
    /// <param name="active"></param>
    public void Focus(bool active)
    {
        Debug.Log("Interactable '" + name + "' received Focus=" + active);
        if (active)
        {
            if (OnFocus != null)
            {
                OnFocus.Invoke();
            }
        }
        else
        {
            if (OnFocusLost != null)
            {
                OnFocusLost.Invoke();
            }
        }
    }

    /// <summary>
    /// Executes all actions configured in this interactable.
    /// </summary>
    public void Interact()
    {
        Debug.Log("Interactable '" + name + "' will Interact");
        if (OnInteract != null)
        {
            OnInteract.Invoke();
        }
    }

    private void Init()
    {
        _coll = GetComponentInChildren<Collider>();
        if (_coll == null)
        {
            Debug.Log(name + "Init(): ERROR: Please add a collider to the CodelessInteractable for it to work.");
        }
        if (gameObject.tag != "Interactable")
        {
            Debug.Log(name + "Init(): ERROR: Please assign tag \"Interactable\" to this gameObject for it to work.");
        }
    }
}
