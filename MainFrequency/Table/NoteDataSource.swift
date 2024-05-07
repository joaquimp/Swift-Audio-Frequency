//
//  NoteDataSource.swift
//  MainFrequency
//
//  Created by Joaquim Pessoa Filho on 07/05/24.
//

import UIKit

class NoteDataSource: NSObject, UITableViewDataSource {
    var notes: [Note] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Não encontrou a célula registrada
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell") as? NoteCell else {
            let cell = UITableViewCell()
            cell.textLabel?.text = notes[indexPath.row].icon.rawValue
            return cell
        }
        
        cell.setup(note: self.notes[indexPath.row])
        return cell
    }
}
