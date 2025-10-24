struct Country: Codable, Identifiable
{
    var id: String { name ?? "Unknown" }
    let name: String? // make optional
    let requiresSubscription: Bool
    let servers: [String: Server]
}