//MARK: - Functions
extension HomeViewController
{
    @objc internal func selectedServerTapped()
    {
        let viewController = ServerSelectionViewController()
        
        if let sheet = viewController.sheetPresentationController
        {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
            
            // Make it appear at the top
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        present(viewController, animated: true, completion: nil)
    }
    
    @objc internal func powerButtonTapped()
    {
        AppLogger.shared.log("[Home] Power Button Tapped")

        Task
        {
            let connected = await VPNManager.shared.isConnectedToVPN()
            AppLogger.shared.log("[Home]VPN Status is \(connected)")

            self.powerButtonView.isUserInteractionEnabled = false //Disables user from tapping button again
            defer { self.powerButtonView.isUserInteractionEnabled = true }

            if connected
            {
                AppLogger.shared.log("[Home] Disconnecting VPN and Stopping Tunnel")
                self.powerButtonView.setState(.disconnecting)
                VPNManager.shared.stopTunnel()
            } else
            {
                AppLogger.shared.log("[Home] Connecting VPN and Starting Tunnel")
                self.powerButtonView.setState(.connecting)
                VPNManager.shared.startTunnel()
            }
        }
    }
}
