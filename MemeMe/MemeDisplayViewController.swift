//
//  MemeDisplayViewController.swift
//  MemeMe
//
//  Created by Daniel Haight on 15/08/2017.
//  Copyright © 2017 Daniel Haight. All rights reserved.
//

import UIKit

class MemeDisplayViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var meme: Meme? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = meme?.memedImage
    }

}
