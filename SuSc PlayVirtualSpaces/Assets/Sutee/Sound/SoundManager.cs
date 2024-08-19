using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;

namespace sutee.Sound
{
    [RequireComponent(typeof(SoundEffectsLibrary))]
    public class SoundManager : MonoBehaviour
    {
        public AudioMixerGroup sFXMixerGroup;

        SoundEffectsLibrary library;
        AudioSource[] player;
        public int numberSources = 10;

        private void Awake()
        {
            library = GetComponent<SoundEffectsLibrary>();

            player = new AudioSource[numberSources];
            for (int i=0; i<numberSources; i++)
            {
                GameObject go = new GameObject("Audio_Player_" + i);
                go.transform.SetParent(transform);
                go.transform.position = Vector3.zero;
                player[i] = go.AddComponent<AudioSource>();
                player[i].outputAudioMixerGroup = sFXMixerGroup;
                player[i].playOnAwake = false;
            }
            
        }

        public void PlaySound(string soundTag)
        {
            //Debug.Log("[SoundManager->PlaySound] " + soundTag);
            SoundAsset asset = library.GetSoundByTag(soundTag);
            if (asset == null)
            {
                Debug.LogWarning($"Sound with tag {soundTag} does not exist");
            }

            AudioSource freeSource = null;
            foreach (AudioSource src in player)
            {
                if (!src.isPlaying)
                {
                    freeSource = src;
                    break;
                }
            }

            if (freeSource != null)
            {
                freeSource.clip = asset.clip;
                freeSource.volume = asset.volume;
                freeSource.pitch = asset.pitch;
                freeSource.loop = asset.loop;
                freeSource.Play();
            }

        }

    }
}
