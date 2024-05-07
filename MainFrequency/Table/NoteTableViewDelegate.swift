//
//  NoteTableViewDelegate.swift
//  MainFrequency
//
//  Created by Joaquim Pessoa Filho on 07/05/24.
//

import UIKit

class NoteTableViewDelegate: NSObject, UITableViewDelegate {
    weak var dataSource: NoteDataSource?
    weak var tableView: UITableView?
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, success) in
            self.dataSource?.notes.remove(at: indexPath.row)
            self.tableView?.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [delete])
        return swipeActions
    }
}
