//
//  StableSort.swift
//  Pods
//
//  Created by John Morgan on 07/04/2016.
//
//

import Foundation


// Source: http://airspeedvelocity.net/2016/01/10/writing-a-generic-stable-sort/
// Enables stable sorting of arrays.
extension RangeReplaceableCollectionType
    where
    Index: RandomAccessIndexType,
    SubSequence.Generator.Element == Generator.Element,
Index.Distance == Index.Stride {
    
    public mutating func stableSortInPlace(
        isOrderedBefore: (Generator.Element,Generator.Element)->Bool
        ) {
            let N = self.count
            
            var aux: [Generator.Element] = []
            aux.reserveCapacity(numericCast(N))
            
            func merge(lo: Index, _ mid: Index, _ hi: Index) {
                
                aux.removeAll(keepCapacity: true)
                
                var i = lo, j = mid
                while i < mid && j < hi {
                    if isOrderedBefore(self[j],self[i]) {
                        aux.append(self[j])
                        j += 1
                    }
                    else {
                        aux.append(self[i])
                        i += 1
                    }
                }
                aux.appendContentsOf(self[i..<mid])
                aux.appendContentsOf(self[j..<hi])
                self.replaceRange(lo..<hi, with: aux)
            }
            
            var sz: Index.Distance = 1
            while sz < N {
                for lo in startIndex.stride(to: endIndex-sz, by: sz*2) {
                    merge(lo, lo+sz, lo.advancedBy(sz*2,limit: endIndex))
                }
                sz *= 2
            }
    }
}

// A less verbose way to remove objects from arrays by reference.
extension Array where Element: AnyObject {
    
    mutating func removeObject(object: Element) {
        
        let index = indexOf { $0 === object }
        
        guard let foundIndex = index else {
            return
        }
        removeAtIndex(foundIndex)
    }
}