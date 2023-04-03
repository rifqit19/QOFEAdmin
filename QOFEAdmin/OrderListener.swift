//
//  BasketListener.swift
//  QOFE
//
//  Created by rifqitriginandri on 05/03/23.
//

import Foundation
import SwiftUI

class OrderListener: ObservableObject{
    
    @Published var activeOrders: [Order]!
    @Published var completedOrders: [Order]!
    
    init(){
        downloadOrder()
    }
    
    func downloadOrder(){
        
        FirebaseReference(.Order).addSnapshotListener { (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            
            if !snapshot.isEmpty {
                
                self.activeOrders = []
                self.completedOrders = []
                
                for order in snapshot.documents{
                    let orderData = order.data()
                    
                    getDrinksFromFirestore(withIds: orderData[kDRINKSID] as? [String] ?? []) { allDrinks in
                        
                        let order = Order()
                        order.customerId = orderData[kCUSTOMERID] as? String
                        order.id = orderData[kID] as? String
                        order.orderItems = allDrinks
                        order.amount = orderData[kAMOUNT] as? Double
                        order.customerName = orderData[kCUSTOMERNAME] as? String ?? ""
                        order.isCompleted = orderData[kISCOMPLETED] as? Bool ?? false
                        
                        if order.isCompleted {
                            self.completedOrders.append(order)
                        }else{
                            self.activeOrders.append(order)
                        }
                        
                        
                    }
                }
                
            }
        }
        
        
    }
}


func getDrinksFromFirestore(withIds: [String], completion: @escaping (_ drinkArray: [Drink]) -> Void){
    
    var count = 0
    var drinkArray: [Drink] = []
    
    if withIds.count == 0{
        completion(drinkArray)
        return
    }
    
    for drinkId in withIds{
        
        FirebaseReference(.Menu).whereField(kID, isEqualTo: drinkId).getDocuments { snapshot, error in
            guard let snapshot = snapshot else{return}
            
            if !snapshot.isEmpty{
                let drinkData = snapshot.documents.first!
                
                drinkArray.append(Drink(
                    id: drinkData[kID] as? String ?? UUID().uuidString,
                    name: drinkData[kNAME] as? String ?? "Unknown",
                    imageName: drinkData[kIMAGENAME] as? String ?? "Unknown",
                    category: Category(rawValue: drinkData[kCATEGORY] as? String ?? "cold") ?? .cold,
                    description: drinkData[kDESCRIPTION] as? String ?? "Description not found",
                    price: drinkData[kPRICE] as? Double ?? 0.0))
                
                count += 1
                
            }else{
                print("have no drink")
                completion(drinkArray)
            }
            
            if count == withIds.count{
                completion(drinkArray)
            }
        }
        
    }
    
}
