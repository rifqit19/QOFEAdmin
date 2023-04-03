//
//  UserDetailView.swift
//  QOFEAdmin
//
//  Created by rifqitriginandri on 25/03/23.
//

import SwiftUI

struct UserDetailView: View {
    
    var order : Order
    @State var user: FUser?
    
    var body: some View {
        
        List{
            Section{
                Text(user?.fullName ?? "")
                Text(user?.email ?? "")
                Text(user?.phoneNumber ?? "")
                Text(user?.fullAddress ?? "")
            }// end of section
        }// end of list
        .listStyle(GroupedListStyle())
        .navigationBarTitle("User Profil")
        .onAppear{
            self.getUser()
        }
    }
    
    private func getUser(){
        downloadUser(userId: self.order.customerId) { user in
            self.user = user
        }
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(order: Order())
    }
}
