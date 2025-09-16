#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7703 Miniforms
{
    ApplicationArea = Basic;
    Caption = 'Miniforms';
    CardPageID = Miniform;
    Editable = false;
    PageType = List;
    SourceTable = "Miniform Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a unique code for a specific miniform.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies your description of the miniform with the code on the header.';
                }
                field("No. of Records in List";"No. of Records in List")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of records that will be sent to the handheld if the miniform on the header is either Selection List or Data List.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }
}

