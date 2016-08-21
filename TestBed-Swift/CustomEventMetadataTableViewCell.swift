//
//  CustomEventParameterParameterTableViewCell.swift
//  TestBed-Swift
//
//  Created by David Westgate on 8/17/16.
//  Copyright © 2016 Branch Metrics. All rights reserved.
//

import UIKit

class CustomEventMetadataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
