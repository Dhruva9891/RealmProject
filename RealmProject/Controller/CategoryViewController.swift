//
//  ViewController.swift
//  RealmProject
//
//  Created by Dhruva Beti on 04/03/21.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeViewController,UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    var categoryArray:Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        categoryTableView.rowHeight = 90.0
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        loadData()
    }
    
    @IBAction func saveDataPressed(_ sender: UIButton) {
        let category = Category()
        category.name = "Dhruva"
        category.done = false
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(category)
            }
            
            categoryTableView.reloadData()

        } catch {
            print("Error: \(error)")
        }
        
    }
    
    
    @IBAction func updateDataPressed(_ sender: UIButton) {
        do {
            let realm = try Realm()
            categoryArray = realm.objects(Category.self)
            if let arr = categoryArray {
                for catObj in arr {
                   try realm.write{
                    catObj.done = true
                    }
                }
            }
            
            categoryTableView.reloadData()

        } catch  {
            print("Error: \(error)")
            
        }
    }
    
    @IBAction func deleteDataPressed(_ sender: UIButton) {
        do {
            let realm = try Realm()
            
            categoryArray = realm.objects(Category.self)
            if let catObj = categoryArray?[0] {
                try realm.write {
                    realm.delete(catObj)
                }
            }
            
            categoryTableView.reloadData()
            
        } catch {
            print("Error: \(error)")
        }
        

    }
    
    // This method should be called atleast once for realm to start listening for changes
    func loadData() {
        do {
            let realm = try Realm()
            
            //listArr starts getting updated dynamically after executing the below line 'once'
            categoryArray = realm.objects(Category.self)
           
            categoryTableView.reloadData()

        } catch {
            print("Error: \(error)")
        }
        
    }
    
    override func deleteObj(indexPath: IndexPath){
        do {
            let realm = try Realm()
            
            self.categoryArray = realm.objects(Category.self)
            if let catObj = self.categoryArray?[indexPath.row] {
                try realm.write {
                    realm.delete(catObj)
                }
            }
            DispatchQueue.main.async {
                self.categoryTableView.reloadData()
            }
            
        } catch {
            print("Error: \(error)")
        }
    }
    
    //Mark - TableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let catObj = categoryArray?[indexPath.row] {
            cell.textLabel?.text = catObj.name
            cell.detailTextLabel?.text = String(catObj.done)
            cell.accessoryType = catObj.done ? .checkmark : .none
        }
      
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toListView", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toListView" {
            let listVC = segue.destination as! ListViewController
            if let index = categoryTableView.indexPathForSelectedRow?.row {
                listVC.selectedCategory = categoryArray?[index]
            }
        }
    }
    
}

