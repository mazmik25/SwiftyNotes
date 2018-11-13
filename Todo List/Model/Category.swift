//
//  Category.swift
//  Todo List
//
//  Created by Wmotion Mac 101 on 5/14/18.
//  Copyright © 2018 Wmotion Mac 101. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var hexColor: String = ""
    let items = List<Item>()
    
}
