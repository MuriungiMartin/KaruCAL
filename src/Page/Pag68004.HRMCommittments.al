#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68004 "HRM-Committments"
{
    PageType = List;
    SourceTable = UnknownTable61722;
    SourceTableView = where("Uploaded Manually"=filter(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Month Budget";"Month Budget")
                {
                    ApplicationArea = Basic;
                }
                field("Month Actual";"Month Actual")
                {
                    ApplicationArea = Basic;
                }
                field(Committed;Committed)
                {
                    ApplicationArea = Basic;
                }
                field("Committed By";"Committed By")
                {
                    ApplicationArea = Basic;
                }
                field("Committed Date";"Committed Date")
                {
                    ApplicationArea = Basic;
                }
                field("Committed Time";"Committed Time")
                {
                    ApplicationArea = Basic;
                }
                field("Committed Machine";"Committed Machine")
                {
                    ApplicationArea = Basic;
                }
                field(Cancelled;Cancelled)
                {
                    ApplicationArea = Basic;
                }
                field("Cancelled By";"Cancelled By")
                {
                    ApplicationArea = Basic;
                }
                field("Cancelled Date";"Cancelled Date")
                {
                    ApplicationArea = Basic;
                }
                field("Cancelled Time";"Cancelled Time")
                {
                    ApplicationArea = Basic;
                }
                field("Cancelled Machine";"Cancelled Machine")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 3 Code";"Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 4 Code";"Shortcut Dimension 4 Code")
                {
                    ApplicationArea = Basic;
                }
                field("G/L Account No.";"G/L Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(Budget;Budget)
                {
                    ApplicationArea = Basic;
                }
                field("Vendor/Cust No.";"Vendor/Cust No.")
                {
                    ApplicationArea = Basic;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field("EXist GL";"EXist GL")
                {
                    ApplicationArea = Basic;
                }
                field("Exist Posted Inv";"Exist Posted Inv")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Uploaded Manually";"Uploaded Manually")
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

