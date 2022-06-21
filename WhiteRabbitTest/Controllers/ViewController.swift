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
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.showsCancelButton = true
            searchBar.barTintColor = #colorLiteral(red: 0.09902153164, green: 0.09902153164, blue: 0.09902153164, alpha: 1)
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.lightGray], for: .normal)
            searchBar.searchTextField.backgroundColor = .lightGray
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
    
    @IBAction func serachBtnAction(_ sender: UIButton) {
        searchBar.isHidden = !searchBar.isHidden
    }
    

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
        cell.configureCell(profile: viewModel.filterList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProfileDetailViewController.getVC()
        vc.profile = viewModel.filterList[indexPath.row]
        self.present(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            viewModel.filterData(searchText)
        } else {
            viewModel.resetData()
        }
        profileListView.reloadData()

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.resetData()
        searchBar.isHidden = true
        profileListView.reloadData()
    }
}
