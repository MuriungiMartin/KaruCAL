#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68852 "ACA-Student Fin. Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control99;"ACA-Std Billing List")
                {
                    Caption = 'Student Billing';
                    Visible = true;
                }
                part(Control1902304208;"Bank Account List")
                {
                    Caption = 'Bank Account';
                }
                part(Control7;"FIN-Receipts List")
                {
                    Caption = 'Official Receipt';
                }
                part(Control22;"ACA-Charge")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Import Receipts")
            {
                ApplicationArea = Basic;
                Caption = 'Import Receipts';
                Image = ImportExport;
                RunObject = XMLport "Export Cust Ledgers";
            }
            action("Import Receipts Buffer")
            {
                ApplicationArea = Basic;
                Caption = 'Import Receipts Buffer';
                Image = Bins;
                RunObject = Page "ACA-Imported Receipts Buffer1";
            }
            action("Posted Receipts Buffer")
            {
                ApplicationArea = Basic;
                Caption = 'Posted Receipts Buffer';
                Image = PostedReceipt;
                Promoted = true;
                RunObject = Page "ACA-Posted Receipts Buffer1";
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
            action("Genereal Setup")
            {
                ApplicationArea = Basic;
                Caption = 'Genereal Setup';
                Image = GeneralPostingSetup;
                Promoted = true;
                RunObject = Page "ACA-General Set-Up";
            }
            action("General journal")
            {
                ApplicationArea = Basic;
                Caption = 'General journal';
                Image = Journal;
                RunObject = Page "General Journal";
            }
            action("Official Receipt")
            {
                ApplicationArea = Basic;
                Caption = 'Official Receipt';
                RunObject = Page "FIN-Receipts List";
            }
            action(Programmes)
            {
                ApplicationArea = Basic;
                Caption = 'Programmes';
                Image = List;
                Promoted = true;
                RunObject = Page "ACA-Programmes List";
            }
        }
        area(embedding)
        {
            action(Customers)
            {
                ApplicationArea = Basic;
                Caption = 'Customers';
                Image = Customer;
                Promoted = true;
                RunObject = Page "Customer List";
            }
            action("Student Billing")
            {
                ApplicationArea = Basic;
                Caption = 'Student Billing';
                Image = "Order";
                Promoted = true;
                RunObject = Page "ACA-Std Billing List";
            }
            action(Action21)
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
        }
        area(reporting)
        {
            group("Reports And Analysis")
            {
                Caption = 'Reports And Analysis';
                Image = Journals;
                action("Fee Structure")
                {
                    ApplicationArea = Basic;
                    Caption = 'Fee Structure';
                    Image = Balance;
                    RunObject = Report "Student Balance Per Stage";
                }
                action("Proforma Invoices")
                {
                    ApplicationArea = Basic;
                    Caption = 'Proforma Invoices';
                    Image = PrintVoucher;
                    RunObject = Report "Student Proforma Invoice";
                }
                action("Student Statements")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student Statements';
                    Image = Journals;
                    RunObject = Report "Student Fee Statement 2";
                }
                action("Payment Journals")
                {
                    ApplicationArea = Basic;
                    Caption = 'Payment Journals';
                    Image = Journals;
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type"=const(Payments),
                                        Recurring=const(false));
                }
                action("General Journals")
                {
                    ApplicationArea = Basic;
                    Caption = 'General Journals';
                    Image = Journal;
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type"=const(General),
                                        Recurring=const(false));
                }
                action("Student Billings Analysis")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student Billings Analysis';
                    Image = "Report";
                    RunObject = Report "Student Billings";
                }
                action("   Student Balances2")
                {
                    ApplicationArea = Basic;
                    Caption = '   Student Balances2';
                    RunObject = Report "ACA-Student Balances";
                }
            }
            separator(Action89)
            {
                Caption = 'History';
                IsHeader = true;
            }
            action("Navi&gate")
            {
                ApplicationArea = Basic;
                Caption = 'Navi&gate';
                Image = Navigate;
                RunObject = Page Navigate;
            }
            action("general journal")
            {
                ApplicationArea = Basic;
                Caption = 'general journal';
                Image = Journal;
                Promoted = true;
                RunObject = Page "General Journal";
            }
        }
        area(sections)
        {
            group(Basics)
            {
                Caption = 'Basics';
                action(Action20)
                {
                    ApplicationArea = Basic;
                    Caption = 'Programmes';
                    Image = List;
                    Promoted = true;
                    RunObject = Page "ACA-Programmes List";
                }
                action(Action5)
                {
                    ApplicationArea = Basic;
                    Caption = 'Customers';
                    Image = Customer;
                    Promoted = true;
                    RunObject = Page "Customer List";
                }
                action(Action6)
                {
                    ApplicationArea = Basic;
                    Caption = 'Student Billing';
                    Image = "Order";
                    Promoted = true;
                    RunObject = Page "ACA-Std Billing List";
                }
            }
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
        }
    }
}

