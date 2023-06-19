//
//  OrderDetailView.swift
//  QOFEAdmin
//
//  Created by rifqitriginandri on 25/03/23.
//

import SwiftUI

struct OrderDetailView: View {
    
    var order: Order
    
    @Environment(\.presentationMode) var presentationMode
    @State var isTapped = false
    @State var isSuccess = false

    @State private var printShowing = false
    @State var drinksName = [String]()
    @State var drinksPrice = [String]()
    @State var dname = ""
    @State var dPrice = ""

    let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM yyyy"
            formatter.locale = Locale(identifier: "id_ID") // Set the desired locale
            return formatter
        }()
    
    var body: some View {
        VStack{
            List{
                
                Section(header: Text("Customer")){
                    NavigationLink(destination: UserDetailView(order: order)) {
                        Text(order.customerName)
                            .font(.headline)
                    }
                    
                    HStack{
                        Text("Total")
                        Spacer()
                        Text("Rp. \(order.amount.clean)")
                    }
                    
                }
                
                Section(header: Text("Daftar Pesanan")){
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
//                        isTapped.toggle()
//                        self.markAsCompleted()
            var i = 1
            order.orderItems.map({ item in
                self.drinksName.append("\(i). \(item.name) - \(item.price.clean)")
//                self.drinksPrice.append(item.price.clean)
                i += 1
            })
            
            

            self.printShowing.toggle()
        }, label: {
            Text(!order.isCompleted ? "Selesaikan Order" : "Selesai")
                .padding().foregroundColor(.white)
        })
                                    .cornerRadius(10)
                                    .frame(height: 45)
                                    .background(!order.isCompleted ? Color("brown") : Color.gray)
                                    .background(!isTapped ? Color("brown") : Color.gray)
                                    .clipShape(Capsule())
                                    .disabled(order.isCompleted)
                            
                                    .background(Group {
                                        if self.printShowing {
                                            
                                            PrintHTMLView(htmlString:
                                                                """
                                                                        <html>
                                                                        <head>
                                                                            <style>
                                                                                /* CSS styling for the receipt */
                                                                                /* Customize the styling as desired */
                                                                                body {
                                                                                    font-family: Arial, sans-serif;
                                                                                }
                                                                                h1 {
                                                                                    text-align: center;
                                                                                }
                                                                                table {
                                                                                    width: 100%;
                                                                                    border-collapse: collapse;
                                                                                }
                                                                                th, td {
                                                                                    border-bottom: 1px solid #000000;
                                                                                }
                                                                                tfoot td {
                                                                                    font-weight: bold;
                                                                                }
                                                                            </style>
                                                                        </head>
                                                                        <body>
                                                                            <h2>QOFE</h2>
                                                                            <h5>\(dateFormatter.string(from: Date()))</h5>
                                                                                            <p>Nama: \(order.customerName ?? "no name")</p>
                                                                            <table>
                                                                                <thead>
                                                                                    <tr>
                                                                                        <th>Item</th>
                                                                                        <th>Price</th>
                                                                                    </tr>
                                                                                </thead>
                                                                                <tbody>
                                                                    
                                                                                                                                                    <thead>
                                                                                                                                                        <tr>
                                                                                                                                                            <td>\(drinksName.joined(separator: "   "))</td>
                                                                                                                                                        </tr>
                                                                                                                                                    </thead>
                                                                    
                                                                                </tbody>
                                                                                    <tfoot>
                                                                                        <tr>
                                                                                            <td><strong>Total:</strong></td>
                                                                                            <td>Rp. \(order.amount.clean)</td>
                                                                                        </tr>
                                                                                    </tfoot>
                                                                                </table>
                                                                            </body>
                                                                            </html>
                                                                    
                                                                    
                                                                    """
                                                          , title: "Report") {
                                                self.printShowing.toggle()
                                                isTapped.toggle()
                                                self.markAsCompleted()
                                                print("Print Sukses")
                                            }error: { error in
                                                print("Print error: \(error)")
                                            }
                                        }
                                    }).onDisappear(){
                                        print("back")
                                        drinksName.removeAll()
                                    }
        )
    }
    
    private func markAsCompleted(){
        self.presentationMode.wrappedValue.dismiss()
        if !order.isCompleted{
            order.isCompleted = true
            order.saveOrderToFirestore()
        }else{
            
        }
    }
    
    struct PrintHTMLView: UIViewControllerRepresentable
    {
        let title: String
        let formatter: UIMarkupTextPrintFormatter
        let callback: () -> ()
        let errorCallback: (Error) -> ()

        init(htmlString: String, title: String, completion: @escaping () -> (), error: @escaping (Error) -> ()) {
            self.title = title
            self.callback = completion
            self.errorCallback = error

            formatter = UIMarkupTextPrintFormatter(markupText: htmlString)
            formatter.perPageContentInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
        }
        

        func makeUIViewController(context: Context) -> UIViewController
        {
            let printInfo = UIPrintInfo(dictionary: nil)
            printInfo.jobName = title
            printInfo.outputType = .photo

            let printController = UIPrintInteractionController.shared
            printController.printInfo = printInfo
            printController.showsNumberOfCopies = false
            printController.showsPaperOrientation = false
            printController.showsPaperSelectionForLoadedPapers = false

            printController.printFormatter = formatter

            let controller = UIViewController()
            DispatchQueue.main.async {
                printController.present(animated: true, completionHandler: { _, completed, error in
                    printController.printFormatter = nil
                    self.callback()
                    
                    if completed {
                        print("Print completed")
                    } else if let error = error {
                        self.errorCallback(error)
                    }
                })
            }
            return controller
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context)
        {
        }
    }

}

struct OrderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetailView(order: Order())
    }
}


