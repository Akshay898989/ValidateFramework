//
//  Extensions.swift
//
//
//  Created by akshaygupta on 09/07/24.
//

#if canImport(UIKit)
import UIKit
#endif

#if canImport(UIKit)
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
#endif

#if canImport(UIKit)
extension UserDefaults {
    enum Keys {
        static let surveyPerformedStatus = "surveyPerformedStatus"
        static let surveyPerformTime = "surveyPerformTime"
    }
    
    var surveyPerformedStatus: [String: Int] {
        get {
            return dictionary(forKey: Keys.surveyPerformedStatus) as? [String: Int] ?? [:]
        }
        set {
            set(newValue, forKey: Keys.surveyPerformedStatus)
        }
    }
    
    var surveyPerformTime: [String: Date] {
        get {
            return dictionary(forKey: Keys.surveyPerformTime) as? [String: Date] ?? [:]
        }
        set {
            set(newValue, forKey: Keys.surveyPerformTime)
        }
    }
}
#endif

