/**
 * Codeless collider is a convenience behaviour, helping beginners to 
 * use unity interactions without coding, and without the need to intrudice Bolt.
 * 
 * For simplicity's sake, it treats collsions and triggers the same! You can 
 * ignoreTriggers, or ignoreCollisions.
 */

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

[RequireComponent(typeof(Collider))]
public class CodelessCollider : MonoBehaviour
{

    private Collider _collider;
    public enum collisionAction { OnCollisionEnter, OnCollisionStay, OnCollisionExit, DoNothing }
    [Tooltip("When should something happen")]
    public collisionAction whenThisHappens;
    private collisionAction _whenThisHappensBackup;
    [Tooltip("When should something happen")]
    public string otherTag = "";
    [Space]
    [Tooltip("Perform this action when the configured collision event occur. (all at once)")]
    public UnityEvent doThis;

    [Space]
    [Tooltip("The collider will only trigger once, but the object will remain in the scene. ")]
    public bool mayOnlyUseOnce = false;
    [Tooltip("The object will be destroyed after the configured collision event occurs. It will first be disabled immediately, and then destroyed after 5 seconds.")]
    public bool destroyAfterCollision = false;
    private float afterSeconds=5f;


    [Header("Show Messages in Console")]
    [Tooltip("Show a message in the console if the configured collision event occurs with a collider with the specified tag.")]
    public bool log = true;
    [Tooltip("Show a message in the console for all collisions occuring with this Collider. Warning: Creates a LOT of messages.")]
    public bool logAll = false;

    [Header("Advanced")]
    [Tooltip("Normally, CodelessCollider reacts to both triggers and colliders. You can ignore one or the other, however. (Note: If you do, even logAll will not be firing on meeting another collider)")]
    public bool ignoreColliders = false;
    [Tooltip("Normally, CodelessCollider reacts to both triggers and colliders. You can ignore one or the other, however. (Note: If you do, even logAll will not be firing on meeting another trigger)")]
    public bool ignoreTriggers = false;

    private void Awake()
    {
        if (_collider == null)
        {
            Init();
        }
    }

    // Start is called before the first frame update
    void Start()
    {
        if (_collider == null)
        {
            Init();
        }
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (ignoreColliders) return;

        if (logAll)
        {
            Debug.Log(name + ".OnCollisionEnter with other object (tag=" + collision.gameObject.tag + ")");
        }

        if (whenThisHappens == collisionAction.OnCollisionEnter
            && (string.IsNullOrEmpty(otherTag) || collision.gameObject.CompareTag(otherTag)))
        {

            if (log && !logAll)
                Debug.Log(name + ".OnCollisionEnter(tag=" + collision.gameObject.tag + ") triggers configured action.");

            doThis.Invoke();
            if (destroyAfterCollision)
            {
                DisableAndDestroy(afterSeconds);
            }

        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (ignoreTriggers) return;

        if (logAll)
        {
            Debug.Log(name + ".OnTriggerEnter with other object (tag=" + other.tag + ")");
        }

        if (whenThisHappens == collisionAction.OnCollisionEnter
            && (string.IsNullOrEmpty(otherTag) || other.CompareTag(otherTag)))
        {

            if (log && !logAll)
                Debug.Log(name + ".OnTriggerEnter(tag=" + other.tag + ") triggers configured action.");

            doThis.Invoke();
            if (destroyAfterCollision) { 
                DisableAndDestroy(afterSeconds);
            }

        }
    }

    private void OnCollisionExit(Collision collision)
    {
        if (ignoreColliders) return;

        if (logAll)
        {
            Debug.Log(name + ".OnCollisionExit with other object (tag=" + collision.gameObject.tag + ")");
        }

        if (whenThisHappens == collisionAction.OnCollisionExit
            && (string.IsNullOrEmpty(otherTag) || collision.gameObject.CompareTag(otherTag)))
        {

            if (log && !logAll)
                Debug.Log(name + ".OnCollisionExit(tag=" + collision.gameObject.tag + ") triggers configured action.");

            doThis.Invoke();
            if (destroyAfterCollision)
            {
                DisableAndDestroy(afterSeconds);
            }

        }
    }
    private void OnTriggerExit(Collider other)
    {
        if (ignoreTriggers) return;

        if (logAll)
        {
            Debug.Log(name + ".OnTriggerExit with other object (tag=" + other.tag + ")");
        }

        if (whenThisHappens == collisionAction.OnCollisionExit
            && (string.IsNullOrEmpty(otherTag) || other.CompareTag(otherTag)))
        {

            if (log && !logAll)
                Debug.Log(name + ".OnTriggerExit(tag=" + other.tag + ") triggers configured action.");

            doThis.Invoke();
            if (destroyAfterCollision)
            {
                DisableAndDestroy(afterSeconds);
            }

        }
    }

    private void OnCollisionStay(Collision collision)
    {
        if (ignoreColliders) return;

        if (logAll)
        {
            Debug.Log(name + ".OnCollisionStay with other object (tag=" + collision.gameObject.tag + ")");
        }

        if (whenThisHappens == collisionAction.OnCollisionStay
            && (string.IsNullOrEmpty(otherTag) || collision.gameObject.CompareTag(otherTag)))
        {
            if (log && !logAll)
                Debug.Log(name + ".OnCollisionStay(tag=" + collision.gameObject.tag + ") triggers configured action.");

            doThis.Invoke();
            if (destroyAfterCollision)
            {
                DisableAndDestroy(afterSeconds);
            }

        }
    }


    private void OnTriggerStay(Collider other)
    {
        if (ignoreTriggers) return;

        if (logAll)
        {
            Debug.Log(name + ".OnTriggerStay with other object (tag=" + other.tag + ")");
        }

        if (whenThisHappens == collisionAction.OnCollisionStay
            && (string.IsNullOrEmpty(otherTag) || other.CompareTag(otherTag)))
        {

            if (log && !logAll)
                Debug.Log(name + ".OnTriggerExit(tag=" + other.tag + ") triggers configured action.");

            doThis.Invoke();
            if (destroyAfterCollision)
            {
                DisableAndDestroy(afterSeconds);
            }

        }
    }

    void Init()
    {
        _collider = GetComponent<Collider>();
        _whenThisHappensBackup = whenThisHappens;
    }

    public void DisableCollider()
    {
        whenThisHappens = collisionAction.DoNothing;
    }

    public void ReEnableCollider()
    {
        whenThisHappens = _whenThisHappensBackup;
    }

    void DisableAndDestroy(float delayTime)
    {
        DisableCollider();
        StartCoroutine(DelayAction(delayTime));
    }

    IEnumerator DelayAction(float delayTime)
    {
        yield return new WaitForSeconds(delayTime);

        Destroy(gameObject);
    }
}