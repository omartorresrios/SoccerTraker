//
//  User.swift
//  SoccerTracker
//
//  Created by Omar Torres on 1/2/19.
//  Copyright © 2019 OmarTorres. All rights reserved.
//

import UIKit

class Team: NSObject {
    
    var name: String?
    var score: Int?
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.score = dictionary["score"] as? Int ?? 0
    }
    
}
