using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cysharp.Threading.Tasks;

public class EffectManager : MonoBehaviour
{
    [SerializeField] private ParticleSystem m_ClearEffectPrefab;
    [SerializeField] private ParticleSystem m_StayEffectPrefab;
    
    private ParticleSystem m_ClearEffect;
    private ParticleSystem m_StayEffect;
    
    void Awake()
    {
        m_ClearEffect = Instantiate(m_ClearEffectPrefab);
        m_StayEffect = Instantiate(m_StayEffectPrefab);
    }
    
    public async UniTask PlayClear(Vector3 position)
    {
        m_ClearEffect.transform.position = position;
        m_ClearEffect.Play();
        await UniTask.WaitForSeconds(2f);
        m_ClearEffect.Stop();
    }
    
    public void StartStayEffect(Vector3 position)
    {
        m_StayEffect.gameObject.SetActive(true);
        m_StayEffect.transform.position = position;
        m_StayEffect.Play();
    }

    public void StopStayEffect(Vector3 position)
    {
        m_StayEffect.gameObject.SetActive(false);
        m_StayEffect.Stop();
    }
}
