//
//  ViewController.swift
//  UIKit MainFrequency
//
//  Created by Joaquim Pessoa Filho on 06/05/24.
//

import UIKit

class ViewController: UIViewController, AnalysisDelegate {
    
    var recordButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = .systemBlue
        button.setTitle("Start", for: .normal)
        button.layer.cornerRadius = 12
        
        return button
    }()
    
    var frequencyLabel: UILabel = UILabel()
    var noteLabel: UILabel = UILabel()
    
    private var recorderDelegate: AudioRecorderDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "First View"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupButton()
        setupLabels()
        
        recorderDelegate = AudioManager()
        recorderDelegate?.delegate = self
    }
    
    func setupLabels() {
        view.addSubview(noteLabel)
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        noteLabel.textAlignment = .center
        noteLabel.text = "A"
        
        NSLayoutConstraint.activate([
            noteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noteLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            noteLabel.heightAnchor.constraint(equalToConstant: 30),
            noteLabel.bottomAnchor.constraint(equalTo: recordButton.topAnchor, constant: -16)
        ])
        
        view.addSubview(frequencyLabel)
        frequencyLabel.translatesAutoresizingMaskIntoConstraints = false
        frequencyLabel.textAlignment = .center
        frequencyLabel.text = "Frequência: 440 Hz"
        
        NSLayoutConstraint.activate([
            frequencyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            frequencyLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            frequencyLabel.heightAnchor.constraint(equalToConstant: 30),
            frequencyLabel.bottomAnchor.constraint(equalTo: noteLabel.topAnchor)
        ])
    }
    
    func setupButton() {
        view.addSubview(recordButton)
        
        recordButton.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            recordButton.widthAnchor.constraint(equalToConstant: 200),
            recordButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @IBAction func handleButton() {
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

#Preview("First") {
    return ViewController()
}
