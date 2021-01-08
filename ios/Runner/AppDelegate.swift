import UIKit
import Flutter
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    let plugin = AllInOneSDKSwiftWrapper()
    var flutterCallbackResult: FlutterResult?
    override func application(_ app: UIApplication, open url: URL, options:
    [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let dict = self.separateDeeplinkParamsIn(url: url.absoluteString, byRemovingParams: nil)
        self.flutterCallbackResult?(dict) // MARK: Called to send response to flutter app in result parameter.
        return true
    }
    func separateDeeplinkParamsIn(url: String?, byRemovingParams rparams: [String]?)  -> [String: String] {
        guard let url = url else {
            return [String : String]()
        }
        /// This url gets mutated until the end. The approach is working fine in current scenario. May need a revisit.
        var urlString = stringByRemovingDeeplinkSymbolsIn(url: url)
        var paramList = [String : String]()
        let pList = urlString.components(separatedBy: CharacterSet.init(charactersIn: "&?//"))
        for keyvaluePair in pList {
            let info = keyvaluePair.components(separatedBy: CharacterSet.init(charactersIn: "="))
            if let fst = info.first , let lst = info.last, info.count == 2 {
                paramList[fst] = lst.removingPercentEncoding
                if let rparams = rparams, rparams.contains(info.first!) {
                    urlString = urlString.replacingOccurrences(of: keyvaluePair + "&", with: "")
                    //Please dont interchage the order
                    urlString = urlString.replacingOccurrences(of: keyvaluePair, with: "")
                }
            }
        }
        if let trimmedURL = pList.first {
            paramList["trimmedurl"] = trimmedURL
        }
        return paramList
    }
    func  stringByRemovingDeeplinkSymbolsIn(url: String) -> String {
        var urlString = url.replacingOccurrences(of: "$", with: "&")
        /// This may need a revisit. This is doing more than just removing the deeplink symbol.
        if let range = urlString.range(of: "&"), urlString.contains("?") == false{
            urlString = urlString.replacingCharacters(in: range, with: "?")
        }
        return urlString
    }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    //PAYTM START
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.example.guardini/epic",binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in

    // Note: this method is invoked on the UI thread.
        guard  call.method == "startTransaction" // Note: same method name as called by the flutter app.
        else {
            result(FlutterMethodNotImplemented)
            return
        }
        if let parameters = call.arguments as? [String: Any] {
            //print(parameters)
            self.flutterCallbackResult = result
            self.plugin.startTransaction(parameters: parameters, callBack: result)//MARK:calling method of AllInOneSwiftSDKWrapper with the callback result to be called from the wrapper
        }
    }
    //checkpoint 1
//    let dict = self.separateDeeplinkParamsIn(url: url.absoluteString, byRemovingParams: nil)
//        self.flutterCallbackResult?(dict) // MARK: Called to send response to flutter app in result parameter.
//        return true
    
    //PAYTM ENDS
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}


//MARK: response got in the URL can be segregated and converted into json from here.
