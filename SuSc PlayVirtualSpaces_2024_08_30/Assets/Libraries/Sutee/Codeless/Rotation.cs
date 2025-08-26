using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotation : MonoBehaviour
{

    [System.Serializable]
    public enum Axis { X, Y, Z}

    public Axis rotationAxis;
    public float speed = 3f;

    // Update is called once per frame
    void Update()
    {
        Vector3 rotationVector = Vector3.zero;
        switch (rotationAxis)
        {
            case Axis.X:
                rotationVector = Vector3.right;
                break;
            case Axis.Y:
                rotationVector = Vector3.up;
                break;
            case Axis.Z:
                rotationVector = Vector3.forward;
                break;
        }
        
        transform.Rotate(rotationVector*speed*Time.deltaTime);
    }
}
