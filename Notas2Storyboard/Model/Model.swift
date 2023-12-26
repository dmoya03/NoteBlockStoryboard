//
//  Model.swift
//  Notas2Storyboard
//
//  Created by Daniel Moya on 19/12/23.
//

import Foundation
import CoreData
import UIKit

class Model {
    
    public static let shared = Model()
    
    func context() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    
    func saveData(title: String, note: String, date: Date) -> Void {
        let context = context()
        let entityNotes = NSEntityDescription.insertNewObject(forEntityName: "Notes", into: context) as! Notes
        entityNotes.title = title
        entityNotes.note = note
        entityNotes.date = date
        
        do {
            try context.save()
            print("Guardo")
        } catch let error as NSError {
            print("Error:", error.localizedDescription)
        }
        
    }
    
    func editData(title: String, note: String, date: Date, notes: Notes) -> Void {
        let context = context()
        notes.setValue(title, forKey: "title")
        notes.setValue(note, forKey: "note")
        notes.setValue(date, forKey: "date")
        do {
            try context.save()
            print("Edito")
        } catch let error as NSError {
            print("Error:", error.localizedDescription)
        }
        
    }
}
