//
//  distinct.swift
//  RxSwiftExt
//
//  Created by Segii Shulga on 5/4/16.
//  Copyright © 2017 RxSwift Community. All rights reserved.
//

import Foundation
import RxSwift

extension Observable {
    /**
     Suppress duplicate items emitted by an Observable
     - seealso: [distinct operator on reactivex.io](http://reactivex.io/documentation/operators/distinct.html)
     - parameter predicate: predicate determines whether element distinct
     
     - returns: An observable sequence only containing the distinct contiguous elements, based on predicate, from the source sequence.
     */
    public func distinct(_ predicate: @escaping (Element) throws -> Bool) -> Observable<Element> {
        var cache = [Element]()
        return compactMap { element -> Element? in
            if try cache.contains(where: predicate) {
                return nil
            } else {
                cache.append(element)
                return element
            }
        }
    }
}

extension Observable where Element: Hashable {
    /**
     Suppress duplicate items emitted by an Observable
     - seealso: [distinct operator on reactivex.io](http://reactivex.io/documentation/operators/distinct.html)
     - returns: An observable sequence only containing the distinct contiguous elements, based on equality operator, from the source sequence.
     */
    public func distinct() -> Observable<Element> {
        var cache = Set<Element>()
        return compactMap { element -> Element? in
            if cache.contains(element) {
                return nil
            } else {
                cache.insert(element)
                return element
            }
        }
    }
}

extension Observable where Element: Equatable {
    /**
     Suppress duplicate items emitted by an Observable
     - seealso: [distinct operator on reactivex.io](http://reactivex.io/documentation/operators/distinct.html)
     - returns: An observable sequence only containing the distinct contiguous elements, based on equality operator, from the source sequence.
     */
    public func distinct() -> Observable<Element> {
        var cache = [Element]()
        return flatMap { element -> Element? in
            if cache.contains(element) {
                return nil
            } else {
                cache.append(element)
                return element
            }
        }
    }
}
