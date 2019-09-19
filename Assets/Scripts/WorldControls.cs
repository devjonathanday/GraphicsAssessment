using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class WorldControls : MonoBehaviour
{
    public GameObject worldCamera, playerCamera;
    private bool worldView = true;
    public GameObject worldCameraControls;

    public void Awake()
    {
        worldView = true;
        worldCamera.SetActive(true);
        playerCamera.SetActive(false);
    }

    public void SwitchCameras()
    {
        worldView = !worldView;

        if(worldView)
        {
            worldCamera.SetActive(true);
            playerCamera.SetActive(false);
            worldCameraControls.SetActive(true);
        }
        else
        {
            worldCamera.SetActive(false);
            playerCamera.SetActive(true);
            worldCameraControls.SetActive(false);
        }
    }
    public void ResetScene()
    {
        SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
    }
}