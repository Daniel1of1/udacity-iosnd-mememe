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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
