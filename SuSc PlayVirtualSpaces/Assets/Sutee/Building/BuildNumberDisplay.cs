namespace sutee.Utils
{
    using TMPro;
    using UnityEngine;

    [RequireComponent(typeof(TextMeshProUGUI))]
    public class BuildNumberDisplay : MonoBehaviour
    {
        private TextMeshProUGUI Text;

        private void Awake()
        {
            Text = GetComponent<TextMeshProUGUI>();
            ResourceRequest request = Resources.LoadAsync("Build", typeof(BuildNumber));
            request.completed += Request_completed;
        }

        private void Request_completed(AsyncOperation obj)
        {
            BuildNumber buildScriptableObject = ((ResourceRequest)obj).asset as BuildNumber;

            if (buildScriptableObject == null)
            {
                Debug.LogError("Build scriptable object not found in resources directory! Check build log for errors!");
            }
            else
            {
                Text.SetText($"Build: {Application.version}.{buildScriptableObject.buildNumber}");
            }
        }
    }
}

