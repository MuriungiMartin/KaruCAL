#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68989 "HRM-Medical Schemes List"
{
    CardPageID = "HRM-Medical Schemes Card";
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "HRM-Medical Schemes";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Scheme No";"Scheme No")
                {
                    ApplicationArea = Basic;
                }
                field("Medical Insurer";"Medical Insurer")
                {
                    ApplicationArea = Basic;
                }
                field("Scheme Name";"Scheme Name")
                {
                    ApplicationArea = Basic;
                }
                field("Scheme Type";"Scheme Type")
                {
                    ApplicationArea = Basic;
                }
                field("In-patient limit";"In-patient limit")
                {
                    ApplicationArea = Basic;
                }
                field("Out-patient limit";"Out-patient limit")
                {
                    ApplicationArea = Basic;
                }
                field("Area Covered";"Area Covered")
                {
                    ApplicationArea = Basic;
                }
                field("Scheme Members";"Scheme Members")
                {
                    ApplicationArea = Basic;
                }
                field("Dependants Included";"Dependants Included")
                {
                    ApplicationArea = Basic;
                }
                field(Comments;Comments)
                {
                    ApplicationArea = Basic;
                }
                field("Start Date";"Start Date")
                {
                    ApplicationArea = Basic;
                }
                field("End Date";"End Date")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
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

