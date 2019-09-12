using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BuildingFire : MonoBehaviour
{
    public ParticleSystem[] fireEmitters;
    [Range(0, 1)]
    public float fireIntensity;
    public float maxEmission;
    public float extinguishDecay;
    
    void Update()
    {
        for (int i = 0; i < fireEmitters.Length; i++)
        {
            ParticleSystem.EmissionModule emission = fireEmitters[i].emission;
            emission.rateOverTime = fireIntensity * maxEmission;
        }
    }

    private void OnParticleCollision(GameObject other)
    {
        fireIntensity -= extinguishDecay;
        if (fireIntensity < 0) fireIntensity = 0;
    }
}