package com.wuc.eyepetizer

import io.flutter.plugin.common.MethodChannel

/**
 * @author     wuchao
 * @date       2021/8/21 23:36
 * @desciption
 */
class ResultStateful private constructor(private var result: MethodChannel.Result) : MethodChannel.Result {

  //防止语音识别回调多次(由于MethodChannel的通讯是一次性的，即调用和回调是一次性的)
  private var called = false

  companion object {
    fun of(result: MethodChannel.Result): ResultStateful {
      return ResultStateful(result)
    }
  }


  override fun success(result: Any?) {
    if (called) {
      return
    }
    called = true
    this.result.success(result)
  }

  override fun error(errorCode: String?, errorMessage: String?, errorDetails: Any?) {
    if (called) {
      return
    }
    called = true
    this.result.error(errorCode, errorMessage, errorDetails)
  }

  override fun notImplemented() {
    if (called) {
      return
    }
    called = true
    result.notImplemented()
  }
}