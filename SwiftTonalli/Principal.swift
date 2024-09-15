//
//  Principal.swift
//  Tonalli
//
//  Created by Sofia Schneider Jimenez on 9/14/24.
//
import SwiftUI
import AVFoundation

struct PrincipalView: View {
    @State private var sourceLanguage = "Español"
    @State private var targetLanguage = "Tzotzil"
    @State private var inputText = ""
    @State private var outputText = ""
    @State private var isRecording = false
    @State private var audioRecorder: AVAudioRecorder?

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

                    VStack(spacing: 8) {
                        Button(action: {
                            // Action for language selection
                        }) {
                            Text(sourceLanguage)
                                .font(.system(size: 18))
                                .padding(10)
                                .frame(width: 190)
                                .background(Color("idiomaInput"))
                                .foregroundColor(.white)
                                .cornerRadius(70)
                        }

                        Image(systemName: "arrow.up.arrow.down")
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color("crearCuenta"))
                            .cornerRadius(40)

                        Text(targetLanguage)
                            .font(.system(size: 18))
                            .padding(10)
                            .frame(width: 180)
                            .background(Color("botonUsuario"))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                    .padding(.horizontal, 80)
                    .padding(.bottom, 20)

                    TextEditor(text: $inputText)
                        .frame(height: 160)
                        .padding(10)
                        .background(Color("background1.1"))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black.opacity(0.2), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                        .scrollContentBackground(.hidden)

                    TextEditor(text: $outputText)
                        .frame(height: 160)
                        .padding(10)
                        .background(Color("background1.1"))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black.opacity(0.2), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                        .disabled(true)
                        .scrollContentBackground(.hidden)

                    Spacer()

                    HStack(spacing: 100) {
                        AudioButton()
                        RecordAudioButton(isRecording: $isRecording, startRecording: startRecording, stopRecording: stopRecording)
                    }
                    .padding(.bottom, 20)

                    HStack(spacing: 90) {
                        Button(action: {
                            // Home button action if needed
                        }) {
                            Image(systemName: "house.fill")
                                .foregroundColor(Color("botonUsuario"))
                                .frame(width: 40, height: 40)
                        }

                        // NavigationLink to HistoryView with smooth transition
                        NavigationLink(destination: HistoryView()
                                        .transition(.opacity)  // Adds a fade-in/fade-out effect
                        ) {
                            Image(systemName: "clock.fill")
                                .foregroundColor(Color("simbolos"))
                                .frame(width: 40, height: 40)
                        }
                        .animation(.easeInOut, value: isRecording)  // Adds smooth animation

                        // NavigationLink to ProfileView with smooth transition
                        NavigationLink(destination: ProfileView()
                                        .transition(.opacity)  // Adds a fade-in/fade-out effect
                        ) {
                            Image(systemName: "person.fill")
                                .foregroundColor(Color("simbolos"))
                                .frame(width: 40, height: 40)
                        }
                        .animation(.easeInOut, value: isRecording)  // Adds smooth animation
                    }
                    .padding(.bottom, -1)
                }
            }
        }
    }

    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try audioSession.setActive(true)

            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            let fileURL = getDocumentsDirectory().appendingPathComponent("recording.m4a")

            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.record()

            isRecording = true
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }


    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false

        if let recorder = audioRecorder {
            sendAudioToBackend(audioFileURL: recorder.url)
        }

        // Añadimos frases hardcodeadas después de detener la grabación
        DispatchQueue.main.async {
            self.inputText = "Hola, ¿cómo estás?" // Frase en español
            self.outputText = "Kolaval, ¿ch'amel la?" // Traducción hardcodeada en tzotzil
        }
    }

    func sendAudioToBackend(audioFileURL: URL) {
        guard let url = URL(string: "http://10.22.181.197/:5000/upload_audio") else {
            print("Invalid backend URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate = formatter.string(from: date)

        var body = Data()

        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"date\"\r\n\r\n")
        body.append("\(currentDate)\r\n")

        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"recording.mp3\"\r\n")
        body.append("Content-Type: audio/mpeg\r\n\r\n")
        if let fileData = try? Data(contentsOf: audioFileURL) {
            body.append(fileData)
        }
        body.append("\r\n--\(boundary)--\r\n")

        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending audio: \(error)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response from server")
                return
            }

            if let data = data, let translatedText = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.outputText = translatedText
                }
            }
        }.resume()
    }

    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

struct RecordAudioButton: View {
    @Binding var isRecording: Bool
    var startRecording: () -> Void
    var stopRecording: () -> Void

    var body: some View {
        Button(action: {
            if isRecording {
                stopRecording()
            } else {
                startRecording()
            }
        }) {
            Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                .foregroundColor(.black)
                .frame(width: 70, height: 70)
                .background(Color("idiomaInput"))
                .cornerRadius(100)
        }
    }
}

struct AudioButton: View {
    var body: some View {
        Button(action: {
        }) {
            Image(systemName: "speaker.wave.2.fill")
                .foregroundColor(.black)
                .frame(width: 70, height: 70)
                .background(Color("idiomaInput"))
                .cornerRadius(100)
        }
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}




struct PrincipalView_Previews: PreviewProvider {
    static var previews: some View {
        PrincipalView()
    }
}
