#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68013 "HRM-Dates"
{
    PageType = List;
    SourceTable = Date;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Period Type";"Period Type")
                {
                    ApplicationArea = Basic;
                }
                field("Period Start";"Period Start")
                {
                    ApplicationArea = Basic;
                }
                field("Period End";"Period End")
                {
                    ApplicationArea = Basic;
                }
                field("Period No.";"Period No.")
                {
                    ApplicationArea = Basic;
                }
                field("Period Name";"Period Name")
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

