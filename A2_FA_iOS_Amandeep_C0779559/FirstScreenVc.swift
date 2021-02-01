//
//  FirstScreenVc.swift
//  A2_FA_iOS_Amandeep_C0779559
//
//  Created by Mac on 01/02/21.
//
import UIKit
import CoreData

class FirstScreenVc: UIViewController {
    var arrProducts = [Products]()
    var arrProviders = [Providers]()
    let context =
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var searchBar : UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchProducts()
    }
    
    func fetchProducts(){
        arrProducts.removeAll()
        do {
            arrProducts = try context.fetch(Products.fetchRequest())
        } catch  {
            
        }
        labtask2()
        tableView.reloadData()
    }
    func labtask2(){
        
        if arrProducts.isEmpty{
            let provider1 = Providers(context: context)
            let provider2 = Providers(context: context)
            for i in 1...10{
                if i < 6 {
                    let product  = Products(context: context)
                    product.product_desc = "Car \(i)"
                    product.product_id = "00\(i)"
                        provider2.provider_name = "BMW"
                        product.product_name = "Car \(i)"
                        product.provider = provider2
                }
                else{
                    
                let product  = Products(context: context)
                product.product_desc = "Bike \(i)"
                product.product_id = "00\(i)"
                    provider2.provider_name = "Yamaha"
                    product.product_name = "CBZ \(i)"
                    product.provider = provider1
                }
                
            }
            try! context.save()
            fetchProducts()
        }
        
    }
   
}
extension FirstScreenVc : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            var predicate: NSPredicate = NSPredicate()
            predicate = NSPredicate(format: "product_name contains[c] '\(searchText)' || product_desc contains[c] '\(searchText)'")
            let fetchRequest : NSFetchRequest<Products> = Products.fetchRequest()
            fetchRequest.predicate = predicate
            do {
                arrProducts = try context.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error)")
            }
        }
        else{
            fetchProducts()
            
        }
        tableView.reloadData()
    }
    
}
extension FirstScreenVc : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return arrProducts.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
            cell.textLabel?.text =
                arrProducts[indexPath.row].product_name
            cell.detailTextLabel?.text = arrProducts[indexPath.row].provider?.provider_name
       
        
        return cell
    }
    
    
}
extension FirstScreenVc : UITableViewDelegate{
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
                let objc = arrProducts[indexPath.row]
                context.delete(objc)
                try! context.save()
                fetchProducts()
            
            
        }
    }
}

