#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68914 "ACA-Std Finance Role Center"
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
                action("Supplementary Exams Report")
                {
                    ApplicationArea = Basic;
                    RunObject = Report "Student Supp Marks";
                }
                action("Student List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student List';
                    RunObject = Report "stud list";
                }
            }
            group("Household Reports")
            {
                Caption = 'Household Reports';
                action(Action1000000039)
                {
                    ApplicationArea = Basic;
                    Caption = 'Student List';
                    RunObject = Report "stud list";
                }
                action("<Household Reports>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Household Reports';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Report "Houshold Balances";
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
                    RunObject = Report "Hostel Allo. Per Room/Block";
                }
            }
            group("Receipts Reports")
            {
                Caption = 'Receipts Reports';
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
            action("No. Series")
            {
                ApplicationArea = Basic;
                Caption = 'No. Series';
                RunObject = Page "No. Series";
            }
            action("Approval Entries")
            {
                ApplicationArea = Basic;
                Caption = 'Approval Entries';
                RunObject = Page "Approval Entries";
            }
            action("Approval Request Entries")
            {
                ApplicationArea = Basic;
                Caption = 'Approval Request Entries';
                RunObject = Page "Approval Request Entries";
            }
            action("Reason Codes")
            {
                ApplicationArea = Basic;
                Caption = 'Reason Codes';
                RunObject = Page "ACA-Programmes List";
            }
            action("Students Card")
            {
                ApplicationArea = Basic;
                Caption = 'Students Card';
                RunObject = Page "ACA-All Students List";
            }
            action("NFM Bands Info")
            {
                ApplicationArea = Basic;
                Caption = 'NFM Bands Info';
                RunObject = Page "Fund Band Batch List";
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
                action("Master Fee Structure")
                {
                    ApplicationArea = Basic;
                    Caption = 'Master Fee Structure';
                    Image = Setup;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = Page "ACA-Master Fee Structure";
                    Visible = false;
                }
                action("Charge Items")
                {
                    ApplicationArea = Basic;
                    Caption = 'Charge Items';
                    Image = Invoice;
                    Promoted = true;
                    RunObject = Page "ACA-Charge";
                }
                action("General Set-Up")
                {
                    ApplicationArea = Basic;
                    Caption = 'General Set-Up';
                    Image = GeneralPostingSetup;
                    Promoted = true;
                    RunObject = Page "ACA-General Set-Up";
                }
                action("Academic Year")
                {
                    ApplicationArea = Basic;
                    Caption = 'Academic Year';
                    Image = Calendar;
                    Promoted = true;
                    RunObject = Page "ACA-Academic Year Card";
                }
                action(Action21)
                {
                    ApplicationArea = Basic;
                    Caption = 'General Set-Up';
                    RunObject = Page "ACA-General Set-Up";
                }
                action("Programmes List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Programmes List';
                    RunObject = Page "ACA-Programmes List";
                }
                action("general journal")
                {
                    ApplicationArea = Basic;
                    Caption = 'general journal';
                    Image = Journal;
                    RunObject = Page "General Journal";
                }
                action(Action4)
                {
                    ApplicationArea = Basic;
                    Caption = 'Academic Year';
                    RunObject = Page "ACA-Academic Year Card";
                }
            }
            group("Periodic Activities")
            {
                Caption = 'Periodic Activities';
                action("Import Receipts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Import Receipts';
                    Image = ImportExport;
                    RunObject = XMLport "Export Cust Ledgers";
                }
                action("Close Current Semester")
                {
                    ApplicationArea = Basic;
                    Caption = 'Close Current Semester';
                    Image = "Report";
                    RunObject = Report "Generate Registration";
                }
                action("Post Batch Billing")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Batch Billing';
                    Image = Report2;
                    Promoted = true;
                    RunObject = Report "Post Billing";
                }
                action("Import Bank Receipts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Import Bank Receipts';
                    Image = ImportExcel;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = XMLport "Export Cust Ledgers";
                }
                action("Imported Bank Receipts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Imported Bank Receipts';
                    Image = ReceiptLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "ACA-Imported Receipts Buffer1";
                }
                action("Posted Receipts Buffer")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Receipts Buffer';
                    Image = PostedReceipts;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "ACA-Posted Receipts Buffer1";
                }
                action("Validate Charges")
                {
                    ApplicationArea = Basic;
                    Caption = 'Validate Charges';
                    RunObject = Page "Unrecognize Charges";
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
                action("Generate Student Charges NFM")
                {
                    ApplicationArea = Basic;
                    Image = Recalculate;
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Generate Student Charges NFM";
                }
                action(Action6)
                {
                    ApplicationArea = Basic;
                    Caption = 'Close Current Semester';
                    RunObject = Report "Generate Registration";
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
                action("Meal Booking")
                {
                    ApplicationArea = Basic;
                    Caption = 'Meal Booking';
                    RunObject = Page "CAT-Meal Booking List";
                }
            }
        }
    }

    var
        cust: Record Customer;
        process: Dialog;
}

