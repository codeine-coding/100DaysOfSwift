//
//  DetailViewController.swift
//  Project1
//
//  Created by Allen Whearry on 2/25/19.
//  Copyright © 2019 Codeine Technologies LLC. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var selectedImageInfo: (imageString: String, pictureCountString: String)? {
        didSet {
            guard let imageInfo = selectedImageInfo else { fatalError() }
            self.imageView.image = UIImage(named: imageInfo.imageString)
            self.title = imageInfo.pictureCountString
        }
    }
    
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "nssl0049.jpg")
        return imageView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .white
        view.addSubview(imageView)
        displayConstraints()
    }
    
    private func displayConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

}
