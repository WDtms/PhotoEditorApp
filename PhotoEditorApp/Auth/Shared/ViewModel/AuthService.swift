//
//  AuthService.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 10.08.2024.
//

import Foundation
import GoogleSignIn
import FirebaseAuth
import FirebaseCore

enum AuthState {
    case initial
    case loggedOut
    case loggedIn(user: UserInfo)
}

class AuthService: ObservableObject {
    @Published var state: AuthState = .loggedOut
    
    private var authSubscription: AuthStateDidChangeListenerHandle?
    
    init() {
        handleInitialState()
        initialiseAuthSubscription()
    }
    
    deinit {
        deinitilizeAuthSubscription()
    }
    
    private func handleInitialState() {
        if let user = Auth.auth().currentUser {
            state = .loggedIn(user: user.toUserInfo())
        }
    }
    
    private func initialiseAuthSubscription() {
        authSubscription = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            
            if let user = user {
                self.state = .loggedIn(user: user.toUserInfo())
            } else {
                self.state = .loggedOut
            }
        }
    }
    
    private func deinitilizeAuthSubscription() {
        if let authSubscription = authSubscription {
            Auth.auth().removeStateDidChangeListener(authSubscription)
        }
    }
    
    func signInWithCredentials(email: String, password: String, completion: @escaping (ActionResult<Void, Error?>) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let _ = result {
                completion(.success(result: ()))
                
                return
            }
            
            completion(.error(error: error))
            
            return
        }
    }
    
    func signUpWithCredentials(email: String, password: String, completion: @escaping (ActionResult<Void, Error?>) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let _ = result {
                completion(.success(result: ()))
                
                return
            }
            
            completion(.error(error: error))
            
            return
        }
    }
    
    func signInWithGoogle(completion: @escaping (ActionResult<Void, Error?>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] signInResult, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.error(error: error))
                
                return
            }
            
            guard let idToken = signInResult?.user.idToken, let accessToken = signInResult?.user.accessToken else {
                let error = NSError(domain: "GoogleSignInError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get ID Token or Access Token."])
                completion(.error(error: error))
                
                return
            }
            
            let credentials = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            self.authenticateWithCredentials(authCredentials: credentials, completion: completion)
            
            return
        }
    }
    
    private func authenticateWithCredentials(authCredentials: AuthCredential, completion: @escaping (ActionResult<Void, Error?>) -> Void) {
        Auth.auth().signIn(with: authCredentials) { result, error in
            if let error = error {
                completion(.error(error: error))
                
                return
            }
            
            if let _ = result {
                completion(.success(result: ()))
                
                return
            }
            
            completion(.error(error: nil))
            
            return
        }
    }
    
    func sendResetPasswordLink(email: String, completion: @escaping (ActionResult<Void, Error?>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.error(error: error))
                
                return
            }
            
            completion(.success(result: ()))
            
            return
        }
    }
    
    func logOut(completion: @escaping (ActionResult<Void, Void>) -> Void) {
        do {
            try Auth.auth().signOut()
            
            completion(.success(result: ()))
        } catch {
            completion(.error(error: ()))
        }
    }
}

extension User {
    func toUserInfo() -> UserInfo {
        UserInfo(email: self.email, avatarUrl: self.photoURL)
    }
}
