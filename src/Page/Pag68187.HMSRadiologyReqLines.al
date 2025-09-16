#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68187 "HMS-Radiology Req. Lines"
{
    PageType = List;
    SourceTable = UnknownTable61420;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Radiology Type Code";"Radiology Type Code")
                {
                    ApplicationArea = Basic;
                }
                field("Radiology Type Name";"Radiology Type Name")
                {
                    ApplicationArea = Basic;
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                }
                field("Performed Date";"Performed Date")
                {
                    ApplicationArea = Basic;
                }
                field("Performed Time";"Performed Time")
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
                field(Completed;Completed)
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

