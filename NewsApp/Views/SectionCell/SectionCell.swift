//
//  SectionCell.swift
//  NewsApp
//
//  CollectionViewCell para las distintas seciones
//

import UIKit
import RxSwift

class SectionCell: UICollectionViewCell {

    // MARK: - Declaración de variables
    static let TAG: String = "SectionCell"
    var id: Int?
    
    // MARK: - Configuración de las distintas vistas
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var containerView: UIView! {
        didSet { containerView.layer.cornerRadius = 5 }
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    /**
         Recibe las respuestas de los clicks en UICollectionView
         - Parameter observable: Subject al que se va a escuchar
     */
    func setObservable(observable: Observable<Int>) {
        observable.subscribe { index in
            
            // Realiza la animación sin necesidad de llamar al realoadData
            // aumentado el rendimiento de la app
            self.setIsActive(isActive: (index.element == self.id!))
        }
    }
    
    /**
        Cambia el estado de la vista (Activo/Inactivo)
        - Parameter isActive: Define si la vista va estar activada o no
     */
    private func setIsActive(isActive: Bool) {
        UIView.animate(withDuration: 0.3) {
            if(isActive) {
                self.containerView.backgroundColor = UIColor.black
                self.title.textColor = UIColor.white
            } else {
                if #available(iOS 13.0, *) {
                    self.containerView.backgroundColor = UIColor.systemBackground
                } else {
                    self.containerView.backgroundColor = UIColor.white
                }
                self.title.textColor = UIColor.systemGray
            }
        }
    }
    
    // Configuro el layout para que el tamaño de la vista sea el mismo tamaño del texto
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let frame: CGSize = CGSize(
            width: self.title.intrinsicContentSize.width * 1.3,
            height: layoutAttributes.frame.height)
        layoutAttributes.size = frame
        return layoutAttributes
    }

}
