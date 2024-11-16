using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    [SerializeField] private Camera m_Camera;
    [SerializeField] private ForceManager m_ForceManagerPrefab;

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
        
        m_ForceManager = Instantiate(m_ForceManagerPrefab);
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
