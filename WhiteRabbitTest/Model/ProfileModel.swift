//
//  ProfileModel.swift
//  WhiteRabbitTest
//
//  Created by amosevasanth.s on 21/06/22.
//

import Foundation

class ProfileModel:NSObject, Codable {
    
    var id: Int
    var name, username, email: String
    var profileImage: String?
    var address: AddressModel
    var phone, website: String?
    var company: CompanyModel?
    
    enum CodingKeys: String, CodingKey {
        case id, name, username, email
        case profileImage = "profile_image"
        case address, phone, website, company
    }
    
    required init(id: Int, name: String, username: String, email: String, profileImage: String?, address: AddressModel, phone: String?, website: String?, company: CompanyModel?) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.profileImage = profileImage
        self.address = address
        self.phone = phone
        self.website = website
        self.company = company
    }
}

class AddressModel: Codable {
    var street, suite, city, zipcode: String
    var geo: GeoModel
    
    required init(street: String, suite: String, city: String, zipcode: String, geo: GeoModel) {
        self.street = street
        self.suite = suite
        self.city = city
        self.zipcode = zipcode
        self.geo = geo
    }
}

class GeoModel: Codable {
    var lat, lng: String
    
    required init(lat: String, lng: String) {
        self.lat = lat
        self.lng = lng
    }
}

class CompanyModel: Codable {
    var name, catchPhrase, bs: String
    
    required init(name: String, catchPhrase: String, bs: String) {
        self.name = name
        self.catchPhrase = catchPhrase
        self.bs = bs
    }
}
