using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class CodelessCounter : MonoBehaviour
{
    public TextMeshProUGUI counterTextField;

    public int score = 0;
    [Space][Tooltip("Disable if the Score should not be shown")]
    public bool showCodelessCounter = true;

    private void Start()
    {
        if (counterTextField == null)
        {
            Debug.Log(name + ".Start(): ERROR: Need to assign counter text field.");
        }
        counterTextField.text = score.ToString();

        this.gameObject.SetActive(showCodelessCounter);
    }

    public void Activate()
    {
        showCodelessCounter = true;
        this.gameObject.SetActive(showCodelessCounter);
    }

    public void Disactivate()
    {
        showCodelessCounter = false;
        this.gameObject.SetActive(showCodelessCounter);
    }

    public void AddOnePoint()
    {
        score++;
        counterTextField.text = score.ToString();
    }

    public void AddPoints(int points)
    {
        score = score + points;
        if (score < 0)
        {
            score = 0;
        }
        counterTextField.text = score.ToString();
    }

    public void RemovePoints(int points)
    {
        score = score - points;
        if (score < 0)
        {
            score = 0;
        }
        counterTextField.text = score.ToString();
    }

    public void ResetScore()
    {
        score = 0;
        counterTextField.text = score.ToString();
    }
}
