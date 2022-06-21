//
//  ProfileViewModel.swift
//  WhiteRabbitTest
//
//  Created by amosevasanth.s on 21/06/22.
//

import UIKit

class ProfileViewModel: NSObject {
    
    var profileList = [ProfileModel]()
    let profileDM = ProfileDataManager()
    
    var listCount: Int {
        return profileList.count
    }
    
    func loadData(success:@escaping() -> (Void)) {
        profileDM.fetchData { list in
            self.profileList = list
            success()
        }
    }
    
    func getImage(id: Int) -> UIImage? {
        return UIImage(data: profileDM.getImageFromLocal(id: id))
    }

}
