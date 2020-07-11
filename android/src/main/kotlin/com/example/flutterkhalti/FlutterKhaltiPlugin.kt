package com.example.flutterkhalti

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.os.Handler
import android.os.Looper
import com.khalti.checkout.helper.Config
import com.khalti.checkout.helper.KhaltiCheckOut
import com.khalti.checkout.helper.OnCheckOutListener
import com.khalti.checkout.helper.PaymentPreference
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.lang.Exception


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
        when (call.method) {
            "khalti#start" -> {
                initKhaltiPayment(call.arguments as HashMap<*, *>)
                result.success(true)
            }
            "khalti#startPayment" -> {
                startPayment(call)
                result.success(true)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    fun startPayment(call: MethodCall) {
        val message = call.arguments as HashMap<String, Any>
        val publicKey: String = message["publicKey"] as String
        val product: HashMap<String, Any> = message["product"] as HashMap<String, Any>
        val paymentPreferences: List<PaymentPreference> = (message["paymentPreferences"] as List<String>).map {
            getPreference(it)
        }

        val builder = Config.Builder(
                publicKey,
                product["id"] as String,
                product["name"] as String,
                (product["amount"] as Double).toLong(),
                object : OnCheckOutListener {
                    override fun onSuccess(data: MutableMap<String, Any>) {
                        channel.invokeMethod("khalti#paymentSuccess", data)
                    }

                    override fun onError(action: String, errorMap: MutableMap<String, String>) {
                        val errorMessage: HashMap<String, String> = HashMap()
                        errorMessage["action"] = action
                        errorMessage["message"] = errorMap.toString()
                        channel.invokeMethod("khalti#paymentError", errorMessage)
                    }
                }
        )
                .paymentPreferences(paymentPreferences)
                .additionalData(product["customData"] as HashMap<String, Any>)
                .productUrl(product["url"] as String)

        val khaltiCheckOut = KhaltiCheckOut(context, builder.build())
        context.runOnUiThread {
            khaltiCheckOut.show()
        }
    }

    fun initKhaltiPayment(params: HashMap<*, *>) {
        val paymentPreferences: List<String> = params["paymentPreferences"] as List<String>

        val builder = Config.Builder(params["publicKey"] as String, params["productId"] as String, params["productName"] as String, (params["amount"] as Double).toLong(), object : OnCheckOutListener {
            override fun onSuccess(data: MutableMap<String, Any>) {
                channel.invokeMethod("khalti#success", data)
            }


            override fun onError(action: String, errorMap: MutableMap<String, String>) {
                val errorMessage: HashMap<String, String> = HashMap()
                errorMessage["action"] = action
                errorMessage["message"] = errorMap.toString()
                channel.invokeMethod("khalti#success", errorMessage)
            }
        })
                .additionalData(params["customData"] as Map<String, Any>?)
                .productUrl(params["productUrl"] as String)
                .paymentPreferences(paymentPreferences.map {
                    getPreference(it)
                })
        val khaltiCheckOut = KhaltiCheckOut(context, builder.build())
        context.runOnUiThread {
            khaltiCheckOut.show()
        }
    }

    fun getPreference(type: String): PaymentPreference {
        when (type) {
            "khalti" -> return PaymentPreference.KHALTI
            "ebanking" -> return PaymentPreference.EBANKING
            "mobilecheckout" -> return PaymentPreference.MOBILE_BANKING
            "connectips" -> return PaymentPreference.CONNECT_IPS
            "sct" -> return PaymentPreference.SCT
        }
        throw  Exception("Invalid khalti payment type")
    }
}
