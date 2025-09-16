#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1621 "Office Vendor Details"
{
    Caption = 'Office Vendor Details';
    PageType = CardPart;
    SourceTable = Vendor;

    layout
    {
        area(content)
        {
            field("Balance (LCY)";"Balance (LCY)")
            {
                ApplicationArea = Basic,Suite;
                ToolTip = 'Specifies the total value of your completed purchases from the vendor in the current fiscal year. It is calculated from amounts excluding tax on all completed purchase invoices and credit memos.';
            }
            field("Balance Due (LCY)";"Balance Due (LCY)")
            {
                ApplicationArea = Basic,Suite;
                ToolTip = 'Specifies the total value of your unpaid purchases from the vendor in the current fiscal year. It is calculated from amounts excluding tax on all open purchase invoices and credit memos.';
            }
        }
    }

    actions
    {
    }
}

