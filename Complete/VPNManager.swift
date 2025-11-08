//
//  VPNManager.swift
//  SkyLink
//
//  Created by Adebayo Sotannde on 10/24/25.
//

import Foundation
import NetworkExtension


final class VPNManager {
    static let shared = VPNManager()
    private init() {}

    private var manager: NETunnelProviderManager?

    // MARK: - Start Tunnel
    func startTunnel() async {
        do {
            print("[VPNManager] Starting tunnel...")

            // Get or select the server
            guard let server = await ConfigurationManager.shared.getOrSelectServer() else {
                print("No server found.")
                return
            }
            
            guard let serverIP = server.publicIP else {
                print("Server public IP is nil.")
                return
            }

            // Generate keys or load stored ones
            guard let privateKey = KeyManager.shared.getPrivateKey() else {
                print("Private key is nil.")
                return
            }
            guard let publicKey = KeyManager.shared.getPublicKey() else {
                print("Public key is nil.")
                return
            }

            // Call Firebase to get assigned IP, server pubkey, and port
            let response = try await FirebaseRequestManager.shared.sendRequest(
                serverIP: serverIP,
                serverPort: server.port ?? 5000,
                publicKey: publicKey
            )

            print("[VPNManager] Received IP: \(response.ip), Port: \(response.port)")

            // Build wg-quick configuration string
            let wgQuickConfig = """
            [Interface]
            PrivateKey = \(privateKey)
            Address = \(response.ip)/32
            DNS = 1.1.1.1

            [Peer]
            PublicKey = \(response.publicKey)
            Endpoint = \(server.publicIP ?? "0.0.0.0"):\(response.port)
            AllowedIPs = 0.0.0.0/0
            PersistentKeepalive = 25
            """
            print("[VPNManager] Final Config:\n\(wgQuickConfig)")

            // Load or create the Tunnel Provider
            let tunnelManager = try await loadOrCreateTunnelProvider()
            tunnelManager.protocolConfiguration = makeProtocolConfig(wgQuickConfig: wgQuickConfig)
            tunnelManager.localizedDescription = "SkyLink VPN"
            tunnelManager.isEnabled = true
            try await tunnelManager.saveToPreferences()

            // Start the tunnel
            try await tunnelManager.connection.startVPNTunnel()
            self.manager = tunnelManager
            print("VPN Tunnel Started Successfully")
            NotificationCenter.default.post(name: Notification.Name("vpnConnected"), object: nil)

        } catch {
            print("[VPNManager] Failed to start tunnel: \(error.localizedDescription)")
        }
    }

     //MARK: - Stop Tunnel
    func stopTunnel() async {
        guard let connection = manager?.connection else {
            print("No active tunnel to stop.")
            return
        }

        connection.stopVPNTunnel()
        print("🛑 VPN Tunnel Stopped")
        NotificationCenter.default.post(name: Notification.Name("vpnDisconnected"), object: nil)
    }
    
   

    // MARK: - Helpers
    private func loadOrCreateTunnelProvider() async throws -> NETunnelProviderManager {
        let managers = try await NETunnelProviderManager.loadAllFromPreferences()
        if let existing = managers.first {
            return existing
        }

        let newManager = NETunnelProviderManager()
        newManager.protocolConfiguration = makeProtocolConfig(wgQuickConfig: "")
        newManager.isEnabled = true
        return newManager
    }

    private func makeProtocolConfig(wgQuickConfig: String) -> NETunnelProviderProtocol
    {
        let proto = NETunnelProviderProtocol()
        proto.providerBundleIdentifier = "com.adebayosotannde.SkyLink.network-extension"
        proto.serverAddress = "SkyLink VPN"
        proto.providerConfiguration = ["wgQuickConfig": wgQuickConfig]
        return proto
    }
}

// MARK: - VPN Status Check
extension VPNManager
{
    func isConnectedToVPN() async -> Bool
    {
        do {
            // 1. Get the currently selected server
            guard let currentServer = await ConfigurationManager.shared.getOrSelectServer(),
                  let serverIP = currentServer.publicIP else {
                print("[VPNManager] No saved server or public IP.")
                return false
            }

            // 2. Fetch user's current public IP
            guard let url = URL(string: "https://api.ipify.org?format=json") else {
                print("[VPNManager] Invalid IPify URL.")
                return false
            }

            let (data, _) = try await URLSession.shared.data(from: url)
            let ipResponse = try JSONDecoder().decode(IPResponse.self, from: data)
            let userIP = ipResponse.ip

            print("[VPNManager] User IP: \(userIP), Server IP: \(serverIP)")

            // 3. Compare and return result
            return userIP == serverIP

        } catch {
            print("[VPNManager] Failed to check VPN connection: \(error.localizedDescription)")
            return false
        }
    }

    // Helper struct for decoding ipify JSON
    private struct IPResponse: Decodable {
        let ip: String
    }
}
