//
//  InternetManager.swift
//  SkyLink
//
//  Created by Adebayo Sotannde on 10/22/25.
//
//

import Foundation
import Network
import UIKit

final class InternetManager
{
    
    static let shared = InternetManager()
    private init() {}

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    private(set) var isConnected: Bool = false

    func startMonitoring()
    {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            let newStatus = path.status == .satisfied

            if self.isConnected != newStatus {
                self.isConnected = newStatus
                DispatchQueue.main.async {
                    if newStatus {
                        print("Internet connection restored")
                    } else {
                        self.showNoInternetAlert()
                    }
                }
            }
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring()
    {
        monitor.cancel()
    }

    /// Public helper that can be called from anywhere
    func checkConnectionAndAlertIfNeeded() -> Bool
    {
        if !isConnected
        {
            DispatchQueue.main.async {
                self.showNoInternetAlert()
            }
        }
        return isConnected
    }

    // MARK: - Alert Presentation
    private func showNoInternetAlert()
    {
        guard let topVC = topViewController() else { return }
        let alert = UIAlertController(
            title: "No Internet Connection",
            message: "Please check your connection and try again.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        if topVC.presentedViewController == nil {
            topVC.present(alert, animated: true)
        }
    }

    private func topViewController(base: UIViewController? = UIApplication.shared.connectedScenes
        .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
        .first?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController {
            return topViewController(base: tab.selectedViewController)
        } else if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
