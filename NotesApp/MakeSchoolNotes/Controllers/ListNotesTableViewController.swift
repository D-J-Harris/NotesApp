//
//  ListNotesTableViewController.swift
//  MakeSchoolNotes
//
//  Created by Chris Orcutt on 1/10/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit

class ListNotesTableViewController: UITableViewController {
    
    @IBOutlet weak var orderSwitch: UISwitch!
    
    // MARK: - Properties
    
    var notes = [Note]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notes = CoreDataHelper.retrieveNotes()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        if ( notes.count < 15 ) {
            return 15
        }
        else {
                return notes.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 2
        let cell = tableView.dequeueReusableCell(withIdentifier: "listNotesTableViewCell", for: indexPath) as! ListNotesTableViewCell
        
        if ( indexPath.row % 2 == 0 ) {
            cell.backgroundColor = UIColor(displayP3Red: 0.9, green: 0.4, blue: 0.4, alpha: 0.35)
        }
        else {
            cell.backgroundColor = UIColor(displayP3Red: 0.9, green: 0.4, blue: 0.4, alpha: 0.55)
        }
        
        
        if ( indexPath.row < notes.count ) {
            let note = notes[indexPath.row]
            cell.noteTitleLabel.text = note.title
            cell.noteModificationTimeLabel.text = note.modificationTime?.convertToString() ?? "unknown"
            cell.notePreviewLabel.text = note.preview
        }
        else {
            cell.noteTitleLabel.text = nil
            cell.noteModificationTimeLabel.text = nil
            cell.notePreviewLabel.text = nil
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let noteToDelete = notes[indexPath.row]
            CoreDataHelper.deleteNote(note: noteToDelete)
            
            notes = CoreDataHelper.retrieveNotes()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 1
        guard let identifier = segue.identifier else { return }
        
        // 2
        switch identifier {
        case "displayNote":
            // 1
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            // 2
            let note = notes[indexPath.row]
            // 3
            let destination = segue.destination as! DisplayNoteViewController
            // 4
            destination.note = note
            
        case "addNote":
            print("create note bar button item tapped")
            
        default:
            print("unexpected segue identifier")
        }
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
        notes = CoreDataHelper.retrieveNotes()
    }
    
    @IBAction func switchTapped(_ sender: UISwitch) {
        notes.reverse()
        tableView.reloadData()
    }
    
}


