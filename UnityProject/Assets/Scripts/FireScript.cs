using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FireScript : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    void OnCollisionEnter(Collision collision)
    {
        // 衝突したオブジェクトの名前を取得
        if (collision.gameObject.CompareTag("Sphere"))
        {
            Debug.Log("Fireに衝突しました");
            
            // 例: ゲームクリアの処理
            GameOver();
        }
    }
    void GameOver()
    {
        Debug.Log("GAME OVER");
    }


    // Update is called once per frame
    void Update()
    {
        
    }
}
