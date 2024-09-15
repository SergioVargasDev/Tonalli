//
//  ProfileView.swift
//  Tonalli
//
//  Created by Sofia Schneider Jimenez on 9/15/24.
//

import SwiftUI

struct ProfileView: View {
    @State var username = "currentUsername"
    @State var email = "currentEmail@example.com"
    @State var password = ""
    @State private var isSaving = false
    @State private var alertMessage = ""
    @State private var showAlert = false

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
                
                VStack(spacing: 2) {
                    ZStack {
                        HStack {
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 160, height: 90)
                            
                            Spacer()
                        }
                        
                        Text("Tonalli")
                            .font(.custom("Lobster-Regular", size: 36))
                            .foregroundColor(.white)
                    }
                    .padding(.top, -10)
                    
                    Spacer().frame(height: 90)
                    
                    VStack(alignment: .leading, spacing: 30) {
                        // Username
                        VStack(alignment: .leading) {
                            Text("Usuario")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            TextField("Usuario", text: $username)
                                .padding(12)
                                .background(Color("botonUsuario"))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 50)
                        
                        // Email
                        VStack(alignment: .leading) {
                            Text("Correo")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            TextField("Correo", text: $email)
                                .padding(12)
                                .background(Color("botonUsuario"))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 50)
                        
                        // Password
                        VStack(alignment: .leading) {
                            Text("Contraseña")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            SecureField("Contraseña", text: $password)
                                .padding(12)
                                .background(Color("botonUsuario"))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 50)
                    }
                    
                    // Save Changes Button
                    if isSaving {
                        ProgressView()
                            .padding()
                    } else {
                        Button(action: {
                            saveChanges()
                        }) {
                            Text("Guardar cambios")
                                .foregroundColor(.white)
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(Color("idiomaInput"))
                                .cornerRadius(30)
                                .padding(.horizontal, 120)
                                .padding(.top, 160)
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Atención"), message: Text(alertMessage), dismissButton: .default(Text("Aceptar")))
                        }
                    }

                    Spacer()
                    
                    // Navigation Buttons at the bottom (with navigation to PrincipalView and HistoryView)
                    HStack(spacing: 90) {
                        // NavigationLink to PrincipalView
                        NavigationLink(destination: PrincipalView()) {
                            Image(systemName: "house.fill")
                                .foregroundColor(Color("simbolos"))
                                .frame(width: 40, height: 40)
                        }

                        // NavigationLink to HistoryView
                        NavigationLink(destination: HistoryView()) {
                            Image(systemName: "clock.fill")
                                .foregroundColor(Color("simbolos"))
                                .frame(width: 40, height: 40)
                        }

                        // No NavigationLink for Profile button since the user is already in ProfileView
                        Image(systemName: "person.fill")
                            .foregroundColor(Color("botonUsuario"))
                            .frame(width: 40, height: 40)
                    }
                    .padding(.bottom, -1) // Adjust padding to match the history view
                }
            }
        }
    }

    // Save changes to the backend
    func saveChanges() {
        isSaving = true
        
        guard let url = URL(string: "http://127.0.0.1:5000/api/usuarios/update_profile") else {
            alertMessage = "Invalid URL"
            showAlert = true
            isSaving = false
            return
        }
        
        let updatedUser = User(username: username, email: email, password: password)
        
        guard let jsonData = try? JSONEncoder().encode(updatedUser) else {
            alertMessage = "Failed to encode user data"
            showAlert = true
            isSaving = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isSaving = false
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    alertMessage = "Error updating profile: \(error.localizedDescription)"
                    showAlert = true
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    alertMessage = "Invalid response from server"
                    showAlert = true
                }
                return
            }
            
            DispatchQueue.main.async {
                alertMessage = "Los cambios han sido guardados correctamente."
                showAlert = true
            }
        }.resume()
    }
}

struct User: Codable {
    var username: String
    var email: String
    var password: String
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
