using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BuildingFire : MonoBehaviour
{
    public ParticleSystem[] fireEmitters;
    [Range(0, 1)]
    public float fireIntensity;
    public float maxEmission;
    
    void Update()
    {
        for (int i = 0; i < fireEmitters.Length; i++)
        {
            ParticleSystem.EmissionModule emission = fireEmitters[i].emission;
            emission.rateOverTime = fireIntensity * maxEmission;
        }
    }
}