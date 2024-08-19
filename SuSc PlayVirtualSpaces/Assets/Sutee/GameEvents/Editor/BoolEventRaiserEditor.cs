using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.Runtime;

namespace sutee.GameEvents2 {

    [CustomEditor(typeof(BoolEventRaiser))]
    public class BoolEventRaiserEditor : Editor
    {
        public override void OnInspectorGUI()
        {
            DrawDefaultInspector();
            BoolEventRaiser raiser = (BoolEventRaiser)target;
            if (GUILayout.Button("Raise Event"))
            {
               raiser.RaiseConfigured();
            }
        }
    }
}
