//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Vijay on 14/5/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    
    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]

        cell.textLabel?.text = category.name
        return cell
    }


    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    // MARK: - Data Manipulation Methods
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            // Add item
            if textField.text! != "" {

                let category = Category(context: self.context)
                category.name = textField.text!

                self.categoryArray.append(category)
                self.saveData()
            }
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }

        alert.addAction(action)
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
    }


    func saveData() {

        do {
            try context.save()
            tableView.reloadData()
        } catch {
            print("Error saving context, \(error)")
        }
    }

    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()) {

        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
        }

        tableView.reloadData()
    }
}
