package com.example.guardini
import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import com.paytm.pgsdk.PaytmOrder
import com.paytm.pgsdk.PaytmPaymentTransactionCallback
import com.paytm.pgsdk.TransactionManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
 
class AllInOneSDKPlugin(var activity: Activity, var call: MethodCall, var result: MethodChannel.Result) {
    private val REQ_CODE = 0
    init {
            if (call.method == "startTransaction") {
                startTransaction()
            }
    }
    private fun startTransaction() {
        val arg = call.arguments as Map<*, *>?
        if (arg != null) {
            val mid = arg["mid"] as String?
            val orderId = arg["orderId"] as String?
            val amount = arg["amount"] as String?
            val txnToken = arg["txnToken"] as String?
            val callbackUrl = arg["callbackUrl"] as String?
            val isStaging = arg["isStaging"] as Boolean
            if (mid == null || orderId == null || amount == null || mid.isEmpty() || orderId.isEmpty() || amount.isEmpty()) {
                showToast("Please enter all field")
                return
            }
            if (txnToken == null || txnToken.isEmpty()) {
                showToast("Token error")
                return
            }
            initiateTransaction(mid, orderId, amount, txnToken, callbackUrl, isStaging)
        } else {
            showToast("Please send arguments")
        }
    }
    private fun initiateTransaction(mid: String, orderId: String, amount: String, txnToken: String, callbackUrl: String?, isStaging: Boolean) {
        var host = "https://securegw.paytm.in/"
        if (isStaging) {
            host = "https://securegw-stage.paytm.in/"
        }
        val callback = if (callbackUrl == null || callbackUrl.trim().isEmpty()) {
            host + "theia/paytmCallback?ORDER_ID=" + orderId
        } else {
            callbackUrl
        }
        val paytmOrder = PaytmOrder(orderId, mid, txnToken, amount, callback)
        val transactionManager = TransactionManager(paytmOrder, object : PaytmPaymentTransactionCallback {
            override fun onTransactionResponse(bundle: Bundle) {
        //Return in both cases if transaction is success or failure
                setResult("Payment Transaction response $bundle", true)
            }
            override fun networkNotAvailable() {
                setResult("networkNotAvailable", false)
            }
            override fun onErrorProceed(s: String) {
                setResult(s, false)
            }
            override fun clientAuthenticationFailed(s: String) {
                setResult(s, false)
            }
            override fun someUIErrorOccurred(s: String) {
                setResult(s, false)
            }
            override fun onErrorLoadingWebPage(iniErrorCode: Int, inErrorMessage: String, inFailingUrl: String) {
                setResult(inErrorMessage, false)
            }
            override fun onBackPressedCancelTransaction() {
                setResult("onBackPressedCancelTransaction", false)
            }
            override fun onTransactionCancel(s: String, bundle: Bundle) {
                setResult("$s $bundle", false)
            }
        })
        transactionManager.setShowPaymentUrl(host + "theia/api/v1/showPaymentPage")
        transactionManager.startTransaction(activity, REQ_CODE)
    }
    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == REQ_CODE && data != null) {
            val message = data.getStringExtra("nativeSdkForMerchantMessage")
            val response = data.getStringExtra("response")
    // data.getStringExtra("nativeSdkForMerchantMessage") this return message if transaction was stopped by users
    // data.getStringExtra("response") this returns the shared response if the transaction was successful or failure.
            if(response !=null &&  response.isNotEmpty()){
                setResult(response,true)
            }else{
                setResult(message,false)
            }
        }
    }
    private fun setResult(message: String, isSuccess: Boolean) {
        if (isSuccess) {

            result.success(message)

        } else {
            result.error("0", message, null)
        }
        // this .finish();

    }
    private fun showToast(message: String) {
        Toast.makeText(activity, message, Toast.LENGTH_LONG).show()
    }
    
}