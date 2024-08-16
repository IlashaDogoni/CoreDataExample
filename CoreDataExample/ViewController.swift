//
//  ViewController.swift
//  CoreDataExample
//
//  Created by Ilya Kokorin on 16.08.2024.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var models = [ToDoListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            title = "Core Data To Do List"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        getAllItems()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(didAddTap))
    }
    
    @objc func didAddTap(){
        let alert = UIAlertController(title: "New Item",
                                      message: "Enter New Item",
                                      preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit",
                                      style: .cancel,
                                      handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            
            self?.createItem(name: text)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getAllItems(){
        do{
             models = try context.fetch(ToDoListItem.fetchRequest())
            print("Fetched items: \(models)")
            for item in models {
                let name = item.name ?? "No Name"
                            let createdAt = item.createdAt ?? Date() // Safely unwrap createdAt
                            print("Fetched item name: \(name), created at: \(createdAt)")                     }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            print("Failed to fetch items: \(error)")
        }
    }
    
    func createItem(name: String){
        let newItem = ToDoListItem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        
        
        
        do{
            try context.save()
            models.append(newItem)
            print(newItem.createdAt ?? "date isnt saved as date")
            tableView.reloadData()
        } catch {
            print("Failed to save item: \(error)")
        }
    }
    
    func deleteItem(item: ToDoListItem){
        context.delete(item)
        
        do {
            try context.save()
            
        } catch {
            
        }
    }
    
    func updateitem(item: ToDoListItem, newName: String){
        item.name = newName
        
        do {
            try context.save()
        } catch {
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        print(model.name ?? "Nothing")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = model.name ?? "Wrong stuff"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of rows: \(models.count)")
        return models.count
    }
    
}


