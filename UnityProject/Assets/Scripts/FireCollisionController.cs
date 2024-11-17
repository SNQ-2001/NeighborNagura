using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UniRx;

public class FireCollisionController : MonoBehaviour
{
    private bool m_OnFireEnd = false;
    private Subject<FireCollisionInfo> _fireSubject = new Subject<FireCollisionInfo>();
    public IObservable<FireCollisionInfo> OnFire => _fireSubject;
    
    public struct FireCollisionInfo
    {
        public Vector3 FirePosition;

        public FireCollisionInfo(Vector3 firePosition)
        {
            FirePosition = firePosition;
        }
    }
    void OnTriggerEnter(Collider other)
    {
        // 衝突したオブジェクトの名前を取得
        if (other.gameObject.CompareTag("Sphere"))
        {
            if (m_OnFireEnd) return;
            m_OnFireEnd = true;
            _fireSubject.OnNext(new FireCollisionInfo(other.transform.position));
        }
    }
}
