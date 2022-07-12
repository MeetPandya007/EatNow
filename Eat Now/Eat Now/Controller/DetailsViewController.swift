//
//  DetailsViewController.swift
//  Eat Now
//
//  Created by Meet on 08/07/22.
//

import UIKit

class DetailsViewController: UIViewController {

//MARK: Variable Declaration
    var db = DBManager()
    var id : Int?
    var Food = Array<Food>()
    var imageArray : [String]?
    var cartCount = 0
    
//MARK: Outlet Declaration
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Food = db.retrieveSingleItem(tablename: "Food", id: id ?? 0)
        imageArray = Food[0].image?.components(separatedBy: "~")
        cartCount = db.read(tablename: "Cart").count
        
        nameLabel.text = Food[0].name
        descriptionLabel.text = Food[0].description
        priceLabel.text = "₹\(Food[0].price ?? "0")"
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
   
    @IBAction func addToCartButtonClicked(_ sender: Any) {
        db.insertInCartTable(id: cartCount + 1, image: Food[0].image ?? "", name: Food[0].name ?? "", shortDescription: Food[0].shortDescription ?? "", description: Food[0].description ?? "", price: Food[0].price ?? "")
        cartCount += 1
        
        if let tabItems = tabBarController?.tabBar.items {
            let tabItem = tabItems[1]
            tabItem.badgeValue = String(db.read(tablename: "Cart").count)
        }
    }
    
}


//MARK: - Extension For Collectionview Controller
extension DetailsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: self.view.frame.width-80, height: 200)
        }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)

        let productImageView = UIImageView(frame: CGRect(x: 20, y: 15, width: self.view.frame.width-120, height: 120))
        productImageView.contentMode = .scaleToFill
        if let img = imageArray?[indexPath.row] {
            productImageView.loadFrom(URLAddress: img)
            productImageView.clipsToBounds = false
            productImageView.layer.shadowColor = UIColor.black.cgColor
            productImageView.layer.shadowOpacity = 1
            productImageView.layer.shadowOffset = CGSize.zero
            productImageView.layer.shadowRadius = 20
        }
        cell.addSubview(productImageView)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray?.count ?? 0
    }
}

//MARK: - Extension of UIImageView to get and set image from URL
extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
            }
        }
    }
}
