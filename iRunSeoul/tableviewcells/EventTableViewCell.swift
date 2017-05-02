//
//  EventTableViewCell.swift
//  iRunSeoul
//
//  Created by Hassan Abid on 18/04/2017.
//
//

import UIKit

class EventTableViewCell: UITableViewCell {

    
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    @IBOutlet weak var leftDaysLabel: UILabel!
    
    
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
