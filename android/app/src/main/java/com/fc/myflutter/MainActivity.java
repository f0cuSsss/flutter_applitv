package com.fc.Applitv;

import android.os.Bundle;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.view.FlutterView;



public class MainActivity extends FlutterActivity {

  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);
    new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(new 
      MethodChannel.MethodCallHandler() {
          @Override
          public void onMethodCall(MethodCall call, MethodChannel.Result result) {

              if(call.method.equals("helloFromNativeCode")){
                  String greetings = helloFromNativeCode();
                  result.success(greetings);
              }

          }
      }
    );
  }
}