//
//  QOFEAdminApp.swift
//  QOFEAdmin
//
//  Created by rifqitriginandri on 25/03/23.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

@main
struct QOFEAdminApp: App {
    
    init(){
        FirebaseApp.configure()
    }

    var body: some Scene {
                
        WindowGroup {
            OrderView()
        }
    }
}
