using UnityEngine;
using UnityEditor;

namespace sutee.GameEvents2 {

    [CustomEditor(typeof(StringEventRaiser))]
    public class StringEventRaiserEditor : Editor
    {
        public override void OnInspectorGUI()
        {
            DrawDefaultInspector();
            StringEventRaiser raiser = (StringEventRaiser)target;
            if (GUILayout.Button("Raise Event"))
            {
                raiser.RaiseConfigured();
            }
        }
    }
}
