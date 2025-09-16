#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69036 "HRM-Exit Processing List"
{
    CardPageID = "HRM-Emp. Exit Interviews";
    Editable = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61215;
    SourceTableView = where(Status=filter(Approved));

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field("Exit Clearance No";"Exit Clearance No")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field("Date Of Clearance";"Date Of Clearance")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Employee Name";"Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field("Interview Done By";"Clearer Name")
                {
                    ApplicationArea = Basic;
                }
                field("Nature Of Separation";"Nature Of Separation")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Date Of Leaving";"Date Of Leaving")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Re Employ In Future";"Re Employ In Future")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1102755004;Outlook)
            {
            }
            systempart(Control1102755006;Notes)
            {
            }
        }
    }

    actions
    {
    }
}

