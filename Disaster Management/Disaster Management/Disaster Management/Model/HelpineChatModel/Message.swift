//
//  Message.swift
//  Disaster Management
//
//  Created by Arnold Rebello on 7/3/20.
//  Copyright © 2020 Arnold Rebello. All rights reserved.
//

import Foundation
import Firebase

struct Message {
    let user: String
    let message: String
    
}

struct Constants
{
    struct refs
    {
        static let db = Database.database().reference()
        static let rootNode = db.child("general")
    }
}
