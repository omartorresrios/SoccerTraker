//
//  DataService.swift
//  SoccerTracker
//
//  Created by Omar Torres on 1/3/19.
//  Copyright © 2019 OmarTorres. All rights reserved.
//

import Foundation
import Firebase

class DataService: NSObject {
    
    static let shared = DataService()
    var teams = [Team]()
    var matches = [Match]()
    var teamNames = [String]()
    
    func fetchTeamNames(completion: @escaping ([String]) -> ()) {
        fetchTeams { (teams) in
            for team in teams {
                if let teamName = team.name {
                    self.teamNames.append(teamName)
                    completion(self.teamNames)
                }
            }
        }
    }
    
    func fetchTeams(completion: @escaping ([Team]) -> ()) {
        databaseRef.child("Teams").observe(.childAdded, with: { (snapshot) in
            if let teamDictionary = snapshot.value as? [String: AnyObject] {
                let teamName = teamDictionary["name"] as! String
                self.teamNames.append(teamName)
                let team = Team(dictionary: teamDictionary)
                self.teams.append(team)
                completion(self.teams)
                
            }
        }, withCancel: nil)
    }
    
    func fetchMatches(completion: @escaping ([Match]) -> ()) {
        databaseRef.child("Matches").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                guard let firstTeamDict = dictionary["Team1"] as? [String: AnyObject] else { return }
                guard let secondTeamDict = dictionary["Team2"] as? [String: AnyObject] else { return }
                let score = dictionary["score"] as? String ?? ""
                
                let match = Match(score: score, firstTeamDict: firstTeamDict, secondTeamDict: secondTeamDict)
                self.matches.append(match)
                completion(self.matches)
            }
        }, withCancel: nil)
    }

}
