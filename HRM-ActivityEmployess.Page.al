#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68148 "HRM-Activity Employess"
{
    PageType = Worksheet;
    SourceTable = UnknownTable61178;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Employee No";"Employee No")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                              Emp.Reset;
                              Emp.SetRange(Emp."No.","Employee No");
                              if Emp.Find('-') then
                              begin
                                "Full Names":=Emp."First Name"+' '+Emp."Middle Name"+' ' +Emp."Last Name"
                              end;
                    end;
                }
                field("Full Names";"Full Names")
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

    var
        Emp: Record UnknownRecord61188;
}

