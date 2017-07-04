//
//  ChatCell.swift
//  SimpleChatEmulator
//
//  Created by Чингиз Б on 04.07.17.
//  Copyright © 2017 Chingiz Bayshurin. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    
//    @IBOutlet weak var timeLabel: UILabel!
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var messageLabel: UILabel!
//    
//    
//    @IBOutlet weak var timeLabel2: UILabel!
//    @IBOutlet weak var titleLable2: UILabel!
//    @IBOutlet weak var messageLabel2: UILabel!
    
    @IBOutlet weak var yourTimestamp: UILabel!
    @IBOutlet weak var yourNickname: UILabel!
    @IBOutlet weak var yourMessage: UILabel!
   
    @IBOutlet weak var yourContactTimestamp: UILabel!
    @IBOutlet weak var yourContactNickname: UILabel!
    @IBOutlet weak var yourContactMessage: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
