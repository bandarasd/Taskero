//
//  UserService.swift
//  Taskero
//

import Foundation

class UserService {

    static let shared = UserService()

    private let baseURL = "http://localhost:3000"

    // MARK: - Check if user exists by phone

    /// Returns true if a DB record exists for the given phone number, false if 404.
    func checkUserByPhone(_ phone: String) async throws -> Bool {
        let encoded = phone.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? phone
        guard let url = URL(string: "\(baseURL)/users/phone/\(encoded)") else {
            throw URLError(.badURL)
        }
        let (_, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        return http.statusCode == 200
    }

    // MARK: - Login

    func login(phone: String, password: String) async throws -> [String: Any] {
        guard let url = URL(string: "\(baseURL)/auth/login") else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
            "phone_number": phone,
            "password": password
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        
        if http.statusCode == 200 {
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                throw URLError(.cannotParseResponse)
            }
            return json
        } else {
            let msg = (try? JSONSerialization.jsonObject(with: data) as? [String: Any])?["error"] as? String
                ?? "Login failed (status \(http.statusCode))"
            throw NSError(domain: "UserService", code: http.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: msg])
        }
    }

    // MARK: - Create user

    /// POSTs a new user record. Throws on non-201 status or network errors.
    func createUser(firstName: String,
                    lastName: String,
                    email: String,
                    phone: String,
                    password: String,
                    role: String) async throws {
        guard let url = URL(string: "\(baseURL)/users") else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
            "phone_number": phone,
            "password": password,
            "role": role
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        guard http.statusCode == 201 || http.statusCode == 200 else {
            let msg = (try? JSONSerialization.jsonObject(with: data) as? [String: Any])?["error"] as? String
                ?? "Failed to create account (status \(http.statusCode))"
            throw NSError(domain: "UserService", code: http.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: msg])
        }
    }
}
