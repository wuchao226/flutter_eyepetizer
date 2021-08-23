package com.wuc.eyepetizer

import android.content.Context
import android.util.Log
import com.iflytek.cloud.InitListener
import com.iflytek.cloud.RecognizerResult
import com.iflytek.cloud.SpeechError
import com.iflytek.cloud.SpeechUtility
import com.iflytek.cloud.ui.RecognizerDialog
import com.iflytek.cloud.ui.RecognizerDialogListener
import org.json.JSONException
import org.json.JSONObject
import java.util.*

/**
 * @author     wuchao
 * @date       2021/8/22 11:14
 * @desciption
 */
class SpeechManager private constructor() {

  private var mIatDialog: RecognizerDialog? = null
  private val mIatResults: HashMap<String, String> = LinkedHashMap()

  companion object {
    private val TAG = SpeechManager::class.java.simpleName

    //    val instance = SpeechManager by lazy(LazyThreadSafetyMode.SYNCHRONIZED) { SpeechManager() }
    val instance = Holder.holder
  }

  private object Holder {
    val holder = SpeechManager()
  }

   fun init(context: Context) {
    //初始化科大讯飞语音
    SpeechUtility.createUtility(context, "appid=5e63940d")
    mIatDialog = RecognizerDialog(context, mInitListener)
    mIatDialog?.setListener(mRecognizerDialogListener)
  }

  private val mInitListener = InitListener { code: Int -> Log.d(TAG, "SpeechRecognizer init() code = $code") }

  fun recognize(recognizerResultListener: RecognizerResultListener) {
    if (mResultListener == null) {
      mResultListener = recognizerResultListener
    }
    mIatResults.clear()
    mIatDialog!!.show()
  }

  private var mRecognizerDialogListener: RecognizerDialogListener = object : RecognizerDialogListener {
    override fun onResult(results: RecognizerResult, isLast: Boolean) {
      printResult(results)
    }

    override fun onError(error: SpeechError) {
      if (mResultListener != null) {
        mResultListener?.onError(error.errorDescription)
      }
    }
  }

  private fun printResult(results: RecognizerResult) {
    val text: String = JsonParser.parseIatResult(results.resultString)
    var sn: String? = null
    // 读取json结果中的sn字段
    try {
      val resultJson = JSONObject(results.resultString)
      sn = resultJson.optString("sn")
    } catch (e: JSONException) {
      e.printStackTrace()
    }
    mIatResults[sn!!] = text
    val stringBuilder = StringBuilder()
    for (key in mIatResults.keys) {
      stringBuilder.append(mIatResults[key])
    }
    if (mResultListener != null) {
      mResultListener!!.onResult(stringBuilder.toString())
    }
  }

  private var mResultListener: RecognizerResultListener? = null

  interface RecognizerResultListener {
    fun onResult(result: String)
    fun onError(errorMsg: String)
  }

}
