/*
 * This is the UnderWaterEffect.cs script.
 * 
 * This script will be used to 'animate' the custom-written shader.
 * We will be doing this by grabbing a certain value of the shader,
 * and adjusting it a certain amount by time.
 * 
 * We will be serializing the variables so that they will be easier to adjust.
 */

using UnityEngine;

[ExecuteInEditMode]
public class UnderWaterEffect : MonoBehaviour
{
    [SerializeField] private Material _heatValueMaterial; // The material we will be using to adjust.

    [SerializeField] private float _timeMultiplier; // We will be using this float to multiply Unity's built-in Time.time.
    [SerializeField] private float _minimumValue; // The minimum value we will be working with.
    [SerializeField] private float _maximumValue; // The maximum value we will be working with.

    float PingPong(float aValue, float aMin, float aMax)
    {
        return Mathf.PingPong(aValue, aMax - aMin) + aMin;
    }

    /*
     * My take on Mathf.PingPong.
     * Slightly modified, so that it doesn't necessarily need to go back and forth on 0 (as minimum value).
     * In this case, 0 gets replaced by float _minimumValue.
     */

    void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        if (_heatValueMaterial != null)
        {
            _heatValueMaterial.SetFloat("_StrengthOfWaves", PingPong((Time.time * _timeMultiplier), _minimumValue, _maximumValue));
        }
    }

    /*
     * OnRenderImage: Gets called after the scene gets rendered.
     * This allows the scene to get adjusted by Image Effects.
     * 
     * SetFloat(First parameter: The name of the value in the shader that will get adjusted, second: value that will replace parameter one)
     */
}

