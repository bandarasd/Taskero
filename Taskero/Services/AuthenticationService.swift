//
//  AuthenticationService.swift
//  Taskero
//

import Foundation
import FirebaseAuth
import FirebaseCore
import AuthenticationServices
import CryptoKit
import GoogleSignIn

@MainActor
class AuthenticationService: ObservableObject {

    @Published var user: FirebaseAuth.User?
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    /// Stored so the coordinator keeps a strong reference during Apple Sign-In
    private var appleSignInCoordinator: AppleSignInCoordinator?
    /// Kept alive for the duration of a phone OTP request
    private var phoneAuthUIDelegate: PhoneAuthUIDelegate?
    /// Raw nonce generated before each Apple Sign-In request
    private(set) var currentNonce: String?

    private var authStateHandle: AuthStateDidChangeListenerHandle?

    // MARK: - Initialisation

    init() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor [weak self] in
                self?.user = user
                self?.isAuthenticated = user != nil
            }
        }
    }

    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    // MARK: - Email / Password

    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            user = result.user
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signUp(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            user = result.user
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Phone / OTP

    /// Sends a verification SMS and returns the verification ID.
    func sendOTP(phoneNumber: String) async throws -> String {
        let delegate = PhoneAuthUIDelegate()
        phoneAuthUIDelegate = delegate
        return try await withCheckedThrowingContinuation { continuation in
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: delegate) { verificationID, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if let id = verificationID {
                    continuation.resume(returning: id)
                } else {
                    continuation.resume(throwing: NSError(
                        domain: "AuthenticationService",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Unknown error sending OTP"]
                    ))
                }
            }
        }
    }

    func verifyOTP(verificationID: String, code: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID,
                verificationCode: code
            )
            let result = try await Auth.auth().signIn(with: credential)
            user = result.user
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Google Sign-In

    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            errorMessage = "Firebase configuration error."
            return
        }

        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)

        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let rootVC = windowScene.keyWindow?.rootViewController
        else {
            errorMessage = "Unable to find root view controller."
            return
        }

        isLoading = true
        errorMessage = nil

        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { [weak self] result, error in
            Task { @MainActor [weak self] in
                defer { self?.isLoading = false }
                if let error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                guard
                    let user = result?.user,
                    let idToken = user.idToken?.tokenString
                else {
                    self?.errorMessage = "Google Sign-In failed: missing token."
                    return
                }
                let credential = GoogleAuthProvider.credential(
                    withIDToken: idToken,
                    accessToken: user.accessToken.tokenString
                )
                do {
                    let result = try await Auth.auth().signIn(with: credential)
                    self?.user = result.user
                } catch {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    // MARK: - Apple Sign-In

    /// Generates a nonce, stores it, and triggers the native Apple Sign-In sheet.
    func signInWithApple() {
        let nonce = randomNonceString()
        currentNonce = nonce

        let coordinator = AppleSignInCoordinator(authService: self)
        appleSignInCoordinator = coordinator

        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = coordinator
        controller.presentationContextProvider = coordinator
        controller.performRequests()
    }

    /// Called by the coordinator after the user authorises with Apple.
    func handleAppleSignIn(authorization: ASAuthorization) async {
        guard
            let appleCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let nonce = currentNonce,
            let tokenData = appleCredential.identityToken,
            let idToken = String(data: tokenData, encoding: .utf8)
        else {
            errorMessage = "Unable to fetch Apple identity token."
            return
        }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let credential = OAuthProvider.appleCredential(
            withIDToken: idToken,
            rawNonce: nonce,
            fullName: appleCredential.fullName
        )
        do {
            let result = try await Auth.auth().signIn(with: credential)
            user = result.user
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Sign Out

    func signOut() {
        do {
            try Auth.auth().signOut()
            // Clear DB-user flag so next sign-in goes through CreateAccountView if needed
            UserDefaults.standard.removeObject(forKey: "isDBUserCreated")
            UserDefaults.standard.removeObject(forKey: "userFirstName")
            UserDefaults.standard.set("", forKey: "userFirstName")
            UserDefaults.standard.set("", forKey: "userLastName")
            UserDefaults.standard.set("", forKey: "userEmail")
            UserDefaults.standard.set("customer", forKey: "userRole")
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Private Helpers

    private func randomNonceString(length: Int = 32) -> String {
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remaining = length
        while remaining > 0 {
            var randoms = [UInt8](repeating: 0, count: 16)
            guard SecRandomCopyBytes(kSecRandomDefault, randoms.count, &randoms) == errSecSuccess else {
                fatalError("Unable to generate secure random bytes")
            }
            randoms.forEach { byte in
                guard remaining > 0 else { return }
                if byte < charset.count {
                    result.append(charset[Int(byte)])
                    remaining -= 1
                }
            }
        }
        return result
    }

    private func sha256(_ input: String) -> String {
        let digest = SHA256.hash(data: Data(input.utf8))
        return digest.compactMap { String(format: "%02x", $0) }.joined()
    }
}

// MARK: - Apple Sign-In Coordinator

private final class AppleSignInCoordinator: NSObject,
    ASAuthorizationControllerDelegate,
    ASAuthorizationControllerPresentationContextProviding {

    private let authService: AuthenticationService

    init(authService: AuthenticationService) {
        self.authService = authService
    }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        Task {
            await authService.handleAppleSignIn(authorization: authorization)
        }
    }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        Task { @MainActor in
            authService.errorMessage = error.localizedDescription
        }
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard
            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = scene.windows.first
        else { return UIWindow() }
        return window
    }
}

// MARK: - Phone Auth UI Delegate

/// Provides a presenting view controller for Firebase's reCAPTCHA web view.
private final class PhoneAuthUIDelegate: NSObject, AuthUIDelegate {
    func present(_ viewControllerToPresent: UIViewController,
                 animated flag: Bool,
                 completion: (() -> Void)? = nil) {
        guard
            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let root = scene.windows.first?.rootViewController
        else { return }
        // Walk up to the topmost presented controller
        var top = root
        while let presented = top.presentedViewController {
            top = presented
        }
        top.present(viewControllerToPresent, animated: flag, completion: completion)
    }

    func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        guard
            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let root = scene.windows.first?.rootViewController
        else { return }
        var top = root
        while let presented = top.presentedViewController {
            top = presented
        }
        top.dismiss(animated: flag, completion: completion)
    }
}
