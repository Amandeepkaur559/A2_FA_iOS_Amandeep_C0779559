//
//  ProductScreenVc.swift
//  A2_FA_iOS_Amandeep_C0779559
//
//  Created by Mac on 01/02/21.
//

import UIKit
import CoreData
class ProductScreenVc: UIViewController {
    let context =
            (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var txtID: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDesc: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtProviderName: UITextField!
    var selectedProduct : Products?
    override func viewDidLoad() {
        super.viewDidLoad()
        load()

    }
   
    @IBAction func saveData(_ sender: Any) {
        let req : NSFetchRequest<Providers> = Providers.fetchRequest()
        req.predicate = NSPredicate(format: "provider_name = '\(txtProviderName.text!)'")
        let storeProvider = try! context.fetch(req)
        var provider : Providers!
        if storeProvider.count == 0{
             provider = Providers(context: context)
             provider.provider_name = txtProviderName.text
        }
        else{
            provider = storeProvider.first!
        }
        if let product = selectedProduct{
            product.product_desc = txtDesc.text
            product.product_id = txtID.text
            product.product_name = txtName.text
            product.product_price = txtPrice.text
            product.provider = provider
        }
        else{
            let product = Products(context: context)
            product.product_desc = txtDesc.text
            product.product_id = txtID.text
            product.product_name = txtName.text
            product.product_price = txtPrice.text
            product.provider = provider
        }
        try! context.save()
        self.navigationController?.popViewController(animated: true)
    }
    
    func load(){
        if let product = selectedProduct{
            txtID.text = product.product_id
            txtName.text = product.product_name
            txtDesc.text = product.product_desc
            txtPrice.text = product.product_price
            txtProviderName.text = product.provider?.provider_name
        }
    }

}
