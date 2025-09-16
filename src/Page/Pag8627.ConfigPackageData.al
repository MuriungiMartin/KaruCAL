#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 8627 "Config. Package Data"
{
    Caption = 'Config. Package Data';
    PageType = List;
    SourceTable = "Config. Package Data";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Package Code";"Package Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code of the package that contains the data that is being created.';
                }
                field(Value;Value)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the value that has been entered for the field in the configuration package record. As needed, you can update and modify the information in this field, which you can use for comments. You can also correct the errors that are preventing the record from being part of the configuration. This is indicated when the Invalid check box is selected.';
                }
            }
        }
    }

    actions
    {
    }
}

