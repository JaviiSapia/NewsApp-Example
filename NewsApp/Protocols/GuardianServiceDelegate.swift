//
//  GuardianServiceDelegate.swift
//  NewsApp
//
//

import Foundation

protocol GuardianSeriviceDelegate: AnyObject {
    
    func service(response articles: ArraySlice<Article>)
    func service(response content: String)
    func service(on error: Error)
    
}
