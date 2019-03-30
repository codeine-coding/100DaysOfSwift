//
//  ViewController.swift
//  ShoppingListChallenge
//
//  Created by Allen Whearry on 3/30/19.
//  Copyright © 2019 Allen Whearry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let cellID = "Cell ID"
    var shoppingList = [String]()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func loadView() {
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    fileprivate func setupView() {
        title = "Shopping List"
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemToList))
        let shareBtn = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        navigationItem.rightBarButtonItems = [addBtn, shareBtn]

        let clearBtn = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearList))
        navigationItem.leftBarButtonItem = clearBtn


    }

    func addItem(_ item: String) {
        shoppingList.insert(item, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }

    @objc func share() {
        let items = shoppingList.joined(separator: "\n")
        let avc = UIActivityViewController(activityItems: [items], applicationActivities: nil)
        avc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItems?[1]
        present(avc, animated: true, completion: nil)
    }

    @objc func addItemToList() {
        let ac = UIAlertController(title: "Enter Item", message: nil, preferredStyle: UIAlertController.Style.alert)
        ac.addTextField()

        let addAction = UIAlertAction(title: "Add", style: UIAlertAction.Style.default) {
            [weak self, weak ac] _ in
            guard let item = ac?.textFields?[0].text else { return }
            self?.addItem(item)
        }

        ac.addAction(addAction)
        present(ac, animated: true, completion: nil)
    }

    @objc func clearList() {
        shoppingList.removeAll()
        tableView.reloadData()
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }


}

