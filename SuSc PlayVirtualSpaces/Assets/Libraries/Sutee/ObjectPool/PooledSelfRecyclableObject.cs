using System.Collections;
using System.Collections.Generic;
using System.Threading;
using sutee.ObjectPool;
using UnityEngine;

public class PooledSelfRecyclableObject : MonoBehaviour
{
    float recycleAfterSeconds = 3f;
    private Coroutine timer;

    private void OnEnable()
    {
        timer = StartCoroutine(Timer());
    }

    IEnumerator Timer()
    {
        yield return new WaitForSeconds(recycleAfterSeconds);
        ObjectPoolManager.Instance.releaseObject(this.gameObject);
    }

    private void OnDisable()
    {
        if (timer != null)
        {
            StopCoroutine(timer);
        }
    }
}
