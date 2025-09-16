#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50055 "Visitors Ledger History"
{
    CardPageID = "Visitors Ledger Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "General Journal Archive";
    SourceTableView = where("Checked Out"=filter(Yes));

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
    }
}

