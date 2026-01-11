import Foundation

class CacheManager {
    static let shared = CacheManager()
    private let fileManager = FileManager.default
    
    // Directory where cache files will live
    private var cacheDirectory: URL {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }

    /// Save any Codable object to disk
    func save<T: Codable>(_ object: T, forKey key: String) {
        let url = cacheDirectory.appendingPathComponent(key + ".json")
        do {
            let data = try JSONEncoder().encode(object)
            try data.write(to: url)
            print("Successfully cached data for key: \(key)")
        } catch {
            print("Failed to save to cache: \(error)")
        }
    }

    /// Retrieve any Codable object from disk
    func load<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        let url = cacheDirectory.appendingPathComponent(key + ".json")
        
        guard fileManager.fileExists(atPath: url.path) else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder().decode(T.self, from: data)
            return object
        } catch {
            print("Failed to load cache for key \(key): \(error)")
            return nil
        }
    }

    /// Remove a specific item
    func remove(forKey key: String) {
        let url = cacheDirectory.appendingPathComponent(key + ".json")
        try? fileManager.removeItem(at: url)
    }
}
