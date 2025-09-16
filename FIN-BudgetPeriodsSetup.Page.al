#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77079 "FIN-Budget Periods Setup"
{
    PageType = List;
    SourceTable = UnknownTable77079;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Budget Name";"Budget Name")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Enabled = true;
                }
                field("Budget Start";"Budget Start")
                {
                    ApplicationArea = Basic;
                }
                field("Budget End";"Budget End")
                {
                    ApplicationArea = Basic;
                }
                field("Period ID/Quater ID";"Period ID/Quater ID")
                {
                    ApplicationArea = Basic;
                }
                field("Period/Quater Start";"Period/Quater Start")
                {
                    ApplicationArea = Basic;
                }
                field("Period/Quater End";"Period/Quater End")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

