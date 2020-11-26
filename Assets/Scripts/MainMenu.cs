using System.Collections;
using System.Collections.Generic;

using UnityEngine;
using UnityEngine.SceneManagement;

public class MainMenu : MonoBehaviour
{
    public Animator transition;

    public void LoadLevelManager() 
    {
        StartCoroutine(_LoadLevelManager());
    }

    IEnumerator _LoadLevelManager()
   {
        transition.SetTrigger("CrossfadeStart");
        yield return new WaitForSeconds(1);
        SceneManager.LoadScene("LevelManager");
   }


}
