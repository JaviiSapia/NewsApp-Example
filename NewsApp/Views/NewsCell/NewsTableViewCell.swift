//
//  NewsCollectionViewCell.swift
//  NewsApp
//
//  Created by Javier Sapia on 03/09/2021.
//

import UIKit

class NewsCell: UITableViewCell {
       
    static let TAG: String = "NewsTableViewCell"
    @IBOutlet weak var header: HeaderView! {
        didSet {
            header.trailText.text = nil
        }
    }
    @IBOutlet weak var newsImage: UIImageView! {
        didSet {
            self.newsImage.isSkeletonable = true
            self.newsImage.showAnimatedSkeleton()
            self.newsImage.layer.cornerRadius = 10
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func loadFromArticle(article: Article) {
        self.header.loadFromArticle(article: article)
        self.header.trailText.text = nil
        self.newsImage.image = article.image
        self.newsImage.hideSkeleton()
        self.newsImage.layer.cornerRadius = 10
    }
    
}
