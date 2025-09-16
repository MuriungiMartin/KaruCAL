#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69002 "HRM-Appraisal Goal List Sup"
{
    CardPageID = "HRM-Appraisal Goal Setting (B)";
    PageType = List;
    SourceTable = UnknownTable61232;
    SourceTableView = where(Sent=const("At Supervisor"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Appraisal No";"Appraisal No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Employee No";"Employee No")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Name";"Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                }
                field(Supervisor;Supervisor)
                {
                    ApplicationArea = Basic;
                }
                field("Appraisal Type";"Appraisal Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Appraisal Period";"Appraisal Period")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field(Sent;Sent)
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

