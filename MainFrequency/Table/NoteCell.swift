//
//  NoteCell.swift
//  MainFrequency
//
//  Created by Joaquim Pessoa Filho on 07/05/24.
//

import UIKit

class NoteCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var frequencyLabel: UILabel!
    
    func setup(note: Note) {
        self.icon.image = UIImage(named: note.icon.rawValue)
        let formatted = String(format: "Frequência: %.2f", note.frequency)
        self.frequencyLabel.text = formatted
    }
}
