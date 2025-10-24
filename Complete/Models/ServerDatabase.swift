//
//  ServerDatabase.swift
//  SkyLink
//
//  Created by Adebayo Sotannde on 10/22/25.
//


import Foundation


struct ServerDatabase: Codable
{
    let servers: [String: Country]
}

struct Server: Codable, Identifiable
{
    var id: String { name }
    let name: String
    let nickname: String?
    let location: String?
    let country: String?
    let state: String?
    let city: String?
    let publicIP: String?
    let osVersion: String?
    let requiresSubscription: Bool
    let capacity: Int
    let currentCapacity: Int
    let lastUpdated: String
    let allowNewConnection: Bool?
}



struct Country: Codable, Identifiable {
    var id: String { name ?? "Unknown" }
    let name: String? // make optional
    let requiresSubscription: Bool
    let servers: [String: Server]
}
