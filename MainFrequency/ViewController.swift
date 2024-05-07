//
//  ViewController.swift
//  UIKit MainFrequency
//
//  Created by Joaquim Pessoa Filho on 06/05/24.
//

import UIKit

class ViewController: UIViewController, AnalysisDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    private var recorderDelegate: AudioRecorderDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        recorderDelegate = AudioManager()
        recorderDelegate?.delegate = self
        
        frequencyLabel.text = "Frequência: 440 Hz"
        noteLabel.text = "A"
        
        self.recordButton.setTitle("Start", for: .normal)
    }
    
    @IBAction func handleButton(_ sender: Any) {
        guard let recorderDelegate = recorderDelegate else {
            print("Delegate para gravação não definido")
            return
        }
        
        if recorderDelegate.isRecording {
            self.recordButton.setTitle("Start", for: .normal)
            recorderDelegate.stop()
        } else {
            self.recordButton.setTitle("Stop", for: .normal)
            recorderDelegate.start()
        }
    }
    
    func didUpdate(frequency: Float, note: String) {
        DispatchQueue.main.async {
            let formatted = String(format: "Frequência: %.2f Hz", frequency)
            self.frequencyLabel.text = formatted
            self.noteLabel.text = note
        }
    }
}
