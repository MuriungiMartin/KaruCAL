#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1531 "Workflow User Group"
{
    Caption = 'Workflow User Group';
    PageType = Document;
    SourceTable = "Workflow User Group";

    layout
    {
        area(content)
        {
            field("Code";Code)
            {
                ApplicationArea = Suite;
                ToolTip = 'Specifies the workflow user group.';
            }
            field(Description;Description)
            {
                ApplicationArea = Suite;
                ToolTip = 'Specifies the workflow user group.';
            }
            part(Control5;"Workflow User Group Members")
            {
                ApplicationArea = Suite;
                SubPageLink = "Workflow User Group Code"=field(Code);
            }
        }
    }

    actions
    {
    }
}

