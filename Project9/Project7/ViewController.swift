//
//  ViewController.swift
//  Project7
//
//  Created by Allen Whearry on 3/31/19.
//  Copyright © 2019 Allen Whearry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let cellID = "Cell ID"

    var petitions = [Petition]()


    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func loadView() {
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: UIBarButtonItem.Style.plain, target: self, action: #selector(showCredits))
        isFiltered(false)


        setData()

    }

    func isFiltered(_ filtered: Bool) {
        if filtered {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear Filter", style: .plain, target: self, action: #selector(clearFilter))
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filter))
        }
    }

    func setData() {
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }

    @objc func fetchJSON() {
        let urlString: String

        if navigationController?.tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }

    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }

    @objc func showError() {
        // never a good idea to put ui work in the background thread, only on the main thread.
        let ac = UIAlertController(title: "Loading Error", message: "There was an problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true, completion: nil)
    }

    @objc func showCredits() {
        let ac = UIAlertController(title: "Data Provided By:", message: "We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true, completion: nil)
    }

    @objc func filter() {
        let ac = UIAlertController(title: "Filter Results", message: "Type text to filter results", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Filter", style: .default, handler: {
            [weak ac] _ in
            guard let text = ac?.textFields?[0].text else { return }
            self.petitions = self.petitions.filter({ $0.body.lowercased().contains(text.lowercased()) || $0.title.lowercased().contains(text.lowercased()) })
            self.isFiltered(true)
            self.tableView.reloadData()
        }))
        present(ac, animated: true, completion: nil)
    }

    @objc func clearFilter() {
        setData()
        isFiltered(false)
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellID)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)

        cell.textLabel?.text = petitions[indexPath.row].title
        cell.detailTextLabel?.text = petitions[indexPath.row].body
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }


}

class SubtitleTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
