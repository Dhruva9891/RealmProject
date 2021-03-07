//
//  ListViewController.swift
//  RealmProject
//
//  Created by Dhruva Beti on 04/03/21.
//

import UIKit
import RealmSwift

class ListViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView!
    
    var selectedCategory:Category?{
        didSet{
            loadData()
        }
    }
    
    
    var listArr:Results<List>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        listTableView.delegate = self
        listTableView.dataSource = self
        
    }
    
    @IBAction func saveDataPressed(_ sender: UIButton) {
        
        do {
            let realm =  try Realm()
            try realm.write{
                if let catObj = selectedCategory{
                    let listObj = List()
                    listObj.title = "Apples"
                    listObj.finished = false
                    catObj.lists.append(listObj)
                }
            }
           
            listTableView.reloadData()

        } catch {
            print("Error:\(error)")
        }
        
    }
    
    @IBAction func updateDataPressed(_ sender: UIButton) {
        
        do {
            let realm = try Realm()
            if let listArray = listArr {
                for listObj in  listArray {
                    try realm.write{
                        listObj.finished = true
                    }
                }
            }
            
            listTableView.reloadData()
        } catch {
            print("Error:\(error)")
        }
        
    }
    
    @IBAction func deleteDataPressed(_ sender: UIButton) {
        
        do {
            let realm = try Realm()
            try realm.write{
                if let arr = listArr{
                    if arr.count > 0{
                        realm.delete(arr[0] as List)
                    }
                }
            }
            listTableView.reloadData()

        } catch {
            print("Error:\(error)")
        }
        
    }
    
// This method should be called atleast once for realm to start listening for changes
    func loadData() {
        
        //listArr starts getting updated dynamically after executing the below line 'once'
        listArr = selectedCategory?.lists.sorted(byKeyPath: "title", ascending: true)
        
        if listTableView != nil {
            listTableView.reloadData()
        }
    }
    
}

extension ListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        if let listObj = listArr?[indexPath.row] {
            cell.textLabel?.text = listObj.title
            cell.detailTextLabel?.text = String(listObj.finished)
            cell.accessoryType = listObj.finished ? .checkmark : .none
        }
        return cell
        
    }
    
    
}
