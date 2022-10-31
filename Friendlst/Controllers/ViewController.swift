//
//  ViewController.swift
//  Friendlst
//
//  Created by Richie Flores on 10/13/22.
//

import UIKit

class ViewController: UITableViewController {
    let dataManager = SampleDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.loadDefaultData()
        configureNavbar()
    }
    
    // MARK: - Helper Functions
    func configureNavbar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemMint
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    // MARK: - TableView Delegates
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.defaultDataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.defaultCell)
        let person = dataManager.defaultDataArray[indexPath.row]
        
        var content = cell?.defaultContentConfiguration()
        content?.text = person.firstName
        content?.textProperties.font = .systemFont(ofSize: 20.0)
        content?.secondaryText = person.city
        content?.secondaryTextProperties.font = .systemFont(ofSize: 15.0)
        content?.secondaryTextProperties.color = .black.withAlphaComponent(0.65)
        content?.image = UIImage(systemName: "circle")
        
        cell?.contentConfiguration = content
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.00
    }
}
