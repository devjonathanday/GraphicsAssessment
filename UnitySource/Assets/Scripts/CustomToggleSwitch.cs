using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.UI;

public class CustomToggleSwitch : MonoBehaviour
{
    public TextMeshProUGUI OnOffLabel;
    public Toggle toggleSwitch;
    public FireTruck truck;
    
    void Update()
    {
        toggleSwitch.interactable = truck.deployed;
    }

    public void ChangeText(string newText)
    {
        OnOffLabel.text = newText;
    }
}