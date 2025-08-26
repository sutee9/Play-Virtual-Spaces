using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

namespace sutee.Sound {

    [CreateAssetMenu(fileName = "New Sound Asset", menuName = "Sutee/Sound/Sound Asset", order = 0)]
    public class SoundAsset : ScriptableObject
    {
        [Tooltip("The tag by which this Sound Asset can be requested. Must be unique")]
        public string tag;
        [Tooltip("Audio clip with sound effect.")]
        public AudioClip clip;
        [Range(0, 1)]
        public float volume = 1f;
        public bool loop = false;
        [Range(0.1f, 10)]
        public float pitch = 1f;
    }
}
