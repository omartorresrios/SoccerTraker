//
//  TeamsTableViewCell.swift
//  SoccerTracker
//
//  Created by Omar Torres on 1/2/19.
//  Copyright © 2019 OmarTorres. All rights reserved.
//

import UIKit

class TeamTableViewCell: UITableViewCell {
    
    var team: Team? {
        didSet {
            teamName.text = team?.name
        }
    }
    
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var teamName: UILabel!
    
    override func layoutSubviews() {
        teamImageView.layer.cornerRadius = teamImageView.bounds.height / 2
        teamImageView.clipsToBounds = true
    }
}
