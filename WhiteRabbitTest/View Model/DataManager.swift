//
//  DataManager.swift
//  WhiteRabbitTest
//
//  Created by amosevasanth.s on 21/06/22.
//

import UIKit
import CoreData

class ProfileDataManager: NSObject {
    
    func fetchOnlineData(onSuccess:@escaping ([ProfileModel]) -> (Void), onFailure:@escaping (String) -> (Void)) {
        
        let url = URL(string: "http://www.mocky.io/v2/5d565297300000680030a986")
        let request : URLRequest = URLRequest(url: url!)
        
        let dataTask = URLSession.shared.dataTask(with: request) {
            data,response,error in
            
            if error == nil {
                UserDefaults.standard.set(true, forKey: "APICalled")
            } else {
                UserDefaults.standard.set(false, forKey: "APICalled")
            }
            do {
                if let jsonData = data {
                    let decoder = JSONDecoder()
                    let list = try decoder.decode([ProfileModel].self, from: jsonData)
                    onSuccess(list)
                }
                
            } catch let error as NSError {
                print(error.localizedDescription)
                onFailure(error.localizedDescription)
            }
            
        }
        dataTask.resume()
        
    }
    
    func fetchLocalData() -> [ProfileModel] {
        var list = [ProfileModel]()
        var appDelegate = AppDelegate()
        DispatchQueue.main.async {
            guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate = delegate
        }
        let context = appDelegate.persistentContainer.viewContext
        let profilesFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Profile")
        
        do {
            let result = try context.fetch(profilesFetchRequest)
            
            for data in result as! [NSManagedObject] {
                
                let geo = GeoModel(lat: data.value(forKey: "lat") as! String, lng: data.value(forKey: "lng") as! String)
                let address = AddressModel(street: data.value(forKey: "street") as! String, suite: data.value(forKey: "suite") as! String, city: data.value(forKey: "city") as! String, zipcode: data.value(forKey: "zipcode") as! String, geo: geo)
                let company = CompanyModel(name: data.value(forKey: "companyName") as? String ?? "", catchPhrase: data.value(forKey: "catchPhrase")  as? String ?? "", bs: data.value(forKey: "bs") as? String ?? "")
                
                let detail = ProfileModel(id: data.value(forKey: "id") as! Int, name: data.value(forKey: "name") as! String, username: data.value(forKey: "userName") as! String, email: data.value(forKey: "email") as! String, profileImage: data.value(forKey: "profileImage") as? String, address: address, phone: data.value(forKey: "phone") as? String, website: data.value(forKey: "website") as? String, company: company)

                list.append(detail)
            }
        } catch {
            print("Failed")
        }
        
        return list
    }
    
    func fetchData(data:@escaping ([ProfileModel]) -> (Void)) {
        if UserDefaults.standard.bool(forKey: "APICalled") == false  {
            print("APi called")
            fetchOnlineData { profiles in
                DispatchQueue.main.async {
                    for profile in profiles {
                        self.saveDataToLocal(data: profile)
                    }
                    self.updateImageData(profiles: profiles) {
                        data(self.fetchLocalData())
                    }
                }
            } onFailure: { error in
                print(error)
            }
        } else {
            DispatchQueue.main.async {
                print("Core data fetched")
                data(self.fetchLocalData())
            }
        }
    }
    
    
    func saveDataToLocal(data: ProfileModel) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let profilesEntity = NSEntityDescription.entity(forEntityName:"Profile", in: context)!
        
        let profiles = NSManagedObject(entity: profilesEntity, insertInto: context)
        profiles.setValue(data.id, forKey: "id")
        profiles.setValue(data.name, forKey: "name")
        profiles.setValue(data.username, forKey: "userName")
        profiles.setValue(data.email, forKey: "email")
        profiles.setValue(data.profileImage, forKey: "profileImage")
        profiles.setValue(data.phone, forKey: "phone")
        profiles.setValue(data.website, forKey: "website")
        profiles.setValue(data.address.street, forKey: "street")
        profiles.setValue(data.address.suite, forKey: "suite")
        profiles.setValue(data.address.city, forKey: "city")
        profiles.setValue(data.address.zipcode, forKey: "zipcode")
        profiles.setValue(data.address.geo.lat, forKey: "lat")
        profiles.setValue(data.address.geo.lng, forKey: "lng")
        profiles.setValue(data.company?.name, forKey: "companyName")
        profiles.setValue(data.company?.catchPhrase, forKey: "catchPhrase")
        profiles.setValue(data.company?.bs, forKey: "bs")
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func updateImageData(profiles: [ProfileModel], success:@escaping() -> (Void)) {
        
        var uploadCount = 0
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let profilesFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Profile")
        
        for profile in profiles {
            profilesFetchRequest.predicate = NSPredicate(format: "id = %@", "\(profile.id)")
            do {
                let profilesFetch = try managedContext.fetch(profilesFetchRequest)
                if profiles.count > 0 {
                    let value = profilesFetch.first as! NSManagedObject
                    
                    self.getImageData(value.value(forKey: "profileImage") as? String ?? "") { data in
                        value.setValue(data, forKey: "profileImageData")
                        appDelegate.saveContext()
                        if profile.profileImage != nil {
                            uploadCount+=1
                        }
                        if uploadCount == profiles.filter({ $0.profileImage != nil }).count {
                            success()
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
        
    }
    
    func getImageData(_ urlString: String, imageData:@escaping (Data?) -> (Void)) {
        if URL(string: urlString) != nil {
            URLSession.shared.dataTask(with: URL(string: urlString)! as URL, completionHandler: { (data, response, error) in
                imageData(data)
            }).resume()
        }
    }
    
    func getImageFromLocal(id: Int) -> Data {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            let profilesFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Profile")
            profilesFetchRequest.predicate = NSPredicate(format: "id = %@", "\(id)")
            
            do {
                let profilesFetch = try managedContext.fetch(profilesFetchRequest)
                if let value = profilesFetch.first as? NSManagedObject {
                    return value.value(forKey: "profileImageData") as? Data ?? Data()
                }
            } catch {
                print(error)
            }
        }
        return Data()
    }

}


