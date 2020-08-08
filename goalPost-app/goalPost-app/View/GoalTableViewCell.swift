//
//  GoalTableViewCell.swift
//  goalPost-app
//
//  Created by Gulnara Saimassay on 7/26/20.
//  Copyright © 2020 Gulnara Saimassay. All rights reserved.
//

import UIKit

class GoalTableViewCell: UITableViewCell {

    @IBOutlet weak var goalDescriptionLabel: UILabel!
    @IBOutlet weak var goalTypeLabel: UILabel!
    @IBOutlet weak var goalProgressLabel: UILabel!
    @IBOutlet weak var completionView: UIView!
    
    func configureCell(goal: Goal){
        self.goalDescriptionLabel.text = goal.goalDescription
        self.goalProgressLabel.text = String(describing: goal.goalProgress)
        self.goalTypeLabel.text = goal.goalType
        if goal.goalProgress == goal.goalCompletionValue{
            self.completionView.isHidden = false
        }else{
            self.completionView.isHidden = true
        }
    }
}
