#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69168 "ACA-Std Hostel Rooms Clear"
{
    PageType = ListPart;
    SourceTable = "ACA-Students Hostel Rooms";

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field("Hostel No";"Hostel No")
                {
                    ApplicationArea = Basic;
                }
                field("Room No";"Room No")
                {
                    ApplicationArea = Basic;
                }
                field("Space No";"Space No")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                           HostelLedger.Reset;
                           HostelLedger.SetRange(HostelLedger."Space No","Space No");
                           if  HostelLedger.Find('-') then
                           begin
                              if HostelLedger.Status<>HostelLedger.Status::Vaccant then Error('Please note that you can only select from vacant spaces');
                              "Room No":=HostelLedger."Room No";
                              "Hostel No":=HostelLedger."Hostel No";
                              "Accomodation Fee":=HostelLedger."Room Cost";
                              "Allocation Date":=Today;
                           end;
                           Sem.Reset;
                           Sem.SetRange(Sem."Current Semester",true);
                           if Sem.Find('-') then
                           Semester:=Sem.Code
                           else Error('Please Select the semester');

                          Registered:=false;
                          Creg.Reset;
                          Creg.SetRange(Creg."Student No.",Student);
                          Creg.SetRange(Creg.Semester,Sem.Code);
                         // Creg.SETRANGE(Creg.Posted,TRUE);
                          if Creg.Find('-') then
                          Registered:=Creg.Registered;

                           GenSetup.Get;
                           if GenSetup."Allow UnPaid Hostel Booking"=false then begin
                           // Check if he has a fee balance
                           if Cust.Get(Student) then begin
                           Cust.CalcFields(Cust.Balance);
                           if (Cust.Balance>1) and (Registered=false) then Error('Please Note that you must first clear your balance');
                           end;

                           //Calculate Paid Accomodation Fee
                           PaidAmt:=0;
                           StudentCharges.Reset;
                           StudentCharges.SetRange(StudentCharges."Student No.",Student);
                           StudentCharges.SetRange(StudentCharges.Semester,Semester);
                           StudentCharges.SetRange(StudentCharges.Recognized,true);
                           StudentCharges.SetFilter(StudentCharges.Code,'%1','ACC*');
                           if StudentCharges.Find('-') then begin
                            repeat
                               PaidAmt:=PaidAmt+StudentCharges.Amount;
                            until StudentCharges.Next=0;
                           end;
                           if PaidAmt>"Accomodation Fee" then begin
                               "Over Paid":=true;
                               "Over Paid Amt":=PaidAmt-"Accomodation Fee";
                            end else begin
                             if PaidAmt<"Accomodation Fee" then begin
                              if ((Cust.Balance * -1)<"Accomodation Fee") and (Registered=false) then // Checking if over paid fee can pay accomodation
                              Error('Accomodation Fee Paid Can Not Book This Room The Paid Amount is '+Format((Cust.Balance*-1)))
                             end else begin
                               "Over Paid":=false;
                               "Over Paid Amt":=0;
                             end;
                           end;
                          end;
                    end;
                }
                field("Accomodation Fee";"Accomodation Fee")
                {
                    ApplicationArea = Basic;
                }
                field("Allocation Date";"Allocation Date")
                {
                    ApplicationArea = Basic;
                }
                field(Charges;Charges)
                {
                    ApplicationArea = Basic;
                }
                field(Cleared;Cleared)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Print Agreement")
            {
                ApplicationArea = Basic;
                Caption = 'Print Agreement';
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

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


    procedure "Book Room"()
    begin

           StudentCharges.SetRange(StudentCharges."Student No.",Student);
           StudentCharges.SetRange(StudentCharges.Semester,Semester);
           StudentCharges.SetRange(Posted,true);
           if StudentCharges.Find('-') then begin
             ChargesRec.SetRange(ChargesRec.Code,StudentCharges.Code);
             if ChargesRec.Find('-') then begin
               PaidAmt:=ChargesRec.Amount
             end;
           end;
           if PaidAmt>"Accomodation Fee" then begin
              //StudentCharges."Over Charged":=TRUE;
              //StudentCharges."Over Charged Amount":=PaidAmt-"Accomodation Fee";
             // StudentCharges.MODIFY;
               "Over Paid":=true;
               "Over Paid Amt":=PaidAmt-"Accomodation Fee";
           end else begin
             if PaidAmt<>"Accomodation Fee" then begin

              Error('Accomodation Fee Paid Can Not Book This Room The Paid Amount is '+Format(PaidAmt))
             end;
           end;
    end;
}

