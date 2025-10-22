//
//  PacketTunnelProvider.swift
//  network-extension
//
//  Created by Developer on 10/6/25.
//

//import NetworkExtension
//
//class PacketTunnelProvider: NEPacketTunnelProvider {
//
//    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
//        print("Im attempting to start the tunnel")
//
//        // ✅ Add this line here:
//        print("🔥 PacketTunnelProvider: startTunnel() CALLED!")
//
//        // ✅ Tell iOS that the tunnel started successfully (for testing)
//        completionHandler(nil)
//    }
//    
//    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
//        print("I will stop")
//        completionHandler()
//    }
//    
//    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)?) {
//        print("Cool Message bro")
//        if let handler = completionHandler {
//            handler(messageData)
//        }
//    }
//    
//    override func sleep(completionHandler: @escaping () -> Void) {
//        print("sleeping bor")
//        completionHandler()
//    }
//    
//    override func wake() {
//        print("waking up bro")
//    }
//}
//




//  PacketTunnelProvider.swift
//  network-extension
//
//  Created by Shahzain Ali on 23/03/2024.


import NetworkExtension
import WireGuardKit

enum PacketTunnelProviderError: String, Error {
    case invalidProtocolConfiguration
    case cantParseWgQuickConfig
}

class PacketTunnelProvider: NEPacketTunnelProvider {

    private var statsTimer: Timer?
    
    
    private lazy var adapter: WireGuardAdapter = {
        return WireGuardAdapter(with: self) { [weak self] _, message in
            self?.log(message)
        }
    }()

    func log(_ message: String) {
        NSLog("WireGuard Tunnel: %@\n", message)
    }

    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        log("Starting tunnel")
        guard let protocolConfiguration = self.protocolConfiguration as? NETunnelProviderProtocol,
              let providerConfiguration = protocolConfiguration.providerConfiguration,
              let wgQuickConfig = providerConfiguration["wgQuickConfig"] as? String else {
            log("Invalid provider configuration")
            completionHandler(PacketTunnelProviderError.invalidProtocolConfiguration)
            return
        }

        guard let tunnelConfiguration = try? TunnelConfiguration(fromWgQuickConfig: wgQuickConfig) else {
            log("wg-quick config not parseable")
            completionHandler(PacketTunnelProviderError.cantParseWgQuickConfig)
            return
        }

        adapter.start(tunnelConfiguration: tunnelConfiguration) { [weak self] adapterError in
            guard let self = self else { return }
            if let adapterError = adapterError {
                self.log("WireGuard adapter error: \(adapterError.localizedDescription)")
            } else {
                let interfaceName = self.adapter.interfaceName ?? "unknown"
                self.log("Tunnel interface is \(interfaceName)")
                print("Hello World ")
                //Start periodic stat reporting
                self.startStatsReportingLoop()
            }
            completionHandler(adapterError)
        }
    }
    
    

       

    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        log("Stopping tunnel")
        adapter.stop { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.log("Failed to stop WireGuard adapter: \(error.localizedDescription)")
            }
            
            // Stop stats reporting when tunnel disconnects
            self.statsTimer?.invalidate()
            self.saveStats(download: 0, upload: 0, isConnected: false)
            completionHandler()

            #if os(macOS)
            // HACK: We have to kill the tunnel process ourselves because of a macOS bug
            exit(0)
            #endif
        }
    }

    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)?) {
        // Add code here to handle the message.
        if let handler = completionHandler {
            handler(messageData)
        }
    }

    override func sleep(completionHandler: @escaping () -> Void) {
        // Add code here to get ready to sleep.
        completionHandler()
    }

    override func wake() {
        // Add code here to wake up.
    }
}

extension PacketTunnelProvider
{
    
    private func startStatsReportingLoop() {
        statsTimer?.invalidate()
        statsTimer = Timer(timeInterval: 2.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            self.adapter.getRuntimeConfiguration { configTextOptional in
                guard let configText = configTextOptional else {
                    print("⚠️ getRuntimeConfiguration returned nil")
                    self.saveStats(download: 0, upload: 0, isConnected: false)
                    return
                }

                var rxBytes: Double = 0
                var txBytes: Double = 0

                for line in configText.split(separator: "\n") {
                    if line.hasPrefix("rx_bytes=") || line.hasPrefix("transfer_rx=") {
                        rxBytes = Double(line
                            .replacingOccurrences(of: "rx_bytes=", with: "")
                            .replacingOccurrences(of: "transfer_rx=", with: "")
                        ) ?? 0
                    } else if line.hasPrefix("tx_bytes=") || line.hasPrefix("transfer_tx=") {
                        txBytes = Double(line
                            .replacingOccurrences(of: "tx_bytes=", with: "")
                            .replacingOccurrences(of: "transfer_tx=", with: "")
                        ) ?? 0
                    }
                }

                let connected = (rxBytes > 0 || txBytes > 0)
                print("📈 [Tunnel] startStatsReportingLoop() firing...")
                print("📡 RX: \(rxBytes) bytes | TX: \(txBytes) bytes | Connected: \(connected)")
                self.saveStats(download: rxBytes, upload: txBytes, isConnected: connected)
            }
        }
        RunLoop.main.add(statsTimer!, forMode: .common)
        }
    
    
    private func saveStats(download: Double, upload: Double, isConnected: Bool) {
        let defaults = UserDefaults(suiteName: "group.com.adebayosotannde.SkyLink")
        defaults?.set(download, forKey: "downloadSpeed")
        defaults?.set(upload, forKey: "uploadSpeed")
        defaults?.set(isConnected, forKey: "isConnected")
        defaults?.synchronize()
    }
}
