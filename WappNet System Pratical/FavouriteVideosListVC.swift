//
//  FavouriteVideosListVC.swift
//  WappNet System Pratical
//
//  Created by Wasim on 29/09/21.
//

import UIKit
import AVFoundation
import AVKit

class FavouriteVideosListVC: UITableViewController {
    
    var arrFavourite = [MediaModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "VideoListCell", bundle: nil), forCellReuseIdentifier: "VideoListCell")
        self.tableView.tableFooterView = UIView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrFavourite = arrMedias.filter({$0.favourite == true})
        self.tableView.reloadData()
    }
    
    @objc func btnFavUnFavTapped(_ sender : UIButton) {
        if let indexPath = self.tableView.indexPathForView(sender) {
            let objRemove = arrFavourite.remove(at: indexPath.row)
            if let find_index = arrMedias.firstIndex(where: {$0.id == objRemove.id}) {
                arrMedias[find_index].favourite = false
            }
            AppDelegate.shared.updateFavourite(objRemove.id ?? "", false)
            self.tableView.deleteRows(at: [indexPath], with: .none)
        }
    }
    @objc func btnImagePreviewTapped(_ sender : UIButton) {
        if let indexPath = self.tableView.indexPathForView(sender), let preview = self.storyboard?.instantiateViewController(withIdentifier: "ImagePreviewVC") as? ImagePreviewVC {
            preview.strURL = arrFavourite[indexPath.row].thumb
            self.present(preview, animated: true, completion: nil)
        }
    }


}
extension FavouriteVideosListVC  {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFavourite.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoListCell", for: indexPath) as? VideoListCell else { return UITableViewCell() }
        let objMedia = arrFavourite[indexPath.row]
        cell.lblName.text = objMedia.title
        cell.imgVideoThumb.setImageWithURL(objMedia.thumb, ph_image: UIImage(), true)
        cell.imgThumb.setImageWithURL(objMedia.thumb, ph_image: UIImage(), true)
        cell.btnFav.isSelected = objMedia.favourite == true
        cell.btnFav.addTarget(self, action: #selector(btnFavUnFavTapped(_:)), for: .touchUpInside)
        cell.btnPreviewThumb.addTarget(self, action: #selector(btnImagePreviewTapped(_:)), for: .touchUpInside)

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let strLink = arrFavourite[indexPath.row].video_link,  let videoURL = URL(string: strLink) {
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player?.play()
            }
        }
    }

}

