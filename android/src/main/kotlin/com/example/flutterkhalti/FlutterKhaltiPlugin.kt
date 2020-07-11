package com.example.flutterkhalti

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.os.Handler
import android.os.Looper
import com.khalti.checkout.helper.Config
import com.khalti.checkout.helper.KhaltiCheckOut
import com.khalti.checkout.helper.OnCheckOutListener
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar


class FlutterKhaltiPlugin : MethodCallHandler {
    companion object {
        @SuppressLint("StaticFieldLeak")
        lateinit var context: Activity
        lateinit var channel: MethodChannel

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            context = registrar.activity()
            channel = MethodChannel(registrar.messenger(), "flutter_khalti")
            channel.setMethodCallHandler(FlutterKhaltiPlugin())
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "khalti#start") {
            initKhaltiPayment(call.arguments as HashMap<*, *>)
        } else {
            result.notImplemented()
        }
    }

    fun initKhaltiPayment(params: HashMap<*, *>) {
        val builder = Config.Builder(params["publicKey"] as String, params["productId"] as String, params["productName"] as String, (params["amount"] as Double).toLong(), object : OnCheckOutListener {
            override fun onSuccess(data: MutableMap<String, Any>) {
                channel.invokeMethod("khalti#success", data)
            }
            override fun onError(action: String, errorMap: MutableMap<String, String>) {
                var errorMessage: HashMap<String, String> = HashMap()
                errorMessage["action"] = action
                errorMessage["message"] = errorMap.toString()
                channel.invokeMethod("khalti#error", errorMessage)
            }
        })
                .additionalData(params["customData"] as Map<String, Any>?)
                .productUrl(params["productUrl"] as String)
        val khaltiCheckOut = KhaltiCheckOut(context, builder.build())
        context.runOnUiThread{
            khaltiCheckOut.show()
        }
    }
}
