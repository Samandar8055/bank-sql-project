use FinalProject
-- Tasks (Bank KPIs)

select * from Merchants
select *from Merchant_Transactions

---Tasks 1

select *from Accounts
select *from Customers
select *from currency_rates

--created rates of currency 
select count(Currency), currency 
from Accounts
group by Currency

--joined 

select top 3 c.FullName, c.CustomerID, a.Balance,a.Currency,(a.Balance * cr.rate_to_usd) as USD_rate 
from Accounts a
inner join Customers c
on c.CustomerID = a.CustomerID
inner join currency_rates as cr
on cr.currency = a.Currency
order by(a.Balance* cr.rate_to_usd) desc

--Task 2
select *from Customers
select *from Loans


--group by non 
select count(c.CustomerID) as N_active_Loan, c.CustomerID
from Customers c
inner join Loans l
on c.CustomerID = l.CustomerID
group by c.CustomerID
having count(c.CustomerID) > 1;

--
select distinct CustomerID, FullName, N_active_Loans 
from (

select c.FullName, c.CustomerID,
count(c.CustomerID) over(partition by c.customerID ) as N_active_Loans
from Customers as c
inner join Loans l
on c.CustomerID = l.CustomerID) t
where N_active_Loans > 1

--Task 3

select *from Transactions
select *from Fraud_Detection
select *from Accounts
select *from currency_rates


select t.AccountID, t.TransactionType, t.amount as transfered_amount, t.Currency, cr.rate_to_usd * t.Amount as Usd_Currency,

f.risklevel, a.createddate, t.Status
from Transactions t
inner join Fraud_Detection f
on t.TransactionID = f.TransactionID
inner join  Accounts a
on a.CustomerID = f.CustomerID
inner join currency_rates cr
on cr.currency = t.Currency
--Filter
where t.TransactionType  in ('Withrawal', 'payment' , 'transfer') -- suspicous type of transactions
and t.Amount *  cr.rate_to_usd > 1000 -- hight amount transactions $1000
or t.Status = 'failed' -- failed or too many attempts
and f.RiskLevel in ('Critical','Hight') -- right level
or t.ReferenceNo in(
select ReferenceNo
from Transactions
group by ReferenceNo
having COUNT(*)>1
) -- duplicated reference numbers 


--Task 4

select *from Accounts
select *from Branches
select *from Loans

select b.BranchName, sum(l.Amount) as total_Loan_Amount_Usd
from Accounts a
inner join Branches b
on a.BranchID = b.BranchID
inner join Loans l
on l.CustomerID = a.CustomerID
group by b.BranchName 

--Task 5
select *from Transactions
select *from currency_rates

select t.AccountID, t.Amount, t.currency, cr.rate_to_usd * t.Amount as usd, t.Date
from Transactions t
inner join currency_rates cr
on cr.currency = t.Currency
where cr.rate_to_usd * t.Amount > 10000


--final code
with tx_usd as (
    select t.accountid, t.transactionid, t.date, cr.rate_to_usd * t.amount as usd
    from transactions t
    inner join currency_rates cr
        on t.currency = cr.currency
    where cr.rate_to_usd * t.amount > 10000
)
select t1.accountid, t1.usd, t1.date as date1, t2.date as date2
from tx_usd t1
inner join tx_usd t2
    on t1.accountid = t2.accountid
    and t1.transactionid < t2.transactionid
where datediff(minute, t1.date, t2.date) < 60


-- Task 6 Additional tasks
--Policies with more then one active (pending) claim
select *from Insurance_Policies
select *from Claims

select p.PolicyID, count(c.ClaimAmount) as ActiveClaim
from Insurance_Policies as p
inner join Claims c
on c.PolicyID = p.PolicyID
where c.Status ='open'
group by p.PolicyID
having count(c.ClaimID)> 1

---Task 7 
--Total Premium revenue by insurance type(current moth)
select InsuranceType, sum(PremiumAmount) as Total_Premuim
from Insurance_Policies
group by InsuranceType

--Task 8 Loan and credit - additional tasks 
-- Identify loan that are overdue

select *from Loans

select CustomerID, StartDate, EndDate, Status
from Loans
where EndDate < getdate()
and status <> 'Closed';










ALTER TABLE Customers
ADD CONSTRAINT PK_Customers PRIMARY KEY (CustomerID);


SELECT * 
FROM Customers
WHERE CustomerID IS NULL;


ALTER TABLE Customers
ALTER COLUMN CustomerID INT NOT NULL;


ALTER TABLE Customers
ADD CONSTRAINT PK_Customers PRIMARY KEY (CustomerID);


--accounts
ALTER TABLE Accounts
ALTER COLUMN AccountID INT NOT NULL;

ALTER TABLE Accounts
ADD CONSTRAINT PK_Accounts PRIMARY KEY (AccountID);

--Transactions
ALTER TABLE Transactions
ALTER COLUMN TransactionID INT NOT NULL;

ALTER TABLE Transactions
ADD CONSTRAINT PK_Transactions PRIMARY KEY (TransactionID);

--branches
ALTER TABLE Branches
ALTER COLUMN BranchID INT NOT NULL;

ALTER TABLE Branches
ADD CONSTRAINT PK_Branches PRIMARY KEY (BranchID);
--employees

ALTER TABLE Employees
ALTER COLUMN EmployeeID INT NOT NULL;

ALTER TABLE Employees
ADD CONSTRAINT PK_Employees PRIMARY KEY (EmployeeID);
--creditcard
ALTER TABLE Credit_Cards
ALTER COLUMN CardID INT NOT NULL;

ALTER TABLE Credit_Cards
ADD CONSTRAINT PK_CreditCards PRIMARY KEY (CardID);

--credit_card_transations
ALTER TABLE Credit_Card_Transactions
ALTER COLUMN TransactionID INT NOT NULL;

ALTER TABLE Credit_Card_Transactions
ADD CONSTRAINT PK_CreditCardTrans PRIMARY KEY (TransactionID);

--onlinebanking users
ALTER TABLE Online_Banking_Users
ALTER COLUMN UserID INT NOT NULL;

ALTER TABLE Online_Banking_Users
ADD CONSTRAINT PK_OnlineUsers PRIMARY KEY (UserID);

--bill payments

ALTER TABLE Bill_Payments
ALTER COLUMN PaymentID INT NOT NULL;

ALTER TABLE Bill_Payments
ADD CONSTRAINT PK_BillPayments PRIMARY KEY (PaymentID);

--mobile banking transactions
ALTER TABLE Mobile_Banking_Transactions
ALTER COLUMN TransactionID INT NOT NULL;

ALTER TABLE Mobile_Banking_Transactions
ADD CONSTRAINT PK_MobileTransactions PRIMARY KEY (TransactionID);

--loans
select *from Loans
ALTER TABLE Loans
ALTER COLUMN LoanID INT NOT NULL;

ALTER TABLE Loans
ADD CONSTRAINT PK_Loans PRIMARY KEY (LoanID);

--loan payments
ALTER TABLE Loan_Payments
ALTER COLUMN PaymentID INT NOT NULL;

ALTER TABLE Loan_Payments
ADD CONSTRAINT PK_LoanPayments PRIMARY KEY (PaymentID);

--debt collection
ALTER TABLE Debt_Collection
ALTER COLUMN DebtID INT NOT NULL;

ALTER TABLE Debt_Collection
ADD CONSTRAINT PK_DebtCollection PRIMARY KEY (DebtID);

--kyc

ALTER TABLE KYC
ALTER COLUMN KYCID INT NOT NULL;

ALTER TABLE KYC
ADD CONSTRAINT PK_KYC PRIMARY KEY (KYCID);

--froud detection
ALTER TABLE Fraud_Detection
ALTER COLUMN FraudID INT NOT NULL;

ALTER TABLE Fraud_Detection
ADD CONSTRAINT PK_FraudDetection PRIMARY KEY (FraudID);

--aml
select *from AML_Cases
ALTER TABLE AML_Cases
ALTER COLUMN CaseID INT NOT NULL;

ALTER TABLE AML_cases
ADD CONSTRAINT PK_AML PRIMARY KEY (CaseID);

--Regulatory_Reports
ALTER TABLE Regulatory_Reports
ALTER COLUMN ReportID INT NOT NULL;

ALTER TABLE Regulatory_Reports
ADD CONSTRAINT PK_RegReports PRIMARY KEY (ReportID);

--Departments
ALTER TABLE Departments
ALTER COLUMN DepartmentID INT NOT NULL;

ALTER TABLE Departments
ADD CONSTRAINT PK_Departments PRIMARY KEY (DepartmentID);

--Salaries
ALTER TABLE Salaries
ALTER COLUMN SalaryID INT NOT NULL;

ALTER TABLE Salaries
ADD CONSTRAINT PK_Salaries PRIMARY KEY (SalaryID);

--Employee_Attendance
ALTER TABLE Employee_Attendance
ALTER COLUMN AttendanceID INT NOT NULL;

ALTER TABLE Employee_Attendance
ADD CONSTRAINT PK_EmpAttendance PRIMARY KEY (AttendanceID);

--Investments
ALTER TABLE Investments
ALTER COLUMN InvestmentID INT NOT NULL;

ALTER TABLE Investments
ADD CONSTRAINT PK_Investments PRIMARY KEY (InvestmentID);

--Stock_Trading_Accounts
ALTER TABLE Stock_Trading_Accounts
ALTER COLUMN AccountID INT NOT NULL;

ALTER TABLE Stock_Trading_Accounts
ADD CONSTRAINT PK_StockTradingAcc PRIMARY KEY (AccountID);

--Foreign_Exchange
ALTER TABLE Foreign_Exchange
ALTER COLUMN FXID INT NOT NULL;

ALTER TABLE Foreign_Exchange
ADD CONSTRAINT PK_FX PRIMARY KEY (FXID);

--Insurance_Policies
ALTER TABLE Insurance_Policies
ALTER COLUMN PolicyID INT NOT NULL;

ALTER TABLE Insurance_Policies
ADD CONSTRAINT PK_InsurancePolicies PRIMARY KEY (PolicyID);

--claims
ALTER TABLE Claims
ALTER COLUMN ClaimID INT NOT NULL;

ALTER TABLE Claims
ADD CONSTRAINT PK_Claims PRIMARY KEY (ClaimID);

--
ALTER TABLE User_Access_Logs
ALTER COLUMN LogID INT NOT NULL;

ALTER TABLE User_Access_Logs
ADD CONSTRAINT PK_UserAccessLogs PRIMARY KEY (LogID);

--
ALTER TABLE Cyber_Security_Incidents
ALTER COLUMN IncidentID INT NOT NULL;

ALTER TABLE Cyber_Security_Incidents
ADD CONSTRAINT PK_CyberIncidents PRIMARY KEY (IncidentID);
--
ALTER TABLE Merchants
ALTER COLUMN MerchantID INT NOT NULL;

ALTER TABLE Merchants
ADD CONSTRAINT PK_Merchants PRIMARY KEY (MerchantID);

--
ALTER TABLE Merchant_Transactions
ALTER COLUMN TransactionID INT NOT NULL;

ALTER TABLE Merchant_Transactions
ADD CONSTRAINT PK_MerchantTrans PRIMARY KEY (TransactionID);

--fk 

-- Make sure column matches PK type and not nullable
ALTER TABLE Accounts
ALTER COLUMN CustomerID INT NOT NULL;

-- Add foreign key
ALTER TABLE Accounts
ADD CONSTRAINT FK_Accounts_Customers
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);

--
ALTER TABLE Transactions
ALTER COLUMN AccountID INT NOT NULL;

ALTER TABLE Transactions
ADD CONSTRAINT FK_Transactions_Accounts
FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID);
--
ALTER TABLE Branches
ALTER COLUMN ManagerID INT NULL; -- Manager may not exist yet

ALTER TABLE Branches
ADD CONSTRAINT FK_Branches_Employees
FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID);

--
ALTER TABLE Accounts
ALTER COLUMN BranchID INT NULL; -- optional

ALTER TABLE Accounts
ADD CONSTRAINT FK_Accounts_Branches
FOREIGN KEY (BranchID) REFERENCES Branches(BranchID);
--
ALTER TABLE Employees
ALTER COLUMN BranchID INT NOT NULL;

ALTER TABLE Employees
ADD CONSTRAINT FK_Employees_Branches
FOREIGN KEY (BranchID) REFERENCES Branches(BranchID);

--




--
ALTER TABLE Credit_Cards
ALTER COLUMN CustomerID INT NOT NULL;

ALTER TABLE Credit_Card_Transactions
ALTER COLUMN CardID INT NOT NULL;

ALTER TABLE Credit_Card_Transactions
ADD CONSTRAINT FK_CreditCardTransactions_CreditCards
FOREIGN KEY (CardID) REFERENCES Credit_Cards(CardID);

ALTER TABLE Credit_Cards
ADD CONSTRAINT FK_CreditCards_Customers
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);

--
ALTER TABLE Online_Banking_Users
ALTER COLUMN CustomerID INT NOT NULL;

ALTER TABLE Online_Banking_Users
ADD CONSTRAINT FK_OnlineBankingUsers_Customers
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);
--

-- 9️⃣ User_Access_Logs → Online_Banking_Users
ALTER TABLE User_Access_Logs
ALTER COLUMN UserID INT NOT NULL;

ALTER TABLE User_Access_Logs
ADD CONSTRAINT FK_UserAccessLogs_OnlineUsers
FOREIGN KEY (UserID) REFERENCES Online_Banking_Users(UserID);

-- 10️⃣ Bill_Payments → Customers
ALTER TABLE Bill_Payments
ALTER COLUMN CustomerID INT NOT NULL;

ALTER TABLE Bill_Payments
ADD CONSTRAINT FK_BillPayments_Customers
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);

-- 11️⃣ Mobile_Banking_Transactions → Customers
ALTER TABLE Mobile_Banking_Transactions
ALTER COLUMN CustomerID INT NOT NULL;

ALTER TABLE Mobile_Banking_Transactions
ADD CONSTRAINT FK_MobileBankingTransactions_Customers
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);

-- 12️⃣ Loans → Customers
ALTER TABLE Loans
ALTER COLUMN CustomerID INT NOT NULL;

ALTER TABLE Loans
ADD CONSTRAINT FK_Loans_Customers
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);

-- 12a️⃣ Loan_Payments → Loans
ALTER TABLE Loan_Payments
ALTER COLUMN LoanID INT NOT NULL;

ALTER TABLE Loan_Payments
ADD CONSTRAINT FK_LoanPayments_Loans
FOREIGN KEY (LoanID) REFERENCES Loans(LoanID);

--

-- 13️⃣ Credit_Scores → Customers
ALTER TABLE Credit_Scores
ALTER COLUMN CustomerID INT NOT NULL;

ALTER TABLE Credit_Scores
ADD CONSTRAINT FK_CreditScores_Customers
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);

-- 14️⃣ Debt_Collection → Customers
ALTER TABLE Debt_Collection
ALTER COLUMN CustomerID INT NOT NULL;

ALTER TABLE Debt_Collection
ADD CONSTRAINT FK_DebtCollection_Customers
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);

-- 15️⃣ KYC → Customers
ALTER TABLE KYC
ALTER COLUMN CustomerID INT NOT NULL;

ALTER TABLE KYC
ADD CONSTRAINT FK_KYC_Customers
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);

-- 16️⃣ Fraud_Detection → Customers
ALTER TABLE Fraud_Detection
ALTER COLUMN CustomerID INT NOT NULL;

ALTER TABLE Fraud_Detection
ADD CONSTRAINT FK_FraudDetection_Customers
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);

-- 17️⃣ AML → Customers
ALTER TABLE AML_cases
ALTER COLUMN CustomerID INT NOT NULL;

ALTER TABLE AML_cases
ADD CONSTRAINT FK_AML_Customers
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);

-- 18️⃣ Regulatory_Reports → (No FK, standalone table)

-- 19️⃣ Departments → Employees (ManagerID)
ALTER TABLE Departments
ALTER COLUMN ManagerID INT NULL;

ALTER TABLE Departments
ADD CONSTRAINT FK_Departments_Employees
FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID);

-- 20️⃣ Salaries → Employees
ALTER TABLE Salaries
ALTER COLUMN EmployeeID INT NOT NULL;

ALTER TABLE Salaries
ADD CONSTRAINT FK_Salaries_Employees
FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID);

-- 21️⃣ Employee_Attendance → Employees
ALTER TABLE Employee_Attendance
ALTER COLUMN EmployeeID INT NOT NULL;

ALTER TABLE Employee_Attendance
ADD CONSTRAINT FK_EmployeeAttendance_Employees
FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID);

-- 22️⃣ Investments → Customers
ALTER TABLE Investments
ALTER COLUMN CustomerID INT NOT NULL;

ALTER TABLE Investments
ADD CONSTRAINT FK_Investments_Customers
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);

-- 23️⃣ Stock_Trading_Accounts → Customers
ALTER TABLE Stock_Trading_Accounts
ALTER COLUMN CustomerID INT NOT NULL;

ALTER TABLE Stock_Trading_Accounts
ADD CONSTRAINT FK_StockTradingAccounts_Customers
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);

-- 24️⃣ Foreign_Exchange → Customers
ALTER TABLE Foreign_Exchange
ALTER COLUMN CustomerID INT NOT NULL;

ALTER TABLE Foreign_Exchange
ADD CONSTRAINT FK_ForeignExchange_Customers
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);

-- 25️⃣ Insurance_Policies → Customers
ALTER TABLE Insurance_Policies
ALTER COLUMN CustomerID INT NOT NULL;

ALTER TABLE Insurance_Policies
ADD CONSTRAINT FK_InsurancePolicies_Customers
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);

-- 26️⃣ Claims → Insurance_Policies
ALTER TABLE Claims
ALTER COLUMN PolicyID INT NOT NULL;

ALTER TABLE Claims
ADD CONSTRAINT FK_Claims_InsurancePolicies
FOREIGN KEY (PolicyID) REFERENCES Insurance_Policies(PolicyID);


ALTER TABLE Merchant_Transactions
ALTER COLUMN MerchantID INT NOT NULL;

ALTER TABLE Merchant_Transactions
ADD CONSTRAINT FK_MerchantTransactions_Merchants
FOREIGN KEY (MerchantID) REFERENCES Merchants(MerchantID);





