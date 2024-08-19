using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

namespace sutee.Sound
{
    public class SoundEffectsLibrary : MonoBehaviour
    {
        public SoundAsset[] library;
        private Dictionary<string, SoundAsset> _lib;

        private void Awake()
        {
            _lib = new Dictionary<string, SoundAsset>();
            if (library != null) { 
                foreach (SoundAsset sass in library)
                {
                    _lib.Add(sass.tag, sass);
                }
            }
        }

        public SoundAsset GetSoundByTag(string tag)
        {
            SoundAsset ret;
            if (_lib.TryGetValue(tag, out ret))
            {
                return ret;
            }
            else
            {
                return null;
            }
        }

    }
}