//
//  Home.swift
//  Notas2Storyboard
//
//  Created by Daniel Moya on 19/12/23.
//

import UIKit
import CoreData

class Home: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var table: UITableView!
    var notes = [Notes]()
    var fetchResultController: NSFetchedResultsController<Notes>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        showNotes()

        //Style bar appearance
        let appearance = UINavigationBarAppearance()
               appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemMint
               appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0),
                                                 .foregroundColor: UIColor.black]
               
        navigationController?.navigationBar.tintColor = .white
               navigationController?.navigationBar.standardAppearance = appearance
               navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //Edit
//        let btnEdit = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
//            print("Edit")
//        }
//        btnEdit.image = UIImage(systemName: "pencil")
//        btnEdit.backgroundColor = .systemBlue
        
        //Delete
        let btnDelete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            let context = Model.shared.context()
            let deleteItem = self.fetchResultController.object(at: indexPath)
            context.delete(deleteItem)
            
            do {
                try context.save()
            } catch let error as NSError {
                print("NOT DELETE", error.localizedDescription)
            }
        }
        btnDelete.image = UIImage(systemName: "trash")
        
        //Actions set
        return UISwipeActionsConfiguration(actions: [/*btnEdit,*/ btnDelete])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let note = notes[indexPath.row]
        
        //Title item bold style
        let attrs = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]
        let attributedString = NSMutableAttributedString(string: note.title ?? "", attributes: attrs)
        cell.textLabel?.attributedText = attributedString
        
        //Date item
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale.current
        cell.detailTextLabel?.text = dateFormatter.string(from: note.date ?? Date())
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "send", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "send"{
            if let id = table.indexPathForSelectedRow{
                let row = notes[id.row]
                let destination = segue.destination as! addView
                destination.notes = row
            }
        }
    }
    //NSFETCHEDRESULT
    func showNotes(){
        let context = Model.shared.context()
        let fetchRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
        let order = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [order]
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        
        do {
            try fetchResultController.performFetch()
            notes = fetchResultController.fetchedObjects!
        } catch let error as NSError {
            print("Didn't show anything", error.localizedDescription)
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        table.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        table.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.table.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            self.table.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            self.table.reloadRows(at: [indexPath!], with: .fade)
        default:
            self.table.reloadData()
        }
        
        self.notes = controller.fetchedObjects as! [Notes]
    }
    

}
