//
//  FirstCell.swift
//  ToDoListApp-ProjectTaskSession 11 LVL 2
//
//  Created by abdurhman elbosaty on 30/07/2021.
//

import UIKit

class FirstCell: UITableViewCell {

    @IBOutlet weak var upArrowOutlet: UIButton!
    @IBOutlet weak var downArrowOutlet: UIButton!
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.backgroundColor = #colorLiteral(red: 0.4943656325, green: 0.4208911657, blue: 0.9406893253, alpha: 1)
            containerView.layer.cornerRadius = 5
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor.lightGray.cgColor
            containerView.layer.shadowColor = UIColor.lightGray.cgColor
            containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
            containerView.layer.shadowRadius = 1
            containerView.layer.shadowOpacity = 5
        }
    }
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!{
        didSet{
            nameLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func upArrowBtnPressed(_ sender: UIButton) {
    }
    @IBAction func downArrowBtnPressed(_ sender: UIButton) {
    }
}
