//
//  ImagePreviewVC.swift
//  WappNet System Pratical
//
//  Created by Wasim on 30/09/21.
//

import UIKit

class ImagePreviewVC: UIViewController {

    @IBOutlet weak var imgThumb : UIImageView!
    var strURL : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgThumb.setImageWithURL(strURL, ph_image: nil, true)
    }
}
