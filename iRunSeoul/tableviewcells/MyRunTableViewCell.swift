//
//  MyRunTableViewCell.swift
//  iRunSeoul
//
//  Created by Hassan Abid on 18/04/2017.
//
//

import UIKit

class MyRunTableViewCell: UITableViewCell {

    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var runDate: UILabel!
    @IBOutlet weak var runTitleLabel: UILabel!
    
    @IBOutlet weak var timeImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceImageView: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceImageView: UIImageView!
    @IBOutlet weak var paceLabel: UILabel!
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
