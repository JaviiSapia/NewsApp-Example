//
//  NewsListDelegate.swift
//  NewsApp
//
//

import Foundation

protocol NewsListDelegate: AnyObject {
    func onChangeListener()
    func news(selected article: Article)
}
