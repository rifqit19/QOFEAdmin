//
//  FirebaseReference.swift
//  QOFE
//
//  Created by rifqitriginandri on 04/03/23.
//

import Foundation
import FirebaseFirestore


enum FCollectionReference: String{
    
    case User
    case Menu
    case Order
    case Basket
    
}


func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
}
