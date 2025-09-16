#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50052 "Visitors Ledger List"
{
    CardPageID = "Visitors Ledger Card";
    Editable = true;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "General Journal Archive";
    SourceTableView = where("Checked Out"=filter(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Visit No.";"Visit No.")
                {
                    ApplicationArea = Basic;
                }
                field("ID No.";"ID No.")
                {
                    ApplicationArea = Basic;
                }
                field("Full Name";"Full Name")
                {
                    ApplicationArea = Basic;
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field(Email;Email)
                {
                    ApplicationArea = Basic;
                }
                field(Company;Company)
                {
                    ApplicationArea = Basic;
                }
                field("Office Station/Department";"Office Station/Department")
                {
                    ApplicationArea = Basic;
                }
                field("Department Name";"Department Name")
                {
                    ApplicationArea = Basic;
                }
                field("Signed in by";"Signed in by")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Date";"Transaction Date")
                {
                    ApplicationArea = Basic;
                }
                field("Time In";"Time In")
                {
                    ApplicationArea = Basic;
                }
                field("Time Out";"Time Out")
                {
                    ApplicationArea = Basic;
                }
                field("Signed Out By";"Signed Out By")
                {
                    ApplicationArea = Basic;
                }
                field("Checked Out";"Checked Out")
                {
                    ApplicationArea = Basic;
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                }
                field("Comment By";"Comment By")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Visitor Register")
            {
                ApplicationArea = Basic;
                Caption = 'Visitor Register';
                Image = "Report";
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "RFQ Report1";
            }
            action("Visitors By Department")
            {
                ApplicationArea = Basic;
                Caption = 'Visitors By Department';
                Image = "Report";
                Promoted = true;
                PromotedOnly = true;
                RunObject = Report "Earnings Summary 2 Ext";
            }
            action("Visitors Register Detailed")
            {
                ApplicationArea = Basic;
                Caption = 'Visitors Register Detailed';
                Image = "Report";
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "Send Email(OverDue Imprest)";
            }
        }
    }
}

