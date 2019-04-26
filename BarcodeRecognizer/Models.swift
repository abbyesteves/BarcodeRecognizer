//
//  Models.swift
//  BarcodeRecognizer
//
//  Created by Abby Esteves on 18/04/2019.
//  Copyright © 2019 Abby Esteves. All rights reserved.
//

import UIKit

struct Product : Decodable {
    var success : Int?
    var status_code : Int?
    var product_count : Int?
    var products : [Products]?
}

struct Products : Decodable {
    var product_name : String?
    var product_image_url : String?
    var product_description : String?
    var product_asin : String?
    var product_gtin : String?
    var category_name : String?
    var category_browse_node_id : String?
    var manufacturer_name : String?
    var manufacturer_image_url : String?
    var brand_name : String?
    var brand_image_url : String?
    var country_of_origin : String?
}

struct Helps : Decodable {
    var header : String?
    var under : [Labels]
}

struct Labels : Decodable {
    var title : String?
    var subTitle : String?
    var icons : String?
}
