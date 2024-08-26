using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.Runtime;

namespace sutee.GameEvents2 {

    [CustomEditor(typeof(StringFloatEventRaiser))]
    public class StringFloatEventRaiserEditor : Editor
    {
        public override void OnInspectorGUI()
        {
            DrawDefaultInspector();
            StringFloatEventRaiser raiser = (StringFloatEventRaiser)target;
            if (GUILayout.Button("Raise Event"))
            {
               raiser.RaiseConfigured();
            }
        }
    }
}
