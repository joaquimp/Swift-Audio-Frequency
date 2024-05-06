//
//  ViewController.swift
//  UIKit MainFrequency
//
//  Created by Joaquim Pessoa Filho on 06/05/24.
//

import UIKit

class ViewController: UIViewController, AnalysisDelegate {
    
    @IBOutlet weak var startStopBtn: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    
    private var recorderDelegate: AudioRecorderDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        recorderDelegate = AudioManager()
        recorderDelegate?.delegate = self
        
        frequencyLabel.text = "0 Hz"
        messageLabel.text = ""
        
        self.startStopBtn.setTitle("Start", for: .normal)
    }
    
    @IBAction func handleButton(_ sender: Any) {
        guard let recorderDelegate = recorderDelegate else {
            messageLabel.text = "Delegate para gravação não definido"
            return
        }
        
        messageLabel.text = ""
        
        if recorderDelegate.isRecording {
            self.startStopBtn.setTitle("Start", for: .normal)
            recorderDelegate.stop()
            messageLabel.text = "gravação parada"
        } else {
            self.startStopBtn.setTitle("Stop", for: .normal)
            recorderDelegate.start()
            messageLabel.text = "gravando..."
        }
        
    }
    
    func didUpdate(frequency: Float) {
        DispatchQueue.main.async {
            self.frequencyLabel.text = "\(frequency) Hz"
        }
    }

}

