//
//  FourthViewController.swift
//  Disaster Management
//
//  Created by Arnold Rebello on 6/7/20.
//  Copyright © 2020 Arnold Rebello. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class EmergencyNeedsViewController: SwipeTableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    let db = Database.database().reference(withPath: "Essential Needs")
    
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    let defaults = UserDefaults.standard
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadItems()
        
//        if let items = defaults.array(forKey: "EssentialListCategories") as? [Item]{
//            itemArray = items
//
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory!.name
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        to delete
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        let timestamp = Double(Date().timeIntervalSince1970*1000)
        db.child(selectedCategory!.name!).child(itemArray[indexPath.row].title!).updateChildValues(["Required": itemArray[indexPath.row].done, "Timestamp": timestamp.rounded()])
        saveItems()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add an Essential List Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add new Category", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            let timestamp = Double(Date().timeIntervalSince1970*1000)
            self.db.child(self.selectedCategory!.name!).child(newItem.title!).setValue([ "Required": newItem.done, "Timestamp": timestamp.rounded()])
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Category Name"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func mergeItems( countval :Int)
    {
        do {if countval==0{
            db.child(selectedCategory!.name!).observe(.childAdded) { (Snapshot) in
                print(Snapshot.key)
                let newItem = Item(context: self.context)
                newItem.title = Snapshot.key
                newItem.done = false
                self.itemArray.append(newItem)
                self.saveItems()
            }
        }
        else   {
            db.child(selectedCategory!.name!).observe(.childAdded) { (Snapshot) in
                var array = [String]()
                for i in 0...self.itemArray.count-1{
                    array.append(self.itemArray[i].title!)
                }
                
                if (array.contains(Snapshot.key)) {
                    print("found same Item")
                    print(Snapshot.key)
                }
                else {
                    let newItem = Item(context: self.context)
                    newItem.title = Snapshot.key
                    newItem.done = (Snapshot.value(forKey: "Required") != nil)
                    self.itemArray.append(newItem)
                    self.saveItems()
                }
            }
            
            
            }
        }
    }
    
    func saveItems() {
        do{
            try context.save()
            
        }
        catch{
            print("Error saving context\(error)")
        }
            self.tableView.reloadData()
    }

    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }
        else {
            request.predicate = categoryPredicate
        }
        
        do
        {
         itemArray = try context.fetch(request)
            print(itemArray)
            mergeItems(countval: itemArray.count)
        }
        catch{
            print("Error printing data from context \(error)")
        }
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = itemArray[indexPath.row] as? NSManagedObject{
            self.context.delete(item)
            self.itemArray.remove(at: indexPath.row)
            do {
                // Save Managed Object Context
                try context.save()

            } catch {
                print("Unable to save managed object context.")
            }
        }
    }
    
    
}

//MARK: - Search Bar methods

extension EmergencyNeedsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        print(searchBar.text!)
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate)
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
