#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68791 "ACA-Std Units Exemptions"
{
    PageType = List;
    SourceTable = UnknownTable61553;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                }
                field("Register for";"Register for")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Stage;Stage)
                {
                    ApplicationArea = Basic;
                }
                field(Unit;Unit)
                {
                    ApplicationArea = Basic;
                }
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
                field("Application Date";"Application Date")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Approval Date";"Approval Date")
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
        Units.Reset;
        Units.SetRange(Units."Programme Code",Programme);
        Units.SetRange(Units."Stage Code",Stage);
        Units.SetRange(Units.Code,Unit);
        if Units.Find('-') then
        Desc:=Units.Desription
        else
        Desc:='';
    end;

    trigger OnOpenPage()
    begin
        Desc:='';
    end;

    var
        Units: Record UnknownRecord61517;
        Desc: Text[250];
}

