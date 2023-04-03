//
//  OrderView.swift
//  QOFEAdmin
//
//  Created by rifqitriginandri on 25/03/23.
//

import SwiftUI

struct OrderView: View {
    
    @ObservedObject var orderListener  = OrderListener()
    
    var body: some View {
        
        NavigationView{
            List{
                
                Section(header: Text("Active Orders")) {
                    ForEach(self.orderListener.activeOrders ?? []) { order in
                        NavigationLink(destination: OrderDetailView(order: order)) {
                            HStack{
                                Text(order.customerName)
                                Spacer()
                                Text("\(order.amount.clean)")
                            }//end of hstack
                        }// end off navigation link
                    }// end of foreach
                }
                
                Section(header: Text("Complete Orders")) {
                    ForEach(self.orderListener.completedOrders ?? []) { order in
                        NavigationLink(destination: OrderDetailView(order: order)){
                            HStack{
                                Text(order.customerName)
                                Spacer()
                                Text("\(order.amount.clean)")
                            }//end of hstack
                            
                        }
                    }// end of foreach
                }
                
                
            }//end off list
            .navigationBarTitle("Orders")
        }// end off navigation
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView()
    }
}
