using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.Runtime;

namespace sutee.GameEvents2 {

    [CustomEditor(typeof(FloatEventRaiser))]
    public class FloatEventRaiserEditor : Editor
    {
        public override void OnInspectorGUI()
        {
            DrawDefaultInspector();
            FloatEventRaiser raiser = (FloatEventRaiser)target;
            if (GUILayout.Button("Raise Event"))
            {
               raiser.RaiseConfigured();
            }
        }
    }
}
