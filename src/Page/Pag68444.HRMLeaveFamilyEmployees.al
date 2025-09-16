#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68444 "HRM-Leave Family Employees"
{
    PageType = ListPart;
    SourceTable = UnknownTable61330;

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
                field("Employee.""First Name"" + ' ' + Employee.""Middle Name"" + ' ' + Employee.""Last Name""";Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Names';
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

    trigger OnAfterGetRecord()
    begin
        if Employee.Get("Employee No") then
;

    var
        Employee: Record UnknownRecord61188;
}

