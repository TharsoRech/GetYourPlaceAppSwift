import SwiftUI

struct LoginPopupView: View {
    @Binding var isPresented: Bool
    var canClose: Bool = false
    
    @Environment(AuthManager.self) private var auth
    @State private var email = ""
    @State private var password = ""
    @State private var isRecoveryMode = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
                .onTapGesture {
                    if canClose {
                        withAnimation(.spring()) { isPresented = false }
                    }
                }
            
            // Login Card
            VStack(spacing: 25) {
                headerSection
                
                VStack(spacing: 20) {
                    CustomInputField(label: "Email", text: $email)
                    
                    if !isRecoveryMode {
                        CustomInputField(label: "Password", text: $password, isSecure: true)
                    }
                }
                .padding(.horizontal, 24)
                
                VStack(spacing: 15) {
                    mainActionButton
                    
                    forgotPasswordButton
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 10)
            }
            .padding(.vertical, 30)
            .background(Color(red: 0.1, green: 0.1, blue: 0.1))
            .cornerRadius(28)
            .overlay(alignment: .topTrailing) {
                if canClose {
                    closeButton
                }
            }
            .padding(.horizontal, 30)
        }
    }
    
    // MARK: - Subviews
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Circle()
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: isRecoveryMode ? "envelope.fill" : "lock.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                )
            
            Text(isRecoveryMode ? "Reset Password" : "Sign In")
                .font(.title2.bold())
                .foregroundColor(.white)
        }
        .padding(.top, 10)
    }
    
    private var closeButton: some View {
        Button(action: {
            withAnimation(.spring()) { isPresented = false }
        }) {
            Image(systemName: "xmark")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white.opacity(0.5))
                .padding(12)
                .background(Color.white.opacity(0.1))
                .clipShape(Circle())
        }
        .padding(16)
    }
    
    private var forgotPasswordButton: some View {
        Button(action: {
            withAnimation(.easeInOut) { isRecoveryMode.toggle() }
        }) {
            Text(isRecoveryMode ? "Back to Login" : "Forgot Password?")
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }
    
    private var mainActionButton: some View {
        Button(action: {
            if isRecoveryMode {
                print("Recovery email sent to \(email)")
                withAnimation { isRecoveryMode = false }
            } else {
                // 1. Create the profile from the state variables
                let profile = UserProfile(email: email, password: password)
                
                // 2. Pass it to the login function
                auth.login(userProfile: profile)
                
                withAnimation {
                    isPresented = false
                }
            }
        }) {
            Text(isRecoveryMode ? "Send Reset Link" : "Login")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

// MARK: - Previews

#Preview("Closable (e.g. from Home)") {
    LoginPopupView(isPresented: .constant(true), canClose: true)
        .environment(AuthManager())
}

#Preview("Mandatory (e.g. Profile Tab)") {
    LoginPopupView(isPresented: .constant(true), canClose: false)
        .environment(AuthManager())
}
