#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68577 "HMS-Treatment List"
{
    CardPageID = "HMS-Treatment Form Header";
    PageType = List;
    SourceTable = UnknownTable61407;
    SourceTableView = where(Status=filter(<>Completed));

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                field("Treatment No.";"Treatment No.")
                {
                    ApplicationArea = Basic;
                }
                field("Doctor ID";"Doctor ID")
                {
                    ApplicationArea = Basic;
                }
                field("Treatment Type";"Treatment Type")
                {
                    ApplicationArea = Basic;
                }
                field("Treatment Date";"Treatment Date")
                {
                    ApplicationArea = Basic;
                }
                field("Treatment Time";"Treatment Time")
                {
                    ApplicationArea = Basic;
                }
                field("Patient No.";"Patient No.")
                {
                    ApplicationArea = Basic;
                }
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field("Relative No.";"Relative No.")
                {
                    ApplicationArea = Basic;
                }
                field("Treatment Remarks";"Treatment Remarks")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(History)
            {
                ApplicationArea = Basic;
                Caption = 'History';
                RunObject = Page "HMS-Treatment History List";
                RunPageLink = "Patient No."=field("Patient No.");
            }
        }
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

