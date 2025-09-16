#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99076 "13thSlips  Reg.Ledger List"
{
    CardPageID = "13thSlips  Ledger Card";
    Editable = true;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable99210;
    SourceTableView = where("Checked Out"=filter(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Check-in By Category")
            {
                ApplicationArea = Basic;
                Caption = 'Check-in By Category';
                Image = CreditMemo;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "FIN-Memo Report";
            }
        }
    }
}

