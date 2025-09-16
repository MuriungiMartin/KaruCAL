#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68291 "ACA-Student Posted Charges"
{
    Editable = false;
    PageType = ListPart;
    SourceTable = "Cust. Ledger Entry";
    SourceTableView = where(Amount=filter(>0));

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Remaining Amount";"Remaining Amount")
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

