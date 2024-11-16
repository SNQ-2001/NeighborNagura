using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UniRx;

public class HoleCollisionController : MonoBehaviour
{
    private bool m_Staying = false;
    private bool m_StayEnd = false;
    private float m_StayCounter = 0f;
    
    private Subject<Vector3> m_StaySubject = new Subject<Vector3>();
    public IObservable<Vector3> OnStaySubject => m_StaySubject;
    
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
            Debug.Log("stay 3 seconds");
            m_StaySubject.OnNext(transform.position);
            m_StayEnd = true;
        }

        if (m_Staying)
        {
            m_StayCounter += Time.deltaTime;
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
