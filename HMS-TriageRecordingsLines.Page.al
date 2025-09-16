#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68105 "HMS-Triage Recordings Lines"
{
    PageType = ListPart;
    SourceTable = UnknownTable61605;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Test Code";"Test Code")
                {
                    ApplicationArea = Basic;
                }
                field("Test Description";"Test Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Test Date";"Test Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Test Time";"Test Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Test By";"Test By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Readings;Readings)
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
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

