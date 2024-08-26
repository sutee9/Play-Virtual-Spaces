using UnityEngine;

namespace sutee.ObjectPool { 
    public class ObjectPoolWarmer : MonoBehaviour
    {
        public GameObject prefab;
        public int initialPoolSize = 1;
        public bool allowExtensionOfPool = true;

        sutee.ObjectPool.ObjectPoolManager _poolManager;

        private void Awake()
        {
            _poolManager = ObjectPoolManager.Instance;
        
        }

        // Start is called before the first frame update
        void Start()
        {
            _poolManager.warmPool(prefab, initialPoolSize, allowExtensionOfPool);
        }
    }
}
