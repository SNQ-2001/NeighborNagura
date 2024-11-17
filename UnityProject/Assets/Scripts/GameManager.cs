using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using UniRx;
using Cysharp.Threading.Tasks;

public class GameManager : MonoBehaviour
{
    [SerializeField] private Camera m_Camera;
    [SerializeField] private ForceManager m_ForceManagerPrefab;
    [SerializeField] private Transform m_FireParent;
    [SerializeField] private HoleCollisionController m_HolePrefab;
    [SerializeField] private FireCollisionController m_FirePrefab;
    [SerializeField] private EffectManager m_EffectManager;
    [SerializeField] private GameObject m_ClearCover;
    
    [SerializeField] private Button m_ChangeSceneButton;
    // [SerializeField] private Button m_LeftButton;
    // [SerializeField] private Button m_RightButton;
    // [SerializeField] private Button m_UpButton;
    // [SerializeField] private Button m_DownButton;
    [SerializeField] private TextMeshProUGUI m_AccelerationText; 

    private ForceManager m_ForceManager;
    private bool m_IsServer;
    private bool m_HoleEnd = false;
    private bool m_OnClearFlag = false;

    private HoleCollisionController m_Hole;
    private List<FireCollisionController> m_FireObjects = new List<FireCollisionController>();
    
    void Awake()
    {
        m_ClearCover.SetActive(false);
        
        //適当な場所にホール生成
        m_Hole = Instantiate(m_HolePrefab);
        // m_Hole.transform.position = new Vector3(
        //     Random.Range(-6.5f, 6.5f),
        //     0.1f,
        //     Random.Range(-18.5f, 18.5f)
        // );
        m_Hole.transform.position = new Vector3(
            5f,
            0.1f,
            13f
        );
        
        for (int i = 0; i < 44; i++)
        {
            if (i == 0 || i == 43)
            {
                for (int j = 0; j < 20; j++)
                {
                    FireCollisionController tempFire = Instantiate(m_FirePrefab, m_FireParent);
                    m_FireObjects.Add(tempFire);
                    tempFire.transform.position = new Vector3(j - 9f - 0.5f, 0.1f, (21f - i) + 0.5f);

                    tempFire.OnFire.Subscribe(info =>
                    {
                        OnFire(info.FirePosition);
                    }).AddTo(this);
                }
            }
            else
            {
                FireCollisionController tempFire0 = Instantiate(m_FirePrefab, m_FireParent);
                tempFire0.transform.position = new Vector3(-9f - 0.5f, 0.1f, (21f - i) + 0.5f);
                FireCollisionController tempFire1 = Instantiate(m_FirePrefab, m_FireParent);
                tempFire1.transform.position = new Vector3(9f + 0.5f, 0.1f, (21f - i) + 0.5f);
                
                m_FireObjects.Add(tempFire0);
                m_FireObjects.Add(tempFire1);
                
                tempFire0.OnFire.Subscribe(info =>
                {
                    OnFire(info.FirePosition);
                }).AddTo(this);
                
                tempFire1.OnFire.Subscribe(info =>
                {
                    OnFire(info.FirePosition);
                }).AddTo(this);
            }
        }
        
        NativeState state = NativeStateManager.State;
        int userRole = state.userRole;

        if (userRole == 0)
        {
            m_IsServer = true;
        }
        else
        {
            m_IsServer = false;
        }

        m_Camera.transform.position = CalcCameraPosition(userRole);
        
        m_ForceManager = Instantiate(m_ForceManagerPrefab);
        m_ChangeSceneButton.OnClickAsObservable().Subscribe((_) =>
        {
            NativeStateManager.GameClearUnity();
        }).AddTo(this);

        m_Hole.OnStaySubject.Subscribe(holeCollisionInfo =>
        {
            if (m_HoleEnd) return;
            m_HoleEnd = true;
            OnClear(holeCollisionInfo).Forget();
        }).AddTo(this);

        m_Hole.OnEnterSubject.Subscribe(info =>
        {
            OnEnter(info);
        }).AddTo(this);

        m_Hole.OnAwaySubject.Subscribe(info =>
        {
            OnAway(info);
        }).AddTo(this);
    }

    void Update()
    {
#if !UNITY_EDITOR
        if (m_IsServer)
        {
            NativeStateManager.SetHostPositionUnity(
                m_ForceManager.BallPosition.x,
                m_ForceManager.BallPosition.z
            );
        }
        else
        {
            m_ForceManager.BallPosition = new Vector3(
                NativeStateManager.State., //hostposition
                0.1f,
                NativeStateManager.State. //hostposition
            );
        }
#endif
        
        NativeState state = NativeStateManager.State;
        Vector3 stateVector = new Vector3(
            (float)state.x,
            (float)state.y,
            (float)state.z
        );
        
        m_AccelerationText.text = stateVector.ToString();
    }

    private void OnFire(Vector3 position)
    {
        Debug.Log("on fire");
        //エフェクトなど
#if !UNITY_EDITOR        
        NativeStateManager.GameOverUnity();
#endif
    }

    private async UniTask OnClear(HoleCollisionController.HoleCollisionInfo info)
    {
        Debug.Log("on clear");
        m_ForceManager.gameObject.SetActive(false);
        //エフェクトなど
        m_EffectManager.StopStayEffect(info.HolePosition);
        m_ClearCover.SetActive(true);
        await UniTask.WaitForSeconds(0.2f);
        await m_EffectManager.PlayClear(info.HolePosition);
#if !UNITY_EDITOR
        NativeStateManager.GameClearUnity();
#endif
    }

    private void OnEnter(HoleCollisionController.HoleCollisionInfo info)
    {
        Debug.Log("on enter");
        //エフェクトなど
        m_EffectManager.StartStayEffect(info.HolePosition);
    }

    private void OnAway(HoleCollisionController.HoleCollisionInfo info)
    {
        Debug.Log("on away");
        m_EffectManager.StopStayEffect(info.HolePosition);
    }

    private Vector3 CalcCameraPosition(int userRole)
    {
        Vector3 cameraPos = new Vector3(
            0f,
            20f,
            0f
        );

        float upOffset = 11f;

        if (userRole <= 1)
        {
            cameraPos += Vector3.forward * upOffset;
        }
        else
        {
            cameraPos -= Vector3.forward * upOffset;
        }

        if (userRole == 0 || userRole == 3)
        {
            cameraPos += Vector3.right * upOffset * Screen.width / Screen.height;
        }
        else
        {
            cameraPos -= Vector3.right * upOffset * Screen.width / Screen.height;
        }

        return cameraPos;
    }
}
