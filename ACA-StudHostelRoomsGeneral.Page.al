#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68204 "ACA-Stud Hostel Rooms General"
{
    PageType = ListPart;
    SourceTable = "ACA-Students Hostel Rooms";
    SourceTableView = where(Billed=const(true));

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Space No";"Space No")
                {
                    ApplicationArea = Basic;
                    Editable = false;

                    trigger OnValidate()
                    begin
                           HostelLedger.Reset;
                           HostelLedger.SetRange(HostelLedger."Space No","Space No");
                           if  HostelLedger.Find('-') then
                           begin
                              "Room No":=HostelLedger."Room No";
                              "Hostel No":=HostelLedger."Hostel No";
                              "Accomodation Fee":=HostelLedger."Room Cost";
                              "Allocation Date":=Today;
                           end;
                    end;
                }
                field("Room No";"Room No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Hostel No";"Hostel No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Accomodation Fee";"Accomodation Fee")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Book Room")
            {
                ApplicationArea = Basic;
            }
            separator(Action2)
            {
            }
            action("Print Agreement")
            {
                ApplicationArea = Basic;
                Caption = 'Print Agreement';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                       Creg.Reset;
                       Creg.SetFilter(Creg."Student No.",Student);
                       Creg.SetFilter(Creg.Semester,Semester);
                       if Creg.Find('-') then
                       Report.Run(39005953,true,true,Creg);
                end;
            }
        }
    }

    var
        HostelLedger: Record "ACA-Hostel Ledger";
        StudentCharges: Record UnknownRecord61535;
        PaidAmt: Decimal;
        ChargesRec: Record UnknownRecord61515;
        Cust: Record Customer;
        GenSetup: Record UnknownRecord61534;
        Creg: Record UnknownRecord61532;
        Sem: Record UnknownRecord61692;
        Registered: Boolean;
}

