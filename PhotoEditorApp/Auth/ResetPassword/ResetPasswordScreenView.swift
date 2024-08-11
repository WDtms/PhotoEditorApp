//
//  ResetPasswordScreenView.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 07.08.2024.
//

import SwiftUI

extension ResetPasswordViewModel {
    var emailErrorMessage : String? {
        if case .validating(let email) = state {
            return AuthErrorMessagesUtils.emailValidationErrorMessage(emailValidation: email)
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

struct ResetPasswordScreenView: View {
    
    @StateObject private var resetPasswordViewModel: ResetPasswordViewModel = ResetPasswordViewModel()
    
    @EnvironmentObject private var authNavigationViewModel: AuthNavigationViewModel
    
    @EnvironmentObject private var authService: AuthService
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                TitledTextField(
                    title: "Email Address",
                    hint: "hello@example.com",
                    text: $resetPasswordViewModel.email,
                    submitLabel: .done,
                    errorText: resetPasswordViewModel.emailErrorMessage,
                    isDisabled: resetPasswordViewModel.disableFields
                )
                
                Spacer()
                    .frame(height: 40)
                
                AppButton(
                    title: "Send Link",
                    action: {
                        resetPasswordViewModel.resetPassword()
                    },
                    isLoading: resetPasswordViewModel.state == .loading,
                    isDisabled: resetPasswordViewModel.disableSubmitButton
                )
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationTitle("Reset Password")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        authNavigationViewModel.hideResetModal()
                    }) {
                        Text("Back")
                    }
                }
            }
            .onAppear {
                resetPasswordViewModel.authService = authService
            }
            .alert("Success!", isPresented: Binding<Bool>(
                get: {
                    if case .success = resetPasswordViewModel.state {
                        return true
                    }
                    return false
                },
                set: { _ in
                    resetPasswordViewModel.state = .idle
                }
            )) {
                Button("OK", role: .cancel) {
                    authNavigationViewModel.hideResetModal()
                }
            } message: {
                if case .success(let email) = resetPasswordViewModel.state {
                    Text("The password reset email has been sent to your email: \(email).")
                } else {
                    Text("The password reset email has been sent to your email.")
                }
            }
            .alert("Oops!", isPresented: Binding<Bool>(
                get: {
                    if case .error = resetPasswordViewModel.state {
                        return true
                    }
                    return false
                },
                set: { _ in
                    resetPasswordViewModel.state = .idle
                }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                if case .error(let localizedError) = resetPasswordViewModel.state {
                    Text(localizedError ?? "Something went wrong.")
                } else {
                    Text("Something went wrong")
                }
            }


        }

    }
    
}

#Preview {
    ResetPasswordScreenView()
}
