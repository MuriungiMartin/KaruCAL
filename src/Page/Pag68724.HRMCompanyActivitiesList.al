#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68724 "HRM-Company Activities List"
{
    CardPageID = "HRM-Company Activities Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61637;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                Editable = false;
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field(Venue;Venue)
                {
                    ApplicationArea = Basic;
                }
                field(Costs;Costs)
                {
                    ApplicationArea = Basic;
                }
                field("Employee Responsible";"Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field(Closed;Closed)
                {
                    ApplicationArea = Basic;
                }
                field("Activity  Status>";"Activity Status")
                {
                    ApplicationArea = Basic;
                    Caption = 'Activity  Status';
                    Style = StrongAccent;
                    StyleExpr = true;
                }
            }
        }
        area(factboxes)
        {
            part(Control1102755004;"HRM-Company Activities Factbox")
            {
                SubPageLink = Code=field(Code);
            }
        }
    }

    actions
    {
    }
}

