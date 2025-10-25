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

            // 1️⃣ Get or select the server
            guard let server = await ConfigurationManager.shared.getOrSelectServer() else {
                print("No server found.")
                return
            }
            
            guard let serverIP = server.publicIP else {
                print("Server public IP is nil.")
                return
            }

            // 2️⃣ Generate keys or load stored ones
            guard let privateKey = KeyManager.shared.getPrivateKey() else {
                print("Private key is nil.")
                return
            }
            guard let publicKey = KeyManager.shared.getPublicKey() else {
                print("Public key is nil.")
                return
            }

            // 3️⃣ Call Firebase to get assigned IP, server pubkey, and port
            let response = try await FirebaseRequestManager.shared.sendRequest(
                serverIP: serverIP,
                publicKey: publicKey
            )

            print("[VPNManager] Received IP: \(response.ip), Port: \(response.port)")

            // 4️⃣ Build wg-quick configuration string
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

            // 5️⃣ Load or create the Tunnel Provider
            let tunnelManager = try await loadOrCreateTunnelProvider()
            tunnelManager.protocolConfiguration = makeProtocolConfig(wgQuickConfig: wgQuickConfig)
            tunnelManager.localizedDescription = "SkyLink VPN"
            tunnelManager.isEnabled = true
            try await tunnelManager.saveToPreferences()

            // 6️⃣ Start the tunnel
            try await tunnelManager.connection.startVPNTunnel()
            self.manager = tunnelManager
            print("VPN Tunnel Started Successfully")

        } catch {
            print("[VPNManager] Failed to start tunnel: \(error.localizedDescription)")
        }
    }

    // MARK: - Stop Tunnel
    func stopTunnel() async {
        guard let connection = manager?.connection else {
            print("No active tunnel to stop.")
            return
        }

        connection.stopVPNTunnel()
        print("🛑 VPN Tunnel Stopped")
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

    private func makeProtocolConfig(wgQuickConfig: String) -> NETunnelProviderProtocol {
        let proto = NETunnelProviderProtocol()
        proto.providerBundleIdentifier = "com.adebayosotannde.SkyLink.network-extension"
        proto.serverAddress = "SkyLink VPN"
        proto.providerConfiguration = ["wgQuickConfig": wgQuickConfig]
        return proto
    }
}
