//
//  ImageViewExtn.swift
//  WappNet System Pratical
//
//  Created by Wasim on 30/09/21.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView
{
    func setImageWithURL(_ TempUrl: String? , ph_image: UIImage?, _ isActivity : Bool = false)
    {
        if let imageUrl = TempUrl , let URLImage = URL(string: imageUrl)
        {
            let resource = ImageResource(downloadURL: URLImage, cacheKey: imageUrl)
            if isActivity {
                self.kf.indicatorType = .activity
            } else {
                self.kf.indicatorType = .none
            }
            self.kf.setImage(with: resource, placeholder: ph_image)
        }
        else
        {
            image = ph_image
        }
    }
    
}

