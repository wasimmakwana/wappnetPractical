//
//  ViewController.swift
//  WappNet System Pratical
//
//  Created by Wasim on 29/09/21.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UITableViewController {

    var filteredTableData : [MediaModel] = []
    var resultSearchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.obscuresBackgroundDuringPresentation = false
//            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            tableView.tableHeaderView = controller.searchBar

            return controller
        })()

        self.tableView.register(UINib.init(nibName: "VideoListCell", bundle: nil), forCellReuseIdentifier: "VideoListCell")
        self.tableView.tableFooterView = UIView()

        self.tableView.reloadData()
    }
    
    @objc func btnFavUnFavTapped(_ sender : UIButton) {
        if let indexPath = self.tableView.indexPathForView(sender) {
            if (resultSearchController.isActive) {
//                var obj = filteredTableData[indexPath.row]
                filteredTableData[indexPath.row].favourite = !(filteredTableData[indexPath.row].favourite ?? false)
                if let find_index = arrMedias.firstIndex(where: {$0.id == filteredTableData[indexPath.row].id}) {
                    arrMedias[find_index].favourite = filteredTableData[indexPath.row].favourite
                }
                AppDelegate.shared.updateFavourite(filteredTableData[indexPath.row].id ?? "", filteredTableData[indexPath.row].favourite)
            } else {
                arrMedias[indexPath.row].favourite = !(arrMedias[indexPath.row].favourite ?? false)
                AppDelegate.shared.updateFavourite(arrMedias[indexPath.row].id ?? "", arrMedias[indexPath.row].favourite)
            }
            self.tableView.reloadData()
//            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    @objc func btnImagePreviewTapped(_ sender : UIButton) {
        if let indexPath = self.tableView.indexPathForView(sender), let preview = self.storyboard?.instantiateViewController(withIdentifier: "ImagePreviewVC") as? ImagePreviewVC {
            if (resultSearchController.isActive) {
                preview.strURL = filteredTableData[indexPath.row].thumb
            } else {
                preview.strURL = arrMedias[indexPath.row].thumb
            }
            self.present(preview, animated: true, completion: nil)
        }
    }
    @IBAction func btnAscendingSortTapped(_ sender : Any) {
        arrMedias = arrMedias.sorted(by: {($0.title ?? "").localizedCompare($1.title ?? "") == .orderedAscending})
        self.tableView.reloadData()
    }
    @IBAction func btnDescendingSortTapped(_ sender : Any) {
        arrMedias = arrMedias.sorted(by: {($0.title ?? "").localizedCompare($1.title ?? "") == .orderedDescending})
        self.tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

}
extension ViewController  {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (resultSearchController.isActive) {
            return filteredTableData.count
        } else {
            return arrMedias.count
        }
//        return arrMedias.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoListCell", for: indexPath) as? VideoListCell else { return UITableViewCell() }
        let objMedia = resultSearchController.isActive ? self.filteredTableData[indexPath.row] : arrMedias[indexPath.row]
        cell.lblName.text = objMedia.title
        cell.imgVideoThumb.setImageWithURL(objMedia.thumb, ph_image: UIImage(), true)
        cell.imgThumb.setImageWithURL(objMedia.thumb, ph_image: UIImage(), true)
        cell.btnFav.isSelected = objMedia.favourite == true
        cell.btnFav.addTarget(self, action: #selector(btnFavUnFavTapped(_:)), for: .touchUpInside)
        cell.btnPreviewThumb.addTarget(self, action: #selector(btnImagePreviewTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objMedia = resultSearchController.isActive ? self.filteredTableData[indexPath.row] : arrMedias[indexPath.row]
        if let strLink = objMedia.video_link,  let videoURL = URL(string: strLink) {
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player?.play()
            }
        }
    }
}
extension ViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData = arrMedias.filter({$0.title?.lowercased().contains(searchController.searchBar.text?.lowercased() ?? "") == true })
        self.tableView.reloadData()
    }

}
