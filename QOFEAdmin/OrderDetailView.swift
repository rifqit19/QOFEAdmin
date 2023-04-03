//
//  OrderDetailView.swift
//  QOFEAdmin
//
//  Created by rifqitriginandri on 25/03/23.
//

import SwiftUI

struct OrderDetailView: View {
    
    var order: Order
    
    var body: some View {
        VStack{
            List{
                Section(header: Text("Customer")){
                    NavigationLink(destination: UserDetailView(order: order)) {
                        Text(order.customerName)
                            .font(.headline)
                    }
                }
                
                Section(header: Text("Order Items")){
                    ForEach(self.order.orderItems){ drink in
                        HStack{
                            Text(drink.name)
                            Spacer()
                            Text("\(drink.price.clean)")
                        }
                    }
                }

            }// end of list
            
        }// end of vstack
        .navigationBarTitle("Order", displayMode: .inline)
        .navigationBarItems(trailing:
        Button(action: {
            self.markAsCompleted()
        }, label: {
            Text(!order.isCompleted ? "Complete Order" : "Order Completed")
        }).disabled(order.isCompleted))
    }
    
    private func markAsCompleted(){
        
        if !order.isCompleted{
            order.isCompleted = true
            order.saveOrderToFirestore()
        }else{
            
        }
        
    }
}

struct OrderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetailView(order: Order())
    }
}
