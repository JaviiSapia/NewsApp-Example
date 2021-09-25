//
//  MainNewsReusableCellCollectionViewCell.swift
//  NewsApp
//
//  Created by Javier Sapia on 02/09/2021.
//

import UIKit
import SkeletonView

class MainNewsReusableCellCollectionViewCell: UICollectionViewCell {
    
    static let TAG: String = "MainNewsReusableCellCollectionViewCell"
    @IBOutlet private weak var image: UIImageView! {
        didSet {
            image.showAnimatedSkeleton()
        }
    }
    @IBOutlet private weak var textContainer: UIView! {
        didSet {
            self.textContainer.alpha = 0.0
        }
    }
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel! {
        didSet {
            date.textColor = UIColor.white.withAlphaComponent(0.8)
        }
    }
    @IBOutlet private weak var container: UIView! {
        didSet {
            self.container.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }
    }
            
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.layer.cornerRadius = 21
    }
    
    func loadImageFromUrl(uri: URL) {
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: uri)
                DispatchQueue.main.async {
                    self.image.hideSkeleton()
                    self.image.image = UIImage(data: data)
                    self.showText()
                }
            }
            catch{
                print("🔴 " + error.localizedDescription)
            }
        }
    }
    
    private func showText() {
        UIView.animate(withDuration: 0.3, delay: 1, options: [], animations: {
            self.textContainer.alpha = 1.0
        }, completion: nil)
    }
    
}
