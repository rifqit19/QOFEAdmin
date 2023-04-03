//
//  UserListener.swift
//  QOFEAdmin
//
//  Created by rifqitriginandri on 25/03/23.
//

import Foundation
import FirebaseCore

func downloadUser(userId: String, completion: @escaping(_ user: FUser?) -> Void){
    
    FirebaseReference(.User).whereField(kID, isEqualTo: userId).getDocuments { snapshot, error in
        guard let snapshot = snapshot else { return }
        
        if !snapshot.isEmpty{
            let userData = snapshot.documents.first!.data()
            completion(FUser(userData as NSDictionary))
        }else{
            completion(nil)
        }
    }
}
