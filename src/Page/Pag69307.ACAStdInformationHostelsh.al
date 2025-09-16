#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69307 "ACA-Std Information (Hostels)h"
{
    CardPageID = "ACA-Students Hostels hst";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Customer;
    SourceTableView = where("Customer Type"=filter(Student));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic;
                }
                field("Balance (LCY)";"Balance (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Black Listed Reason";"Black Listed Reason")
                {
                    ApplicationArea = Basic;
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic;
                }
                field(City;City)
                {
                    ApplicationArea = Basic;
                }
                field(Contact;Contact)
                {
                    ApplicationArea = Basic;
                }
                field("Telex No.";"Telex No.")
                {
                    ApplicationArea = Basic;
                }
                field("Our Account No.";"Our Account No.")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
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
            action("Post Charges")
            {
                ApplicationArea = Basic;
                Caption = 'Post Charges';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                      if Confirm('Do You Really Want to Post The Room Charges') then begin
                      GenSetUp.Get();
                      if GenSetUp.Find('-') then
                      begin
                        NoSeries.Reset;
                        NoSeries.SetRange(NoSeries."Series Code",GenSetUp."Transaction Nos.");
                        if NoSeries.Find('-') then
                        begin
                          LastNo:=NoSeries."Last No. Used"
                        end;
                      end;
                      StudentHostel.Reset;
                      StudentHostel.SetRange(StudentHostel.Student,"No.");
                      StudentHostel.SetRange(StudentHostel.Billed,false) ;
                      if StudentHostel.Find('-') then
                      begin
                         repeat;
                         //message(LastNo);
                         LastNo:=IncStr(LastNo);
                         NoSeries."Last No. Used":=LastNo;
                         NoSeries.Modify;
                         StudentCharges.Init();
                         StudentCharges."Transacton ID":=LastNo;
                         StudentCharges.Validate(StudentCharges."Transacton ID");
                         StudentCharges."Student No.":="No.";
                         StudentCharges."Transaction Type":=StudentCharges."transaction type"::Charges;
                         StudentCharges.Description:='Hostel Charges '+StudentHostel."Space No";
                         StudentCharges.Amount:=StudentHostel."Accomodation Fee";
                         StudentCharges.Date:=StudentHostel."Allocation Date";
                         StudentCharges.Code:='ACC';
                         StudentCharges.Charge:=true;
                         StudentCharges.Insert(true);
                         StudentHostel.Billed:=true;
                         StudentHostel."Billed Date":=Today;
                         StudentHostel.Modify;
                         until StudentHostel.Next=0;
                      end;
                      Message('Hostel Charges Posted Successfully');
                     end;
                end;
            }
            action("Student Room")
            {
                ApplicationArea = Basic;
                Caption = 'Student Room';
                Image = List;
                Promoted = true;
                RunObject = Page "ACA-Stud. Hostel Rooms";
                RunPageLink = Student=field("No.");
                RunPageView = where(Cleared=filter(false));
            }
        }
    }

    var
        acadYear: Record UnknownRecord61382;
        semz: Record UnknownRecord61692;
        PictureExists: Boolean;
        StudentPayments: Record UnknownRecord61536;
        StudentCharge: Record UnknownRecord61535;
        GenJnl: Record "Gen. Journal Line";
        Stages: Record UnknownRecord61516;
        LineNo: Integer;
        GenJnlLine: Record "Gen. Journal Line";
        Units: Record UnknownRecord61517;
        ExamsByStage: Record UnknownRecord61526;
        ExamsByUnit: Record UnknownRecord61527;
        Charges: Record UnknownRecord61515;
        ChargesRec: Record UnknownRecord61515;
        PaidAmt: Decimal;
        Receipt: Record UnknownRecord61538;
        NoRoom: Integer;
        ReceiptItems: Record UnknownRecord61539;
        "GenSetUp.": Record UnknownRecord61534;
        StudentCharges2: Record UnknownRecord61535;
        CourseReg: Record UnknownRecord61532;
        CurrentBill: Decimal;
        GLEntry: Record "G/L Entry";
        CustLed: Record "Cust. Ledger Entry";
        BankLedg: Record "Bank Account Ledger Entry";
        DCustLedg: Record "Detailed Cust. Ledg. Entry";
        PDate: Date;
        DocNo: Code[20];
        VendLedg: Record "Vendor Ledger Entry";
        DVendLedg: Record "Detailed Vendor Ledg. Entry";
        NoSeries: Record "No. Series Line";
        VATEntry: Record "VAT Entry";
        CReg: Record UnknownRecord61532;
        StudCharges: Record UnknownRecord61535;
        CustLed2: Record "Cust. Ledger Entry";
        Receipt2: Record UnknownRecord61538;
        Cont: Boolean;
        LastNo: Code[20];
        Cust: Record Customer;
        CustPostGroup: Record "Customer Posting Group";
        window: Dialog;
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
        Receipts: Record UnknownRecord61538;
        CustLedg: Record "Cust. Ledger Entry";
        DueDate: Date;
        Sems: Record UnknownRecord61692;
        ChangeLog: Record "Change Log Entry";
        StudentHostel: Record "ACA-Students Hostel Rooms";
        StudentCharges: Record UnknownRecord61535;
        GenSetUp: Record UnknownRecord61534;
        Rooms_Spaces: Record UnknownRecord61824;
        Hostel_Rooms: Record "ACA-Hostel Block Rooms";
        Host_Ledger: Record "ACA-Hostel Ledger";
        counts: Integer;


    procedure "Book Room"()
    begin
          // --------Check If More Than One Room Has Been Selected
        
        
          StudentHostel.Reset;
          NoRoom:=0;
          StudentHostel.SetRange(StudentHostel.Student,"No.");
          StudentHostel.SetRange(StudentHostel.Billed,false);
          StudentHostel.SetFilter(StudentHostel."Space No",'<>%1','');
          if StudentHostel.Find('-') then begin
            repeat
            // Get the Hostel Name
            StudentHostel.TestField(StudentHostel.Semester);
            StudentHostel.TestField(StudentHostel."Academic Year");
            StudentHostel.TestField(StudentHostel."Space No");
            NoRoom:=NoRoom+1;
            if NoRoom>1 then begin
              Error('Please Note That You Can Not Select More Than One Room')
            end;
            // check if the room is still vacant
            Rooms_Spaces.Reset;
            Rooms_Spaces.SetRange(Rooms_Spaces."Space Code",StudentHostel."Space No");
            Rooms_Spaces.SetRange(Rooms_Spaces."Room Code",StudentHostel."Room No");
            Rooms_Spaces.SetRange(Rooms_Spaces."Hostel Code",StudentHostel."Hostel No");
            if Rooms_Spaces.Find('-') then
            if Rooms_Spaces.Status<>Rooms_Spaces.Status::Vaccant then Error('The selected room is nolonger vacant');
        
            // ----------Check If He has UnCleared Room
           StudentHostel.Reset;
           StudentHostel.SetRange(StudentHostel.Student,"No.");
           StudentHostel.SetRange(StudentHostel.Cleared,false);
           if StudentHostel.Find('-') then begin
              if StudentHostel.Count>1 then begin
                Error('Please Note That You Must First Clear Your Old Rooms Before You Book Another Room')
              end;
           end;
           //---Check if The Student Have Paid The Accomodation Fee
           StudentCharges.Reset;
           StudentCharges.SetRange(StudentCharges."Student No.",StudentHostel.Student);
           StudentCharges.SetRange(StudentCharges.Semester,StudentHostel.Semester);
           StudentCharges.SetRange(Posted,true);
           if StudentCharges.Find('-') then begin
             ChargesRec.SetRange(ChargesRec.Code,StudentCharges.Code);
             if ChargesRec.Find('-') then begin
               PaidAmt:=ChargesRec.Amount
             end;
           end;
           if PaidAmt>StudentHostel."Accomodation Fee" then begin
               StudentHostel."Over Paid":=true;
               StudentHostel."Over Paid Amt":=PaidAmt-StudentHostel."Accomodation Fee";
               StudentHostel.Modify;
          /*
           END ELSE BEGIN
             IF PaidAmt<>StudentHostel."Accomodation Fee" THEN BEGIN
        
              ERROR('Accomodation Fee Paid Can Not Book This Room The Paid Amount is '+FORMAT(PaidAmt))
             END;
             */
           end;
        
        
            Rooms_Spaces.Reset;
            Rooms_Spaces.SetRange(Rooms_Spaces."Space Code",StudentHostel."Space No");
            if Rooms_Spaces.Find('-') then begin
              Rooms_Spaces.Status:=Rooms_Spaces.Status::"Fully Occupied";
              Rooms_Spaces.Modify;
              Clear(counts);
          // Post to  the Ledger Tables
          Host_Ledger.Reset;
          if Host_Ledger.Find('-') then counts:=Host_Ledger.Count;
          Host_Ledger.Init;
            Host_Ledger."Space No":=StudentHostel."Space No";
            Host_Ledger."Room No":=StudentHostel."Room No";
            Host_Ledger."Hostel No":=StudentHostel."Hostel No";
            Host_Ledger.No:=counts;
            Host_Ledger.Status:=Host_Ledger.Status::"Fully Occupied";
            Host_Ledger."Room Cost":=StudentHostel.Charges;
            Host_Ledger."Student No":=StudentHostel.Student;
            Host_Ledger."Receipt No":='';
            Host_Ledger.Semester:=StudentHostel.Semester;
            Host_Ledger.Gender:= Gender;
            Host_Ledger."Hostel Name":='';
            Host_Ledger.Campus:="Global Dimension 1 Code";
            Host_Ledger."Academic Year":=StudentHostel."Academic Year";
          Host_Ledger.Insert(true);
        
        
        Hostel_Rooms.Reset;
        Hostel_Rooms.SetRange(Hostel_Rooms."Hostel Code",StudentHostel."Hostel No");
        Hostel_Rooms.SetRange(Hostel_Rooms."Room Code",StudentHostel."Room No");
        if Hostel_Rooms.Find('-') then begin
           Hostel_Rooms.CalcFields(Hostel_Rooms."Bed Spaces",Hostel_Rooms."Occupied Spaces");
           if Hostel_Rooms."Bed Spaces"=Hostel_Rooms."Occupied Spaces" then
            Hostel_Rooms.Status:=Hostel_Rooms.Status::"Fully Occupied"
           else if Hostel_Rooms."Occupied Spaces"<Hostel_Rooms."Bed Spaces" then
           Hostel_Rooms.Status:=Hostel_Rooms.Status::"Partially Occupied";
           Hostel_Rooms.Modify;
        end;
        
              StudentHostel.Billed:=true;
              StudentHostel."Billed Date":=Today;
              StudentHostel."Allocation Date":=Today;
              StudentHostel.Allocated:=true;
              StudentHostel.Modify;
        
        
            end;
          //  IF StudentHostel."Over Paid" THEN BEGIN
          //    PostOverPayment();
            // END;
            until StudentHostel.Next=0;
            Message('Room Booked Successfully');
          end;

    end;


    procedure PostOverPayment()
    begin
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name",'PAYMENTs');
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",'CHARGES');
        if GenJnlLine.Find('-') then begin
          GenJnlLine.DeleteAll
        end;

          StudentHostel.Reset;
          StudentHostel.SetRange(StudentHostel.Student,"No.");
          StudentHostel.SetRange(StudentHostel.Cleared,false);
          if StudentHostel.Find('-') then begin
            repeat
            StudentHostel.TestField(StudentHostel.Semester);
            StudentHostel.TestField(StudentHostel."Space No");
            //IF StudentHostel.Charges>0 THEN BEGIN
              LineNo:=LineNo+1000;
              GenJnlLine.Init;
              GenJnlLine."Journal Template Name":='PAYMENTs';
              GenJnlLine."Journal Batch Name":='CHARGES';
              GenJnlLine."Line No.":=LineNo;
              GenJnlLine."Account Type":=GenJnlLine."account type"::Customer;
              GenJnlLine."Account No.":="No.";
              GenJnlLine.Validate(GenJnlLine."Account No.");
              GenJnlLine."Posting Date":=Today;
              GenJnlLine."Document Type":=GenJnlLine."document type"::Payment;
              GenJnlLine."Document No.":=StudentHostel."Space No" +' '+ StudentHostel."Room No";
             //GenJnlLine."External Document No.":="Cheque No";
              GenJnlLine.Amount:=-StudentHostel."Over Paid Amt";
              GenJnlLine.Validate(GenJnlLine.Amount);
              GenJnlLine."Bal. Account Type":=GenJnlLine."bal. account type"::"G/L Account";
              GenJnlLine."Bal. Account No.":='300202';
              GenJnlLine.Description:=Name;
              GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
              GenJnlLine."Shortcut Dimension 1 Code":='ACADEMIC';
             //GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
             //GenJnlLine."Document No.":="Doc No";
             if GenJnlLine.Amount<>0 then
               GenJnlLine.Insert;
            //END;
            until StudentHostel.Next=0;
          end;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name",'PAYMENTs');
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",'CHARGES');
        if GenJnlLine.Find('-') then begin
           Codeunit.Run(Codeunit::"Gen. Jnl.-Post",GenJnlLine);
        end;
    end;


    procedure CheckClearence()
    begin
    end;


    procedure GetCurrentYear() currYear: Code[20]
    begin
           acadYear.Reset;
           acadYear.SetRange(acadYear.Current,true);
           if acadYear.Find('-') then begin
           currYear:=acadYear.Code;
           end;
    end;


    procedure GetCurrsEM() currsem: Code[20]
    begin
           semz.Reset;
           semz.SetRange(semz."Current Semester",true);
           if semz.Find('-') then begin
           currsem:=semz.Code;
           end;
    end;
}

