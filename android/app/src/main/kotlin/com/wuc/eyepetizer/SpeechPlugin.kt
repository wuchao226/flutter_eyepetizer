package com.wuc.eyepetizer

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.text.TextUtils
import android.widget.Toast
import androidx.core.app.ActivityCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.text.SimpleDateFormat
import java.util.*

/**
 * @author     wuchao
 * @date       2021/8/21 21:55
 * @desciption
 */
class SpeechPlugin(var context: Context) : MethodChannel.MethodCallHandler, FlutterPlugin {
  companion object {
    const val RECOGNIZER_REQUEST_CODE = 0x0010
  }

  private var mResultStateful: ResultStateful? = null

  override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
    when (methodCall.method) {
      "time" -> result.success(SimpleDateFormat("yyyy-MM-dd hh:mm:ss", Locale.getDefault()).format(System.currentTimeMillis()))
      "toast" -> {
        val toString = methodCall.argument<String>("msg")
        if (methodCall.hasArgument("msg") && !TextUtils.isEmpty(toString)) {
          Toast.makeText(context, toString, Toast.LENGTH_LONG).show()
        } else {
          Toast.makeText(context, "msg 不能为空", Toast.LENGTH_SHORT).show()
        }
      }
      "start" -> {
        mResultStateful = ResultStateful.of(result)
        startRecognizer()
      }
      else -> {
        // 表明没有对应实现
        result.notImplemented()
      }
    }
  }

  // 启动识别器
  fun startRecognizer() {
    val checkResultList = checkPermissions()
    if (checkResultList.isNotEmpty()) {
      ActivityCompat.requestPermissions(context as Activity, checkResultList.toTypedArray(), RECOGNIZER_REQUEST_CODE)
    } else {
      SpeechManager.instance.recognize(recognizerResultListener)
    }
  }

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    //通过MethodChannel与原生通信
//    val methodChannel = MethodChannel(binding.binaryMessenger, "speech_plugin");
//    methodChannel.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
  }

  private var recognizerResultListener: SpeechManager.RecognizerResultListener = object : SpeechManager.RecognizerResultListener {
    override fun onResult(result: String) {
      if (mResultStateful != null) {
        mResultStateful?.success(result)
      }
    }

    override fun onError(errorMsg: String) {
      if (mResultStateful != null) {
        mResultStateful?.error(errorMsg, null, null)
      }
    }
  }

  private fun checkPermissions(): List<String> {
    val checkResultList: MutableList<String> = ArrayList()
    if (Build.VERSION.SDK_INT >= 23) {
      val permissions = arrayOf(
        Manifest.permission.WRITE_EXTERNAL_STORAGE,
        Manifest.permission.READ_PHONE_STATE,
        Manifest.permission.READ_EXTERNAL_STORAGE,
        Manifest.permission.RECORD_AUDIO, Manifest.permission.READ_CONTACTS,
        Manifest.permission.ACCESS_COARSE_LOCATION, Manifest.permission.ACCESS_FINE_LOCATION
      )
      for (permission in permissions) {
        if (ActivityCompat.checkSelfPermission(
            context,
            permission
          ) != PackageManager.PERMISSION_GRANTED
        ) {
          checkResultList.add(permission)
        }
      }
    }
    return checkResultList
  }
}