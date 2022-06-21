//
//  ProfileViewModel.swift
//  WhiteRabbitTest
//
//  Created by amosevasanth.s on 21/06/22.
//

import UIKit

class ProfileViewModel: NSObject {
    
    var profileList = [ProfileModel]()
    var filterList = [ProfileModel]()
    let profileDM = ProfileDataManager()
    
    var listCount: Int {
        return profileList.count
    }
    
    func loadData(success:@escaping() -> (Void)) {
        profileDM.fetchData { list in
            self.profileList = list
            self.filterList = list
            success()
        }
    }
    
    func filterData(_ text: String) {
        filterList = profileList.filter({ user -> Bool in
            return (user.name.lowercased().contains(text.lowercased()) || user.email.lowercased().contains(text.lowercased()))
        })
    }
    
    func resetData() {
        filterList = profileList
    }
    
    func getImage(id: Int) -> UIImage? {
        return UIImage(data: profileDM.getImageFromLocal(id: id))
    }

}
