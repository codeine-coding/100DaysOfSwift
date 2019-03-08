//
//  WebsiteListViewController.swift
//  Project4
//
//  Created by Allen Whearry on 3/8/19.
//  Copyright © 2019 Codeine Technologies LLC. All rights reserved.
//

import UIKit

class WebsiteListViewController: UIViewController {
    let cellID = "Cell ID"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    override func loadView() {
        view = tableView
    }

}

extension WebsiteListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = websites[indexPath.row].url
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let website = websites[indexPath.row].url
        guard let url = URL(string: "https://" + website) else { return }
        let destinationController = ViewController()
        destinationController.websiteURL = url
        navigationController?.pushViewController(destinationController, animated: true)
    }
    
    
}
