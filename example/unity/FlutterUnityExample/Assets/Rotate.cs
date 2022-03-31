using System;
using UnityEngine;

public class Rotate : MonoBehaviour
{
    [SerializeField]
    private Vector3 v3;

    // Start is called before the first frame update
    void Start()
    {
        v3 = new Vector3(0, 0, 0);
    }

    // Update is called once per frame
    void Update()
    {
        gameObject.transform.Rotate(v3 * Time.deltaTime * 10);
    }

    public void SetRotationSpeed(string data)
    {        
        FlutterUnityPlugin.Message message = FlutterUnityPlugin.Messages.Receive(data);

        Debug.Log($"[DATA]: {message.data}");

        float value = float.Parse(message.data);

        v3 = new Vector3(value, value, value);

        message.data = "SetRotationSpeed: " + value;

        FlutterUnityPlugin.Messages.Send(message);
    }
}
