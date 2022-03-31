using System.Runtime.InteropServices;
using UnityEngine;

namespace FlutterUnityPlugin
{
    public class Message
    {
        public int id;
        public string data;

        public Message() { }

		public Message(
			int id,
			string data
			) {
			this.id = id;
			this.data = data;
		}

        public static Message FromJson(string json)
        {
            return JsonUtility.FromJson<Message>(json);
        }

        public string ToJson()
        {
            return JsonUtility.ToJson(this);
        }
    }

    public static class Messages
    {
        public static void Send(Message message)
        {
            string data = message.ToJson();

            if (Application.platform == RuntimePlatform.Android)
            {
                using (AndroidJavaClass FlutterUnityPluginClass = new AndroidJavaClass("com.glartek.flutter_unity.FlutterUnityPlugin"))
                {
                    FlutterUnityPluginClass.CallStatic("onMessage", data);
                }
            }
            else
            {
                #if UNITY_IOS
                FlutterUnityPluginOnMessage(data);
                #endif

                #if UNITY_WEBGL
                SendMessageToWeb(message.data);
                #endif				
            }
        }

        public static Message Receive(string data)
        {
            if (Application.platform == RuntimePlatform.WebGLPlayer) {
				Message message = new Message(0, data);
				return message;
			}
            return Message.FromJson(data);
        }

        #if UNITY_IOS
        [DllImport("__Internal")]
        private static extern void FlutterUnityPluginOnMessage(string data);
        #endif

        #if UNITY_WEBGL
        [DllImport("__Internal")]
		private static extern void SendMessageToWeb(string data);
        #endif
    }
}
