//
//  ViewController.swift
//  To-Do App
//
//  Created by Zachary Broeg on 7/12/18.
//  Copyright © 2018 Zachary Broeg. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UITableViewController {

    var arrayItem = [Data]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        loadItems()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayItem.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = arrayItem[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        arrayItem[indexPath.row].done = !arrayItem[indexPath.row].done
    
        //CODE TO DELETE THE CODE
        //context.delete(arrayItem[indexPath.row])
        //arrayItem.remove(at: indexPath.row)
        //saveItems()
    
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Task", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            
            let newItem = Data(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            //newItem.parentCategory = self.selectedCategory
            self.arrayItem.append(newItem)
            
           
            self.saveItems()
            
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Task"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    
    }
    
    func saveItems() {
        
        do {
            try self.context.save()
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        let request : NSFetchRequest<Data> = Data.fetchRequest()
        do {
         arrayItem = try context.fetch(request)
        } catch {
            print("Error fetching Data \(error)")
        }
        
        tableView.reloadData()
    }
    
    

}


extension NotesViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Data> = Data.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        do {
            arrayItem = try context.fetch(request)
        } catch {
            print("Error fetching Data \(error)")
        }
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
