//
//  HistoryView.swift
//  Tonalli
//
//  Created by Sofia Schneider Jimenez on 9/15/24.
//
import SwiftUI

struct Translation: Identifiable {
    var id = UUID()  // Unique identifier
    var originalText: String  // The original text (e.g., in Spanish)
    var translatedText: String  // The translated text (e.g., in Tzotzil)
    var date: Date  // The date when the translation was made
}

struct HistoryView: View {
    // A list of past translations (dummy data for now)
    @State var translations: [Translation] = [
        Translation(originalText: "Hola, ¿cómo estás?", translatedText: "Kolaval, ¿ch'amel la?", date: Date()),
        Translation(originalText: "gracias", translatedText: "Kolaval", date: Date()),
        Translation(originalText: "estoy bien", translatedText: "Lek oyun", date: Date()),
        Translation(originalText: "que me recomiendas visitar", translatedText: "abil ava me’bel ta jich sk'inal", date: Date()),
        Translation(originalText: "donde puedo encontrar artesanias locales", translatedText: "banti ta xak kotanik ta p’ijotik ba ajk’opotik", date: Date()),
        Translation(originalText: "que festividades hay durante esta temporada", translatedText: "jabil va a chalal yu’un lo’on", date: Date()),
        Translation(originalText: "quiero probar comida tradicional", translatedText: "vok’ va k’axojel vinajel ta ton ta yich lo’on", date: Date()),
    ]
    
    var gradient = Gradient(colors: [
        Color("background1"),
        Color("botonLogin")
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
                            
                            Spacer() // Pushes the logo to the left
                        }
                        
                        Text("Tonalli")
                            .font(.custom("Lobster-Regular", size: 36))
                            .foregroundColor(.white)
                    }
                    .padding(.top, -10)
                    
                    Spacer().frame(height: 9)
                    
                    // List of translations
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(translations) { translation in
                                HStack {
                                    Text(translation.originalText)
                                        .font(.body)
                                        .foregroundColor(Color.black)
                                        .padding()
                                    
                                    Spacer()
                                    
                                    Text(translation.translatedText)
                                        .font(.body)
                                        .foregroundColor(Color.black)
                                        .padding()
                                }
                                .frame(maxWidth: .infinity)
                                .background(Color("background1.1"))
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.black.opacity(0.2), lineWidth: 1)
                                )
                                .padding(.horizontal, 10)
                            }
                        }
                        .padding(.bottom, 20)  // Add padding to prevent last item from being cut off
                    }
                    
                    // Removed Spacer() to give ScrollView space to scroll
                    
                    HStack(spacing: 90) {
                        // NavigationLink to PrincipalView
                        NavigationLink(destination: PrincipalView()) {
                            Image(systemName: "house.fill")
                                .foregroundColor(Color("simbolos"))
                                .frame(width: 40, height: 40)
                        }
                        
                        Button(action: {
                            // Clock button (currently the user is on HistoryView)
                        }) {
                            Image(systemName: "clock.fill")
                                .foregroundColor(Color("botonUsuario"))
                                .frame(width: 40, height: 40)
                        }
                        
                        // NavigationLink to ProfileView
                        NavigationLink(destination: ProfileView()) {
                            Image(systemName: "person.fill")
                                .foregroundColor(Color("simbolos"))
                                .frame(width: 40, height: 40)
                        }
                    }
                    .padding(.bottom, -1)
                }
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}

