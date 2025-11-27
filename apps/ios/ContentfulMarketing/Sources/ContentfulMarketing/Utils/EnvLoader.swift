import Foundation

/// Utility class to load environment variables from .env file
class EnvLoader {
    static let shared = EnvLoader()
    
    private var envDict: [String: String] = [:]
    
    private init() {
        loadEnvFile()
    }
    
    /// Load environment variables from .env file
    private func loadEnvFile() {
        // Try multiple possible locations for .env file
        // Priority: iOS app directory > Project root > Monorepo root
        var possiblePaths: [String?] = []
        
        // 1. Direct path from source file location (most reliable for development)
        // Get the directory where the source files are located
        let sourceFile = #file
        var sourceDir = (sourceFile as NSString).deletingLastPathComponent // Utils
        sourceDir = (sourceDir as NSString).deletingLastPathComponent // ContentfulMarketing
        sourceDir = (sourceDir as NSString).deletingLastPathComponent // Sources
        sourceDir = (sourceDir as NSString).deletingLastPathComponent // ContentfulMarketing
        sourceDir = (sourceDir as NSString).deletingLastPathComponent // ContentfulMarketing
        // Now we should be in apps/ios/
        possiblePaths.append((sourceDir as NSString).appendingPathComponent(".env"))
        // Also try going up to project root
        let projectRoot = (sourceDir as NSString).deletingLastPathComponent
        possiblePaths.append((projectRoot as NSString).appendingPathComponent(".env"))
        
        // 2. In the iOS app directory (apps/ios/.env) - from bundle path
        if let bundlePath = Bundle.main.bundlePath as NSString? {
            // Navigate up from app bundle to find iOS directory
            var path = bundlePath.deletingLastPathComponent // Remove .app
            path = (path as NSString).deletingLastPathComponent // Remove Products or Debug/Release
            path = (path as NSString).deletingLastPathComponent // Remove build directory
            path = (path as NSString).deletingLastPathComponent // Remove DerivedData or project
            possiblePaths.append((path as NSString).appendingPathComponent("apps/ios/.env"))
            possiblePaths.append((path as NSString).appendingPathComponent(".env"))
        }
        
        // 3. In the project root (for monorepo)
        if let projectRoot = findProjectRoot() {
            possiblePaths.append((projectRoot as NSString).appendingPathComponent("apps/ios/.env"))
            possiblePaths.append((projectRoot as NSString).appendingPathComponent(".env"))
        }
        
        // 4. Current working directory (when running from Xcode)
        let cwd = FileManager.default.currentDirectoryPath
        possiblePaths.append((cwd as NSString).appendingPathComponent("apps/ios/.env"))
        possiblePaths.append((cwd as NSString).appendingPathComponent(".env"))
        
        // 5. In the app bundle (if included)
        possiblePaths.append(Bundle.main.path(forResource: ".env", ofType: nil))
        
        for path in possiblePaths.compactMap({ $0 }) {
            if FileManager.default.fileExists(atPath: path) {
                if let content = try? String(contentsOfFile: path, encoding: .utf8) {
                    parseEnvContent(content)
                    print("Loaded .env file from: \(path)")
                    return
                }
            }
        }
        
        // Also try reading from the iOS app directory specifically
        if let projectPath = findProjectRoot() {
            let envPath = (projectPath as NSString).appendingPathComponent(".env")
            if FileManager.default.fileExists(atPath: envPath),
               let content = try? String(contentsOfFile: envPath, encoding: .utf8) {
                parseEnvContent(content)
                print("Loaded .env file from: \(envPath)")
                return
            }
        }
        
        print("No .env file found. Using system environment variables or defaults.")
    }
    
    /// Find the project root directory by looking for common markers
    private func findProjectRoot() -> String? {
        var currentPath = Bundle.main.bundlePath
        
        // Navigate up to find project root
        for _ in 0..<10 {
            let packageJson = (currentPath as NSString).appendingPathComponent("package.json")
            let gitDir = (currentPath as NSString).appendingPathComponent(".git")
            let xcodeproj = (currentPath as NSString).appendingPathComponent("ContentfulMarketing.xcodeproj")
            
            if FileManager.default.fileExists(atPath: packageJson) ||
               FileManager.default.fileExists(atPath: gitDir) ||
               FileManager.default.fileExists(atPath: xcodeproj) {
                return currentPath
            }
            
            let parent = (currentPath as NSString).deletingLastPathComponent
            if parent == currentPath {
                break
            }
            currentPath = parent
        }
        
        return nil
    }
    
    /// Parse .env file content
    private func parseEnvContent(_ content: String) {
        let lines = content.components(separatedBy: .newlines)
        
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Skip empty lines and comments
            if trimmed.isEmpty || trimmed.hasPrefix("#") {
                continue
            }
            
            // Parse KEY=VALUE format
            if let range = trimmed.range(of: "=") {
                let key = String(trimmed[..<range.lowerBound]).trimmingCharacters(in: .whitespacesAndNewlines)
                var value = String(trimmed[range.upperBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
                
                // Remove quotes if present
                if (value.hasPrefix("\"") && value.hasSuffix("\"")) || 
                   (value.hasPrefix("'") && value.hasSuffix("'")) {
                    value = String(value.dropFirst().dropLast())
                }
                
                if !key.isEmpty {
                    envDict[key] = value
                }
            }
        }
    }
    
    /// Get environment variable value
    /// Priority: .env file > System environment > Default value
    func get(_ key: String, defaultValue: String? = nil) -> String? {
        // First check .env file
        if let value = envDict[key], !value.isEmpty {
            return value
        }
        
        // Then check system environment
        if let value = ProcessInfo.processInfo.environment[key], !value.isEmpty {
            return value
        }
        
        // Finally return default
        return defaultValue
    }
    
    /// Get environment variable with a default value
    func get(_ key: String, default defaultValue: String) -> String {
        return get(key, defaultValue: defaultValue) ?? defaultValue
    }
}

