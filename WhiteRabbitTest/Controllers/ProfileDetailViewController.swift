//
//  ProfileDetailViewController.swift
//  WhiteRabbitTest
//
//  Created by amosevasanth.s on 21/06/22.
//

import UIKit

class ProfileDetailViewController: UIViewController {
    
    static func getVC() -> ProfileDetailViewController {
        let detailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileDetailViewController") as! ProfileDetailViewController
        return detailsVC
    }
    
    @IBOutlet weak var detailsListView: UITableView!
    
    var profile: ProfileModel?
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image = ProfileViewModel().getImage(id: profile?.id ?? 0)
    }
    

    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    

}

extension ProfileDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard var cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell") else {
            return UITableViewCell()
        }
        cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle,reuseIdentifier: "DetailsCell")
        
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Name"
            cell.detailTextLabel?.text = profile?.name
            break
        case 1:
            cell.textLabel?.text = "User name"
            cell.detailTextLabel?.text = profile?.username
            break
        case 2:
            cell.textLabel?.text = "Email address"
            cell.detailTextLabel?.text = profile?.email
            break
        case 3:
            cell.textLabel?.text = "Address"
            cell.detailTextLabel?.text = "\(profile?.address.street ?? "")\n\(profile?.address.suite ?? "")\n\(profile?.address.city ?? "") - \(profile?.address.zipcode ?? "")"
            break
        case 4:
            cell.textLabel?.text = "Phone"
            cell.detailTextLabel?.text = profile?.phone
            break
        case 5:
            cell.textLabel?.text = "Website"
            cell.detailTextLabel?.text = profile?.website
            break
        case 6:
            cell.textLabel?.text = "Company"
            cell.detailTextLabel?.text = "\(profile?.company?.name ?? "")\n\(profile?.company?.catchPhrase ?? "")\n\(profile?.company?.bs ?? "")"
            break
        default:
            break
        }
        
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
        cell.detailTextLabel?.numberOfLines = 0
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 200))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 200))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        mainView.addSubview(imageView)
        mainView.backgroundColor = #colorLiteral(red: 0.09902153164, green: 0.09902153164, blue: 0.09902153164, alpha: 1)
        return mainView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return image != nil ? 220 : 0
    }
    
}
