#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 79001 "FIN-Audit Dept. Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1904484608;"ACA-Std Billing List")
                {
                    Caption = 'Student Bills';
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Proforma Invoice")
            {
                ApplicationArea = Basic;
                Caption = 'Proforma Invoice';
                Image = "Report";
                RunObject = Report UnknownReport52017711;
            }
            action("Fee Structure")
            {
                ApplicationArea = Basic;
                Caption = 'Fee Structure';
                RunObject = Report UnknownReport39005907;
            }
            group("Finance reports")
            {
                Caption = 'Finance reports';
                action("Student Balances")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student Balances';
                    RunObject = Report "ACA-Student Balances";
                }
                action("Statement 1")
                {
                    ApplicationArea = Basic;
                    Caption = 'Statement 1';
                    RunObject = Report Statement;
                }
                action("Statement 2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Statement 2';
                    RunObject = Report "Customer Balance";
                }
                action("Stud. List With Balances")
                {
                    ApplicationArea = Basic;
                    Caption = 'Stud. List With Balances';
                    RunObject = Report "Student Balances Per Semester";
                }
                action("balances per semester")
                {
                    ApplicationArea = Basic;
                    RunObject = Report "Student Balances Per Semester";
                }
                action("Fee Collection")
                {
                    ApplicationArea = Basic;
                    Caption = 'Fee Collection';
                    RunObject = Report "Fee Collection";
                }
                action("Student Balances")
                {
                    ApplicationArea = Basic;
                    RunObject = Report "ACA-Student Balances";
                }
                action("Fee Receipt")
                {
                    ApplicationArea = Basic;
                    Caption = 'Fee Receipt';
                    RunObject = Report "Student Receipts";
                }
                action("Student List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student List';
                    RunObject = Report "stud list";
                }
            }
            group("POS Reports")
            {
                Caption = 'POS Reports';
                action("Daily Cashier Sales Report")
                {
                    ApplicationArea = Basic;
                    Caption = 'Daily Cashier Sales Report';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "POS cashier Sales Report";
                }
                action("Daily Sales Summary")
                {
                    ApplicationArea = Basic;
                    Caption = 'Daily Sales Summary';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "POS Daily Totals";
                }
                action("Sales Per Item Report")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Per Item Report';
                    Image = Report2;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "Sales Per Item Summary Two";
                }
                action(Action1000000019)
                {
                    ApplicationArea = Basic;
                    Caption = 'POS Reports';
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "POS Sales Reports";
                }
            }
            group("Hostel Status Summary Reports")
            {
                Caption = 'Hostel Status Summary Reports';
                action(Action1000000021)
                {
                    ApplicationArea = Basic;
                    Caption = 'Hostel Status Summary Reports';
                    Image = AdjustEntries;
                    RunObject = Report "Hostel Status Summary Report";
                }
            }
            group("Student Clearance Reports")
            {
                Caption = 'Student Clearance Reports';
                action("Clearance Reports")
                {
                    ApplicationArea = Basic;
                    Caption = 'Clearance Reports';
                    Image = Answers;
                    RunObject = Report "ACA-Student Clearance List";
                }
            }
            group("Hostel Detailed Allocations Reports")
            {
                Caption = 'Hostel Detailed Allocations Reports';
                action(Action1000000023)
                {
                    ApplicationArea = Basic;
                    Caption = 'Hostel Detailed Allocations Reports';
                    Image = AddToHome;
                    RunObject = Report "Hostel Allo. Per Room/Block";
                }
            }
        }
        area(embedding)
        {
            action("Student Billing")
            {
                ApplicationArea = Basic;
                Caption = 'Student Billing';
                Image = UserSetup;
                RunObject = Page "ACA-Std Billing List";
            }
            action("Missing Balance Imports")
            {
                ApplicationArea = Basic;
                Caption = 'Missing Balance Imports';
                Image = Migration;
                Promoted = true;
                RunObject = Page "GEN-Journal Buffer";
            }
            action("Approval Request Entries")
            {
                ApplicationArea = Basic;
                Caption = 'Approval Request Entries';
                RunObject = Page "Approval Request Entries";
            }
            action("Programmes List")
            {
                ApplicationArea = Basic;
                Caption = 'Programmes List';
                RunObject = Page "ACA-Programmes List";
            }
            action("Students Card")
            {
                ApplicationArea = Basic;
                Caption = 'Students Card';
                RunObject = Page "ACA-All Students List";
            }
            action("Official Receipts")
            {
                ApplicationArea = Basic;
                Caption = 'Official Receipts';
                RunObject = Page "FIN-Receipts List";
            }
            action("Official Receipt")
            {
                ApplicationArea = Basic;
                Caption = 'Official Receipt';
                RunObject = Page "FIN-Receipts List";
            }
            action("Settlement Types")
            {
                ApplicationArea = Basic;
                Caption = 'Settlement Types';
                RunObject = Page "ACA-Settlement Types";
            }
            action("Payment Vouchers")
            {
                ApplicationArea = Basic;
                Caption = 'Payment Vouchers';
                RunObject = Page "FIN-Payment Vouchers";
            }
            action("Interbank Transfer")
            {
                ApplicationArea = Basic;
                Caption = 'Interbank Transfer';
                RunObject = Page "FIN-Interbank Transfer";
            }
            action(Imprest)
            {
                ApplicationArea = Basic;
                Caption = 'Imprest';
                RunObject = Page "FIN-Imprests List";
            }
        }
        area(processing)
        {
            group(Setups)
            {
                Caption = 'Setups';
                action("Charge Items")
                {
                    ApplicationArea = Basic;
                    Caption = 'Charge Items';
                    Image = Invoice;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "ACA-Charge";
                }
            }
            group("Periodic Audit Activities")
            {
                Caption = 'Periodic Audit Activities';
                action("Posted Receipts Buffer")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Receipts Buffer';
                    Image = PostedReceipts;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "ACA-Posted Receipts Buffer1";
                }
                action("Post Billings (Batch)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Billings (Batch)';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Report "Post Billing";
                    Visible = false;
                }
                action("Incomplete Student Charges")
                {
                    ApplicationArea = Basic;
                    Caption = 'Incomplete Student Charges';
                    RunObject = Report "Incomplete Student Charges";
                }
                action("Semester Registrations")
                {
                    ApplicationArea = Basic;
                    RunObject = Report registeredstudents;
                }
                action("Registered Students")
                {
                    ApplicationArea = Basic;
                    Caption = 'Registered Students';
                    Image = PostingEntries;
                    Promoted = true;
                    RunObject = Report "Norminal Roll (Cont. Students)";
                }
                action("Cashier Transactions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cashier Transactions';
                    RunObject = Report "Cashier Transactions";
                }
                action("Receipt Entries By User")
                {
                    ApplicationArea = Basic;
                    Caption = 'Receipt Entries By User';
                    RunObject = Report "Receipts Entries - By Users";
                }
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
                action("Meal Booking")
                {
                    ApplicationArea = Basic;
                    Caption = 'Meal Booking';
                    RunObject = Page "CAT-Meal Booking List";
                }
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
            group(AcadReportss)
            {
                Caption = 'Academics';
                Image = AnalysisView;
                group(AcadReports2)
                {
                    Caption = 'Academic Reports';
                    Image = AnalysisView;
                    action("CUE Report")
                    {
                        ApplicationArea = Basic;
                        Caption = 'CUE Report';
                        Image = BreakRulesList;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "CUE Report";
                    }
                    action("All Students")
                    {
                        ApplicationArea = Basic;
                        Image = Report2;
                        RunObject = Report "All Students";
                    }
                    action("Student Applications Report")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Student Applications Report';
                        Image = "Report";
                        RunObject = Report "Student Applications Report";
                    }
                    action("Norminal Roll")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Norminal Roll';
                        Image = Report2;
                        RunObject = Report "Norminal Roll (Cont. Students)";
                    }
                    action("Class List (By Stage)")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Class List (By Stage)';
                        Image = List;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "ACA-Class List (List By Stage)";
                    }
                    action("Signed Norminal Roll")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Signed Norminal Roll';
                        Image = Report2;
                        Promoted = true;
                        RunObject = Report "Signed Norminal Role";
                    }
                    action("Multiple Record")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Multiple Record';
                        Image = Report2;
                        RunObject = Report "Multiple Student Records";
                    }
                    action("Population by Programme")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Population by Programme';
                        Image = Report2;
                        RunObject = Report "Population By Programme";
                    }
                    action("Prog. Category")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Prog. Category';
                        Image = Report2;
                        RunObject = Report "Population By Prog. Category";
                    }
                    action("List By County")
                    {
                        ApplicationArea = Basic;
                        Caption = 'List By County';
                        Image = "report";
                        RunObject = Report "List By County";
                    }
                    action("Hostel Allocations")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Hostel Allocations';
                        Image = PrintCover;
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "Hostel Allocations";
                    }
                    action("Clearance report")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Clearance report';
                        Image = AllocatedCapacity;
                        Promoted = true;
                        RunObject = Report "ACA-Student Clearance List";
                    }
                }
            }
        }
    }

    var
        cust: Record Customer;
        process: Dialog;
}

