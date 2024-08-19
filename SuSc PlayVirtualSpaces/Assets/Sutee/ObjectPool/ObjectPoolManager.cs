using System;
using System.Collections.Generic;
using UnityEngine;

namespace sutee.ObjectPool { 

	public class ObjectPoolManager : GenericSingleton<ObjectPoolManager>
	{
		public bool logStatus;
		public Transform root;
		public int defaultPoolSize = 1;
		public bool defaultPoolExtensibility = true;
		public bool parkInsteadOfDeactivate = false;
		public Vector3 parkPosition = new Vector3(0f, 1000f, 0f);

		private Dictionary<GameObject, ObjectPool<GameObject>> prefabLookup;
		private Dictionary<GameObject, ObjectPool<GameObject>> instanceLookup;

		private bool dirty = false;

        protected override void Awake()
		{
			base.Awake();
			Ready();
		}

		void Ready()
        {
			prefabLookup = new Dictionary<GameObject, ObjectPool<GameObject>>();
			instanceLookup = new Dictionary<GameObject, ObjectPool<GameObject>>();
		}
		void Update()
		{
			if (logStatus && dirty)
			{
				PrintStatus();
				dirty = false;
			}
		}

		public void warmPool(GameObject prefab, int size)
		{
			warmPool(prefab, size, defaultPoolExtensibility);
		}

		public void warmPool(GameObject prefab, int size, bool allowExtension)
		{
			if (prefabLookup.ContainsKey(prefab))
			{
				throw new Exception("Pool for prefab " + prefab.name + " has already been created");
			}
			var pool = new ObjectPool<GameObject>(() => { return InstantiatePrefab(prefab); }, size, allowExtension );
			prefabLookup[prefab] = pool;

			dirty = true;
		}

		public GameObject spawnObject(GameObject prefab)
		{
			return spawnObject(prefab, Vector3.zero, Quaternion.identity);
		}

		public GameObject spawn(GameObject prefab)
		{
			if (prefabLookup == null)
            {
				Ready();
            }
			if (!prefabLookup.ContainsKey(prefab))
			{
				//Debug.Log("[Pool] Did not contain key " + prefab);
				WarmPool(prefab, defaultPoolSize);
			}
			var pool = prefabLookup[prefab];

			var clone = pool.GetItem();
			if (clone == null)
            {
				return null;
            }
			else {
				if (parkInsteadOfDeactivate)
                {
					clone.transform.position = new Vector3(0f, 0f, 0f);
				}
				clone.SetActive(true);
				
				instanceLookup.Add(clone, pool);
				dirty = true;
				return clone;
			}
		}

		public GameObject spawnObject(GameObject prefab, Vector3 position, Quaternion rotation)
		{
			var clone = spawn(prefab);
			if (clone == null)
			{
				return null;
			}
			else
			{
				clone.transform.position = position;
				clone.transform.rotation = rotation;
				return clone;
			}
		}

		

		public GameObject spawnObject(GameObject prefab, Transform parent, bool worldPositionStays = true)
		{
			var clone = spawn(prefab);
			if (clone == null)
			{
				return null;
			}
			else
			{
				clone.transform.SetParent(parent, worldPositionStays);
				return clone;
			}
		}

		/**
		 * Return a pooled object to the pool. Use this instead of Destroy when dealing with pooled objects.
		 */
		public void releaseObject(GameObject clone, bool reparentToPool = true)
		{
			if (parkInsteadOfDeactivate)
			{
				clone.transform.position = parkPosition;
			}
			else
			{
				clone.SetActive(false);
			}
			

			if (instanceLookup.ContainsKey(clone))
			{
				instanceLookup[clone].ReleaseItem(clone);
				instanceLookup.Remove(clone);
				if (reparentToPool) { 
					clone.transform.SetParent(root, false);
				}
				dirty = true;
			}
			else
			{
				Debug.LogWarning("No pool contains the object: " + clone.name);
			}
		}


		private GameObject InstantiatePrefab(GameObject prefab)
		{
			var go = Instantiate(prefab) as GameObject;
			if (root != null) go.transform.parent = root;
			return go;
		}

		public void PrintStatus()
		{
			foreach (KeyValuePair<GameObject, ObjectPool<GameObject>> keyVal in prefabLookup)
			{
				Debug.Log(string.Format("Object Pool for Prefab: {0} In Use: {1} Total {2}", keyVal.Key.name, keyVal.Value.CountUsedItems, keyVal.Value.Count));
			}
		}

		#region Static API

		public static void WarmPool(GameObject prefab, int size)
		{
			Instance.warmPool(prefab, size);
		}

		public static GameObject SpawnObject(GameObject prefab)
		{
			return Instance.spawnObject(prefab);
		}

		public static GameObject SpawnObject(GameObject prefab, Vector3 position, Quaternion rotation)
		{
			return Instance.spawnObject(prefab, position, rotation);
		}

		public static void ReleaseObject(GameObject clone)
		{
			Instance.releaseObject(clone);
		}

		#endregion
	}
}