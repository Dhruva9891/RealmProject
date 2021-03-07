//
//  Category.swift
//  RealmProject
//
//  Created by Dhruva Beti on 04/03/21.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var done: Bool = false
    let lists = RealmSwift.List<List>()
    
}
