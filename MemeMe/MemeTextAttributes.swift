//
//  MemeTextAttributes.swift
//  MemeMe
//
//  Created by Daniel Haight on 15/08/2017.
//  Copyright © 2017 Daniel Haight. All rights reserved.
//

import UIKit

struct MemeTextAttributes {
    
    static var defaultAttritubes: [String:Any] {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        let memeTextAttributes:[String:Any] = [
            NSParagraphStyleAttributeName: style,
            NSForegroundColorAttributeName: UIColor.white,
            NSStrokeColorAttributeName: UIColor.black,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -4]
        
        return memeTextAttributes
    }

    static var smallAttritubes: [String:Any] {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        style.lineBreakMode = .byTruncatingMiddle
        
        let memeTextAttributes:[String:Any] = [
            NSParagraphStyleAttributeName: style,
            NSForegroundColorAttributeName: UIColor.white,
            NSStrokeColorAttributeName: UIColor.black,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
            NSStrokeWidthAttributeName: -4]
        
        return memeTextAttributes
    }
}
