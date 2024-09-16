//
//  ContentView.swift
//  CheckOut
//
//  Created by Cole Roberts on 9/1/23.
//

import SwiftUI

@available(iOS 17.0, *)
struct StartView: View {
    @ObservedObject var user: Checkout = Checkout()
    var body: some View {
        NavigationView {
            ZStack {
                Color(.black)
                VStack {
                    VStack {
                        Text(user.getBannerText())
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        if user.showPositionSelection() || user.showTextEntry() {
                            GeometryReader { geometry in
                                HStack {
                                    ZStack(alignment: .bottomLeading){
                                        Text("")
                                            .frame(maxWidth: geometry.size.width, maxHeight: 10)
                                            .background(Rectangle().foregroundColor(.red).cornerRadius(10))
                                        Text("")
                                            .frame(maxWidth: geometry.size.width * CGFloat(user.getCompletionBar()), maxHeight: 10)
                                            .background(Rectangle().foregroundColor(.green).cornerRadius(10))
                                    }
                                }
                            }
                            .frame(maxWidth: 275, maxHeight: 10)
                        }
                    }.frame(maxWidth: .infinity, maxHeight: 70)
                        .padding()
                        .background(Rectangle().foregroundColor(.white).cornerRadius(10))
                        .background(Rectangle().foregroundColor(.white).offset(y: -10))
                    VStack {
                        VStack(){
                            if user.showPositionSelection() {
                                Text("Select your position to start:").foregroundColor(.black)
                                HStack {
                                    Button { user.setPosition(choice: true) } label: {
                                        Text("Server")
                                            .frame(maxWidth: .infinity, maxHeight: 50)
                                            .background(Rectangle().foregroundColor(user.isServer() ? .green : .red).cornerRadius(10))
                                    }
                                    Button { user.setPosition(choice: false) } label: {
                                        Text("Takeout")
                                            .frame(maxWidth: .infinity, maxHeight: 50)
                                            .background(Rectangle().foregroundColor(!user.isServer() && user.isProgressEnabled() ? .green : .red).cornerRadius(10))
                                    }
                                }
                                if user.isProgressEnabled() {
                                    Text("Was there a Runner?")
                                        .foregroundColor(.black)
                                    HStack() {
                                        Button{ user.selectRunner(choice: false) } label: {
                                            Text("No")
                                                .frame(maxWidth: .infinity, maxHeight: 50)
                                                .background(Rectangle().foregroundColor(!user.hadRunner() && user.runnerPicked() ? .green : .red).cornerRadius(10))
                                        }
                                        Button{ user.selectRunner(choice: true) } label: {
                                            Text("Yes")
                                                .frame(maxWidth: .infinity, maxHeight: 50)
                                                .background(Rectangle().foregroundColor(user.hadRunner() ? .green : .red).cornerRadius(10))
                                        }
                                    }
                                }
                                if user.showBusserSelection() {
                                    Text("Select a Busser Tip.")
                                        .foregroundColor(.black)
                                    HStack() {
                                        Button { user.selectTip(tip: 0.17) } label: {
                                            Text("17%")
                                                .frame(maxWidth: .infinity, maxHeight: 50)
                                                .background(Rectangle().foregroundColor(user.isBusserSet(to: 0.17) ? .green : .red).cornerRadius(10))
                                        }
                                        Button { user.selectTip(tip: 0.18) } label: {
                                            Text("18%")
                                                .frame(maxWidth: .infinity, maxHeight: 50)
                                                .background(Rectangle().foregroundColor(user.isBusserSet(to: 0.18) ? .green : .red).cornerRadius(10))
                                        }
                                    }
                                    HStack () {
                                        Button { user.selectTip(tip: 0.19) } label: {
                                            Text("19%")
                                                .frame(maxWidth: .infinity, maxHeight: 50)
                                                .background(Rectangle().foregroundColor(user.isBusserSet(to: 0.19) ? .green : .red).cornerRadius(10))
                                        }
                                        Button { user.selectTip(tip: 0.20) } label: {
                                            Text("20%")
                                                .frame(maxWidth: .infinity, maxHeight: 50)
                                                .background(Rectangle().foregroundColor(user.isBusserSet(to: 0.20) ? .green : .red).cornerRadius(10))
                                        }
                                    }
                                }
                                if user.allowTextEntry() {
                                    Button { user.advanceToTextEntry() } label: {
                                        Text("Continue")
                                            .frame(maxWidth: .infinity, maxHeight: 50)
                                            .background(Rectangle().foregroundColor(.green).cornerRadius(10))
                                    }
                                }
                            } else if user.showTextEntry() {
                                HStack {
                                    Text("Net Sales")
                                        .frame(maxWidth: .infinity, maxHeight: 45)
                                    TextField("Enter", text: $user.netSalesText)
                                        .onChange(of: user.netSalesText) { user.markAndToggleNetText(text: user.netSalesText) }
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, maxHeight: 45)
                                        .keyboardType(.decimalPad)
                                        .background(Color.white.cornerRadius(10))
                                }.padding(.all, 5).background(Rectangle().foregroundColor(.red).cornerRadius(10))
                                if user.isServer() {
                                    if user.hadRunner() {
                                        HStack {
                                            Text("Food")
                                                .frame(maxWidth: .infinity, maxHeight: 45)
                                            TextField("Enter", text: $user.foodText)
                                                .onChange(of: user.foodText) { user.markAndToggleText(text: user.foodText, position: 1, textBox: 1) }
                                                .foregroundColor(.black)
                                                .frame(maxWidth: .infinity, maxHeight: 45)
                                                .keyboardType(.decimalPad)
                                                .background(Color.white.cornerRadius(10))
                                        }.padding(.all, 5).background(Rectangle().foregroundColor(.red).cornerRadius(10))
                                    }
                                    HStack {
                                        Text("Beer")
                                            .frame(maxWidth: .infinity, maxHeight: 45)
                                        TextField("Enter", text: $user.beerText)
                                            .onChange(of: user.beerText) { user.markAndToggleText(text: user.beerText, position: 1, textBox: 2) }
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity, maxHeight: 45)
                                            .keyboardType(.decimalPad)
                                            .background(Color.white.cornerRadius(10))
                                    }.padding(.all, 5).background(Rectangle().foregroundColor(.red).cornerRadius(10))
                                    HStack {
                                        Text("Wine")
                                            .frame(maxWidth: .infinity, maxHeight: 45)
                                        TextField("Enter", text: $user.wineText)
                                            .onChange(of: user.wineText) { user.markAndToggleText(text: user.wineText, position: 1, textBox: 3) }
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity, maxHeight: 45)
                                            .keyboardType(.decimalPad)
                                            .background(Color.white.cornerRadius(10))
                                    }.padding(.all, 5).background(Rectangle().foregroundColor(.red).cornerRadius(10))
                                    HStack {
                                        Spacer()
                                        Text("Liqour")
                                            .frame(maxWidth: .infinity, maxHeight: 45)
                                        TextField("Enter", text: $user.liqourText)
                                            .onChange(of: user.liqourText) { user.markAndToggleText(text: user.liqourText, position: 1, textBox: 4) }
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity, maxHeight: 45)
                                            .keyboardType(.decimalPad)
                                            .background(Color.white.cornerRadius(10))
                                    }.padding(.all, 5).background(Rectangle().foregroundColor(.red).cornerRadius(10))
                                    HStack {
                                        Spacer()
                                        Text("Mocktails")
                                            .frame(maxWidth: .infinity, maxHeight: 45)
                                        TextField("Enter", text: $user.mockText)
                                            .onChange(of: user.liqourText) { user.markAndToggleText(text: user.liqourText, position: 1, textBox: 5) }
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity, maxHeight: 45)
                                            .keyboardType(.decimalPad)
                                            .background(Color.white.cornerRadius(10))
                                    }.padding(.all, 5).background(Rectangle().foregroundColor(.red).cornerRadius(10))
                                } else {
                                    HStack {
                                        Text("Door Dash")
                                            .frame(maxWidth: .infinity, maxHeight: 45)
                                        TextField("Enter", text: $user.doorDashText)
                                            .onChange(of: user.doorDashText) { user.markAndToggleText(text: user.doorDashText, position: 2, textBox: 1) }
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity, maxHeight: 45)
                                            .keyboardType(.decimalPad)
                                            .background(Color.white.cornerRadius(10))
                                    }.padding(.all, 5).background(Rectangle().foregroundColor(.red).cornerRadius(10))
                                    HStack {
                                        Spacer()
                                        Text("Uber Eats")
                                            .frame(maxWidth: .infinity, maxHeight: 45)
                                        Spacer()
                                        TextField("Enter", text: $user.uberEatsText)
                                            .onChange(of: user.uberEatsText) { user.markAndToggleText(text: user.uberEatsText, position: 2, textBox: 2) }
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity, maxHeight: 45)
                                            .keyboardType(.decimalPad)
                                            .background(Color.white.cornerRadius(10))
                                    }.padding(.all, 5).background(Rectangle().foregroundColor(.red).cornerRadius(10))
                                }
                                Button { user.textContinueButton() } label: {
                                    Text("Continue")
                                        .frame(maxWidth: .infinity, maxHeight: 50)
                                        .background(Rectangle().foregroundColor(user.allowCompleted() ? .green : .red).cornerRadius(10))
                                }
                            } else {
                                VStack(){
                                    HStack {
                                        Text("Net Sales: ")
                                        Spacer()
                                        Text(String(Int(user.getNetSales())))
                                    }
                                    if user.isServer() {
                                        HStack {
                                            Text("Alcohol Sales: ")
                                            Spacer()
                                            Text(String(Int(user.getLiqourSales())))
                                        }
                                        HStack{
                                            Text("15% Tip Total: ")
                                            Spacer()
                                            Text(String(Int(user.getFifteenPercentTip())))
                                        }
                                        if user.hadRunner() {
                                            HStack{
                                                Text("Food Sales: ")
                                                Spacer()
                                                Text(String(Int(user.getFoodSales())))
                                            }
                                            HStack{
                                                Text("Food Tip Total: ")
                                                Spacer()
                                                Text(String(Int(user.getFoodTipTotal())))
                                            }
                                        }
                                        HStack{
                                            Text("Busser Tip: ")
                                            Spacer()
                                            Text(String(Int(user.getBusserTip())))
                                        }
                                        HStack{
                                            Text("Host Tip: ")
                                            Spacer()
                                            Text(String(Int(user.getHostTip())))
                                        }
                                        if user.hadRunner() {
                                            HStack{
                                                Text("Runner Tip: ")
                                                Spacer()
                                                Text(String(Int(user.getRunnerTip())))
                                            }
                                        }
                                        HStack{
                                            Text("Bartender Tip: ")
                                            Spacer()
                                            Text(String(Int(user.getBartenderTip())))
                                        }
                                    } else {
                                        HStack {
                                            Text("Door Dash Sales: ")
                                            Spacer()
                                            Text(String(Int(user.getDoorDashSales())))
                                        }
                                        HStack {
                                            Text("Uber Eats Sales: ")
                                            Spacer()
                                            Text(String(Int(user.getUberEatsSales())))
                                        }
                                        HStack{
                                            Text("Total 3rd Party Sales: ")
                                            Spacer()
                                            Text(String(Int(user.get3rdPartySales())))
                                        }
                                        HStack{
                                            Text("Net Sales - 3rd Party: ")
                                            Spacer()
                                            Text(String(Int(user.getNetMinus3rdSales())))
                                        }
                                        HStack{
                                            Text("Tippable Sales: ")
                                            Spacer()
                                            Text(String(Int(user.getTippableSales())))
                                        }
                                        HStack{
                                            Text("Runner Tip: ")
                                            Spacer()
                                            Text(String(Int(user.getRunnerTip())))
                                        }
                                    }
                                }
                                .foregroundColor(.black)
                            }
                        }
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Rectangle().foregroundColor(.white).cornerRadius(10))
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    Spacer()
                    if user.isProgressEnabled() {
                        VStack {
                            HStack() {
                                Button { user.returnButton() } label: {
                                    Text("Return")
                                        .font(.title2)
                                        .frame(maxWidth: .infinity, maxHeight: 50)
                                        .background(Rectangle().foregroundColor(.red).cornerRadius(10))
                                }
                                Button { user.restartButton() } label: {
                                    Text("Restart")
                                        .font(.title2)
                                        .frame(maxWidth: .infinity, maxHeight: 50)
                                        .background(Rectangle().foregroundColor(.red).cornerRadius(10))
                                }
                            }
                        }
                        .padding()
                        .background(Rectangle().foregroundColor(.white).cornerRadius(10))
                        .background(Rectangle().foregroundColor(.white).offset(y: 10))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

@available(iOS 17.0, *)
struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}

