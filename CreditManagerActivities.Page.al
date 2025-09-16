#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 36623 "Credit Manager Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = UnknownTable36623;

    layout
    {
        area(content)
        {
            cuegroup("My Approvals")
            {
                Caption = 'My Approvals';
                field("Approvals - Sales Orders";"Approvals - Sales Orders")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Orders';
                    DrillDownPageID = "Approval Entries";
                    ToolTip = 'Specifies the number of sales orders awaiting approval.';
                }
                field("Approvals - Sales Invoices";"Approvals - Sales Invoices")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Invoices';
                    DrillDownPageID = "Approval Entries";
                    ToolTip = 'Specifies the number of sales invoices awaiting approval.';
                }
            }
            cuegroup(Customers)
            {
                Caption = 'Customers';
                field("Customers - Overdue";"Customers - Overdue")
                {
                    ApplicationArea = Basic;
                    Caption = 'Overdue';
                    DrillDownPageID = "Customer List - Collections";
                    ToolTip = 'Specifies the number of overdue customers.';
                }
                field("Customers - Blocked";"Customers - Blocked")
                {
                    ApplicationArea = Basic;
                    Caption = 'Blocked';
                    DrillDownPageID = "Customer List - Collections";
                    ToolTip = 'Specifies the number of blocked customers.';
                }
                field("Overdue Sales Invoices";"Overdue Sales Invoices")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Customer Ledger Entries";
                    ToolTip = 'Specifies the number of overdue sales invoices.';
                }
            }
            cuegroup("Sales Orders")
            {
                Caption = 'Sales Orders';
                field("Sales Orders On Hold";"Sales Orders On Hold")
                {
                    ApplicationArea = Basic;
                    Caption = 'On Hold';
                    DrillDownPageID = "Customer Order Header Status";
                    ToolTip = 'Specifies the number of sales orders that are on hold.';
                }
                field("SOs Pending Approval";"SOs Pending Approval")
                {
                    ApplicationArea = Basic;
                    Caption = 'Pending Approval';
                    DrillDownPageID = "Customer Order Header Status";
                    ToolTip = 'Specifies the number of sales orders that are pending approval.';
                }
                field("Approved Sales Orders";"Approved Sales Orders")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved';
                    DrillDownPageID = "Customer Order Header Status";
                    ToolTip = 'Specifies the number of approved sales orders.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;

        SetRange("Overdue Date Filter",0D,WorkDate - 1);
        SetRange("User Filter",UserId);
    end;
}

