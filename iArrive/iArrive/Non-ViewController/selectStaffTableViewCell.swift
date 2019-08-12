//
//  selectStaffTableViewCell.swift
//  iArrive
//
//  Created by Lam Wun Yin on 28/6/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit

class selectStaffTableViewCell: UITableViewCell {

    // MARK: Properties
    var didSelectedRow = false
    var whiteRoundedView = UIView()
    var nameLabel = UILabel()
    var jobTitleLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        whiteRoundedView = UIView(frame: CGRect(x: 10, y: 5, width: self.contentView.frame.size.width - 20, height: self.contentView.frame.size.height + 10))
        whiteRoundedView.layer.backgroundColor = UIColor.white.cgColor
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 8.0
        whiteRoundedView.layer.applySketchShadow(
            color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.16),
            x: 0,
            y: 3,
            blur: 6,
            spread: 0)
        
        nameLabel.frame = CGRect(x: 30, y: 18, width: 524, height: 33)
        jobTitleLabel.frame = CGRect(x: 30, y: 53, width: 524, height: 32)
        nameLabel.font = UIFont(name: "NotoSans-Bold", size: 24)
        jobTitleLabel.font = UIFont(name: "NotoSans-Light", size: 24)
        nameLabel.textColor = UIColor.black.withAlphaComponent(0.3)
        jobTitleLabel.textColor = UIColor.black.withAlphaComponent(0.3)
        whiteRoundedView.addSubview(nameLabel)
        whiteRoundedView.addSubview(jobTitleLabel)
        whiteRoundedView.bringSubviewToFront(nameLabel)
        whiteRoundedView.bringSubviewToFront(jobTitleLabel)
        
        self.contentView.addSubview(whiteRoundedView)
        self.contentView.sendSubviewToBack(whiteRoundedView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
