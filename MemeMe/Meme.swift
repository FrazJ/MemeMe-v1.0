//
//  Memed.swift
//  MemeMe
//
//  Created by Frazer Hogg on 20/08/2015.
//  Copyright (c) 2015 HomeProjects. All rights reserved.
//

import Foundation
import UIKit

class Meme {
    
    /* Properties */
    
    var topText : String
    var bottomText : String
    var originalImage: UIImage
    var memedImage : UIImage
    
    
    /* Initialiser */
    
    init (topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}