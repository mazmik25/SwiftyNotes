//
//  ToDoListViewController.swift
//  Todo List
//
//  Created by Wmotion Mac 101 on 5/9/18.
//  Copyright © 2018 Wmotion Mac 101. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {

    var todoItems: Results<Item>?
    let realm = try! Realm()
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedCategory : Category? {
        //TODO: as category get set, this method is running
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        
        tableView.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        guard let color = selectedCategory?.hexColor else {fatalError("Failed getting hex color")}
        
        title = selectedCategory?.name
        
        updateNavBar(withHexCode: color)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "28AAC0")
    }
    
    //MARK: Navigation Bar Setup
    private func updateNavBar(withHexCode colorHex: String) {

        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller doesn't exist")}
        guard let navBarColor = UIColor(hexString: colorHex) else {fatalError("Failed changing Navigation Bar Color")}

        //uncomment this code to change navBars
        //navBar.prefersLargeTitles = false
        
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        searchBar.tintColor = navBarColor
    
    }
    
    //MARK:- Tableview Data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {

            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let color = UIColor(hexString: selectedCategory!.hexColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                
                cell.backgroundColor = color
                
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
        } else {
            cell.textLabel?.text = "No Activity Found"
        }
        
        return cell
    }
    
    //MARK:- Tableview Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                    
                    // use this method below to delete item
                    // realm.delete(item)
                }
            } catch {
                print(error)
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:- Add New Item
    @IBAction func addNewItem(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        let submit = UIAlertAction(title: "Submit", style: .default) { (action) in
            //TODO: Insert to sqlite
//            print("Sucess. The text is = \(textField.text!)")
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        
                        newItem.title = textField.text!
                        newItem.done = false
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print(error)
                }
            }
            
            
            
            //refresh tableview
            self.tableView.reloadData()
        }
        
        alert.addAction(submit)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK:- Data Manipulation
    private func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        
    }
    
    private func saveItems(item: Item) {
        
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Error \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK:- Update Model
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print(error)
            }
        }
    }
    
}

//MARK:- Search Bar Method
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
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

