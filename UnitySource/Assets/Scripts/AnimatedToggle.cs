using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class AnimatedToggle : Toggle
{
    public Animator toggleAnimator;

    protected override void Start()
    {
        toggleAnimator = GetComponent<Animator>();
    }

    public override void OnPointerClick(PointerEventData eventData)
    {
        base.OnPointerClick(eventData);
        toggleAnimator.SetBool("IsOn", isOn);
    }
}
