//
//  FoodViewController.swift
//  Eat Now
//
//  Created by Meet on 07/07/22.
//

import UIKit

class FoodViewController: UIViewController {

//MARK: Variable Declaration
    var db = DBManager()
    var food = Array<Food>()
    var cartCount = 0
    
//MARK: Outlet Declaration
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        food = db.read(tablename: "Food")
        cartCount = db.read(tablename: "Cart").count
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        getBadgeData()
    }
    //USED FOR DEMO - BASICALLY TO SET DATA FOR ONCE IN THE TABLE -
    
}

//MARK: - Extension For Tableview Methods
extension FoodViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return food.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell
        cell?.titleLabel.text = food[indexPath.row].name
        cell?.descriptionLabel.text = food[indexPath.row].shortDescription
        cell?.priceLabel.text = "₹\(food[indexPath.row].price ?? "0")"
        cell?.addToCartButton.accessibilityValue = "\(indexPath.row)"
        cell?.addToCartButton.addTarget(self, action: #selector(addToCartClicked(_:)), for: .touchUpInside)
       
        if let imageLink = food[indexPath.row].image?.components(separatedBy: "~")[0]{
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        vc.id = food[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Extension For Custom Methods
extension FoodViewController{
    @objc func addToCartClicked(_ sender: UIButton){
        let index = Int(sender.accessibilityValue ?? "") ?? 0
        
        db.insertInCartTable(id: cartCount + 1, image: food[index].image ?? "", name: food[index].name ?? "", shortDescription: food[index].shortDescription ?? "", description: food[index].description ?? "", price: food[index].price ?? "")
        cartCount += 1
        getBadgeData()
    }
    
    func getBadgeData(){
        if let tabItems = tabBarController?.tabBar.items {
            let tabItem = tabItems[1]
            tabItem.badgeValue = String(db.read(tablename: "Cart").count)
        }
        
    }
}
