using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraControls : MonoBehaviour
{
    public float rotationSpeed;
    private bool CWRotate, CCWRotate;

    void Update()
    {
        if(CWRotate) transform.RotateAround(Vector3.zero, Vector3.up, rotationSpeed);
        if(CCWRotate) transform.RotateAround(Vector3.zero, Vector3.up, -rotationSpeed);
    }

    public void StartRotation(bool clockwise)
    {
        if (clockwise) CWRotate = true;
        else CCWRotate = true;
    }
    public void StopRotation(bool clockwise)
    {
        if (clockwise) CWRotate = false;
        else CCWRotate = false;
    }
}