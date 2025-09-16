#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68126 "ACA-Hostel Reservation"
{
    PageType = Card;
    SourceTable = "ACA-Hostel Reservation Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field("Reservation Code";"Reservation Code")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Rooms Reservations")
            {
                Caption = 'Rooms Reservations';
                part(Control1102755007;"ACA-Hostel Reservation Lines")
                {
                    SubPageLink = Code=field(Code);
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Reserve Rooms")
            {
                ApplicationArea = Basic;
                Caption = 'Reserve Rooms';

                trigger OnAction()
                begin
                    if Confirm('Do you realy want to Reserve the selected rooms?') then begin
                    HostReservLines.Reset;
                    HostReservLines.SetRange(HostReservLines.Code,Code);
                    if HostReservLines.Find('-') then begin
                    repeat
                    HostLedger.Reset;
                    HostLedger.SetRange(HostLedger."Space No",HostReservLines."Space No");
                    if HostLedger.Find('-') then begin
                    HostLedger.Status:=HostLedger.Status::"Fully Occupied";
                    HostLedger."Reservation Remarks":="Reservation Code";
                    HostLedger."Reservation UserID":=UserId;
                    HostLedger."Reservation Date":=Today;
                    HostLedger.Modify;
                    end;
                    until HostReservLines.Next=0;
                    end;
                    Message('Reservation Completed Successfully');
                    end;
                end;
            }
        }
    }

    var
        HostLedger: Record "ACA-Hostel Ledger";
        HostReservLines: Record "ACA-Hostel Reservation Lines";
}

