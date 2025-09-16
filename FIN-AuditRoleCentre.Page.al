#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68716 "FIN-Audit Role Centre"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control29)
            {
                systempart(Control27;Outlook)
                {
                }
            }
            group(Control26)
            {
                part(Control25;"Approval Entries")
                {
                    Caption = 'My Approval Entries';
                }
                systempart(Control24;Links)
                {
                }
                systempart(Control23;MyNotes)
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("&G/L Trial Balance")
            {
                ApplicationArea = Basic;
                Caption = '&G/L Trial Balance';
                Image = "Report";
                RunObject = Report "Trial Balance";
            }
            action("&Bank Detail Trial Balance")
            {
                ApplicationArea = Basic;
                Caption = '&Bank Detail Trial Balance';
                Image = "Report";
                RunObject = Report "Bank Acc. - Detail Trial Bal.";
            }
            action("&Account Schedule")
            {
                ApplicationArea = Basic;
                Caption = '&Account Schedule';
                Image = "Report";
                RunObject = Report "Account Schedule";
            }
            action("Bu&dget")
            {
                ApplicationArea = Basic;
                Caption = 'Bu&dget';
                Image = "Report";
                RunObject = Report Budget;
            }
            action("Trial Bala&nce/Budget")
            {
                ApplicationArea = Basic;
                Caption = 'Trial Bala&nce/Budget';
                Image = "Report";
                RunObject = Report "Trial Balance/Budget";
            }
            action("Trial Balance by &Period")
            {
                ApplicationArea = Basic;
                Caption = 'Trial Balance by &Period';
                Image = "Report";
                RunObject = Report "Trial Balance by Period";
            }
            action("&Fiscal Year Balance")
            {
                ApplicationArea = Basic;
                Caption = '&Fiscal Year Balance';
                Image = "Report";
                RunObject = Report "Fiscal Year Balance";
            }
            action("Balance Comp. - Prev. Y&ear")
            {
                ApplicationArea = Basic;
                Caption = 'Balance Comp. - Prev. Y&ear';
                Image = "Report";
                RunObject = Report "Balance Comp. - Prev. Year";
            }
            action("&Closing Trial Balance")
            {
                ApplicationArea = Basic;
                Caption = '&Closing Trial Balance';
                Image = "Report";
                RunObject = Report "Closing Trial Balance";
            }
            separator(Action106)
            {
            }
            action("Cash Flow Date List")
            {
                ApplicationArea = Basic;
                Caption = 'Cash Flow Date List';
                Image = "Report";
                RunObject = Report "Cash Flow Date List";
            }
            separator(Action104)
            {
            }
            action("Aged Accounts &Receivable")
            {
                ApplicationArea = Basic;
                Caption = 'Aged Accounts &Receivable';
                Image = "Report";
                RunObject = Report "Aged Accounts Receivable";
            }
            action("Aged Accounts Pa&yable")
            {
                ApplicationArea = Basic;
                Caption = 'Aged Accounts Pa&yable';
                Image = "Report";
                RunObject = Report "Aged Accounts Payable";
            }
            action("Reconcile Cus&t. and Vend. Accs")
            {
                ApplicationArea = Basic;
                Caption = 'Reconcile Cus&t. and Vend. Accs';
                Image = "Report";
                RunObject = Report "Reconcile Cust. and Vend. Accs";
            }
            separator(Action100)
            {
            }
            action("&VAT Registration No. Check")
            {
                ApplicationArea = Basic;
                Caption = '&VAT Registration No. Check';
                Image = "Report";
                RunObject = Report "VAT Registration No. Check";
            }
            action("VAT E&xceptions")
            {
                ApplicationArea = Basic;
                Caption = 'VAT E&xceptions';
                Image = "Report";
                RunObject = Report "VAT Exceptions";
            }
            action("VAT &Statement")
            {
                ApplicationArea = Basic;
                Caption = 'VAT &Statement';
                Image = "Report";
                RunObject = Report "VAT Statement";
            }
            action("VAT - VIES Declaration Tax Aut&h")
            {
                ApplicationArea = Basic;
                Caption = 'VAT - VIES Declaration Tax Aut&h';
                Image = "Report";
                RunObject = Report "VAT- VIES Declaration Tax Auth";
            }
            action("VAT - VIES Declaration Dis&k")
            {
                ApplicationArea = Basic;
                Caption = 'VAT - VIES Declaration Dis&k';
                Image = "Report";
                RunObject = Report "VAT- VIES Declaration Disk";
            }
            action("EC Sales &List")
            {
                ApplicationArea = Basic;
                Caption = 'EC Sales &List';
                Image = "Report";
                RunObject = Report "EC Sales List";
            }
            separator(Action93)
            {
            }
            action("&Intrastat - Checklist")
            {
                ApplicationArea = Basic;
                Caption = '&Intrastat - Checklist';
                Image = "Report";
                RunObject = Report "Intrastat - Checklist";
            }
            action("Intrastat - For&m")
            {
                ApplicationArea = Basic;
                Caption = 'Intrastat - For&m';
                Image = "Report";
                RunObject = Report "Intrastat - Form";
            }
            separator(Action90)
            {
            }
            action("Cost Accounting P/L Statement")
            {
                ApplicationArea = Basic;
                Caption = 'Cost Accounting P/L Statement';
                Image = "Report";
                RunObject = Report "Cost Acctg. Statement";
            }
            action("CA P/L Statement per Period")
            {
                ApplicationArea = Basic;
                Caption = 'CA P/L Statement per Period';
                Image = "Report";
                RunObject = Report "Cost Acctg. Stmt. per Period";
            }
            action("CA P/L Statement with Budget")
            {
                ApplicationArea = Basic;
                Caption = 'CA P/L Statement with Budget';
                Image = "Report";
                RunObject = Report "Cost Acctg. Statement/Budget";
            }
            action("Cost Accounting Analysis")
            {
                ApplicationArea = Basic;
                Caption = 'Cost Accounting Analysis';
                Image = "Report";
                RunObject = Report "Cost Acctg. Analysis";
            }
            separator(Action85)
            {
            }
            action("Vendor - T&op 10 List")
            {
                ApplicationArea = Basic;
                Caption = 'Vendor - T&op 10 List';
                Image = "Report";
                RunObject = Report "Vendor - Top 10 List";
            }
            action("Vendor/&Item Purchases")
            {
                ApplicationArea = Basic;
                Caption = 'Vendor/&Item Purchases';
                Image = "Report";
                RunObject = Report "Vendor/Item Purchases";
            }
            separator(Action82)
            {
            }
            group(Procurement)
            {
                Caption = 'Procurement Reports';
            }
            action("Inventory - &Availability Plan")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory - &Availability Plan';
                Image = ItemAvailability;
                RunObject = Report "Inventory - Availability Plan";
            }
            action("Inventory &Purchase Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory &Purchase Orders';
                Image = "Report";
                RunObject = Report "Inventory Purchase Orders";
            }
            action("Inventory - &Vendor Purchases")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory - &Vendor Purchases';
                Image = "Report";
                RunObject = Report "Inventory - Vendor Purchases";
            }
            action("Inventory &Cost and Price List")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory &Cost and Price List';
                Image = "Report";
                RunObject = Report "Inventory Cost and Price List";
            }
            action("Purchase Quote Request Report")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Quote Request Report';
                Image = "Report";
                RunObject = Report "Purchase Quote Request Report";
            }
            action(Action75)
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Quote Request Report';
                Image = "Report";
                RunObject = Report UnknownReport39005490;
            }
            action("Local Purchase Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Local Purchase Orders';
                Image = "Report";
                RunObject = Report "Local Purchase Orders";
            }
            action("Purchase Requisition")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Requisition';
                Image = "Report";
                RunObject = Report "HR Appraisal Reports";
            }
            action("Purchase Order")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Order';
                Image = "Report";
                RunObject = Report "Purchase Order1";
            }
            group(payroll_Reports)
            {
                Caption = 'Payroll Reports';
                action("Company Payroll Master")
                {
                    ApplicationArea = Basic;
                    Caption = 'Company Payroll Master';
                    Image = CompanyInformation;
                    Promoted = true;
                    RunObject = Report "Company Payroll Summary";
                }
                action("vew payslip")
                {
                    ApplicationArea = Basic;
                    Caption = 'vew payslip';
                    RunObject = Report "Individual Payslips mst";
                }
                action("Payroll summary")
                {
                    ApplicationArea = Basic;
                    Caption = 'Payroll summary';
                    RunObject = Report "Individual Payslips mst";
                }
                action("payroll summary2")
                {
                    ApplicationArea = Basic;
                    Caption = 'payroll summary2';
                    RunObject = Report prPayrollSummary2;
                }
                action(deductions)
                {
                    ApplicationArea = Basic;
                    Caption = 'deductions';
                    RunObject = Report "prDeductions Report";
                }
                action("Staff pension")
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff pension';
                    RunObject = Report "Staff Pension Report";
                }
                action("Gross Netpay")
                {
                    ApplicationArea = Basic;
                    Caption = 'Gross Netpay';
                    RunObject = Report prGrossNetPay;
                }
                action("Third Rule")
                {
                    ApplicationArea = Basic;
                    Caption = 'Third Rule';
                    RunObject = Report "A third Rule Report";
                }
                action("Co_op Remittance")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co_op Remittance';
                    RunObject = Report "prCoop remmitance";
                }
                action(Transactions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transactions';
                    RunObject = Report "pr Transactions";
                }
                action("bank Schedule")
                {
                    ApplicationArea = Basic;
                    Caption = 'bank Schedule';
                    RunObject = Report "pr Bank Schedule";
                }
                action(Action59)
                {
                    ApplicationArea = Basic;
                    Caption = 'vew payslip';
                    Image = "report";
                    Promoted = true;
                    RunObject = Report "Individual Payslips mst";
                }
                action(Action58)
                {
                    ApplicationArea = Basic;
                    Caption = 'Payroll summary';
                    Image = payslip;
                    RunObject = Report "Individual Payslips mst";
                }
                action(Action57)
                {
                    ApplicationArea = Basic;
                    Caption = 'payroll summary2';
                    Image = summary;
                    RunObject = Report prPayrollSummary2;
                }
                action(Action56)
                {
                    ApplicationArea = Basic;
                    Caption = 'deductions';
                    Image = DepositSlip;
                    RunObject = Report "prDeductions Report";
                }
                action(Action55)
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff pension';
                    Image = Aging;
                    RunObject = Report "Staff Pension Report";
                }
                action(Action54)
                {
                    ApplicationArea = Basic;
                    Caption = 'Gross Netpay';
                    Image = Giro;
                    RunObject = Report prGrossNetPay;
                }
                action(Action53)
                {
                    ApplicationArea = Basic;
                    Caption = 'Third Rule';
                    Image = AddWatch;
                    RunObject = Report "A third Rule Report";
                }
                action(Action52)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co_op Remittance';
                    Image = CreateForm;
                    RunObject = Report "prCoop remmitance";
                }
                separator(Action51)
                {
                    Caption = 'setup finance';
                }
                action("receipt type")
                {
                    ApplicationArea = Basic;
                    Caption = 'receipt type';
                    Image = ServiceSetup;
                    RunObject = Page "FIN-Receipt Types";
                }
                action(Action49)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transactions';
                    RunObject = Report "pr Transactions";
                }
                action(Action48)
                {
                    ApplicationArea = Basic;
                    Caption = 'bank Schedule';
                    RunObject = Report "pr Bank Schedule";
                }
                separator(Action43)
                {
                }
                action("Paye Scheule")
                {
                    ApplicationArea = Basic;
                    Caption = 'Paye Scheule';
                    RunObject = Report "prPaye Schedule mst";
                }
                action("Employer Certificate")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employer Certificate';
                    RunObject = Report "Employer Certificate P.10 mst";
                }
                action("P.10")
                {
                    ApplicationArea = Basic;
                    Caption = 'P.10';
                    RunObject = Report "P.10 A mst";
                }
                action(NSSF)
                {
                    ApplicationArea = Basic;
                    Caption = 'NSSF';
                    Image = Replan;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Report "Pop. By Prog./Gender/Settl.";
                }
                action(PAYE)
                {
                    ApplicationArea = Basic;
                    Caption = 'PAYE';
                    Image = Reconcile;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Report "Population By Faculty";
                }
                action(HELB)
                {
                    ApplicationArea = Basic;
                    Caption = 'HELB';
                    Image = Hierarchy;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Report UnknownReport52017866;
                }
                action(NHIF)
                {
                    ApplicationArea = Basic;
                    Caption = 'NHIF';
                    Image = RefreshText;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Report UnknownReport52017867;
                }
            }
            group(Fixed_Reports)
            {
                Caption = 'Fixed Reports';
                separator(Action18)
                {
                    Caption = 'Fixed Assets';
                }
                action("Fixed Assets List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Fixed Assets List';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Fixed Asset - List";
                }
                action("Acquisition List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Acquisition List';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Fixed Asset - Acquisition List";
                }
                action(Details)
                {
                    ApplicationArea = Basic;
                    Caption = 'Details';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Fixed Asset - Details";
                }
                action("Book Value 01")
                {
                    ApplicationArea = Basic;
                    Caption = 'Book Value 01';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Fixed Asset - Book Value 01";
                }
                action("Book Value 02")
                {
                    ApplicationArea = Basic;
                    Caption = 'Book Value 02';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Fixed Asset - Book Value 02";
                }
                action(Analysis)
                {
                    ApplicationArea = Basic;
                    Caption = 'Analysis';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Fixed Asset - Analysis";
                }
                action("Projected Value")
                {
                    ApplicationArea = Basic;
                    Caption = 'Projected Value';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Fixed Asset - Projected Value";
                }
                action("G/L Analysis")
                {
                    ApplicationArea = Basic;
                    Caption = 'G/L Analysis';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Fixed Asset - G/L Analysis";
                }
                action(Register)
                {
                    ApplicationArea = Basic;
                    Caption = 'Register';
                    Image = Confirm;
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Fixed Asset Register";
                }
            }
            group(human)
            {
                Caption = 'HR Reports';
                action("Employee List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee List';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "HR Employee List";
                }
                action("Employee Beneficiaries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Beneficiaries';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "HR Employee Beneficiaries";
                }
            }
        }
        area(sections)
        {
            group(Approvals)
            {
                Caption = 'Approvals';
                Image = Alerts;
                action("Pending My Approval")
                {
                    ApplicationArea = Basic;
                    Caption = 'Pending My Approval';
                    RunObject = Page "Approval Entries";
                }
                action("My Approval requests")
                {
                    ApplicationArea = Basic;
                    Caption = 'My Approval requests';
                    RunObject = Page "Approval Request Entries";
                }
                action("Clearance Requests")
                {
                    ApplicationArea = Basic;
                    Caption = 'Clearance Requests';
                    RunObject = Page "ACA-Clearance Approval Entries";
                }
            }
            group(Billing)
            {
                Caption = 'Student Billing';
                Image = LotInfo;
                action(Action1000000015)
                {
                    ApplicationArea = Basic;
                    Caption = 'Billing';
                    RunObject = Page "ACA-Std Billing List";
                }
            }
            group("Cash Management")
            {
                Caption = 'Cash Management';
                Image = LotInfo;
                action("Bank Account")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bank Account';
                    RunObject = Page "Bank Account List";
                }
            }
            group(Common_req)
            {
                Caption = 'Common Requisitions';
                Image = LotInfo;
                action("Stores Requisitions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Stores Requisitions';
                    RunObject = Page "PROC-Store Requisition";
                }
                action("Imprest Requisitions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Imprest Requisitions';
                    RunObject = Page "FIN-Imprest List UP";
                }
                action("Leave Applications")
                {
                    ApplicationArea = Basic;
                    Caption = 'Leave Applications';
                    RunObject = Page "HRM-Leave Requisition List";
                }
                action("My Approved Leaves")
                {
                    ApplicationArea = Basic;
                    Caption = 'My Approved Leaves';
                    Image = History;
                    RunObject = Page "HRM-My Approved Leaves List";
                }
                action("File Requisitions")
                {
                    ApplicationArea = Basic;
                    Image = Register;
                    Promoted = true;
                    RunObject = Page "REG-File Requisition List";
                }
                action("Meal Booking")
                {
                    ApplicationArea = Basic;
                    Caption = 'Meal Booking';
                    RunObject = Page "CAT-Meal Booking List";
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                separator(Action36)
                {
                    Caption = 'LPOs';
                }
                action("Posted Purchase Receipts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page "Posted Purchase Receipts";
                }
                action("Posted Purchase Invoices")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                }
                action("Posted Return Shipments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Return Shipments';
                    RunObject = Page "Posted Return Shipments";
                }
                action("Posted Purchase Credit Memos")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Purchase Credit Memos';
                    RunObject = Page "Posted Purchase Credit Memos";
                }
                action("Posted Assembly Orders")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Assembly Orders';
                    RunObject = Page "Posted Assembly Orders";
                }
                separator(Action42)
                {
                    Caption = 'Finance';
                }
                action(Store_Req)
                {
                    ApplicationArea = Basic;
                    Caption = 'Stores Requisitions';
                    RunObject = Page "PROC-Posted Store Reqs";
                }
                action(_Int_bank_trans)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Interbank transfers';
                    RunObject = Page "FIN-Posted Interbank Trans.";
                }
                action("Cancelled inter_Bank")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Receipts';
                    RunObject = Page "FIN-Posted Receipts list";
                }
                action(Posted_PVss)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Payment Vouchers';
                    RunObject = Page "FIN-Posted Payment Vouch.";
                }
                action(department)
                {
                    ApplicationArea = Basic;
                    Caption = 'Departments';
                }
            }
        }
    }
}

