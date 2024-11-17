using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UniRx;

public class HoleCollisionController : MonoBehaviour
{
    public struct HoleCollisionInfo
    {
        public float StaySeconds;
        public Vector3 HolePosition;

        public HoleCollisionInfo(float staySeconds, Vector3 holePosition)
        {
            StaySeconds = staySeconds;
            HolePosition = holePosition;
        }
    }
    
    private bool m_Staying = false;
    private bool m_StayEnd = false;
    private float m_StayCounter = 0f;
    
    private Subject<HoleCollisionInfo> m_StaySubject = new Subject<HoleCollisionInfo>();
    public IObservable<HoleCollisionInfo> OnStaySubject => m_StaySubject;
    
    void Awake()
    {
        m_Staying = false;
        m_StayEnd = false;
        m_StayCounter = 0f;
    }

    void Update()
    {
        if (m_StayCounter >= 3f && !m_StayEnd)
        {
            // m_StaySubject.OnNext(new HoleCollisionInfo(
            //     m_StayCounter,
            //     transform.position
            // ));
            m_StayEnd = true;
        }

        if (m_Staying)
        {
            m_StayCounter += Time.deltaTime;
            m_StaySubject.OnNext(new HoleCollisionInfo(
                m_StayCounter,
                transform.position
            ));
        }
        else if(m_StayCounter != 0f)
        {
            m_StayCounter = 0f;
        }
    }
    
    void OnTriggerEnter(Collider other)
    {
        // 衝突したオブジェクトの名前を取得
        if (other.gameObject.CompareTag("Sphere"))
        {
            Debug.Log("holeに衝突");
            m_Staying = true;
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (other.gameObject.CompareTag("Sphere"))
        {
            Debug.Log("holeから離脱");
            m_Staying = false;
        }
    }
}
