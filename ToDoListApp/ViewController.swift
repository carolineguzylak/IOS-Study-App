//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Carly Guzylak on 7/1/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    private let table: UITableView =
    {
        let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier:"cell")
        return table
    }()
    
    //This is the list that stores our reminder entries
    var items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = UserDefaults.standard.stringArray(forKey: "items") ?? []
        // Do any additional setup after loading the view.
        title = "To Do List"
        view.addSubview(table)
        table.dataSource = self
        //we add the plus button here
        //.add and didTapAdd is the plus button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd() {
        //This creates the alert that becomes our pop up when we
        //create a new reminder
        let alert = UIAlertController(title: "New Item", message: "Enter New To Do List Item", preferredStyle: .alert)
        
        //This is the text field where we type in our reminder
        alert.addTextField { field in
            field.placeholder = "Enter Item..."
        }
        //Cancel Button
        alert.addAction(UIAlertAction(title:"Cancel", style: .cancel, handler: nil))
        //Done Button
        //When pressed, a new reminder must be created
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] (_) in
            if let field = alert.textFields?.first {
                if let text = field.text, !text.isEmpty {
                    //There is where a new to do list item is added
                    DispatchQueue.main.async{
                        //These next four lines ensure that items are saved
                        //when is app is closed out
                        //where text is the new item
                        var currentItems = UserDefaults.standard.stringArray(forKey: "items") ?? []
                        currentItems.append(text)
                        UserDefaults.standard.setValue(currentItems, forKey: "items")
                        //? means optional
                        self?.items.append(text)
                        self?.table.reloadData()
                    }
                }
            }
        }))
        
        present(alert, animated:true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //creates rows according to the number of reminders currently active
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }


}

