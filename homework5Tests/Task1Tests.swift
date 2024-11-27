import XCTest
@testable import homework5

final class BankAccountTests: XCTestCase {
    func testInitialBalanceIsZero() {
        let account = BankAccount()
        XCTAssertEqual(account.balance, 0.0, "Init Balance should be 0")
        XCTAssertEqual(account.creditLimit, 10000, "Credit Limit Set")
        XCTAssertEqual(account.creditBalance, 0.0, "Credit Balance Set")
        XCTAssertEqual(account.creditLoan, 0.0, "Credit Loan Set")
        XCTAssertEqual(account.transactionHistory.count, 0, "Transaction history should be empty initially")
    }
    
    func testDeposit() {
        let account = BankAccount()
        account.deposit(amount: 100)
        XCTAssertEqual(account.balance, 100.0, "Balance should be 100 after deposit")
    }
    
    func testNegativeDeposit() {
        let account = BankAccount()
        account.deposit(amount: -100)
        XCTAssertEqual(account.balance, 0.0, "Balance still should be 0")
    }
    
    func testWithdraw() {
        let account = BankAccount()
        account.deposit(amount: 100)
        let success = account.withdraw(amount: 50)
        XCTAssertTrue(success, "Withdrawal should be done")
        XCTAssertEqual(account.balance, 50.0, "Balance should become 50")
    }
    
    func testNegativeWithdraw() {
        let account = BankAccount()
        account.deposit(amount: 100)
        let success = account.withdraw(amount: -50)
        XCTAssertFalse(success, "Withdrawal shouldn't be done")
        XCTAssertEqual(account.balance, 100.0, "Balance should be 100")
    }
    
    func testTooMuchWithdraw() {
        let account = BankAccount()
        account.deposit(amount: 100)
        let success = account.withdraw(amount: 150)
        XCTAssertFalse(success, "Withdrawal shouldn't be done")
        XCTAssertEqual(account.balance, 100.0, "Balance should be 100")
    }
    
    func testTakeCredit() {
        let account = BankAccount()
        let success = account.takeCredit(amount: 5000)
        XCTAssertTrue(success, "Credit should be taken")
        XCTAssertEqual(account.creditBalance, 5000.0, "Credit balance 5000 after taking credit")
        XCTAssertEqual(account.creditLoan, 5000.0, "Credit loan equal the credit taken")
        XCTAssertEqual(account.balance, 5000.0, "Total balance equal the credit taken")
    }
    
    func testTakeTwoCredits() {
        let account = BankAccount()
        _ = account.takeCredit(amount: 5000)
        let success = account.takeCredit(amount: 6000)
        XCTAssertFalse(success, "Taking second credit should fail")
        XCTAssertEqual(account.creditBalance, 5000.0, "Credit balance doesn't change")
        XCTAssertEqual(account.creditLoan, 5000.0, "Credit loan doesn't change")
    }
    
    func testTakeCreditBeyondLimitFails() {
        let account = BankAccount()
        let success = account.takeCredit(amount: 15000)
        XCTAssertFalse(success, "Taking credit should fail")
        XCTAssertEqual(account.creditBalance, 0.0, "Credit balance doesn't change")
        XCTAssertEqual(account.creditLoan, 0.0, "Credit loan doesn't change")
    }
    
    func testPayCredit() {
        let account = BankAccount()
        _ = account.takeCredit(amount: 5000)
        let success = account.payCredit(amount: 3000)
        XCTAssertTrue(success, "Paying credit successful")
        XCTAssertEqual(account.creditLoan, 2000.0, "Credit loan 2000 after payment")
    }
    
    func testPayCreditExceedingLoanFails() {
        let account = BankAccount()
        _ = account.takeCredit(amount: 5000)
        let success = account.payCredit(amount: 6000)
        XCTAssertFalse(success, "Paying more than the credit loan should fail")
        XCTAssertEqual(account.creditLoan, 5000.0, "Credit loan don't change")
    }
    
    func testTransactionHistory() {
        let account = BankAccount()
        account.deposit(amount: 100)
        _ = account.withdraw(amount: 50)
        _ = account.takeCredit(amount: 5000)
        let history = account.getTransactionHistory()
        XCTAssertEqual(history.count, 3, "3 transactions")
        XCTAssertEqual(history[0].amount, 100, "First transaction deposit 100")
        XCTAssertEqual(history[1].amount, 50, "Second transaction withdraw 50")
        XCTAssertEqual(history[2].amount, 5000, "Third transaction credit 5000")
    }
    
}
