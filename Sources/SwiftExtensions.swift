//
//  StableSort.swift
//  Pods
//
//  Created by John Morgan on 07/04/2016.
//
//

import Foundation


// Source: http://airspeedvelocity.net/2016/01/10/writing-a-generic-stable-sort/
// Swift 3 update: http://sketchytech.blogspot.co.uk/2016/03/swift-sticking-together-with.html
// Enables stable sorting of arrays.

extension RangeReplaceableCollection
    where
    Index: Strideable,
    IndexDistance == Index.Stride {
    
    public mutating func stableSortInPlace(
        isOrderedBefore: @escaping (Iterator.Element,Iterator.Element)->Bool
        ) {
        let N = self.count
        
        var aux: [Iterator.Element] = []
        aux.reserveCapacity(numericCast(N))
        
        func merge(lo: Index, mid: Index, hi: Index) {
            aux.removeAll(keepingCapacity: true)
            
            var i = lo, j = mid
            while i < mid && j < hi {
                if isOrderedBefore(self[j],self[i]) {
                    aux.append(self[j])
                    j = (j as! Int + 1) as! Self.Index
                }
                else {
                    aux.append(self[i])
                    i = (i as! Int + 1) as! Self.Index
                }
            }
            aux.append(contentsOf:self[i..<mid])
            aux.append(contentsOf:self[j..<hi])
            self.replaceSubrange(lo..<hi, with: aux)
        }
        
        var sz: IndexDistance = 1
        while sz < N {
            let limit = index(endIndex, offsetBy: -sz)
            for lo in stride(from:startIndex, to: limit, by: sz*2) {
                
                if let hi = index(lo, offsetBy:sz*2, limitedBy: endIndex) {
                    let mid = index(lo, offsetBy: sz)
                    merge(lo:lo, mid: mid, hi:hi)
                }
                
            }
            sz *= 2
        }
    }
}

// A less verbose way to remove objects from arrays by reference.
extension Array where Element: AnyObject {
    
    mutating func removeObject(_ object: Element) {
        
        let index = self.index { $0 === object }
        
        guard let foundIndex = index else {
            return
        }
        remove(at: foundIndex)
    }
}
