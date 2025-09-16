#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 8636 "Config. Field Mapping"
{
    Caption = 'Config. Field Mapping';
    PageType = List;
    SourceTable = "Config. Field Mapping";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Old Value";"Old Value")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the old value in the data that you want to map to new value. Usually, the value is one that is based on an option list.';
                }
                field("New Value";"New Value")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the value in the data in Microsoft Dynamics NAV to which you want to map the old value. Usually, the value is one that is in an existing option list.';
                }
            }
        }
    }

    actions
    {
    }
}

