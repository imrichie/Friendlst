//
//  DummyData.swift
//  Friendlst
//
//  Created by Richie Flores on 10/19/22.
//

import Foundation

class SamplePerson {
    var firstName: String
    var lastName: String
    var city: String = "Unknown"
    var birthDate: Date = Date() 
    
    init(firstName: String, lastName: String, city: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.city = city
    }
}

class DefaultData {
    var firstName: String
    var city: String
    
    init(firstName: String, city: String) {
        self.firstName = firstName
        self.city = city
    }
}

class SampleDataManager {
    var persons = [SamplePerson]()
    var defaultDataArray = [DefaultData]()
    
    func loadFriendData() {
        let person1 = SamplePerson(firstName: "Sophie", lastName: "Hodges", city: "Glendale, AZ")
        let person2 = SamplePerson(firstName: "Warren", lastName: "Stewart", city: "Riverside, CA")
        let person3 = SamplePerson(firstName: "Abigail", lastName: "Sutherland", city: "San Francisco, CA")
        let person4 = SamplePerson(firstName: "Ava", lastName: "Hill", city: "Austin, TX")
        let person5 = SamplePerson(firstName: "Melanie", lastName: "Burgess", city: "Seattle, WA")
        
        persons.append(person1)
        persons.append(person2)
        persons.append(person3)
        persons.append(person4)
        persons.append(person5)
    }
    
    func loadDefaultData() {
        let defaultData1 = DefaultData(firstName: "Hodges, Sophie", city: "Glendale, AZ")
        let defaultData2 = DefaultData(firstName: "Steward, Warren", city: "Temecula, CA")
        let defaultData3 = DefaultData(firstName: "Sutherland, Abigail", city: "San Francisco, CA")
        let defaultData4 = DefaultData(firstName: "Hill, Ava", city: "Austin, TX")
        let defaultData5 = DefaultData(firstName: "Burgess, Melanie", city: "Seattle, WA")
        
        defaultDataArray.append(defaultData1)
        defaultDataArray.append(defaultData2)
        defaultDataArray.append(defaultData3)
        defaultDataArray.append(defaultData4)
        defaultDataArray.append(defaultData5)
    }
}
