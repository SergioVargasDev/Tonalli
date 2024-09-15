//
//  ContentView.swift
//  Tonalli
//
//  Created by Sofia Schneider Jimenez on 9/14/24.
//



import SwiftUI

enum NavigationDestination: Hashable {
    case principalView
    case signUpView
}

struct LoginView: View {
    var mtext = "Tonalli"
    @State  var username = ""
    @State  var password = ""
    @State private var isLoggedIn = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @State private var isLoading = false
    @State private var isCreatingAccount = false
    
    var gradient = Gradient(colors: [
        Color("background1"),
        Color("background1.1")
    ])

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: gradient,
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    
                    Text(mtext)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .font(.custom("Lobster-Regular", size: 44))
                    
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 190, height: 150)
                        .padding(.top, -20)
                        .padding(.bottom, 70)
                    
                    ZStack {
                        UsernameBut(username: self.$username)
                        
                        Circle()
                            .fill(Color("crearCuenta"))
                            .frame(width: 50, height: 50)
                            .offset(x: -100)
                        
                        Image(systemName: "person.fill")
                            .foregroundColor(Color("simbolos"))
                            .offset(x: -100)
                    }
                    .padding(.bottom, 10)
                    
                    ZStack {
                        InputPasswordLogin(password: self.$password)
                        
                        Circle()
                            .fill(Color("crearCuenta"))
                            .frame(width: 50, height: 50)
                            .offset(x: 100)
                        
                        Image(systemName: "lock.fill")
                            .foregroundColor(Color("simbolos"))
                            .offset(x: 100)
                    }
                    .padding(.bottom, 10)
                    
                    if isLoading {
                        ProgressView()
                            .padding(.top, 10)
                    } else {
                        Button(action: {
                            login()
                        }) {
                            Text("Login")
                                .foregroundColor(.white)
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(Color("botonLogin"))
                                .cornerRadius(30)
                                .padding(.horizontal, 120)
                                .padding(.top, 85)
                        }
                    }
                    
                    ZStack {
                        Text("¿No tienes cuenta aún?")
                            .foregroundColor(Color("botonLogin"))
                            .padding(.top, 30)
                    }
                    .padding(.top, 30)
                    
                    // Navigation to SignUpView
                    Button(action: {
                        isCreatingAccount = true  // Trigger navigation to SignUpView
                    }) {
                        Text("Crear cuenta")
                            .font(.system(size: 14))
                            .foregroundColor(Color("textoApp"))
                            .padding(7)
                            .frame(maxWidth: .infinity)
                            .background(Color("crearCuenta"))
                            .cornerRadius(30)
                            .padding(.horizontal, 140)
                    }
                    .navigationDestination(isPresented: $isCreatingAccount) {
                        SignUpView()
                    }
                    .navigationDestination(isPresented: $isLoggedIn) {
                        PrincipalView()
                    }
                    Spacer()
                }
                .padding(.top, 0)
                .alert(isPresented: $showErrorAlert) {
                    Alert(title: Text("Login Failed"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
    struct Login: Codable {
        var usuario: String
        var contrasena: String
    }
    
    struct LoginResponse: Codable {
        var message: String
    }

    func login() {
            isLoading = true
            
            guard let url = URL(string: "http://10.22.181.197:5000/api/usuarios/login") else {
                print("Invalid URL")
                errorMessage = "Invalid URL"
                showErrorAlert = true
                isLoading = false
                return
            }

            let loginData = Login(usuario: username, contrasena: password)

            guard let jsonData = try? JSONEncoder().encode(loginData) else {
                print("Failed to encode login data")
                errorMessage = "Failed to encode login data"
                showErrorAlert = true
                isLoading = false
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    isLoading = false
                }

                if let error = error {
                    print("Error: \(error)")
                    errorMessage = "Error: \(error.localizedDescription)"
                    DispatchQueue.main.async {
                        showErrorAlert = true
                    }
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Error with response: \(response.debugDescription)")
                    errorMessage = "Invalid username or password"
                    DispatchQueue.main.async {
                        showErrorAlert = true
                    }
                    return
                }


                if let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                        DispatchQueue.main.async {
                            if decodedResponse.message == "Login exitoso" {
                                isLoggedIn = true  // Navigate to PrincipalView on successful login
                            } else {
                                errorMessage = "Login failed: \(decodedResponse.message)"
                                showErrorAlert = true
                            }
                        }
                    } catch {
                        print("Failed to decode response: \(error)")
                        errorMessage = "Failed to decode response"
                        DispatchQueue.main.async {
                            showErrorAlert = true
                        }
                    }
                }
            }.resume()
        }
    }

struct UsernameBut: View{
    @Binding var username: String
    var body: some View{
        TextField("Usuario", text: $username)
            .autocapitalization(.none)
            .foregroundColor(.white)
            .padding(10)
            .background(Color("botonUsuario"))
            .cornerRadius(30)
            .multilineTextAlignment(.center)
            .frame(height: 20)
            .padding(.horizontal, 80)
    }
}

struct InputPasswordLogin: View{
    @Binding var password: String
    var body: some View{
        SecureField("Contraseña", text: $password)
            .autocapitalization(.none)
            .padding(10)
            .background(Color("botonUsuario"))
            .cornerRadius(30)
            .multilineTextAlignment(.center)
            .frame(height: 20)
            .padding(.horizontal, 80)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
