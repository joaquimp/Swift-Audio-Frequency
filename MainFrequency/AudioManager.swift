//
//  MainFrequencyApp.swift
//  MainFrequency
//
//  Created by Joaquim Pessoa Filho on 06/05/24.
//

import Foundation
import AVFoundation
import Accelerate

@Observable
class AudioManager {
    private var audioEngine: AVAudioEngine!
    private var inputNode: AVAudioInputNode!
    private var audioFormat: AVAudioFormat!
    
    private let amplitudeThreshold: Float = 0.01
    private var sampleRate: Float = 44100.0  // Esta taxa deve corresponder à configuração real do hardware

    var currentFrequency: Float = 440.00
    var currentNote: String = "A"
    var isRecording: Bool = false

    init() {
        setupAudioEngine()
    }

    private func setupAudioEngine() {
        audioEngine = AVAudioEngine()
        inputNode = audioEngine.inputNode
        audioFormat = inputNode.outputFormat(forBus: 0)
        
        print("Sample: \(audioFormat.sampleRate)")
        self.sampleRate = Float(audioFormat.sampleRate)

        let frameLength = UInt(16384)  // Tamanho do buffer ajustado para melhor resolução da FFT
        let fftSetup = vDSP_create_fftsetup(vDSP_Length(log2(Float(frameLength))), FFTRadix(kFFTRadix2))

        var real = [Float](repeating: 0, count: Int(frameLength))
        var imag = [Float](repeating: 0, count: Int(frameLength))
        var window = [Float](repeating: 0, count: Int(frameLength))
        vDSP_hann_window(&window, frameLength, Int32(vDSP_HANN_NORM))
        var fftMagnitudes = [Float](repeating: 0, count: Int(frameLength / 2))
        var complexBuffer = DSPSplitComplex(realp: &real, imagp: &imag)
        
        inputNode.installTap(onBus: 0, bufferSize: AVAudioFrameCount(frameLength), format: audioFormat) { buffer, _ in
            let bufferPointer = UnsafeMutableBufferPointer(start: &real, count: Int(frameLength))
            buffer.floatChannelData!.pointee.withMemoryRebound(to: Float.self, capacity: Int(frameLength)) { channelData in
                vDSP_vmul(channelData, 1, window, 1, bufferPointer.baseAddress!, 1, frameLength)
            }
            
            // Calcular RMS para verificar se o áudio é alto o suficiente para análise
            var meanSquare: Float = 0
            vDSP_measqv(bufferPointer.baseAddress!, 1, &meanSquare, vDSP_Length(frameLength))
            let rmsValue = sqrt(meanSquare)
            
            let isLoudEnough = rmsValue > self.amplitudeThreshold
       
            if isLoudEnough {
                // Conversão de dados reais para um formato complexo usado pela FFT
                vDSP_ctoz(bufferPointer.baseAddress!.withMemoryRebound(to: DSPComplex.self, capacity: Int(frameLength / 2)) { $0 }, 2, &complexBuffer, 1, vDSP_Length(frameLength / 2))
                vDSP_fft_zrip(fftSetup!, &complexBuffer, 1, vDSP_Length(log2(Float(frameLength))), FFTDirection(FFT_FORWARD))
                vDSP_zvmags(&complexBuffer, 1, &fftMagnitudes, 1, vDSP_Length(frameLength / 2))
                
                var maxFrequencyIndex: vDSP_Length = 0
                var maxMagnitude: Float = 0
                vDSP_maxvi(&fftMagnitudes, 1, &maxMagnitude, &maxFrequencyIndex, vDSP_Length(frameLength / 2))
                
                let frequency = Float(maxFrequencyIndex) * (self.sampleRate / Float(frameLength))
                
                Task {
                    await MainActor.run {
                        self.currentFrequency = frequency
                        self.currentNote = self.frequencyToNote(Double(frequency))
                    }
                }
            }
        }
    }
    
    private func frequencyToNote(_ frequency: Double) -> String {
        let noteNames = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
        let a4 = 440.0
        let a4Index = 9 // Index of A in the noteNames array (starting from C)

        // Calculate the number of half steps away from A4
        let halfStepsFromA4 = Int(round(12 * log(frequency / a4) / log(2.0)))
        
        // Calculate the index of the note in the array
        let noteIndex = (a4Index + halfStepsFromA4 + 120) % 12 // +120 to avoid negative index
        return noteNames[noteIndex]
    }


    func start() {
        guard !audioEngine.isRunning else {
            isRecording = false
            return
        }
        
        do {
            try audioEngine.start()
            isRecording = true
        } catch {
            isRecording = false
            print("Erro ao iniciar o engine de áudio: \(error)")
        }
    }

    func stop() {
        audioEngine.stop()
        isRecording = false
    }
}
