//
//  Match.swift
//  SoccerTracker
//
//  Created by Omar Torres on 1/3/19.
//  Copyright © 2019 OmarTorres. All rights reserved.
//

import UIKit

class Match: NSObject {
    
    var firstTeamName: String?
    var secondTeamName: String?
    var firstTeamGoals: String?
    var secondTeamGoals: String?
    var score: String?
    
    init(score: String, firstTeamDict: [String: Any], secondTeamDict: [String: Any]) {
        
        self.firstTeamName = firstTeamDict["name"] as? String ?? ""
        self.firstTeamGoals = firstTeamDict["goals"] as? String ?? ""
        
        
        self.secondTeamName = secondTeamDict["name"] as? String ?? ""
        self.secondTeamGoals = secondTeamDict["goals"] as? String ?? ""
        
        self.score = score
    }


}
