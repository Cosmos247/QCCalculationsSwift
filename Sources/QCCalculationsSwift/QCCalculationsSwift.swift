// The Swift Programming Language
// https://docs.swift.org/swift-book

// MARK: - Bonus Calculation Functions

public func calculateCLNBonus(entries: [DataEntry]) -> (count: Int, amount: Int) {
    let clnFields = ["КЛН", "Incomplete", "Dailer", "BX", "АО ПО", "АО КЛ", "ST", "AO BX", "HL КЛН", "Видача", "Відміна", "Відмова"]
    let clnEntries = entries.filter { entry in
        guard let subDept = entry.subDepartment else { return false }
        return clnFields.contains(subDept)
    }
    let totalCount = clnEntries.compactMap { entry in
        guard let quantityString = entry.quantity else { return nil }
        return abs(Int(quantityString) ?? 0) // Use absolute value for bonus calculation
    }.reduce(0, +)
    return (count: totalCount, amount: totalCount * 6)
}

public func calculateChatsBonus(entries: [DataEntry]) -> (count: Int, amount: Int) {
    let chatsFields = ["AO/ST Chats", "HL Chats"]
    let chatsEntries = entries.filter { entry in
        guard let subDept = entry.subDepartment else { return false }
        return chatsFields.contains(subDept)
    }
    let totalCount = chatsEntries.compactMap { entry in
        guard let quantityString = entry.quantity else { return nil }
        return abs(Int(quantityString) ?? 0) // Use absolute value for bonus calculation
    }.reduce(0, +)
    return (count: totalCount, amount: totalCount * 2)
}

public func calculateNPSBonus(entries: [DataEntry]) -> (count: Int, amount: Int) {
    let npsEntries = entries.filter { entry in
        entry.subDepartment == "NPS"
    }
    let totalCount = npsEntries.compactMap { entry in
        guard let quantityString = entry.quantity else { return nil }
        return abs(Int(quantityString) ?? 0) // Use absolute value for bonus calculation
    }.reduce(0, +)
    return (count: totalCount, amount: totalCount * 3)
}

public func calculateVVRiskBonus(entries: [DataEntry]) -> (count: Int, amount: Int) {
    let vvRiskEntries = entries.filter { entry in
        entry.subDepartment == "На ризик"
    }
    let totalCount = vvRiskEntries.compactMap { entry in
        guard let quantityString = entry.quantity else { return nil }
        return abs(Int(quantityString) ?? 0) // Use absolute value for bonus calculation
    }.reduce(0, +)
    return (count: totalCount, amount: totalCount * 4)
}

public func calculateVVApprovedBonus(entries: [DataEntry]) -> (count: Int, amount: Int) {
    let vvApprovedEntries = entries.filter { entry in
        entry.subDepartment == "Ідентифікація"
    }
    let totalCount = vvApprovedEntries.compactMap { entry in
        guard let quantityString = entry.quantity else { return nil }
        return abs(Int(quantityString) ?? 0) // Use absolute value for bonus calculation
    }.reduce(0, +)
    return (count: totalCount, amount: totalCount * 7)
}

// MARK: - Statistics Calculation Functions

public func calculateMonthlyStats(entries: [DataEntry], daysInMonth: Int) -> (totalCount: Double, totalTime: Double, averageSpeed: Double) {
    let totalCount = Double(entries.compactMap { Int($0.quantity ?? "0") }.reduce(0, +))
    let totalTime = entries.compactMap { entry in
        guard let timeString = entry.timeOfCheck else { return 0.0 }
        return timeStringToHours(timeString) ?? 0.0
    }.reduce(0.0, { $0 + $1 })
    
    let averageSpeed = totalTime > 0 ? totalCount / totalTime : 0
    
    return (totalCount: totalCount, totalTime: totalTime, averageSpeed: averageSpeed)
}

public func calculateCLNStats(entries: [DataEntry]) -> (count: Int, checkTime: Double) {
    let clnFields = ["КЛН", "NPS", "Incomplete", "Dailer", "BX", "АО ПО", "АО КЛ", "ST", "AO BX", "HL КЛН", "Видача", "Відміна", "Відмова"]
    
    let clnEntries = entries.filter { entry in
        guard let subDept = entry.subDepartment else { return false }
        return clnFields.contains(subDept)
    }
    
    let totalCount = clnEntries.compactMap { entry in
        guard let quantityString = entry.quantity else { return nil }
        return Int(quantityString)
    }.reduce(0, +)
    
    let totalTime = clnEntries.compactMap { entry in
        guard let timeString = entry.timeOfCheck else { return nil }
        return timeStringToHours(timeString)
    }.reduce(0, +)
    
    return (count: totalCount, checkTime: totalTime)
}

public func calculateChatsStats(entries: [DataEntry]) -> (count: Int, checkTime: Double) {
    let chatsFields = ["AO/ST Chats", "HL Chats"]
    
    let chatsEntries = entries.filter { entry in
        guard let subDept = entry.subDepartment else { return false }
        return chatsFields.contains(subDept)
    }
    
    let totalCount = chatsEntries.compactMap { entry in
        guard let quantityString = entry.quantity else { return nil }
        return Int(quantityString)
    }.reduce(0, +)
    
    let totalTime = chatsEntries.compactMap { entry in
        guard let timeString = entry.timeOfCheck else { return nil }
        return timeStringToHours(timeString)
    }.reduce(0, +)
    
    return (count: totalCount, checkTime: totalTime)
}

public func calculateVVStats(entries: [DataEntry]) -> (count: Int, checkTime: Double) {
    let vvFields = ["На ризик", "Ідентифікація"]
    
    let vvEntries = entries.filter { entry in
        guard let subDept = entry.subDepartment else { return false }
        return vvFields.contains(subDept)
    }
    
    let totalCount = vvEntries.compactMap { entry in
        guard let quantityString = entry.quantity else { return nil }
        return Int(quantityString)
    }.reduce(0, +)
    
    let totalTime = vvEntries.compactMap { entry in
        guard let timeString = entry.timeOfCheck else { return nil }
        return timeStringToHours(timeString)
    }.reduce(0, +)
    
    return (count: totalCount, checkTime: totalTime)
}

public func formatTime(hours: Double) -> String {
    let totalMinutes = Int(hours * 60)
    let h = totalMinutes / 60
    let m = totalMinutes % 60
    return String(format: "%02d:%02d", h, m)
}

public func timeStringToHours(_ timeString: String) -> Double? {
    // Check if the time is negative
    let isNegative = timeString.hasPrefix("-")
    let timeToProcess = isNegative ? String(timeString.dropFirst()) : timeString
    
    let components = timeToProcess.split(separator: ":").compactMap { Double($0) }
    guard components.count == 3 else { return nil }
    
    let hours = components[0]
    let minutes = components[1]
    let seconds = components[2]
    
    let totalHours = hours + (minutes / 60.0) + (seconds / 3600.0)
    return isNegative ? -totalHours : totalHours
}
