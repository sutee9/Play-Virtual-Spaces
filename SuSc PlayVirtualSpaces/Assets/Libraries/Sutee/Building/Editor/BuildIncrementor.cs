namespace sutee.Utils { 

    using UnityEditor;
    using UnityEditor.Build;
    using UnityEditor.Build.Reporting;
    using UnityEngine;

    public class BuildIncrementor : IPreprocessBuildWithReport
    {
        public int callbackOrder => 1;

        public void OnPreprocessBuild(BuildReport report)
        {
            BuildNumber buildScriptableObject = AssetDatabase.LoadAssetAtPath<BuildNumber>("Assets/Resources/Build.asset");
            
            if (null == buildScriptableObject)
            {
                buildScriptableObject = ScriptableObject.CreateInstance<BuildNumber>();
                AssetDatabase.CreateAsset(buildScriptableObject, "Assets/Resources/Build.asset"); // create the new one with correct build number before build starts
            }
            
            switch (report.summary.platform)
            {
                case BuildTarget.StandaloneOSX:
                    PlayerSettings.macOS.buildNumber = IncrementBuildNumber(PlayerSettings.macOS.buildNumber);
                    buildScriptableObject.buildNumber = PlayerSettings.macOS.buildNumber;
                    break;
                case BuildTarget.iOS:
                    PlayerSettings.iOS.buildNumber = IncrementBuildNumber(PlayerSettings.iOS.buildNumber);
                    buildScriptableObject.buildNumber = PlayerSettings.iOS.buildNumber;
                    break;
                case BuildTarget.Android:
                    PlayerSettings.Android.bundleVersionCode++;
                    buildScriptableObject.buildNumber = PlayerSettings.Android.bundleVersionCode.ToString();
                    break;
                case BuildTarget.PS4:
                    PlayerSettings.PS4.appVersion = IncrementBuildNumber(PlayerSettings.PS4.appVersion);
                    buildScriptableObject.buildNumber = PlayerSettings.PS4.appVersion;
                    break;
                case BuildTarget.XboxOne:
                    PlayerSettings.XboxOne.Version = IncrementBuildNumber(PlayerSettings.XboxOne.Version);
                    buildScriptableObject.buildNumber = PlayerSettings.XboxOne.Version;
                    break;
                case BuildTarget.WSAPlayer:
                    PlayerSettings.WSA.packageVersion = new System.Version(PlayerSettings.WSA.packageVersion.Major, PlayerSettings.WSA.packageVersion.Minor, PlayerSettings.WSA.packageVersion.Build + 1);
                    buildScriptableObject.buildNumber = PlayerSettings.WSA.packageVersion.Build.ToString();
                    break;
                case BuildTarget.Switch:
                    PlayerSettings.Switch.displayVersion = IncrementBuildNumber(PlayerSettings.Switch.displayVersion);
                    PlayerSettings.Switch.releaseVersion = IncrementBuildNumber(PlayerSettings.Switch.releaseVersion);
                    // which one to use?
                    buildScriptableObject.buildNumber = PlayerSettings.Switch.displayVersion;
                    break;
                case BuildTarget.tvOS:
                    PlayerSettings.tvOS.buildNumber = IncrementBuildNumber(PlayerSettings.tvOS.buildNumber);
                    buildScriptableObject.buildNumber = PlayerSettings.tvOS.buildNumber;
                    break;
                default:
                    Debug.Log("Platform: " +report.summary.platform + " does not seem to provide buildNumber implementation. Using proprietary only.");
                    buildScriptableObject.buildNumber = IncrementBuildNumber(buildScriptableObject.buildNumber); //Windows does not support build numbers.
                    break;
            }
            EditorUtility.SetDirty(buildScriptableObject);
            Debug.Log("Current Build Number: " + buildScriptableObject.buildNumber);
            AssetDatabase.SaveAssets();
        }

        private string IncrementBuildNumber(string buildNumber)
        {
            int.TryParse(buildNumber, out int outputBuildNumber);

            return (outputBuildNumber + 1).ToString();
        }
    }
}