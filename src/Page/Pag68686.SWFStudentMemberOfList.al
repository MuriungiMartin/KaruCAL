#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68686 "SWF-Student Member Of List"
{
    PageType = ListPart;
    SourceTable = UnknownTable61452;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                field("Date Registered";"Date Registered")
                {
                    ApplicationArea = Basic;
                }
                field(Designation;Designation)
                {
                    ApplicationArea = Basic;
                }
                field("Designation Name";"Designation Name")
                {
                    ApplicationArea = Basic;
                }
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field("Student Name";"Student Name")
                {
                    ApplicationArea = Basic;
                }
                field("Date Expired";"Date Expired")
                {
                    ApplicationArea = Basic;
                }
                field(Active;Active)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

