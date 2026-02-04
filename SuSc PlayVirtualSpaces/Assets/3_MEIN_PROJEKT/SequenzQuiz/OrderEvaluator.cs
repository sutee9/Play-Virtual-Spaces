using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class OrderEvaluator : MonoBehaviour
{
    public int[] correctSequence;

    public UnityEvent whenCorrect;
    public UnityEvent whenWrong;
    public UnityEvent onReset;

    public float resetAfter = 5f;
    private int _currSequenceIndex = 0;
    private bool _acceptingReports = true;

    [Space]
    public int[] reportedSequence;
    // Start is called before the first frame update
    void Start()
    {
        if (correctSequence.Length > 0)
        {
            reportedSequence = new int[correctSequence.Length];
        }
    }

    public void Reset()
    {
        _currSequenceIndex = 0;
        _acceptingReports = true;
        onReset.Invoke();
        if (correctSequence.Length > 0)
        {
            reportedSequence = new int[correctSequence.Length];
        }
    }

    public void Report(int number)
    {
        if (_currSequenceIndex >= reportedSequence.Length)
        {
            Debug.Log("OrderEvaluator: Over Index");
            return;
        }
        if (!_acceptingReports)
        {
            Debug.LogWarning("Order Evaluator: Currently not accepting reports. Reset first");
            return;
        }

        //Add Report to Answer Sequence
        reportedSequence[_currSequenceIndex] = number;

        //Check if Sequence is full and should be evaluated
        if (_currSequenceIndex == reportedSequence.Length - 1)
        {
            _acceptingReports = false;
            bool correct = true;
            for (int i = 0; i < reportedSequence.Length; i++)
            {
                if (correctSequence[i] != reportedSequence[i])
                {
                    correct = false;
                    break;
                }
            }

            if (correct)
            {
                whenCorrect.Invoke();
            }
            else
            {
                whenWrong.Invoke();
            }
            Invoke("Reset", resetAfter);
        }
        else
        {
            _currSequenceIndex++;
        }
        
    }
}
