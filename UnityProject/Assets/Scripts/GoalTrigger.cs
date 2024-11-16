using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GoalTrigger : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    void OnCollisionEnter(Collision collision)
    {
        // 衝突したオブジェクトの名前を取得（例: Player）
        if (collision.gameObject.CompareTag("Player"))
        {
            Debug.Log("ゴールに衝突しました！");
            // 例: ゲームクリアの処理
            GameClear();
        }
    }

    void GameClear()
    {
        Debug.Log("ゲームクリア！");
    }

    // Update is called once per frame
    void Update()
    {
    }
}