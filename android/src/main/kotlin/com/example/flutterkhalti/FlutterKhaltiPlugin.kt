package com.example.flutterkhalti

import android.annotation.SuppressLint
import android.content.Context
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import khalti.checkOut.api.Config
import khalti.checkOut.api.OnCheckOutListener
import khalti.checkOut.helper.KhaltiCheckOut


class FlutterKhaltiPlugin : MethodCallHandler {
    companion object {
        @SuppressLint("StaticFieldLeak")
        lateinit var context: Context
        lateinit var channel: MethodChannel

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            context = registrar.context()
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
        val config = Config(params["publicKey"] as String, params["productId"] as String, params["productName"] as String, params["productUrl"] as String, (params["amount"] as Double).toLong(), params["customData"] as HashMap<String, String>, object : OnCheckOutListener {
            override fun onSuccess(data: HashMap<String, Any>) {
                channel.invokeMethod("khalti#success", data)
            }

            override fun onError(action: String, message: String) {
                var errorMessage: HashMap<String, String> = HashMap()
                errorMessage["action"] = action
                errorMessage["message"] = message
                channel.invokeMethod("khalti#success", errorMessage)

            }
        })
        val khaltiCheckOut = KhaltiCheckOut(context, config)
        khaltiCheckOut.show()
    }
}
