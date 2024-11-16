using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class GameManager : MonoBehaviour
{
    [SerializeField] private Camera m_Camera;
    [SerializeField] private ForceManager m_ForceManagerPrefab;
    
    [SerializeField] private Button m_ChangeSceneButton;
    // [SerializeField] private Button m_LeftButton;
    // [SerializeField] private Button m_RightButton;
    // [SerializeField] private Button m_UpButton;
    // [SerializeField] private Button m_DownButton;
    [SerializeField] private TextMeshProUGUI m_AccelerationText; 

    private ForceManager m_ForceManager;
    private bool m_IsServer;
    
    void Awake()
    {
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
        
        Vector3 stateVector = new Vector3(
            (float)state.x,
            (float)state.y,
            (float)state.z
        );
        
        m_AccelerationText.text = stateVector.ToString();
        
        m_ForceManager = Instantiate(m_ForceManagerPrefab);
    }

    private Vector3 CalcCameraPosition(int userRole)
    {
        Vector3 cameraPos = new Vector3(
            0f,
            20f,
            0f
        );

        float upOffset = 5f;

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
