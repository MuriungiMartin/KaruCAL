#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68090 "PRL-Short Listing Lines"
{
    AutoSplitKey = false;
    PageType = ListPart;
    SourceTable = UnknownTable61065;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Qualification Type";"Qualification Type")
                {
                    ApplicationArea = Basic;
                }
                field(Requirements;Requirements)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Score;Score)
                {
                    ApplicationArea = Basic;
                    Caption = 'Desired Score';
                }
                field("Desired Score";"Desired Score")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

