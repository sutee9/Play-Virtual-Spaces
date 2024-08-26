using UnityEngine;

public class GenericSingleton<T> : MonoBehaviour where T : Component
{
    private static T instance;
    public static T Instance
    {
        get
        {
            if (instance == null)
            {
                instance = FindObjectOfType<T>();
                if (instance == null)
                {
                    GameObject obj = new GameObject();
                    obj.name = typeof(T).Name;
                    instance = obj.AddComponent<T>();
                }
            }
            return instance;
        }
    }

    protected virtual void Awake()
    {
        if (instance == null)
        {
            instance = this as T;
            Debug.Log("New Game Controller instantiated. stack=" + UnityEngine.StackTraceUtility.ExtractStackTrace());
            DontDestroyOnLoad(this.gameObject);
        }
        else
        {
            Debug.Log("Another singleton " + instance.name + " already existed. Destroying this: " + this.name);
            Destroy(gameObject);
        }
    }
}