#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1280 "Bank Clearing Standards"
{
    Caption = 'Bank Clearing Standards';
    PageType = List;
    SourceTable = "Bank Clearing Standard";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code of the bank clearing standard that you choose in the Bank Clearing Standard field on a company, customer, or vendor bank account card.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the description of the bank clearing standard that you choose in the Bank Clearing Standard field on a company, customer, or vendor bank account card.';
                }
            }
        }
    }

    actions
    {
    }
}

