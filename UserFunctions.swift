//
//  UserFunctions.swift
//  CheckOut
//
//  Created by Cole Roberts on 6/26/24.
//

import Foundation

class Checkout: ObservableObject {
    @Published private var bannerText: String = "Willow Street Tip Out"
    @Published private var completedTasks: Int = 0
    @Published private var totalTasks: Int = 8
    @Published private var positionPicked: Bool = false
    @Published private var runnerSelected: Bool = false
    @Published private var runnerSelection: Bool = false
    @Published private var busserPicked: Bool = false
    @Published private var busserTip: Double = 0.00
    @Published private var textProgress: [[Bool]] = [[false], [false, false, false, false, false, false], [false, false, false]]
    @Published private var completed: Bool = false
    @Published private var isAServer: Bool = false
    @Published public var netSalesText: String = ""
    @Published public var foodText: String = ""
    @Published public var beerText: String = ""
    @Published public var wineText: String = ""
    @Published public var mockText: String = ""
    @Published public var liqourText: String = ""
    @Published public var doorDashText: String = ""
    @Published public var uberEatsText: String = ""
    
    init(){}
    
    public func isCompleted() -> Bool {
        return completed
    }
    
    public func getNetSales() -> Double {
        return Double(netSalesText) ?? 0.00
    }
    
    public func getFifteenPercentTip() -> Double {
        return getNetSales() * 0.15
    }
    
    public func getBusserTip() -> Double {
        return getFifteenPercentTip() * busserTip
    }
    
    public func getHostTip() -> Double {
        return getFifteenPercentTip() * 0.05
    }
    
    public func getLiqourSales() -> Double {
        return (Double(beerText) ?? 0.00) + (Double(wineText) ?? 0.00) + (Double(liqourText) ?? 0.00) + (Double(mockText) ?? 0.00)
    }
    
    public func getBartenderTip() -> Double {
        return getLiqourSales() * 0.05
    }
    
    public func getFoodSales() -> Double {
        return (Double(foodText) ?? 0.00)
    }
    
    public func getFoodTipTotal() -> Double {
        return getFoodSales() * 0.15
    }
    
    public func getRunnerTip() -> Double {
        return isServer() ? getFoodSales() * 0.08 : getTippableSales() * 0.05
    }
    
    public func getDoorDashSales() -> Double {
        return Double(doorDashText) ?? 0.00
    }
    
    public func getUberEatsSales() -> Double {
        return Double(uberEatsText) ?? 0.00
    }
    
    public func get3rdPartySales() -> Double {
        return getDoorDashSales() + getUberEatsSales()
    }
    
    public func getNetMinus3rdSales() -> Double {
        return getNetSales() - get3rdPartySales()
    }
    
    public func getTippableSales() -> Double {
        return getNetMinus3rdSales() * 0.15
    }
    
    public func getBannerText() -> String {
        return bannerText
    }
    
    public func toggleBannerProgress() {
        if completed {
            bannerText = "Tip Out Completed"
        } else {
            bannerText = "Willow Street Tip Out"
        }
    }
    
    public func getCompletionBar() -> Double {
        return Double(completedTasks) / Double(totalTasks)
    }
    
    public func returnButton() {
        if completed {
            completed = false
            toggleBannerProgress()
            return
        } else if textProgress[0][0] {
            textProgress = [[false], [false, false, false, false, false], [false, false, false]]
            netSalesText = ""
            foodText = ""
            beerText = ""
            wineText = ""
            liqourText = ""
            doorDashText = ""
            uberEatsText = ""
            mockText = ""
            toggleTextProgress()
            return
        }
        
        if isAServer {
            if busserPicked {
                busserPicked = false
                busserTip = 0.00
            } else if runnerPicked() {
                runnerSelected = false
            } else {
                positionPicked = false
            }
        } else {
            if runnerPicked() {
                runnerSelected = false
            } else {
                positionPicked = false
            }
        }
        togglePositionProgress()
        return
    }
    
    public func restartButton() {
        bannerText = "Willow Street Tip Out"
        completedTasks = 0
        totalTasks  = 8
        positionPicked = false
        runnerSelected = false
        runnerSelection = false
        busserPicked = false
        busserTip = 0.00
        textProgress = [[false], [false, false, false, false, false], [false, false, false]]
        completed = false
        isAServer = false
        netSalesText = ""
        foodText = ""
        mockText = ""
        beerText = ""
        wineText = ""
        liqourText = ""
        doorDashText = ""
        uberEatsText = ""
    }
    
    public func showPositionSelection() -> Bool {
        return !textProgress[0][0] && !completed
    }
    
    public func isProgressEnabled() -> Bool {
        return positionPicked
    }
    
    public func isServer() -> Bool {
        return isAServer && positionPicked
    }
    
    public func setPosition(choice: Bool) {
        if !choice {
            busserTip = 0.00
        }
        isAServer = choice
        positionPicked = true
        togglePositionProgress()
    }
    
    public func runnerPicked() -> Bool {
        return runnerSelected
    }
    
    public func hadRunner() -> Bool {
        return runnerSelected && runnerSelection
    }
    
    public func selectRunner(choice: Bool) {
        runnerSelection = choice
        runnerSelected = true
        togglePositionProgress()
    }
    
    public func isBusserSet(to: Double) -> Bool {
        return busserTip == to
    }
    
    public func selectTip(tip: Double) {
        busserTip = tip
        busserPicked = true
        togglePositionProgress()
    }
    
    public func showBusserSelection() -> Bool {
        return isServer() && runnerPicked()
    }
    
    public func togglePositionProgress() {
        if isAServer {
            if runnerPicked() {
                if hadRunner(){
                    totalTasks = 8
                } else {
                    totalTasks = 7
                }
            } else {
                totalTasks = 8
            }
        } else {
            totalTasks = 5
        }
        
        if !positionPicked {
            completedTasks = 0
        } else if !runnerSelected {
            completedTasks = 1
        } else {
            if !isAServer {
                completedTasks = 2
            } else {
                if !busserPicked {
                    completedTasks = 2
                } else {
                    completedTasks = 3
                }
            }
        }
        return
    }
    
    public func allowTextEntry() -> Bool {
        return runnerPicked() ? isAServer ? busserPicked : true : false
    }
    
    public func advanceToTextEntry() {
        textProgress[0][0] = true
    }
    
    public func showTextEntry() -> Bool {
        return textProgress[0][0] && !completed
    }
    
    public func toggleTextProgress() {
        var textCount = isAServer ? 3 : 2
        for x in textProgress[isAServer ? 1 : 2] {
            if x {
                textCount += 1
            }
        }
        completedTasks = textCount
        return
    }
    
    public func markAndToggleNetText(text: String) {
        if text == "" {
            textProgress[1][0] = false
            textProgress[2][0] = false
        } else if isAServer {
            textProgress[1][0] = true
        } else {
            textProgress[2][0] = true
        }
        toggleTextProgress()
    }
    
    public func markAndToggleText(text: String, position: Int, textBox: Int) {
        if text == "" {
            textProgress[position][textBox] = false
        } else {
            textProgress[position][textBox] = true
        }
        toggleTextProgress()
    }
    
    public func textContinueButton() {
        if allowCompleted() {
            toggleBannerProgress()
            completed = true
        }
    }
    
    public func allowCompleted() -> Bool {
        return totalTasks == completedTasks
    }
    
}
