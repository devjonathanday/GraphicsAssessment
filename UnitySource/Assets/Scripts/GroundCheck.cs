using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GroundCheck : MonoBehaviour
{
    public LayerMask groundLayers;
    public bool grounded { get; private set; }
    
    private void OnTriggerEnter(Collider other)
    {
        if(((1 << other.gameObject.layer) & groundLayers) != 0)
            grounded = true;
    }
    private void OnTriggerStay(Collider other)
    {
        if (((1 << other.gameObject.layer) & groundLayers) != 0)
            grounded = true;
    }
    private void OnTriggerExit(Collider other)
    {
        if (((1 << other.gameObject.layer) & groundLayers) != 0)
            grounded = false;
    }
}