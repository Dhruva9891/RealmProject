//
//  List.swift
//  RealmProject
//
//  Created by Dhruva Beti on 04/03/21.
//

import Foundation
import RealmSwift

class List: Object {
    @objc dynamic var title:String = ""
    @objc dynamic var finished:Bool = false
}
