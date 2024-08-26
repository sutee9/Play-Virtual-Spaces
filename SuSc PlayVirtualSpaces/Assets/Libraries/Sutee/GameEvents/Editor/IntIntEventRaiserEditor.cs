using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.Runtime;

namespace sutee.GameEvents2 {

    [CustomEditor(typeof(IntIntEventRaiser))]
    public class IntIntEventRaiserEditor : Editor
    {
        public override void OnInspectorGUI()
        {
            DrawDefaultInspector();
            IntIntEventRaiser raiser = (IntIntEventRaiser)target;
            if (GUILayout.Button("Raise Event"))
            {
               raiser.RaiseConfigured();
            }
        }
    }
}
