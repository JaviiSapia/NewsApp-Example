//
//  MainNewsCell.swift
//  NewsApp
//
//  Created by Javier Sapia on 05/09/2021.
//

import UIKit

class MainNewsCell: UICollectionViewCell {

    // MARK: - Declaración de variables
    static let TAG: String = "MainNewsCell"
    
    // MARK: - Configuración de las distintas vistas
    @IBOutlet private weak var container: UIView! {
        didSet {
            container.layer.cornerRadius = 21
            container.layer.masksToBounds = true
            container.isUserInteractionEnabled = false
        }
    }
    @IBOutlet private weak var image: AsyncImage! {
        didSet { image.showAnimatedSkeleton() }
    }
    @IBOutlet private weak var header: HeaderView! {
        didSet {
            header.alpha = 0.0
            header.section.textColor = UIColor.lightGray
            header.headline.textColor = UIColor.white
            header.trailText.text = nil
        }
    }
    @IBOutlet private weak var headerContainer: UIView! {
        didSet {
            headerContainer.alpha = 0.0
            headerContainer.translatesAutoresizingMaskIntoConstraints = false
            headerContainer.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /**
        Infla la vista con la información traida del articulo
        - Parameter article: El articulo que se desea representar
     */
    func loadFromArticle(article: Article)  {
        self.header.loadFromArticle(article: article)
        self.header.trailText.text = nil
        self.header.date.text = nil
        self.image.loadFromUrl(url: article.image!)         
        self.play()
    }
    
    // Inicia una animación
    private func play() {
        UIView.animate(withDuration: 1) {
            self.headerContainer.alpha = 1.0
        } completion: { _ in
            UIView.animate(withDuration: 1) {
                self.header.alpha = 1.0
            }
        }

    }

}
