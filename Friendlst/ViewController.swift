//
//  ViewController.swift
//  Friendlst
//
//  Created by Richie Flores on 10/13/22.
//

import UIKit

class ViewController: UITableViewController {
    let dataManager = SamplePersonManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load dummy data
        dataManager.loadData()
        
        // verify data is loaded into array
        if (!dataManager.persons.isEmpty) {
            print("Number of Persons: \(dataManager.persons.count)")
        }
        
        // configure the navigation bar
        if #available(iOS 13, *) {
            configureNavbar()
        }
    }
    
    // MARK: - Availability Features
    @available(iOS 13, *)
    func configureNavbar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = .tintColor
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.topItem?.rightBarButtonItem?.tintColor = .white
    }
    
    //MARK: - TableView Delegates
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "personCell") {
            let person = dataManager.persons[indexPath.row]
            let personFullName = "\(person.lastName), \(person.firstName)"
            
            cell.textLabel?.text = personFullName
            cell.detailTextLabel?.text = person.city
            
            return cell
        } else {
            let defaultCell = UITableViewCell()
            return defaultCell
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.persons.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
