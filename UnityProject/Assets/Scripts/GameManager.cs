using System.Collections;
using System.Collections.Generic;
using JetBrains.Annotations;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using UniRx;

public class GameManager : MonoBehaviour
{
    [SerializeField] private Camera m_Camera;
    [SerializeField] private ForceManager m_ForceManagerPrefab;
    [SerializeField] private GameObject m_FirePrefab;
    [SerializeField] private Transform m_FireParent;
    [SerializeField] private GameObject m_HolePrefab;
    
    [SerializeField] private Button m_ChangeSceneButton;
    // [SerializeField] private Button m_LeftButton;
    // [SerializeField] private Button m_RightButton;
    // [SerializeField] private Button m_UpButton;
    // [SerializeField] private Button m_DownButton;
    [SerializeField] private TextMeshProUGUI m_AccelerationText; 

    private ForceManager m_ForceManager;
    private bool m_IsServer;

    private GameObject m_Hole;
    private List<GameObject> m_FireObjects = new List<GameObject>();
    
    void Awake()
    {
        //適当な場所にホール生成
        m_Hole = Instantiate(m_HolePrefab);
        m_Hole.transform.position = new Vector3(
            Random.Range(-9f, 9f),
            0.1f,
            Random.Range(-18.5f, 18.5f)
        );
        
        for (int i = 0; i < 44; i++)
        {
            if (i == 0 || i == 43)
            {
                for (int j = 0; j < 25; j++)
                {
                    GameObject tempFire = Instantiate(m_FirePrefab, m_FireParent);
                    m_FireObjects.Add(tempFire);
                    tempFire.transform.position = new Vector3(j - 12f, 0.5f, (21f - i) + 0.5f);
                }
            }
            else
            {
                GameObject tempFire0 = Instantiate(m_FirePrefab, m_FireParent);
                tempFire0.transform.position = new Vector3(-12f, 0.5f, (21f - i) + 0.5f);
                GameObject tempFire1 = Instantiate(m_FirePrefab, m_FireParent);
                tempFire1.transform.position = new Vector3(12f, 0.5f, (21f - i) + 0.5f);
                
                m_FireObjects.Add(tempFire0);
                m_FireObjects.Add(tempFire1);
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
    }

    void Update()
    {
        NativeState state = NativeStateManager.State;
        Vector3 stateVector = new Vector3(
            (float)state.x,
            (float)state.y,
            (float)state.z
        );
        
        m_AccelerationText.text = stateVector.ToString();
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
