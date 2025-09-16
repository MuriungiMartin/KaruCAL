#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68558 "HMS-Appointment List"
{
    CardPageID = "HMS-Appointment Form Header";
    PageType = List;
    SourceTable = UnknownTable61403;
    SourceTableView = where("Treatment Status"=filter(<>Completed));

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                field("Appointment No.";"Appointment No.")
                {
                    ApplicationArea = Basic;
                }
                field("Appointment Date";"Appointment Date")
                {
                    ApplicationArea = Basic;
                }
                field("Appointment Time";"Appointment Time")
                {
                    ApplicationArea = Basic;
                }
                field("Appointment Type";"Appointment Type")
                {
                    ApplicationArea = Basic;
                }
                field("Patient Type";"Patient Type")
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
                field(Doctor;Doctor)
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
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

