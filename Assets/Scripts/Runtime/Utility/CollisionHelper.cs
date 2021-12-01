using System;
using UnityEngine;

namespace Runtime.Utility
{
    public class CollisionHelper : MonoBehaviour
    {
        public Action<Collider> OnTriggerEnterEvent;
        public Action<Collider> OnTriggerStayEvent;
        public Action<Collider> OnTriggerExitEvent;
        
        public Action<UnityEngine.Collision> OnCollisionEnterEvent;
        public Action<UnityEngine.Collision> OnCollisionStayEvent;
        public Action<UnityEngine.Collision> OnCollisionExitEvent;
        
        private void OnTriggerEnter(Collider other)
        {
            OnTriggerEnterEvent?.Invoke(other);
        }

        private void OnTriggerStay(Collider other)
        {
            OnTriggerStayEvent?.Invoke(other);
        }

        private void OnTriggerExit(Collider other)
        {
            OnTriggerExitEvent?.Invoke(other);
        }

        private void OnCollisionEnter(UnityEngine.Collision other)
        {
            OnCollisionEnterEvent?.Invoke(other);
        }

        private void OnCollisionStay(UnityEngine.Collision other)
        {
            OnCollisionStayEvent?.Invoke(other);
        }

        private void OnCollisionExit(UnityEngine.Collision other)
        {
            OnCollisionExitEvent?.Invoke(other);
        }
    }
}