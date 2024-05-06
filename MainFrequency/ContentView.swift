import SwiftUI
import AVFoundation
import Accelerate

struct ContentView: View {
    @StateObject private var audioManager = AudioManager()

    var body: some View {
        VStack {
            if audioManager.isLoudEnough {
                Text("Frequência Atual: \(audioManager.currentFrequency, specifier: "%.2f") Hz")
            } else {
                Text("Áudio muito baixo para análise")
            }
        }
        .onAppear {
            audioManager.startAudioEngine()
        }
        .onDisappear {
            audioManager.stopAudioEngine()
        }
    }
}

class AudioManager: ObservableObject {
    private var audioEngine: AVAudioEngine!
    private var inputNode: AVAudioInputNode!
    private var audioFormat: AVAudioFormat!
    
    private let amplitudeThreshold: Float = 0.01
    private var sampleRate: Float = 44100.0  // Esta taxa deve corresponder à configuração real do hardware

    @Published var currentFrequency: Float = 0.0
    @Published var isLoudEnough: Bool = false

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
            
            Task {
                await MainActor.run {
                    self.isLoudEnough = isLoudEnough
                }
            }
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
                    }
                }
            }
        }

        do {
            try audioEngine.start()
        } catch {
            print("Erro ao iniciar o engine de áudio: \(error)")
        }
    }

    func startAudioEngine() {
        guard !audioEngine.isRunning else { return }
        do {
            try audioEngine.start()
        } catch {
            print("Erro ao iniciar o engine de áudio: \(error)")
        }
    }

    func stopAudioEngine() {
        audioEngine.stop()
    }
}
