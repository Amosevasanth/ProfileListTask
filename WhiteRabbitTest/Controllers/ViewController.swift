//
//  ViewController.swift
//  WhiteRabbitTest
//
//  Created by amosevasanth.s on 21/06/22.
//

import UIKit

class ViewController: UIViewController {
    
    let viewModel = ProfileViewModel()
    
    @IBOutlet weak var profileListView: UITableView! {
        didSet {
            profileListView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let activityIndicator = ActivityIndicator(view:view, navigationController:nil,tabBarController: nil)
        activityIndicator.showActivityIndicator()
        
        viewModel.loadData {
            DispatchQueue.main.async {
                self.profileListView.reloadData()
                activityIndicator.stopActivityIndicator()
            }
        }

    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
        cell.configureCell(profile: viewModel.profileList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProfileDetailViewController.getVC()
        vc.profile = viewModel.profileList[indexPath.row]
        self.present(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

