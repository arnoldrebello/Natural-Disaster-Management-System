//
//  EmergencyCategoriesViewController.swift
//  Disaster Management
//
//  Created by Arnold Rebello on 7/30/20.
//  Copyright © 2020 Arnold Rebello. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class EmergencyCategoriesViewController: SwipeTableViewController {
    
    
    var categories = [Category]()
    let db = Database.database().reference(withPath: "Essential Needs")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
      
        tableView.rowHeight = 80.0
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //MARK: - table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EmergencyNeedsViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name ?? "No Categories Added Yet"
        return cell
        
    }
    func mergeCategories( countval :Int)
    {
        do {if countval==0{
            db.observe(.childAdded) { (Snapshot) in
                print(Snapshot.key)
                let newCategory = Category(context: self.context)
                newCategory.name = Snapshot.key
                self.categories.append(newCategory)
                self.saveCategories()
            }
        }
        else   {
            db.observe(.childAdded) { (Snapshot) in
                var array = [String]()
                for i in 0...self.categories.count-1{
                    array.append(self.categories[i].name!)
                }
                
                if (array.contains(Snapshot.key)) {
                    print("found same category")
                    print(Snapshot.key)
                }
                else {
                    let newCategory = Category(context: self.context)
                    newCategory.name = Snapshot.key
                    self.categories.append(newCategory)
                    self.saveCategories()
                }
            }
            
            
            }
        }
    }
    func saveCategories()
    {do {
        try context.save()
        
    }catch{
        print("Error saving category\(error)")
        }
        tableView.reloadData()
        
    }
    
    func loadCategories() {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categories = try context.fetch(request)
            mergeCategories(countval: categories.count)
        }catch {
            print("Error loading categories \(error)")
        }
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = categories[indexPath.row] as? NSManagedObject  {
            print(categoryForDeletion)
            context.delete(categoryForDeletion)
            db.child(categories[indexPath.row].name!).removeValue()
            self.categories.remove(at: indexPath.row)
            do {
                // Save Managed Object Context
                try context.save()
                
            } catch {
                print("Unable to save managed object context.")
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert  = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            print("1.\(newCategory) 2.\(Category()) 3.\(self.context)" )
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            self.saveCategories()
            

        }
        
        
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new Category"
        }
        present(alert, animated:true, completion: nil)
    }
    
}


