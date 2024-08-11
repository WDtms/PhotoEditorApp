//
//  SignInScreenView.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 06.08.2024.
//

import SwiftUI

extension SignInViewModel {
    var emailErrorMessage: String? {
        if case .validating(let email, _) = state {
            return AuthErrorMessagesUtils.emailValidationErrorMessage(emailValidation: email)
        }
        
        return nil
    }
    
    var passwordErrorMessage: String? {
        if case .validating(_, let password) = state {
            return AuthErrorMessagesUtils.passwordValidationErrorMessage(passwordValidation: password)
        }
        
        return nil
    }
    
    var disableFields: Bool {
        return switch state {
        case .loading:
            true
        default:
            false
        }
    }
    
    var disableSubmitButton: Bool {
        return switch state {
        case .loading, .validating:
            true
        default:
            false
        }
    }
}

struct SignInScreenView: View {
    
    @StateObject private var signInViewModel : SignInViewModel = SignInViewModel()
    
    @FocusState private var focusedField: FocusableField?
    
    @EnvironmentObject private var authService: AuthService
    
    @EnvironmentObject private var authNavigationViewModel: AuthNavigationViewModel
    
    enum FocusableField: Hashable {
        case email, password
    }
    
    var body: some View {
        
        VStack {
            
            TitledTextField(
                title: "Email Address",
                hint: "hello@example.com",
                text: $signInViewModel.email,
                submitLabel: .next,
                isSecure: false,
                errorText: signInViewModel.emailErrorMessage,
                isDisabled: signInViewModel.disableFields
            )
            .focused($focusedField, equals: .email)
            .onSubmit {
                focusedField = .password
            }
            
            Spacer().frame(height: 20)
            
            TitledTextField(
                title: "Password",
                hint: "•••••••••",
                text: $signInViewModel.password,
                submitLabel: .done,
                isSecure: true,
                errorText: signInViewModel.passwordErrorMessage,
                isDisabled: signInViewModel.disableFields,
                helperButton: Button(
                    action: {
                        authNavigationViewModel.showResetModal()
                    },
                    label: {
                        Text("Forgot password?")
                            .font(.system(size: 14))
                    }
                )
            )
            .focused($focusedField, equals: .password)
            
            Spacer().frame(height: 40)
            
            AppButton(
                title: "Sign In",
                action: {
                    signInViewModel.signInWithEmailAndPassword()
                },
                isLoading: signInViewModel.state == .loading,
                isDisabled: signInViewModel.disableSubmitButton
            )
            
            Spacer().frame(height: 20)
            
            GoogleFooterView(isDisabled: signInViewModel.state == .loading) {
                signInViewModel.signInWithGoogle()
            }
            
            Spacer()
            
            HStack {
                Text("Don't have an account yet?")
                    .foregroundStyle(Color.gray)
                
                Button(action: {
                    authNavigationViewModel.goToSignUp()
                }, label: {
                    Text("Create account")
                        .foregroundColor(.blue)
                })
            }
            
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
        .navigationTitle("Login")
        .alert("Oops!", isPresented: Binding<Bool>(
            get: {
                if case .error = signInViewModel.state {
                    return true
                }
                
                return false
            }, set: { _ in
                signInViewModel.state = .idle
            }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            if case .error(let errorMessage) = signInViewModel.state, let errorMessage = errorMessage {
                Text(errorMessage)
            } else {
                Text("Something went wrong.")
            }
        }
        .onAppear {
            signInViewModel.authService = authService
        }

    }
}

#Preview {
    SignInScreenView()
}
