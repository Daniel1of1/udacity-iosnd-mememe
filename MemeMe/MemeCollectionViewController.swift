//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Daniel Haight on 10/08/2017.
//  Copyright © 2017 Daniel Haight. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeCell"

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    //MARK: UIViewController

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displayMeme" {
            let destination = segue.destination as! MemeDisplayViewController
            let index = collectionView!.indexPath(for:(sender as! UICollectionViewCell))!.row
            let meme = appDelegate.memes[index]
            destination.meme = meme
        }
    }

    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        
        let meme = appDelegate.memes[indexPath.row]
        cell.imageView.image = meme.originalImage
        cell.topLabel.attributedText = NSAttributedString(string: meme.topText, attributes: MemeTextAttributes.smallAttritubes)
        cell.bottomLabel.attributedText = NSAttributedString(string: meme.bottomText, attributes: MemeTextAttributes.smallAttritubes)

    
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = min(collectionView.frame.width, collectionView.frame.height)/3 - 8
        return CGSize(width: length, height: length)
    }


}
