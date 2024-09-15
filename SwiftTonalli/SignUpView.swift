//
//  SignUpView.swift
//  Tonalli
//
//  Created by Sofia Schneider Jimenez on 9/14/24.
//

import SwiftUI

struct SignUpView: View {
    var mtext = "Tonalli"
    @State var username = ""
    @State var email = ""
    @State var password = ""
    @State var firstName = ""
        @State var lastName = ""
    @State private var showAlert = false
    @State private var shouldNavigateToLogin = false
    
    var gradient = Gradient(colors: [
        Color("background1"),
        Color("background1.1")
    ])
    
    var body: some View {
        NavigationStack{
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
                        .padding(.bottom,70)
                    
                    Username(username: self.$username)
                    Mail(email: self.$email)
                    InputPassword(password: self.$password)
                    FirstName(firstName: self.$firstName)
                    LastName(lastName: self.$lastName)
                    
                    Button(action: {
                        signUp()
                    }) {
                        Text("Crear cuenta")
                            .foregroundColor(.white)
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .background(Color("botonLogin"))
                            .cornerRadius(30)
                            .padding(.horizontal, 120)
                            .padding(.top,80)
                    }
                    .padding(.top, 50)
                    
                    Spacer()
                    
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Registro exitoso"),
                        message: Text("Tu cuenta ha sido creada correctamente."),
                        dismissButton: .default(Text("Aceptar")) {
                            shouldNavigateToLogin = true
                        }
                    )
                }
                .navigationDestination(isPresented: $shouldNavigateToLogin) {
                    LoginView()
                }
            }}
        
    }
    
    struct User: Codable {
        var usuario: String
        var contrasena: String
        var correo: String
        var nombre: String
        var apellido: String
    }
    
    
    
    func signUp() {
        guard let url = URL(string: "http://10.22.181.197:5000/api/usuarios/register") else {
            print("Invalid URL")
            return
        }
        
        let newUser = User(usuario: username, contrasena: password, correo: email, nombre: firstName, apellido: lastName)
        
        guard let jsonData = try? JSONEncoder().encode(newUser) else {
            print("Failed to encode user data")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error in sign up: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error with response: \(response.debugDescription)")
                return
            }
            
            if let data = data {
                do {
                    let responseJSON = try JSONDecoder().decode([String: String].self, from: data)
                    if responseJSON["message"] == "Signup successful" {
                        DispatchQueue.main.async {
                            showAlert = true
                        }
                    } else {
                        print("Signup failed: \(responseJSON["message"] ?? "Unknown error")")
                    }
                } catch {
                    print("Failed to decode response: \(error)")
                }
            }
        }.resume()
    }
}

struct Username: View{
    @Binding var username: String
    var body: some View{
        TextField("Usuario", text: $username)
            .padding(12)
            .background(Color("background1.1"))
            .cornerRadius(10)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 50)
    }
}

struct Mail: View {
    @Binding var email: String
    var body: some View{
        TextField("Correo", text: $email)
            .padding(12)
            .background(Color("background1.1"))
            .cornerRadius(10)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 50)
    }
}

struct InputPassword: View{
    @Binding var password: String
    var body: some View {
        SecureField("Contraseña", text: $password)
            .padding(12)
            .background(Color("background1.1"))
            .cornerRadius(10)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 50)
    }
}

struct FirstName: View {
    @Binding var firstName: String
    var body: some View {
        TextField("Nombre", text: $firstName)
            .padding(12)
            .background(Color("background1.1"))
            .cornerRadius(10)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 50)
    }
}

struct LastName: View {
    @Binding var lastName: String
    var body: some View {
        TextField("Apellido", text: $lastName)
            .padding(12)
            .background(Color("background1.1"))
            .cornerRadius(10)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 50)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
    

