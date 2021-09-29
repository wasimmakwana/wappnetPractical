//
//  VideoListCell.swift
//  WappNet System Pratical
//
//  Created by Wasim on 29/09/21.
//

import UIKit

class VideoListCell: UITableViewCell {
    
    @IBOutlet weak var imgVideoThumb : UIImageView!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var imgThumb : UIImageView!
    @IBOutlet weak var videoBGView : UIView!
    @IBOutlet weak var btnFav : UIButton!
    @IBOutlet weak var btnPreviewThumb : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        imgThumb.superview?.layer.cornerRadius = 30 * Device.ScreenScale
        imgThumb.superview?.layer.masksToBounds = true
        
        btnFav.layer.cornerRadius = 30 * Device.ScreenScale
        btnFav.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
