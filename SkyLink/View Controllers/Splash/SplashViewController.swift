//
//  SetupViewController.swift
//  SkyLink
//
//  Created by Adebayo Sotannde on 10/22/25.
//

import UIKit
import FirebaseAuth

class SplashViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // Delay for visual splash effect
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8)
        {
            self.beginStartupFlow()
        }
    }

    private func beginStartupFlow() {
        // Step 1: Check Internet
        guard InternetManager.shared.checkConnectionAndAlertIfNeeded() else {
            print("No Internet — waiting for user to reconnect.")
            return
        }

        // Step 2: Check for existing Firebase user
        if let user = Auth.auth().currentUser {
            print("Existing Firebase user found: \(user.uid)")
            self.generateKeys(for: user.uid)
        } else {
            print("No user found — signing in anonymously.")
            signInAnonymously()
        }
    }

    private func signInAnonymously() {
        Auth.auth().signInAnonymously { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                print("Error creating anonymous user: \(error.localizedDescription)")
                return
            }

            guard let user = result?.user else {
                print("No user returned from signInAnonymously.")
                return
            }

            print("Anonymous user created successfully: \(user.uid)")
            self.generateKeys(for: user.uid)
        }
    }

    private func generateKeys(for uid: String) {
        KeyManager.shared.generateKeysIfNeeded(for: uid) { success in
            DispatchQueue.main.async {
                if success {
                    print("Keys generated or verified successfully.")
                    self.navigateToHome()
                } else {
                    print("Key generation failed.")
                    self.showErrorAndRetry()
                }
            }
        }
    }

    private func navigateToHome() {
        let homeVC = HomeViewController()
        self.navigationController?.setViewControllers([homeVC], animated: true)
    }

    private func showErrorAndRetry() {
        let alert = UIAlertController(
            title: "Setup Error",
            message: "An error occurred while preparing your account. Please try again.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
            self.beginStartupFlow()
        })
        present(alert, animated: true)
    }
}
