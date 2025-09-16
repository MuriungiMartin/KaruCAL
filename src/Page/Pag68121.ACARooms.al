#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68121 "ACA-Rooms"
{
    PageType = Document;
    SourceTable = "ACA-Hostel Ledger";

    layout
    {
        area(content)
        {
            field("Hostel No";"Hostel No")
            {
                ApplicationArea = Basic;
                LookupPageID = "ACA-Hostel List";

                trigger OnValidate()
                begin
                      "Hostel Rec".SetRange("Hostel Rec"."Asset No","Hostel No");
                      if "Hostel Rec".Find('-')  then
                      begin
                        Hostel:="Hostel Rec".Description
                      end;
                      SetRange("Hostel No","Hostel Rec"."Asset No");

                      if SetCurrentkey("Room No") then;
                    // setrange("Hostel No","Hostel No");
                    //SETRANGE(Status,Status::Vacant);
                end;
            }
            field(Hostel;Hostel)
            {
                ApplicationArea = Basic;
                Editable = false;
                Style = Standard;
                StyleExpr = true;
            }
            repeater(Control1000000000)
            {
                field("Hostel No2";"Hostel No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Room No";"Room No")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Space No";"Space No")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Reservation Remarks";"Reservation Remarks")
                {
                    ApplicationArea = Basic;
                }
                field("Reservation UserID";"Reservation UserID")
                {
                    ApplicationArea = Basic;
                }
                field("Reservation Date";"Reservation Date")
                {
                    ApplicationArea = Basic;
                }
                field("Room Cost";"Room Cost")
                {
                    ApplicationArea = Basic;
                }
                field("Students Count";"Students Count")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    var
        Hostel: Text[30];
        "Hostel No": Code[20];
        "Hostel Rec": Record "ACA-Hostel Card";
        Programmes: Code[20];
        "Starting No": Code[20];
        "Ending No": Code[20];
        "Starting Room No": Code[20];
}

