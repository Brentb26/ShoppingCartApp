//
//  ViewController.swift
//  ShoppingCartApp
//
//  Created by Brent Blitek on 10/25/21.
//

import UIKit
public struct ShoppingCart: Codable{
    var item: String
    var price: Double
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var userTextFieldOutlet: UITextField!
    @IBOutlet weak var tableOutlet: UITableView!
    @IBOutlet weak var priceOutlet: UITextField!
    
    var itemsArray : [ShoppingCart] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableOutlet.dataSource = self
        tableOutlet.delegate = self
        
        itemsArray.append(ShoppingCart(item: "placeholder", price: 0.0))
        
        if let items = UserDefaults.standard.data(forKey: "theItems"){
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ShoppingCart].self, from: items){
                itemsArray = decoded
            }
                
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = itemsArray[indexPath.row].item
        cell.detailTextLabel?.text = String(itemsArray[indexPath.row].price)
        return cell
    }
    
    @IBAction func addButton(_ sender: UIButton) {

        for object in itemsArray {
            
            if (userTextFieldOutlet.text! == object.item){
                
        let alert = UIAlertController(title: "You have already entered that into your shoppingcart.", message: "Would you like to add it again?", preferredStyle: .alert)
        let addAlertAction = UIAlertAction(title: "Keep", style: .default) { (action) in
            self.itemsArray.append(ShoppingCart(item: self.userTextFieldOutlet.text!, price: Double(self.priceOutlet.text!)!))
            self.tableOutlet.reloadData()
        }
                let noAddAlertAction = UIAlertAction(title: "Don't Add", style: .default) { (action) in
                }
            
            alert.addAction(addAlertAction)
            alert.addAction(noAddAlertAction)
            
            present(alert, animated: true, completion: nil)
               return
        }
        }
        itemsArray.append(ShoppingCart(item: userTextFieldOutlet.text!, price: Double(priceOutlet.text!)!))
        tableOutlet.reloadData()
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(itemsArray){
            UserDefaults.standard.set(encoded, forKey: "theItems")
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete)
        {
            itemsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }
    

}

