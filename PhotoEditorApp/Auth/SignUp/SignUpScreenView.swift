//
//  SignUpScreenView.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 06.08.2024.
//

import SwiftUI

extension SignUpViewModel {
    var emailErrorMessage : String? {
        if case .validating(let email, _, _) = state {
            return AuthErrorMessagesUtils.emailValidationErrorMessage(emailValidation: email)
        }
        
        return nil
    }
    
    var passwordErrorMessage: String? {
        if case .validating(_, let password, _) = state {
            return AuthErrorMessagesUtils.passwordValidationErrorMessage(passwordValidation: password)
        }
        
        return nil
    }
    
    var repeatedPasswordErrorMessage: String? {
        if case .validating(_, _, let repeatedPassword) = state {
            return switch repeatedPassword {
            case .notMatch:
                "Passwords do not match."
            case .valid:
                nil
            }
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
    
    var disableSumbitButton: Bool {
        return switch state {
        case .loading, .validating:
            true
        default:
            false
        }
    }
}

struct SignUpScreenView: View {
    
    @StateObject private var signUpViewModel: SignUpViewModel = SignUpViewModel()
        
    @EnvironmentObject private var authService: AuthService
    
    @EnvironmentObject private var authNavigationViewModel: AuthNavigationViewModel
    
    @FocusState private var focusedField: FocusableField?
    
    enum FocusableField: Hashable {
        case email, password, repeatPassword
    }
    
    var body: some View {
        
        GeometryReader { proxy in
            
            ScrollView {
                VStack {
                    
                    TitledTextField(
                        title: "Email Address",
                        hint: "hello@example.com",
                        text: $signUpViewModel.email,
                        submitLabel: .next,
                        errorText: signUpViewModel.emailErrorMessage,
                        isDisabled: signUpViewModel.disableFields
                    )
                    .focused($focusedField, equals: .email)
                    .onSubmit {
                        focusedField = .password
                    }
                    
                    Spacer().frame(height: 20)
                    
                    TitledTextField(
                        title: "Password",
                        hint: "•••••••••",
                        text: $signUpViewModel.password,
                        submitLabel: .next,
                        isSecure: true,
                        errorText: signUpViewModel.passwordErrorMessage,
                        isDisabled: signUpViewModel.disableFields
                    )
                    .focused($focusedField, equals: .password)
                    .onSubmit {
                        focusedField = .repeatPassword
                    }
                    
                    Spacer().frame(height: 20)
                    
                    TitledTextField(
                        title: "Repeat Password",
                        hint: "•••••••••",
                        text: $signUpViewModel.repeatedPassword,
                        isSecure: true,
                        errorText: signUpViewModel.repeatedPasswordErrorMessage,
                        isDisabled: signUpViewModel.disableFields
                    )
                    .focused($focusedField, equals: .repeatPassword)
                    .onSubmit {
                        signUpViewModel.signUpWithEmailAndPassword()
                    }
                    
                    Spacer().frame(height: 40)
                    
                    AppButton(
                        title: "Sign Up",
                        action: {
                            signUpViewModel.signUpWithEmailAndPassword()
                        },
                        isLoading: signUpViewModel.state == .loading,
                        isDisabled: signUpViewModel.disableSumbitButton
                    )
                    
                    Spacer().frame(height: 20)
                    
                    GoogleFooterView(isDisabled: signUpViewModel.state == .loading) {
                        signUpViewModel.signUpWithGoogle()
                    }
                    
                    Spacer().frame(height: 20)
                    
                    VStack {
                        Spacer()
                        
                        HStack {
                            Text("Already have an account?")
                                .foregroundStyle(Color.gray)
                            
                            Button(
                                action: {
                                    authNavigationViewModel.goBack()
                                }, label: {
                                    Text("Sign in here")
                                }
                            )
                        }
                    }
                    .frame(maxHeight: .infinity)
                    
                }
                .padding()
                .frame(minHeight: proxy.size.height,  maxHeight: .infinity, alignment: .top)
                
            
            }
            .navigationTitle("Create Account")
            .scrollBounceBehavior(.basedOnSize, axes: [.vertical])
            .alert("Oops!", isPresented: Binding<Bool>(
                get: {
                    if case .error  = signUpViewModel.state {
                        return true
                    }
                    
                    return false
                },
                set: { _ in
                    signUpViewModel.state = .idle
                }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                
                if case .error(let errorMessage) = signUpViewModel.state, let errorMessage = errorMessage {
                    Text(errorMessage)
                } else {
                    Text("Something went wrong")
                }
                
            }
            .onAppear {
                signUpViewModel.authService = authService
            }
            
        }

    }
}

#Preview {
    SignUpScreenView()
}
