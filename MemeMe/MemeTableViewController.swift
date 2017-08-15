//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Daniel Haight on 10/08/2017.
//  Copyright © 2017 Daniel Haight. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displayMeme" {
            let destination = segue.destination as! MemeDisplayViewController
            let index = tableView.indexPath(for:(sender as! UITableViewCell))!.row
            let meme = appDelegate.memes[index]
            destination.meme = meme
        }
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell", for: indexPath) as! MemeTableViewCell
        let meme = appDelegate.memes[indexPath.row]
        cell.memeLabel.text = meme.topText + meme.bottomText
        cell.memeImageView.image = meme.originalImage
        cell.topLabel.attributedText = NSAttributedString(string: meme.topText, attributes: MemeTextAttributes.smallAttritubes)
        cell.bottomLabel.attributedText = NSAttributedString(string: meme.bottomText, attributes: MemeTextAttributes.smallAttritubes)
        
        return cell
    
    }
    
    //MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            appDelegate.memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
