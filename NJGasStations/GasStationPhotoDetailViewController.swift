//
//  GasStationPhotoDetailViewController.swift
//  NJGasStations
//
//  Created by Joseph T. Furmanowski on 10/7/22.
//

import UIKit

class GasStationPhotoDetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let photoModel = GasStationPhotosModel.sharedInstance
    var photo:String = ""
    var largePhotoView = UIImageView()
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let filePath = photoModel.getImageFilePath(photo) {
            largePhotoView.image = UIImage (contentsOfFile: filePath)
        } else {
            largePhotoView.image = nil
        }
        
        largePhotoView.sizeToFit()
        scrollView.addSubview(largePhotoView)
        scrollView.contentSize = largePhotoView.bounds.size
        scrollView.minimumZoomScale = 0.01
        scrollView.maximumZoomScale = 2.0
        scrollView.delegate = self
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return largePhotoView
    }
    
}
