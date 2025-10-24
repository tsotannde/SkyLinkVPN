//
//  SetupViewController.swift
//  SkyLink
//
//  Created by Adebayo Sotannde on 10/22/25.
//

import UIKit
import FirebaseAuth

#warning("Change Design of Splash Screen")
class SplashViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = DesignSystem.AppColors.Themes.primaryColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8)
        {
            Task
            {
                await self.startAppFlow()
            }
        }
    }
    
    private func startAppFlow() async
    {
        
        guard InternetManager.shared.checkConnectionAndAlertIfNeeded() else
        {
            showNoInternetAlert()
            return
        }
        
        ServerFetcherManager.shared.fetchServers()
        KeyManager.shared.generateKeysIfNeeded(for: <#T##String#>)
        do {
            // Step 1: Fetch servers
            try await ServerFetcherManager.shared.fetchServers()
            
            // Step 2: Handle Firebase user
            if let user = Auth.auth().currentUser {
                print("✅ Existing Firebase user: \(user.uid)")
                KeyManager.shared.verifyOrGenerateKeys(for: user.uid)
            } else {
                print("🆕 No Firebase user found — signing in anonymously.")
                _ = try await Auth.auth().signInAnonymously()
            }
            
            // Step 3: Choose random server
            if let server = await ConfigurationManager.shared.chooseRandomServer(isSubscribed: false)
            {
                print("🎯 Selected server: \(server.name)")
            }
            
            // Step 4: Navigate to main app
            let home = HomeViewController()
            UIApplication.shared.windows.first?.rootViewController = mainVC
            
        } catch {
            print("❌ Error during startup: \(error.localizedDescription)")
        }
    }
 
}

extension SplashViewController
{
    private func showNoInternetAlert()
    {
        let alert = UIAlertController(title: "No Internet Connection",message: "Please check your internet connection and try again.",preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "OK", style: .default)
        { _ in
               Task
            {
                   await self.startAppFlow()
            }
        }
           
        alert.addAction(retryAction)
        present(alert, animated: true)
    }
}



   
 
