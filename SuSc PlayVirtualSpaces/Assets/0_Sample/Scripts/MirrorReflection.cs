using UnityEngine;

public class MirrorReflection : MonoBehaviour
{
    public Camera mirrorCamera;
    public Transform mirrorSurface;

    void Update()
    {
        Vector3 cameraDirectionWorldSpace = Camera.main.transform.position - mirrorSurface.position;
        Vector3 reflectionDirection = Vector3.Reflect(cameraDirectionWorldSpace, mirrorSurface.up);

        mirrorCamera.transform.position = mirrorSurface.position + reflectionDirection;
        mirrorCamera.transform.LookAt(mirrorSurface.position);
    }
}