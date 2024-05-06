//
//  ViewController.swift
//  UIKit MainFrequency
//
//  Created by Joaquim Pessoa Filho on 06/05/24.
//

import UIKit

class ViewController: UIViewController, AnalysisDelegate {
    
    var startStopBtn: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = .systemBlue
        button.setTitle("Start", for: .normal)
        button.layer.cornerRadius = 12
        
        return button
    }()
    
    var messageLabel: UILabel = UILabel()
    var frequencyLabel: UILabel = UILabel()
    var frequencyFixedLabel: UILabel = UILabel()
    
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
        view.addSubview(frequencyLabel)
        frequencyLabel.translatesAutoresizingMaskIntoConstraints = false
        frequencyLabel.textAlignment = .center
        frequencyLabel.text = "0 Hz"
        
        NSLayoutConstraint.activate([
            frequencyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            frequencyLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            frequencyLabel.heightAnchor.constraint(equalToConstant: 30),
            frequencyLabel.bottomAnchor.constraint(equalTo: startStopBtn.topAnchor, constant: -28),
        ])
        
        
        
        view.addSubview(frequencyFixedLabel)
        frequencyFixedLabel.translatesAutoresizingMaskIntoConstraints = false
        frequencyFixedLabel.textAlignment = .center
        frequencyFixedLabel.text = "Frequency"

        NSLayoutConstraint.activate([
            frequencyFixedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            frequencyFixedLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            frequencyFixedLabel.heightAnchor.constraint(equalToConstant: 30),
            frequencyFixedLabel.bottomAnchor.constraint(equalTo: frequencyLabel.topAnchor, constant: 8),
        ])
        
        view.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textAlignment = .center
        messageLabel.text = "gravação parada"
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            messageLabel.heightAnchor.constraint(equalToConstant: 30),
            messageLabel.topAnchor.constraint(equalTo: startStopBtn.bottomAnchor, constant: 8),
        ])
    }
    
    func setupButton() {
        view.addSubview(startStopBtn)
        
        startStopBtn.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        
        startStopBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            startStopBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startStopBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            startStopBtn.widthAnchor.constraint(equalToConstant: 200),
            startStopBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @IBAction func handleButton() {
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

#Preview("First") {
    return ViewController()
}
