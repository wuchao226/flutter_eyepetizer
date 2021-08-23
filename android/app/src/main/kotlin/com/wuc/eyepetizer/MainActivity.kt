package com.wuc.eyepetizer

import android.app.AlertDialog
import android.content.DialogInterface
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.devio.flutter.splashscreen.SplashScreen

class MainActivity : FlutterActivity() {
  private var mSpeechPlugin: SpeechPlugin? = null
  override fun onCreate(savedInstanceState: Bundle?) {
    SplashScreen.show(this, true)
    super.onCreate(savedInstanceState)
    // 初始化
    SpeechManager.instance.init(this)
  }

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    mSpeechPlugin = SpeechPlugin(this)
    //通过MethodChannel与原生通信
    MethodChannel(flutterEngine.dartExecutor, "speech_plugin")
      .setMethodCallHandler(mSpeechPlugin)
  }

  override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
    super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    if (requestCode == SpeechPlugin.RECOGNIZER_REQUEST_CODE) {
      if (grantResults.isNotEmpty()) {
        var grantedSize = 0
        for (grantResult in grantResults) {
          if (grantResult == PackageManager.PERMISSION_GRANTED) {
            grantedSize++
          }
        }
        if (grantedSize == grantResults.size) {
          mSpeechPlugin?.startRecognizer()
        } else {
          showWaringDialog()
        }
      } else {
        showWaringDialog()
      }
    }
  }

  private fun showWaringDialog() {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
      AlertDialog.Builder(this, android.R.style.Theme_Material_Light_Dialog_Alert)
        .setTitle(R.string.waring)
        .setMessage(R.string.permission_waring)
        .setPositiveButton(R.string.sure, DialogInterface.OnClickListener { dialog, which -> go2AppSettings() })
        .setNegativeButton(R.string.cancel, null).show()
    }
  }


  private fun go2AppSettings() {
    val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
    val uri = Uri.fromParts("package", packageName, null)
    intent.data = uri
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    startActivity(intent)
  }
}
