//
//  QuestTableViewCell.swift
//  Descent AI
//
//  Created by Jose Gabriel Ferrer on 19/11/20.
//

import UIKit

class QuestTableViewCell: UITableViewCell {

    @IBOutlet weak var labelQuestName: UILabel!
    @IBOutlet weak var labelExtraInfoQuest: UILabel!
    @IBOutlet weak var imgQuest: UIImageView!
    @IBOutlet weak var langQuest: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
