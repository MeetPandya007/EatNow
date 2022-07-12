//
//  CartViewController.swift
//  Eat Now
//
//  Created by Meet on 07/07/22.
//

import UIKit

class CartViewController: UIViewController {

//MARK: Variable Declaration
    var db = DBManager()
    var cart = Array<Food>()
    
//MARK: Outlet Declaration
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var payButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
        cart.removeAll()
        cart = db.read(tablename: "Cart")
        payButton.setTitle(nil, for: .normal)
        payButton.setTitle("₹\(getTotalPay())", for: .normal)
        tableView.reloadData()
     }
    
    @IBAction func payButtonClicked(_ sender: Any) {
        if cart.count > 0{
            let alert = UIAlertController(title: "Do you want to pay ₹\(getTotalPay())", message: "", preferredStyle: UIAlertController.Style.alert)
            let Yes = UIAlertAction(title: "Yes", style: .default) { (action) -> Void in
                var orderedItems = self.cart[0].name ?? ""
                for i in 1..<self.cart.count{
                    orderedItems += ",\(self.cart[i].name ?? "")"
                }
                self.db.insertInOrders(customerName: "Meet", orderedItems: orderedItems, price: self.getTotalPay())
                self.db.deleteByTableName(tableName: "Cart")
                self.cart.removeAll()
                self.payButton.setTitle(nil, for: .normal)
                self.payButton.setTitle("₹0", for: .normal)
                self.tableView.reloadData()
                
                
            }
            let Cancel = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(Yes)
            alert.addAction(Cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: - Extension for Tableview Methods
extension CartViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as? CartTableViewCell
        cell?.titleLabel.text = cart[indexPath.row].name
        cell?.descriptionLabel.text = cart[indexPath.row].shortDescription
        cell?.priceLabel.text = "₹\(cart[indexPath.row].price ?? "0")"
        
        if let imageLink = cart[indexPath.row].image?.components(separatedBy: "~")[0]{
            if imageLink != ""{
                cell?.productImageView.loadFrom(URLAddress: imageLink)
                cell?.productImageView.clipsToBounds = false
                cell?.productImageView.layer.shadowColor = UIColor.black.cgColor
                cell?.productImageView.layer.shadowOpacity = 1
                cell?.productImageView.layer.shadowOffset = CGSize.zero
                cell?.productImageView.layer.shadowRadius = 20
            }else{
                cell?.productImageView.image = UIImage(systemName: "photo")
                cell?.productImageView.tintColor = UIColor.gray
                
            }
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            db.deleteByID(id: cart[indexPath.row].id)
            cart.remove(at: indexPath.row)
            
            if let tabItems = tabBarController?.tabBar.items {
                let tabItem = tabItems[1]
                tabItem.badgeValue = String(db.read(tablename: "Cart").count)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            payButton.setTitle(nil, for: .normal)
            payButton.setTitle("₹\(getTotalPay())", for: .normal)
            
        }
    }
}

//MARK: - Extension for Custom Methods
extension CartViewController{
    func getTotalPay() -> String{
        var count = 0
        cart = db.read(tablename: "Cart")
        for i in 0..<cart.count{
            count += Int(cart[i].price ?? "00") ?? 00
        }
        return String(count)
    }
}
