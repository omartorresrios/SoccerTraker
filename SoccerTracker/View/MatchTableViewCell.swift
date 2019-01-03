//
//  MatchCollectionViewCell.swift
//  SoccerTracker
//
//  Created by Omar Torres on 1/2/19.
//  Copyright © 2019 OmarTorres. All rights reserved.
//

import UIKit

class MatchTableViewCell: UITableViewCell {
    
    var matchData: Match? {
        didSet {
            firstTeamName.text = matchData?.firstTeamName
            secondTeamName.text = matchData?.secondTeamName
            score.text = matchData?.score
        }
    }
    
    @IBOutlet weak var match: UILabel!
    @IBOutlet weak var firstTeamImageView: UIImageView!
    @IBOutlet weak var firstTeamName: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var secondTeamImageView: UIImageView!
    @IBOutlet weak var secondTeamName: UILabel!
    
    override func layoutSubviews() {
        firstTeamImageView.layer.cornerRadius = firstTeamImageView.bounds.height / 2
        firstTeamImageView.clipsToBounds = true
        secondTeamImageView.layer.cornerRadius = secondTeamImageView.bounds.height / 2
        secondTeamImageView.clipsToBounds = true
    }
}
