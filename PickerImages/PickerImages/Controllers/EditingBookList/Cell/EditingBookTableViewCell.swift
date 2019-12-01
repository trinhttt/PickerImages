//
//  EditingBookTableViewCell.swift
//  PickerImages
//
//  Created by Trinh Thai on 12/1/19.
//  Copyright © 2019 Trinh Thai. All rights reserved.
//

import UIKit

class EditingBookTableViewCell: UITableViewCell {
    @IBOutlet weak var ibDeleteButton: UIButton!
    @IBOutlet weak var ibEditButton: UIButton!
    var deleteActionHandler: ((Int) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func ibDeleteTapped(_ sender: Any) {
        if let sender = sender as? UIButton {
            deleteActionHandler?(sender.tag)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
