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
    private var note: Note = Note(icon: .A, frequency: 440)
    
    // TableView
    @IBOutlet weak var tableView: UITableView!
    private var noteDataSource = NoteDataSource()
    private var noteTableViewDelegate = NoteTableViewDelegate()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configurando delegate
        recorderDelegate = AudioManager()
        recorderDelegate?.delegate = self
        
        // Configurando table
        self.tableView.dataSource = self.noteDataSource
        self.tableView.delegate = self.noteTableViewDelegate
        self.noteTableViewDelegate.dataSource = self.noteDataSource
        self.noteTableViewDelegate.tableView = self.tableView
        
        // configurando View
        frequencyLabel.text = "Frequência: 440 Hz"
        noteLabel.text = "A"
        configRecordButton(enable: false)
    }
    
    private func configRecordButton(enable: Bool) {
        if enable {
            self.recordButton.setTitle("Parar", for: .normal)
            self.recordButton.backgroundColor = #colorLiteral(red: 1, green: 0.2156862745, blue: 0.3725490196, alpha: 1)
        } else {
            self.recordButton.setTitle("Iniciar", for: .normal)
            self.recordButton.backgroundColor = #colorLiteral(red: 0.03899999335, green: 0.5180000067, blue: 1, alpha: 1)
        }
        self.recordButton.layer.cornerRadius = 25
        self.recordButton.setTitleColor(.white, for: .normal)
    }
    
    @IBAction func handleButton(_ sender: Any) {
        guard let recorderDelegate = recorderDelegate else {
            print("Delegate para gravação não definido")
            return
        }
        
        if recorderDelegate.isRecording {
            recorderDelegate.stop()
        } else {
            recorderDelegate.start()
        }
        
        configRecordButton(enable: recorderDelegate.isRecording)
    }
    
    @IBAction func addNote(_ sender: Any) {
        self.noteDataSource.notes.append(self.note)
        self.tableView.reloadData()
    }
    
    func didUpdate(frequency: Float, note: String) {
        DispatchQueue.main.async {
            self.note = Note(icon: NoteIcon(rawValue: note), frequency: frequency)
            let formatted = String(format: "Frequência: %.2f Hz", frequency)
            self.frequencyLabel.text = formatted
            self.noteLabel.text = note
        }
    }
}
