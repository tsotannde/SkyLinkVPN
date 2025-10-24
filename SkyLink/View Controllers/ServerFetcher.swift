import Foundation

final class ServerFetcher
{

    static let shared = ServerFetcher()
    private let firebaseURL = "https://vpn-se-default-rtdb.firebaseio.com/.json"
    
    
    private init()
    {
    }

    /// Fetch all servers and return as `[Server]`
    func fetchServers(completion: @escaping (Result<[Server], Error>) -> Void) {
        guard let url = URL(string: firebaseURL) else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0)))
                return
            }

            print("📡 Fetching servers... Data size: \(data.count) bytes")

            do {
                let decoded = try JSONDecoder().decode(ServerDatabase.self, from: data)
                let servers = decoded.servers.flatMap { (_, country) in
                    country.servers.map { (_, server) in server }
                }

                print("✅ Successfully decoded \(servers.count) servers.")
                completion(.success(servers))
            } catch {
                print("❌ Failed to decode: \(error.localizedDescription)")
                if let json = String(data: data, encoding: .utf8) {
                    print("Raw JSON: \(json)")
                }
                completion(.failure(error))
            }
        }.resume()
    }
   
    func fetchCountries(completion: @escaping (Result<[Country], Error>) -> Void) {
        guard let url = URL(string: firebaseURL) else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0)))
                return
            }

            print("🌍 Fetching countries... Data size: \(data.count) bytes")

            do {
                let decoded = try JSONDecoder().decode(ServerDatabase.self, from: data)
                var countries: [Country] = []

                for (key, value) in decoded.servers {
                    // Inject the Firebase key as 'name' manually
                    let country = Country(
                        name: key,
                        requiresSubscription: value.requiresSubscription,
                        servers: value.servers
                    )
                    countries.append(country)
                }

                print("✅ Successfully decoded \(countries.count) countries.")
                completion(.success(countries))
            } catch {
                print("❌ Failed to decode countries: \(error.localizedDescription)")
                if let json = String(data: data, encoding: .utf8) {
                    print("Raw JSON: \(json)")
                }
                completion(.failure(error))
            }
        }.resume()
    }
    
}
