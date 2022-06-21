//
//  ProfileCell.swift
//  WhiteRabbitTest
//
//  Created by amosevasanth.s on 21/06/22.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.setCornerRadius(color: .clear)
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    
    @IBOutlet weak var mainView: UIView! {
        didSet {
            mainView.setCornerRadius()
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
    
    func configureCell(profile: ProfileModel) {
        profileImageView.image = ProfileViewModel().getImage(id: profile.id) ?? UIImage(named: "defaultUser")
        nameLabel.text = profile.name
        companyNameLabel.text = profile.company?.name
    }
    
}
