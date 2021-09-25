//
//  AsyncImage.swift
//  NewsApp
//
//  Extención de UIImageView para manejar la carga de imágenes
//  de manera asyncrona
//

import Foundation
import SkeletonView
import UIKit

class AsyncImage: UIImageView {
    private let cache = NSCache<NSURL, UIImage>()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setSkeleton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setSkeleton()
    }
    
    // Muestra el efecto de carga
    private func setSkeleton() {
        self.isSkeletonable = true
        self.showAnimatedSkeleton()
    }
    
    /**
        Carga una imágen desde la web o desde la cache en segundo plano
        - Parameter url: La url de la imágen a mostrar
        - Parameter onFinish: Callback de notificación de fin de carga de la imagen
        - Parameter onError: Callback de notificación de interrupción de error al cargar la imágen
     */
    func loadFromUrl(url: String, onFinish: ((_ image: UIImage) -> Void)? = nil, onError: ((_ error: Error) -> Void)? = nil) {
        let tempUrl: NSURL = NSURL(string: url)!
        DispatchQueue.global().async {
            // Busco la imagen en la cache
            if let imageInCache = self.cache.object(forKey: tempUrl) {
                DispatchQueue.main.async {
                    // Escondo el efecto de carga y muestro la imágen
                    self.hideSkeleton()
                    self.image = imageInCache
                    onFinish?(imageInCache)
                }
            } else {
                do {
                    // Traigo la imagen por HTTP
                    let data = try Data(contentsOf: URL(string: url)!)
                    let image = UIImage(data: data)
                    self.cache.setObject(image!, forKey: tempUrl)
                    DispatchQueue.main.async {
                        // Escondo el efecto de carga y muestro la imágen
                        self.hideSkeleton()
                        self.image = image
                        onFinish?(image!)
                    }
                } catch let error {
                    print("🔴 Hubo un problema al cargar la imágen", error.localizedDescription)
                    onError?(error)
                }
            }
        }
    }
    
}
