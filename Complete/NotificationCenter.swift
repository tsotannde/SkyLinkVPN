//
//  NitificationCenter.swift
//  SkyLink
//
//  Created by Adebayo Sotannde on 10/22/25.
//


import Foundation

extension Notification.Name
{
    static let serverDidUpdate = Notification.Name("serverDidUpdate")
    static let configurationDidChange = Notification.Name("configurationDidChange")
    static let internetDidConnect = Notification.Name("internetDidConnect")
    static let internetDidDisconnect = Notification.Name("internetDidDisconnect")
}


//NEW UPDATED

import Foundation

extension Notification.Name {
    static let vpnDidConnect = Notification.Name("vpnConnected")
    static let vpnDidDisconnect = Notification.Name("vpnDisconnected")
}
