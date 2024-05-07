//
//  MainFrequencyApp.swift
//  MainFrequency
//
//  Created by Joaquim Pessoa Filho on 06/05/24.
//

import SwiftUI

struct ContentView: View {
    @State private var audioManager = AudioManager()
    
    var body: some View {
        VStack {
            Text("Frequência: \(audioManager.currentFrequency, specifier: "%.2f") Hz")
            Text(audioManager.currentNote)
            
            Button(action: {
                if audioManager.isRecording {
                    audioManager.stop()
                } else {
                    audioManager.start()
                }
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 25.0)
                        .foregroundStyle(audioManager.isRecording ? .enabled : .accent)
                    Text(audioManager.isRecording ? "Stop" : "Start")
                        .foregroundStyle(.white)
                }.frame(width: 150, height: 50)
            })
        }
        .onDisappear {
            audioManager.stop()
        }
    }
}

// AVFoundation problem
//#Preview {
//    ContentView()
//}
