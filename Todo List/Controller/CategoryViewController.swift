//
//  CategoryViewController.swift
//  Todo List
//
//  Created by Wmotion Mac 101 on 5/14/18.
//  Copyright © 2018 Wmotion Mac 101. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    var categoryArray: Results<Category>?
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
        tableView.rowHeight = 80
        
        tableView.separatorStyle = .none
    }
    
    //MARK:- TableView Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //MARK:- Nil Coalescing Operator
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categoryArray?[indexPath.row] {
            
            cell.textLabel?.text = category.name 
            
            cell.backgroundColor = UIColor(hexString: category.hexColor)
            
            cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: category.hexColor)!, returnFlat: true)
            
        }
         
        return cell
    }
    
    //MARK:- TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: Move to another category
        performSegue(withIdentifier: "goToItem", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:- Passing Data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ToDoListViewController
        
        if let index = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categoryArray?[index.row]
        }
    }
    
    //MARK:- TableView Data Manipulation
    private func loadItems() {
        
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    private func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK:- Delete data from swipe
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categoryArray?[indexPath.row] {
            
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print(error)
            }
        }
        
    }

    //MARK:- Add New Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        let submit = UIAlertAction(title: "Save", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.hexColor = UIColor.randomFlat.hexValue()
             
            self.save(category: newCategory)
            
            self.tableView.reloadData()
            
        }
        
        alert.addAction(submit)
        present(alert, animated: true, completion: nil)
    }
    
}
