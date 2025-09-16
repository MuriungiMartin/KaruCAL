#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1213 "Data Exchange Types"
{
    ApplicationArea = Basic;
    Caption = 'Data Exchange Types';
    PageType = List;
    SourceTable = "Data Exchange Type";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the data exchange type.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the data exchange type.';
                }
                field("Data Exch. Def. Code";"Data Exch. Def. Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the data exchange definition that the data exchange type uses.';
                }
            }
        }
    }

    actions
    {
    }
}

