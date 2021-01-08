import Foundation
import AppInvokeSDK
class AllInOneSDKSwiftWrapper: FlutterViewController{
    lazy var viewController = UIApplication.shared.windows.first?.rootViewController
    let appinvoke = AIHandler()
    var flutterCallbackResult: FlutterResult?
    func startTransaction(parameters: [String:Any], callBack: @escaping FlutterResult) {
        self.flutterCallbackResult = callBack
        if let mid = parameters["mid"] as? String, let callbackUrl = parameters["callbackUrl"] as? String, let isStaging = parameters["isStaging"] as? Bool, let orderId = parameters["orderId"] as? String, let transactionToken = parameters["txnToken"] as? String, let amount = parameters["amount"] as? String {
            DispatchQueue.main.async {
              var env:AIEnvironment = .production
              if isStaging {
                env = .staging
              } else {
                env = .production
              }
              self.appinvoke.openPaytm(merchantId: mid, orderId: orderId, txnToken: transactionToken, amount: amount, callbackUrl: callbackUrl, delegate: self, environment: env)
            }
        }
    }
}
extension AllInOneSDKSwiftWrapper: AIDelegate {
//    func didFinish(with status: AIPaymentStatus, response: [String : Any]) {
//        <#code#>
//    }
//
    func didFinish(with status: AIPaymentStatus, response: [String : Any]) {
        self.flutterCallbackResult?(response)
    }
    func openPaymentWebVC(_ controller: UIViewController?) {
        if let vc = controller {
            DispatchQueue.main.async {[weak self] in
              self?.viewController?.present(vc, animated: true, completion: nil)
            }
        }
    }
}
