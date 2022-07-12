//
//  Food.swift
//  Eat Now
//
//  Created by Meet on 07/07/22.
//

import Foundation
import UIKit
  
class Food
{
    var id: Int
    var name: String?
    var description: String?
    var image: String?
    var shortDescription: String?
    var price: String?
      
    init(id: Int, image:String, name:String, description:String, shortDescription: String, price: String)
    {
        self.id = id
        self.image = image
        self.name = name
        self.description = description
        self.shortDescription = shortDescription
        self.price = price
    }
}
