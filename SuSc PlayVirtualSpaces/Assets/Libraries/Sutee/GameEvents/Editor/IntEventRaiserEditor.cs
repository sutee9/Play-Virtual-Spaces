using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.Runtime;

namespace sutee.GameEvents2 {

    [CustomEditor(typeof(IntEventRaiser))]
    public class IntEventRaiserEditor : Editor
    {
        public override void OnInspectorGUI()
        {
            DrawDefaultInspector();
            IntEventRaiser raiser = (IntEventRaiser)target;
            if (GUILayout.Button("Raise Event"))
            {
               raiser.RaiseConfigured();
            }
        }
    }
}
