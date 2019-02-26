//
//  ViewController.swift
//  Project1
//
//  Created by Allen Whearry on 2/25/19.
//  Copyright © 2019 Codeine Technologies LLC. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let cellID = "Picture Cell"
    
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Storm Viewer"
        
        // must register a UITableViewCell when building programmatically
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items.sorted() {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        print(pictures)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 22)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        let selectedImage = pictures[indexPath.row]
        let pictureCount = "Picture \(indexPath.row + 1) of \(pictures.count)"
        detailViewController.selectedImage = selectedImage
        detailViewController.navigationTitle = pictureCount
        navigationController?.pushViewController(detailViewController, animated: true)
    }


}

