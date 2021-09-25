//
//  NewsCollectionViewCell.swift
//  NewsApp
//
//  Created by Javier Sapia on 03/09/2021.
//

import UIKit

class NewsCell: UICollectionViewCell {
       
    // MARK: - Declaración de variables
    static let TAG: String = "NewsCell"
    
    // MARK: - Configuración de las distintas vistas    
    @IBOutlet private weak var container: UIView! {
        didSet {
            container.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var header: HeaderView! {
        didSet {
            header.trailText.text = nil
        }
    }
    @IBOutlet weak var imageContainer: UIView! {
        didSet {
            self.imageContainer.layer.masksToBounds = true
            self.imageContainer.layer.cornerRadius = 10
        }
    }
    @IBOutlet private weak var newsImage: AsyncImage! {
        didSet {
            self.newsImage.layer.masksToBounds = true
            self.newsImage.layer.cornerRadius = 10
        }
    }
    
    
    // MARK: - Se infla la UIView
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /**
        Infla la vista con la información traida del articulo
        - Parameter article: El articulo que se desea representar
     */
    func loadFromArticle(article: Article) {
        self.header.loadFromArticle(article: article)
        self.header.trailText.text = nil
        self.newsImage.loadFromUrl(url: article.image!)        
        self.newsImage.layer.cornerRadius = 10
    }
    
}
