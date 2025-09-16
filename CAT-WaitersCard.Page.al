#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69083 "CAT-Waiters Card"
{
    PageType = Card;
    SourceTable = UnknownTable61784;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Category;Category)
                {
                    ApplicationArea = Basic;
                }
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field(empname;emplName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Name';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
          if emp.Get("Employee No.") then begin
          emplName:=emp."First Name"+' '+emp."Middle Name"+' '+emp."Last Name";
          end;
    end;

    var
        emplName: Text[250];
        emp: Record UnknownRecord61188;
}

