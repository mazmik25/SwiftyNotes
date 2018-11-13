//
//  Item.swift
//  Todo List
//
//  Created by Wmotion Mac 101 on 5/15/18.
//  Copyright © 2018 Wmotion Mac 101. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
