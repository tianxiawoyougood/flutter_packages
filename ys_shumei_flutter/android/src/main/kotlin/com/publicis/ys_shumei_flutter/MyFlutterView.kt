package com.publicis.ys_shumei_flutter

import android.content.Context
import android.os.Build
import android.util.Log
import android.view.View
import android.widget.FrameLayout
import android.widget.Toast
import androidx.annotation.RequiresApi
import com.ishumei.sdk.captcha.SmCaptchaWebView
import com.ishumei.sdk.captcha.SmCaptchaWebView.ResultListener
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import java.util.*

class MyFlutterView(
    private val context: Context?,
    messenger: BinaryMessenger,
    viewId: Int,
    args: Map<String, Any>?
) : PlatformView,
    MethodChannel.MethodCallHandler {

    private val TAG: String = "MyFlutterView"
    private val channel: MethodChannel = MethodChannel(
        messenger, "shumei_method_channel_$viewId"
    )
    private var captchaWebView: SmCaptchaWebView? = null

    init {
        channel.setMethodCallHandler(this)
        Log.i(TAG, "init")
    }

    override fun getView(): View {

        return initSmCaptchaWebView()
    }

    override fun dispose() {
        destroyCaptchaWebView()
    }

    fun dip2px(context: Context, dpValue: Double): Int {
        val scale = context.resources.displayMetrics.density
        return (dpValue * scale + 0.5f).toInt()
    }

    private fun initSmCaptchaWebView(): SmCaptchaWebView{
        if (captchaWebView == null) {
            captchaWebView = SmCaptchaWebView(context)
        }
        return captchaWebView!!
    }
    @RequiresApi(Build.VERSION_CODES.KITKAT)
    private fun setSmCaptchaWebView(arguments: Map<String,Objects>, result: MethodChannel.Result) {
        Log.i(TAG, "context = $context")
        //设置滑块信息
        val width = dip2px(context!!, arguments["width"] as Double)
        val lp = FrameLayout.LayoutParams(
            width, width / 3 * 2
        )
        captchaWebView?.layoutParams = lp

        // 初始化验证码WebView
        val option = SmCaptchaWebView.SmOption()
        option.organization = arguments["organization"] as String // 必填，组织标识
        option.appId = arguments["appId"] as String // 必填，应用标识

        option.mode = SmCaptchaWebView.MODE_SLIDE
        val listener: ResultListener = object : ResultListener {
            override fun onReady() {
                channel.invokeMethod("onReady","onReady")
            }

            override fun onError(code: Int) {
                channel.invokeMethod("onError","验证失败，请重试")
            }

            override fun onSuccess(rid: CharSequence, pass: Boolean) {
                if(pass){
                    channel.invokeMethod("pass",rid)
                }else{
                    channel.invokeMethod("no_pass","验证失败，请重试")
                }
            }
        }
        val code = captchaWebView?.initWithOption(option, listener)
        println("code: $code")
    }

    @RequiresApi(Build.VERSION_CODES.KITKAT)
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when(call.method){
            "initSmCaptchaWebView" -> setSmCaptchaWebView(call.arguments as Map<String,Objects>,result)
            "destroySmCaptchaWebView" -> destroyCaptchaWebView()
            "reload"->relod()
        }
    }

    private fun relod(){
        if (captchaWebView != null){
            captchaWebView!!.reload()
        }
    }

    private fun destroyCaptchaWebView() {
        if (captchaWebView != null) {
            captchaWebView!!.clearAnimation()
            captchaWebView!!.clearCache(true)
            captchaWebView!!.destroy()
            captchaWebView = null
        }
    }
}
