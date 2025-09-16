#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69100 "HRM-Salary Increament Register"
{
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable61791;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field(names;names)
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Name';
                }
                field("Increament Month";"Increament Month")
                {
                    ApplicationArea = Basic;
                }
                field("Increament Year";"Increament Year")
                {
                    ApplicationArea = Basic;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                }
                field("Prev. Salary";"Prev. Salary")
                {
                    ApplicationArea = Basic;
                }
                field("Current Salary";"Current Salary")
                {
                    ApplicationArea = Basic;
                }
                field("Job Grade";"Job Grade")
                {
                    ApplicationArea = Basic;
                }
                field("Job Category";"Job Category")
                {
                    ApplicationArea = Basic;
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic;
                }
                field(Reversed;Reversed)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
              Clear(names);
              if emps.Get("Employee No.") then
              names:=emps."First Name"+' '+emps."Middle Name"+' '+emps."Last Name";
    end;

    var
        names: Text[250];
        emps: Record UnknownRecord61118;
}

