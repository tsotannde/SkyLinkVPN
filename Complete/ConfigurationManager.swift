//
//  ConfigurationManager.swift
//  SkyLink
//
//  Created by Adebayo Sotannde on 10/22/25.
//

import Foundation

final class ConfigurationManager {

    static let shared = ConfigurationManager()
    private init() {}

    private let userDefaults = UserDefaults.standard
    private let cachedServerKey = "cachedServers"
    private let currentServerKey = "currentServer"

    // MARK: - Save and Load
    func saveCurrentServer(_ server: Server) {
        do {
            let data = try JSONEncoder().encode(server)
            userDefaults.set(data, forKey: currentServerKey)
            print("💾 Saved current server: \(server.name)")
        } catch {
            print("❌ Failed to save current server: \(error.localizedDescription)")
        }
    }

    func loadCurrentServer() -> Server? {
        guard let data = userDefaults.data(forKey: currentServerKey) else { return nil }
        return try? JSONDecoder().decode(Server.self, from: data)
    }

    // MARK: - Load Cached Servers
    func loadCachedServers() -> [Server]? {
        guard let data = userDefaults.data(forKey: cachedServerKey) else { return nil }
        return try? JSONDecoder().decode([Server].self, from: data)
    }

    // MARK: - Choose Random Server
    func chooseRandomServer(isSubscribed: Bool, completion: @escaping (Server?) -> Void) {
        // Attempt to use cached servers first
        if let cachedServers = loadCachedServers() {
            let eligible = cachedServers.filter { isSubscribed || !$0.requiresSubscription }

            if let randomServer = eligible.randomElement() {
                print("🎯 Selected random cached server: \(randomServer.name)")
                saveCurrentServer(randomServer)
                completion(randomServer)
                return
            } else {
                print("⚠️ No eligible cached servers found. Fetching from network...")
            }
        }

        // Fallback — fetch from Firebase
//        ServerFetcherManager.shared.fetchServers { result in
//            switch result {
//            case .success(let servers):
//                let eligible = servers.filter { isSubscribed || !$0.requiresSubscription }
//
//                if let randomServer = eligible.randomElement() {
//                    print("✅ Selected random fetched server: \(randomServer.name)")
//                    self.saveCurrentServer(randomServer)
//                    completion(randomServer)
//                } else {
//                    print("❌ No suitable servers found after fetching.")
//                    completion(nil)
//                }
//
//            case .failure(let error):
//                print("❌ Failed to fetch servers: \(error.localizedDescription)")
//                completion(nil)
//            }
        }
    }

    // MARK: - Refresh Server Data
    func refreshServerData(completion: @escaping (Bool) -> Void)
    {
//        ServerFetcherManager.shared.refreshServerData { success in
//            print(success ? "✅ ConfigurationManager refresh success." : "❌ ConfigurationManager refresh failed.")
//            completion(success)
//        }
    }

