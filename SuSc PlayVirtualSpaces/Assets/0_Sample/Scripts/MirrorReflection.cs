using UnityEngine;

public class MirrorReflection : MonoBehaviour
{
    public Camera mainCamera;  // Die Hauptkamera in der Szene
    public Camera mirrorCamera;  // Die Kamera für die Spiegelreflexion
    public Transform mirrorSurface;  // Das Transform des Spiegels (Plane oder Quad)

    void LateUpdate()
    {
        // Berechne die reflektierte Position der Kamera relativ zum Spiegel
        Vector3 cameraToMirror = mirrorSurface.position - mainCamera.transform.position;
        Vector3 reflectPos = mirrorSurface.position + Vector3.Reflect(cameraToMirror, mirrorSurface.forward);

        // Setze die Position der MirrorCamera auf die reflektierte Position
        mirrorCamera.transform.position = reflectPos;

        // Berechne die reflektierte Vorwärtsrichtung der Kamera und setze die Rotation der MirrorCamera
        Vector3 forward = Vector3.Reflect(mainCamera.transform.forward, mirrorSurface.forward);
        mirrorCamera.transform.rotation = Quaternion.LookRotation(forward, Vector3.up);

        // Flip die Kamera auf der X-Achse, um die Spiegelung zu korrigieren
        mirrorCamera.projectionMatrix = mainCamera.projectionMatrix * Matrix4x4.Scale(new Vector3(-1, 1, 1));
    }
}