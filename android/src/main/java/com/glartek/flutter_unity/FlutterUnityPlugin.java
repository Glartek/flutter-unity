package com.glartek.flutter_unity;

import android.app.Activity;
import android.view.WindowManager;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

@Keep
public class FlutterUnityPlugin implements FlutterPlugin, ActivityAware {
    static List<FlutterUnityView> views = new ArrayList<>();

    private FlutterPluginBinding flutterPluginBinding;
    private int initialActivityRequestedOrientation;
    private Activity currentActivity;
    private FlutterUnityPlayer player;

    @Keep
    public static void onMessage(String data) {
        Log.d(String.valueOf(FlutterUnityPlugin.class), "onMessage: " + data);
        try {
            JSONObject jsonObject = new JSONObject(data);
            int messageId = jsonObject.getInt("id");
            String messageData = jsonObject.getString("data");
            for (FlutterUnityView view : FlutterUnityPlugin.views) {
                view.onMessage(messageData);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        Log.d(String.valueOf(this), "onAttachedToEngine");
        flutterPluginBinding = binding;
        binding.getPlatformViewRegistry().registerViewFactory("unity_view", new FlutterUnityViewFactory(this));
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        Log.d(String.valueOf(this), "onDetachedFromEngine");
        flutterPluginBinding = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        Log.d(String.valueOf(this), "onAttachedToActivity");
        onActivity(binding.getActivity());
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        Log.d(String.valueOf(this), "onDetachedFromActivityForConfigChanges");
        onActivity(null);
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        Log.d(String.valueOf(this), "onReattachedToActivityForConfigChanges");
        onActivity(binding.getActivity());
    }

    @Override
    public void onDetachedFromActivity() {
        Log.d(String.valueOf(this), "onDetachedFromActivity");
        onActivity(null);
    }

    FlutterPluginBinding getFlutterPluginBinding() {
        return flutterPluginBinding;
    }

    void resetScreenOrientation() {
        currentActivity.setRequestedOrientation(initialActivityRequestedOrientation);
    }

    FlutterUnityPlayer getPlayer() {
        return player;
    }

    private void onActivity(Activity activity) {
        if (activity != null) {
            initialActivityRequestedOrientation = activity.getRequestedOrientation();
            currentActivity = activity;
            player = new FlutterUnityPlayer(activity);
            activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
        } else {
            currentActivity = null;
            player.destroy();
            player = null;
        }
    }
}
