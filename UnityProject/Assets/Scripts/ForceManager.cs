using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using UniRx;

public class ForceManager : MonoBehaviour
{
    [SerializeField] private GameObject m_BallPrefab;

    private GameObject m_Ball;
    private Rigidbody m_BallRigidBody;
    private Vector3 m_Acceleration = Vector3.zero;
    
    void Awake()
    {
        m_Ball = Instantiate(m_BallPrefab);
        m_Ball.transform.position = Vector3.zero + Vector3.up * 1f;
        m_BallRigidBody = m_Ball.GetComponent<Rigidbody>();

        // m_ChangeSceneButton.onClick.AsObservable().Subscribe((_) =>
        // {
        //     ChangeScene();
        // }).AddTo(this);
        //
        // m_LeftButton.onClick.AsObservable().Subscribe((_) =>
        // {
        //     m_Acceleration -= 0.1f * Vector3.right;
        // }).AddTo(this);
        //
        // m_RightButton.onClick.AsObservable().Subscribe((_) =>
        // {
        //     m_Acceleration += 0.1f * Vector3.right;
        // }).AddTo(this);
        //
        // m_UpButton.onClick.AsObservable().Subscribe((_) =>
        // {
        //     m_Acceleration += 0.1f * Vector3.forward;
        // }).AddTo(this);
        //
        // m_DownButton.onClick.AsObservable().Subscribe((_) =>
        // {
        //     m_Acceleration -= 0.1f * Vector3.forward;
        // }).AddTo(this);
    }

    void Update()
    {
        NativeState state = NativeStateManager.State;
        Vector3 stateVector = new Vector3(
            (float)state.x,
            (float)state.y,
            (float)state.z
        );
        m_Acceleration = new Vector3(
            stateVector.x * 20f,
            0f,
            stateVector.y * 20f
        );
        // m_AccelerationText.text = m_Acceleration.ToString();
        // m_AccelerationText.text = stateVector.ToString();
    }
    
    void LateUpdate()
    {
        m_BallRigidBody.AddForce(m_Acceleration);
    }

    private void ChangeScene()
    {
        //Swift側の関数を呼び出す
        NativeStateManager.EndGameScene();
    }
}
