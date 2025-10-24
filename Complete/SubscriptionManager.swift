//
//  SubscriptionManager.swift
//  SkyLink
//
//  Created by Adebayo Sotannde on 10/22/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class SubscriptionManager {
    static let shared = SubscriptionManager()
    private init() {}

    private let db = Firestore.firestore()

    /// Returns whether the current user is subscribed.
    func isSubcribed() -> Bool {
        // First check local cache (for speed)
        if let cached = UserDefaults.standard.value(forKey: "isSubscribed") as? Bool {
            return cached
        }
        return false
    }

    /// Refreshes subscription status from Firebase and stores it locally.
    func refreshSubscriptionStatus(completion: ((Bool) -> Void)? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("❌ No Firebase user found while checking subscription.")
            completion?(false)
            return
        }

        db.collection("subscriptions").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("❌ Error checking subscription: \(error.localizedDescription)")
                completion?(false)
                return
            }

            let isActive = snapshot?.data()?["isActive"] as? Bool ?? false
            UserDefaults.standard.set(isActive, forKey: "isSubscribed")
            print(isActive ? "✅ Subscription active for user \(uid)" : "⚠️ No active subscription for user \(uid)")
            completion?(isActive)
        }
    }
}
