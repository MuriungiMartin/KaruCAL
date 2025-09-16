#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9200 "Time Zones"
{
    Caption = 'Time Zones';
    PageType = List;
    SourceTable = "Time Zone";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ID;ID)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the ID of the time zone.';
                }
                field("Display Name";"Display Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the full name of the time zone.';
                }
            }
        }
    }

    actions
    {
    }
}

