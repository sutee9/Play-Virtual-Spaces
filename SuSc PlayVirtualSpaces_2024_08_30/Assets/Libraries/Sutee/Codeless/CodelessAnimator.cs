using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CodelessAnimator : MonoBehaviour
{
    [Tooltip("The animation clip to play. Use an Event to then trigger the PlayClip1 method")]
    public AnimationClip clip1;
    [Tooltip("The animation clip to play. Use an Event to then trigger the PlayClip2 method")]
    public AnimationClip clip2;
    [Tooltip("The animation clip to play. Use an Event to then trigger the PlayClip3 method")]
    public AnimationClip clip3;
    [Tooltip("The animation clip to play. Use an Event to then trigger the PlayClip4 method")]
    public AnimationClip clip4;

    private Animation _anim;

    private void Awake()
    {
        _anim = GetComponent<Animation>();
        if (_anim == null)
        {
            _anim = gameObject.AddComponent<Animation>();
        }
        _anim.playAutomatically = false;
        _anim.Play();


        
        if (clip1 != null) {
            clip1.legacy = true;
            _anim.AddClip(clip1, "clip1");
        }
        if (clip2 != null)
        {
            clip2.legacy = true;
            _anim.AddClip(clip2, "clip2");
        }
        if (clip3 != null)
        {
            clip3.legacy = true;
            _anim.AddClip(clip3, "clip3");
        }
        if (clip4 != null)
        {
            clip4.legacy = true;
            _anim.AddClip(clip4, "clip4");
        }
    }

    public void PlayClip1()
    {
        PlayClip("clip1");
    }

    public void PlayClip2()
    {
        PlayClip("clip2");
    }

    public void PlayClip3()
    {
        PlayClip("clip3");
    }

    public void PlayClip4()
    {
        PlayClip("clip4");
    }

    protected void PlayClip(string name)
    {
        if (_anim.isPlaying)
        {
            _anim.Stop();
            _anim.Rewind();
        }
        _anim.Play(name);
    }
}
