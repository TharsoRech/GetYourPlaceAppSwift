import SwiftUI
import PhotosUI

struct LoginPopupView: View {
    @Binding var isPresented: Bool
    var canClose: Bool = false
    
    @Environment(AuthManager.self) private var auth
    
    // --- State Properties ---
    enum AuthMode { case login, recovery, register }
    @State private var mode: AuthMode = .login
    
    // Core Data
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var country = ""
    @State private var bio = ""
    
    // Profile Image Logic
    @State private var selectedItem: PhotosPickerItem?
    @State private var base64Image: String?
    @State private var profileUIImage: UIImage?

    // --- Validation Logic ---
    private var isEmailValid: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
    
    private var isFormComplete: Bool {
        if mode == .register {
            return isEmailValid && !password.isEmpty && !name.isEmpty && !country.isEmpty && !bio.isEmpty && base64Image != nil
        } else if mode == .login {
            return isEmailValid && !password.isEmpty
        } else {
            return isEmailValid
        }
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
                .onTapGesture {
                    if canClose { closePopup() }
                }
            
            VStack(spacing: 0) { // Changed to 0 to control spacing manually
                headerSection
                    .padding(.bottom, 20)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        if mode == .register {
                            imagePickerSection
                            CustomInputField(label: "Full Name", text: $name)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            CustomInputField(label: "Email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                            
                            if !email.isEmpty && !isEmailValid {
                                Text("Please enter a valid email address")
                                    .font(.caption2)
                                    .foregroundColor(.red.opacity(0.8))
                                    .padding(.leading, 10)
                            }
                        }
                        
                        if mode != .recovery {
                            CustomInputField(label: "Password", text: $password, isSecure: true)
                        }
                        
                        if mode == .register {
                            CustomInputField(label: "Country", text: $country)
                            
                            // Multiline Bio Field
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("About Me")
                                        .font(.caption.bold())
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text("Required")
                                        .font(.caption2)
                                        .foregroundColor(.orange)
                                }
                                
                                TextEditor(text: $bio)
                                        .frame(height: 100)
                                        .scrollContentBackground(.hidden)
                                        .background(Color.white.opacity(0.05))
                                        .padding(4)
                                        .cornerRadius(12)
                                        .foregroundColor(.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                        )
                                
                                Text("This is the most important part of your profile for hosts to get to know you!")
                                    .font(.caption2)
                                    .italic()
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 5)
                }
                .frame(maxHeight: mode == .register ? 450 : 200) // Tighter height for login
                
                // Action Buttons Section
                VStack(spacing: 15) {
                    mainActionButton
                        .disabled(!isFormComplete)
                        .opacity(isFormComplete ? 1.0 : 0.5)
                    
                    HStack {
                        forgotPasswordButton
                        Spacer()
                        toggleModeButton
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 25) // Consistent spacing
            }
            .background(Color(red: 0.1, green: 0.1, blue: 0.1))
            .cornerRadius(28)
            .overlay(alignment: .topTrailing) {
                if canClose { closeButton }
            }
            .padding(.horizontal, 30)
        }
    }
    
    // MARK: - Subviews
    
    private var headerSection: some View {
        VStack(spacing: 10) {
            Text(mode == .register ? "Create Account" : (mode == .recovery ? "Reset" : "Sign In"))
                .font(.title2.bold())
                .foregroundColor(.white)
        }
        .padding(.top, 25)
    }

    private var imagePickerSection: some View {
        PhotosPicker(selection: $selectedItem, matching: .images) {
            VStack {
                if let image = profileUIImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 80, height: 80)
                        .overlay(Image(systemName: "camera.fill").foregroundColor(.white))
                }
                Text("Add Profile Photo").font(.caption).foregroundColor(base64Image == nil ? .orange : .gray)
            }
        }
        .onChange(of: selectedItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    profileUIImage = UIImage(data: data)
                    base64Image = data.base64EncodedString()
                }
            }
        }
    }
    
    private var mainActionButton: some View {
        Button(action: {
            switch mode {
            case .recovery:
                withAnimation { mode = .login }
            case .login:
                let profile = UserProfile(email: email, password: password)
                profile.role = .owner
                auth.login(userProfile: profile)
                closePopup()
            case .register:
                let newProfile = UserProfile(
                    name: name,
                    email: email,
                    password: password,
                    country: country,
                    bio: bio,
                    role: .owner,
                    base64Image: base64Image
                )
                auth.login(userProfile: newProfile)
                closePopup()
            }
        }) {
            Text(mode == .register ? "Register Account" : (mode == .recovery ? "Send Link" : "Login"))
                .font(.headline).foregroundColor(.black)
                .frame(maxWidth: .infinity).frame(height: 50)
                .background(isFormComplete ? Color.white : Color.white.opacity(0.3))
                .cornerRadius(12)
        }
    }

    private var toggleModeButton: some View {
        Button(action: {
            withAnimation(.easeInOut) {
                mode = (mode == .register) ? .login : .register
            }
        }) {
            Text(mode == .register ? "Already have an account?" : "Create Account")
                .font(.footnote).foregroundColor(.white)
        }
    }

    private var forgotPasswordButton: some View {
        Button(action: {
            withAnimation(.easeInOut) {
                mode = (mode == .recovery) ? .login : .recovery
            }
        }) {
            if mode != .register {
                Text(mode == .recovery ? "Back to Login" : "Forgot Password?")
                    .font(.footnote).foregroundColor(.gray)
            }
        }
    }

    private var closeButton: some View {
        Button(action: closePopup) {
            Image(systemName: "xmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white.opacity(0.5))
                .padding(10).background(Color.white.opacity(0.1)).clipShape(Circle())
        }
        .padding(16)
    }

    private func closePopup() {
        withAnimation(.spring()) { isPresented = false }
    }
}



#Preview("Closable (e.g. from Home)") {
    LoginPopupView(isPresented: .constant(true), canClose: true)
        .environment(AuthManager())
}

#Preview("Mandatory (e.g. Profile Tab)") {
    LoginPopupView(isPresented: .constant(true), canClose: false)
        .environment(AuthManager())
}
