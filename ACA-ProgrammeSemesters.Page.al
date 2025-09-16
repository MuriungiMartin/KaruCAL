#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68750 "ACA-Programme Semesters"
{
    PageType = List;
    SourceTable = UnknownTable61525;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field(Desc;Desc)
                {
                    ApplicationArea = Basic;
                    Caption = 'Description';
                    Editable = false;
                }
                field(Current;Current)
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
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
                field("Registration Deadline";"Registration Deadline")
                {
                    ApplicationArea = Basic;
                }
                field("Marks Entry Deadline";"Marks Entry Deadline")
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
        if Sem.Get(Semester) then
        Desc:=Sem.Description
        else
        Desc:='';
    end;

    var
        Sem: Record UnknownRecord61692;
        Desc: Text[200];
}

