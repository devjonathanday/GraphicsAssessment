using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class FireTruck : MonoBehaviour
{
    [Header("Deploy")]
    public Vector3 deployedPosition;
    public bool deployed { get; private set; }
    public float moveLerp;

    [Header("Water")]
    public ParticleSystem waterEmitter;
    private ParticleSystem.MainModule main;
    private ParticleSystem.EmissionModule emission;

    public float waterPower;
    public bool waterEmitting = false;
    public float maxStartSpeed;

    void Update()
    {
        if (deployed)
        {
            transform.position = Vector3.Lerp(transform.position, deployedPosition, moveLerp);

            main = waterEmitter.main;
            emission = waterEmitter.emission;

            main.startSpeed = waterPower * maxStartSpeed;
            emission.enabled = waterEmitting;
        }
    }

    public void Deploy()
    {
        deployed = true;
    }

    public void ToggleWater(bool status)
    {
        waterEmitting = status;
    }
    public void UpdateWaterPower(float value)
    {
        waterPower = value;
    }
}