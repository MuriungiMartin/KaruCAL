#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68597 "HMS Pharmacy List"
{
    CardPageID = "HMS Pharmacy Header";
    PageType = List;
    SourceTable = UnknownTable61423;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                field("Pharmacy No.";"Pharmacy No.")
                {
                    ApplicationArea = Basic;
                }
                field("Pharmacy Date";"Pharmacy Date")
                {
                    ApplicationArea = Basic;
                }
                field("Pharmacy Time";"Pharmacy Time")
                {
                    ApplicationArea = Basic;
                }
                field("Patient No.";"Patient No.")
                {
                    ApplicationArea = Basic;
                }
                field(Surname;Surname)
                {
                    ApplicationArea = Basic;
                }
                field("Middle Name";"Middle Name")
                {
                    ApplicationArea = Basic;
                }
                field("Employee PF No.";xRec."Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field("Issued By";"Issued By")
                {
                    ApplicationArea = Basic;
                }
                field("Doctor ID";"Doctor ID")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        GetDoctorName("Doctor ID",DoctorName);
                    end;
                }
                field("Link Type";"Link Type")
                {
                    ApplicationArea = Basic;
                }
                field("Link No.";"Link No.")
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
            action(Pharmacy)
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin
                    Report.Run(51868,true);
                end;
            }
        }
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;

    var
        Doctor: Record UnknownRecord61387;
        DoctorName: Text[30];


    procedure GetDoctorName(var DoctorID: Code[20];var DoctorName: Text[30])
    begin
        Doctor.Reset;
        DoctorName:='';
        if Doctor.Get(DoctorID) then
          begin
            //Doctor.CALCFIELDS(Doctor."Doctor's Name");
            DoctorName:=Doctor."Doctor's Name";
          end;
    end;
}

