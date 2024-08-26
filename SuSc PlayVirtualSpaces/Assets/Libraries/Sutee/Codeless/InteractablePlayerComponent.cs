using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using sutee.GameEvents2;

/// <summary>
/// The InteractablePlayerComponent must be placed on the player
/// It will target forward (z-positive) to raycast with a range of Range.
/// If the ray hits CodelessInteractable with the Interactable-tag, it will
/// trigger its Focus method (true) if it leaves again, it will Focus(false).
/// It will also display the interactables tooltipText in the playerHud.
/// If the player clicks the left mouse button while Focusing on an object, then the
/// interactables Interact method will be called, and all actions therin be executed.
///
/// If used with a first person controller, the raySource is the mainCamera.
/// </summary>
public class InteractablePlayerComponent : MonoBehaviour
{
    

    [Range(5f, 150f)]
    public float range = 50f;
    public GameObject raySource;

    [Space]
    public StringEvent setTextInHUD;
    public VoidEvent clearTextInHUD;

    [Space]
    public bool showRay = true;
    private string _interactableTag = "Interactable";
    private CodelessInteractable _currentInteractable;

    private void Awake()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        Vector3 fwd = raySource.transform.TransformDirection(Vector3.forward);
        if (showRay) Debug.DrawRay(raySource.transform.position, fwd * 50, Color.green);

        RaycastHit hit;
        if (Physics.Raycast(raySource.transform.position, fwd, out hit, range))
        {
            //do something if hit object ie
            if (hit.collider.tag == _interactableTag)
            {
                Collider coll = hit.collider;
                CodelessInteractable interactable = coll.GetComponent<CodelessInteractable>();
                if (interactable != null)
                {
                    if (_currentInteractable != null && interactable != _currentInteractable)
                    {
                        _currentInteractable.Focus(false);
                        clearTextInHUD.Raise();
                    }

                    if (interactable != _currentInteractable) { 
                        _currentInteractable = interactable;

                        setTextInHUD.Raise(interactable.text);
                        _currentInteractable.Focus(true);
                    }

                    if (Input.GetMouseButtonDown(0) || Input.GetKeyDown("e") || Input.GetKeyDown(KeyCode.E))
                    {
                        _currentInteractable.Interact();
                    }
                }
                else
                {
                    Debug.Log("Encountered Misconfigured Interactable with name " + coll + ". Missing CodelessInteractable Component");
                }
            }
            else if (_currentInteractable != null)
            {
                _currentInteractable.Focus(false);
                _currentInteractable = null;
                clearTextInHUD.Raise();
            }
            
        }

    }
}
