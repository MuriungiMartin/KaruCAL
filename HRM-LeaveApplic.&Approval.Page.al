#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68338 "HRM-Leave Applic. & Approval"
{
    PageType = ListPart;
    SourceTable = UnknownTable61282;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Employee No";"Employee No")
                {
                    ApplicationArea = Basic;
                }
                field(Names;Names)
                {
                    ApplicationArea = Basic;
                    Caption = 'Names';
                    Editable = false;
                }
                field("Application Code";"Application Code")
                {
                    ApplicationArea = Basic;
                }
                field("Leave Code";"Leave Code")
                {
                    ApplicationArea = Basic;
                }
                field("Days Applied";"Days Applied")
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
                field("Application Date";"Application Date")
                {
                    ApplicationArea = Basic;
                }
                field("Approved Days";"Approved Days")
                {
                    ApplicationArea = Basic;
                }
                field("Approved Start Date";"Approved Start Date")
                {
                    ApplicationArea = Basic;
                }
                field("Verified By Manager";"Verified By Manager")
                {
                    ApplicationArea = Basic;
                }
                field("Approved End Date";"Approved End Date")
                {
                    ApplicationArea = Basic;
                }
                field("Approval Date";"Approval Date")
                {
                    ApplicationArea = Basic;
                }
                field(Comments;Comments)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Employee.Reset;
        if Employee.Get("Employee No") then
        Names:=Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
    end;

    var
        Names: Text[250];
        Employee: Record UnknownRecord61188;
}

