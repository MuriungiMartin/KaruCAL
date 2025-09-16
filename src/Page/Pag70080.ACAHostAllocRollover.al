#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 70080 "ACA-Host. Alloc. Rollover"
{
    Caption = 'Hostel Allocation Roll-over';
    PageType = Card;
    SourceTable = "ACA-Hostel Card";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(SourceSemester;SourceSemester)
                {
                    ApplicationArea = Basic;
                    Caption = 'Source Semester';
                    TableRelation = "ACA-Semesters".Code;
                }
                field(ClearanceCutOff;ClearanceCutOff)
                {
                    ApplicationArea = Basic;
                    Caption = 'Clearance Cutoff';
                }
            }
            grid(CurrValues)
            {
                Caption = 'Current Values';
                field(CurrAcademicYear;CurrAcademicYear)
                {
                    ApplicationArea = Basic;
                    Caption = 'Current Acad. Year';
                    Editable = false;
                    Enabled = false;
                }
                field(CurrSemester;CurrSemester)
                {
                    ApplicationArea = Basic;
                    Caption = 'Current Semester';
                    Editable = false;
                    Enabled = false;
                }
                field(SourceAcademicYear;SourceAcademicYear)
                {
                    ApplicationArea = Basic;
                    Caption = 'Source Acad. Year';
                    Editable = false;
                    Enabled = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(ImpAlloc)
            {
                ApplicationArea = Basic;
                Caption = 'Import Allocations';
                Image = "Action";
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if ((CurrAcademicYear='') or (SourceAcademicYear='') or (CurrSemester='') or (SourceSemester='') or (ClearanceCutOff=0D)) then
                      Error('Specify all Parameters ');
                    if Confirm('Import Allocations?',false)=false then Error('Cancelled!');
                    GenJnl.Reset;
                    GenJnl.SetRange("Journal Template Name",'SALES');
                    GenJnl.SetRange("Journal Batch Name",'ACCOM');
                    GenJnl.DeleteAll;

                    Clear(LineNo);
                    ACAStudentsHostelRooms.Reset;
                    //Old Value
                    //ACAStudentsHostelRooms.SETRANGE("Academic Year",SourceAcademicYear);
                    ACAStudentsHostelRooms.SetRange(Semester,SourceSemester);
                    ACAStudentsHostelRooms.SetRange(Allocated,true);
                    ACAStudentsHostelRooms.SetRange(Cleared,false);
                    ACAStudentsHostelRooms.SetRange("Hostel No",Rec."Asset No");

                    //ACAStudentsHostelRooms.SETFILTER("Clearance Date",'%1..',ClearanceCutOff);
                     //     ACAStudentsHostelRooms.SETRANGE(Cleared,TRUE);
                    if ACAStudentsHostelRooms.Find('-') then begin
                      repeat
                        begin
                        custsz.Reset;
                        custsz.SetRange("No.",ACAStudentsHostelRooms.Student);
                    if custsz.Find('-') then begin
                    //Clear The Ledgers
                    ACAHostelLedger.Reset;
                    ACAHostelLedger.SetRange(Semester,SourceSemester);
                    ACAHostelLedger.SetRange("Hostel No",ACAStudentsHostelRooms."Hostel No");
                    ACAHostelLedger.SetRange("Room No",ACAStudentsHostelRooms."Room No");
                    ACAHostelLedger.SetRange("Space No",ACAStudentsHostelRooms."Space No");
                    if ACAHostelLedger.Find('-') then  begin
                      //Delete Entry
                      ACAHostelLedger.Delete;
                      end;
                        ACAStudentsHostelRooms.Cleared:=true;
                        ACAStudentsHostelRooms.Modify;
                          ACAStudentsHostelRooms2.Reset;
                          ACAStudentsHostelRooms2.SetRange(ACAStudentsHostelRooms2.Student,ACAStudentsHostelRooms.Student);
                         // ACAStudentsHostelRooms2.SETRANGE(ACAStudentsHostelRooms2."Space No",ACAStudentsHostelRooms."Space No");
                         // ACAStudentsHostelRooms2.SETRANGE(ACAStudentsHostelRooms2."Room No",ACAStudentsHostelRooms."Room No");
                        //  ACAStudentsHostelRooms2.SETRANGE(ACAStudentsHostelRooms2."Hostel No",Rec."Asset No");
                          ACAStudentsHostelRooms2.SetRange(ACAStudentsHostelRooms2.Semester,CurrSemester);
                       //   ACAStudentsHostelRooms2.SETRANGE(ACAStudentsHostelRooms2."Academic Year",CurrAcademicYear);
                          ACAStudentsHostelRooms2.SetRange(Cleared,false);
                          if not ACAStudentsHostelRooms2.Find('-') then begin
                            ACAStudentsHostelRooms2.Init;
                            ACAStudentsHostelRooms2.Student:=ACAStudentsHostelRooms.Student;
                            ACAStudentsHostelRooms2."Space No":=ACAStudentsHostelRooms."Space No";
                            ACAStudentsHostelRooms2."Room No":=ACAStudentsHostelRooms."Room No";
                            ACAStudentsHostelRooms2."Hostel No":=ACAStudentsHostelRooms."Hostel No";
                            ACAStudentsHostelRooms2."Accomodation Fee":=ACAStudentsHostelRooms."Accomodation Fee";
                            ACAStudentsHostelRooms2.Charges:=ACAStudentsHostelRooms.Charges;
                            ACAStudentsHostelRooms2.Semester:=CurrSemester;
                            ACAStudentsHostelRooms2."Hostel Assigned":=ACAStudentsHostelRooms."Hostel Assigned";
                            ACAStudentsHostelRooms2."Academic Year":=CurrAcademicYear;
                            ACAStudentsHostelRooms2.Gender:=ACAStudentsHostelRooms.Gender;
                            ACAStudentsHostelRooms2."Settlement Type":=ACAStudentsHostelRooms."Settlement Type";
                            ACAStudentsHostelRooms2."Campus Code":=ACAStudentsHostelRooms."Campus Code";
                            ACAStudentsHostelRooms2.Insert;
                            BookRoom(ACAStudentsHostelRooms."Settlement Type",ACAStudentsHostelRooms."Hostel No",ACAStudentsHostelRooms."Room No",
                            ACAStudentsHostelRooms."Space No",ACAStudentsHostelRooms.Student,CurrSemester,ACAStudentsHostelRooms.Gender,CurrAcademicYear,ACAStudentsHostelRooms.Charges);
                            end else begin
                              //IF ACAStudentsHostelRooms2.Allocated=FALSE THEN
                           // BookRoom(ACAStudentsHostelRooms."Settlement Type",ACAStudentsHostelRooms."Hostel No",ACAStudentsHostelRooms."Room No",
                           // ACAStudentsHostelRooms."Space No",ACAStudentsHostelRooms.Student,CurrSemester,ACAStudentsHostelRooms.Gender,CurrAcademicYear,ACAStudentsHostelRooms.Charges);
                              end;
                              end;
                        end;
                        until ACAStudentsHostelRooms.Next=0;
                      end;


                    GenJnl.Reset;
                    GenJnl.SetRange("Journal Template Name",'SALES');
                    GenJnl.SetRange("Journal Batch Name",'ACCOM');
                    if GenJnl.Find('-') then begin
                    Codeunit.Run(Codeunit::"Gen. Jnl.-Post Bill",GenJnl);
                    end;
                       Message('Posted Successfully');
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        ACAAcademicYear.Reset;
        ACAAcademicYear.SetRange(Current,true);
        if ACAAcademicYear.Find('-') then begin
          CurrAcademicYear:=ACAAcademicYear.Code;
          SourceAcademicYear:=ACAAcademicYear.Code;
          end;

        ACASemesters.Reset;
        ACASemesters.SetRange("Current Semester",true);
        if ACASemesters.Find('-') then begin
          CurrSemester:=ACASemesters.Code;
          end;
    end;

    var
        custsz: Record Customer;
        CurrAcademicYear: Code[20];
        SourceAcademicYear: Code[20];
        CurrSemester: Code[20];
        SourceSemester: Code[20];
        ClearanceCutOff: Date;
        ACAStudentsHostelRooms: Record "ACA-Students Hostel Rooms";
        ACAAcademicYear: Record UnknownRecord61382;
        ACASemesters: Record UnknownRecord61692;
        ACAStudentsHostelRooms2: Record "ACA-Students Hostel Rooms";
        AccPayment: Boolean;
        hostStus: Record "ACA-Students Hostel Rooms";
        charges1: Record UnknownRecord61515;
        cou: Integer;
        studRoomBlock: Record "ACA-Students Hostel Rooms";
        Blocks: Record "ACA-Hostel Card";
        coReg: Record UnknownRecord61532;
        HostelLedger: Record "ACA-Hostel Ledger";
        Sem: Record UnknownRecord61692;
        Registered: Boolean;
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
        StudentCharges: Record UnknownRecord61535;
        GenSetUp: Record UnknownRecord61534;
        Rooms_Spaces: Record UnknownRecord61824;
        Hostel_Rooms: Record "ACA-Hostel Block Rooms";
        Host_Ledger: Record "ACA-Hostel Ledger";
        counts: Integer;
        hostcard: Record "ACA-Hostel Card";
        studItemInv: Record "ACA-Std Hostel Inventory Items";
        invItems: Record "ACA-Hostel Inventory";
        Hostel_Rooms2: Record "ACA-Hostel Block Rooms";
        settlementType: Option " ",JAB,SSP,"Special Programme";
        Creg1: Record UnknownRecord61532;
        prog: Record UnknownRecord61511;
        allocations: Record "ACA-Students Hostel Rooms";
        "Settlement TypeR": Record UnknownRecord61522;
        ACAHostelLedger: Record "ACA-Hostel Ledger";


    procedure BookRoom(settle_m: Code[20];HostNos: Code[20];RoomNo: Code[20];SpaceNo: Code[20];Student: Code[20];Semester: Code[20];Gender: Option " ",Male,Female;AcadYear: Code[20];chg: Decimal)
    var
        rooms: Record "ACA-Hostel Block Rooms";
        billAmount: Decimal;
    begin
            // --------Check If More Than One Room Has Been Selected
          Clear(billAmount);
           rooms.Reset;
          rooms.SetRange(rooms."Hostel Code",HostNos);
          rooms.SetRange(rooms."Room Code",RoomNo);
          if rooms.Find('-') then begin
            if settle_m='Special Programme' then
              billAmount:=rooms."Special Programme"
            else if settle_m='KUCCPS' then
              billAmount:=rooms."JAB Fees"
            else if settle_m='PSSP' then
              billAmount:=rooms."SSP Fees";
            if billAmount=0 then billAmount:=rooms."JAB Fees";

          end;
          Cust.Reset;
          Cust.SetRange(Cust."No.",Student);
          if Cust.Find('-') then begin
          end;


           //---Check if The Student Have Paid The Accomodation Fee
           charges1.Reset;
           charges1.SetRange(charges1.Hostel,true);
           if charges1.Find('-') then begin
           end else Error('Accommodation not setup.');

           if Blocks.Get(HostNos,Cust.Gender) then begin
           end;

            Rooms_Spaces.Reset;
            Rooms_Spaces.SetRange(Rooms_Spaces."Space Code",SpaceNo);
            Rooms_Spaces.SetRange("Hostel Code",HostNos);
            Rooms_Spaces.SetRange("Room Code",RoomNo);
            if Rooms_Spaces.Find('-') then begin
              Rooms_Spaces.Status:=Rooms_Spaces.Status::"Fully Occupied";
              Rooms_Spaces.Modify;
              Clear(counts);
          // Post to  the Ledger Tables
          Host_Ledger.Reset;
          if Host_Ledger.Find('-') then counts:=Host_Ledger.Count;
          if not Host_Ledger.Get(SpaceNo,RoomNo,HostNos) then begin
          Host_Ledger.Init;
            Host_Ledger."Space No":=SpaceNo;
            Host_Ledger."Room No":=RoomNo;
            Host_Ledger."Hostel No":=HostNos;
            Host_Ledger.No:=counts;
            Host_Ledger.Status:=Host_Ledger.Status::"Fully Occupied";
            Host_Ledger."Room Cost":=chg;
            Host_Ledger."Student No":=Student;
            Host_Ledger."Receipt No":='';
            Host_Ledger.Semester:=Semester;
            Host_Ledger.Gender:= Gender;
            Host_Ledger."Hostel Name":='';
            Host_Ledger.Campus:=Cust."Global Dimension 1 Code";
            Host_Ledger."Academic Year":=AcadYear;
          Host_Ledger.Insert(true);
          end;


        Hostel_Rooms.Reset;
        Hostel_Rooms.SetRange(Hostel_Rooms."Hostel Code",HostNos);
        Hostel_Rooms.SetRange(Hostel_Rooms."Room Code",RoomNo);
        if Hostel_Rooms.Find('-') then begin
           Hostel_Rooms.CalcFields(Hostel_Rooms."Bed Spaces",Hostel_Rooms."Occupied Spaces");
           if Hostel_Rooms."Bed Spaces"=Hostel_Rooms."Occupied Spaces" then
            Hostel_Rooms.Status:=Hostel_Rooms.Status::"Fully Occupied"
           else if Hostel_Rooms."Occupied Spaces"<Hostel_Rooms."Bed Spaces" then
           Hostel_Rooms.Status:=Hostel_Rooms.Status::"Partially Occupied";
           Hostel_Rooms.Modify;
        end;
        ACAStudentsHostelRooms2.Reset;
              ACAStudentsHostelRooms2.SetRange(ACAStudentsHostelRooms2.Student,Student);
              ACAStudentsHostelRooms2.SetRange(ACAStudentsHostelRooms2."Space No",SpaceNo);
              ACAStudentsHostelRooms2.SetRange(ACAStudentsHostelRooms2."Room No",RoomNo);
              ACAStudentsHostelRooms2.SetRange(ACAStudentsHostelRooms2."Hostel No",HostNos);
              ACAStudentsHostelRooms2.SetRange(ACAStudentsHostelRooms2.Semester,Semester);
           //   ACAStudentsHostelRooms2.SETRANGE(ACAStudentsHostelRooms2."Academic Year",AcadYear);
              if ACAStudentsHostelRooms2.Find('-') then begin
              ACAStudentsHostelRooms2.Billed:=true;
              ACAStudentsHostelRooms2."Billed Date":=Today;
              ACAStudentsHostelRooms2."Allocation Date":=Today;
              ACAStudentsHostelRooms2."Allocated By":=UserId;
              ACAStudentsHostelRooms2."Time allocated":=Time;
              ACAStudentsHostelRooms2.Allocated:=true;
              ACAStudentsHostelRooms2.Modify;
              end;


            end;

        Clear(Cust);
        Cust.Reset;
        Cust.SetRange("No.",Student);
        if Cust.Find('-') then begin
         postCharge(Student,Semester,SpaceNo,chg);
          end;
           // UNTIL StudentHostel.NEXT=0;

         // END;
    end;

    local procedure postCharge(Student: Code[20];Semester: Code[20];SpaceNo: Code[20];charges2: Decimal)
    begin
        charges1.Reset;
        charges1.SetRange(charges1.Hostel,true);
        if not charges1.Find('-') then begin
          Error('The charges Setup does not have an item tagged as Hostel.');
        end;

        if Cust.Get(Student) then;



        GenSetUp.Get();

        DueDate:=StudentCharges.Date;

         if DueDate=0D then DueDate:=Today;
         LineNo:=LineNo+10;
        GenJnl.Init;
        GenJnl."Line No." := LineNo;
        GenJnl."Posting Date":=Today;
        GenJnl."Document No.":=CurrSemester+' Hostel';
        GenJnl.Validate(GenJnl."Document No.");
        GenJnl."Journal Template Name":='SALES';
        GenJnl."Journal Batch Name":='ACCOM';
        GenJnl."Account Type":=GenJnl."account type"::Customer;
        //
        // IF Cust.GET(Student) THEN BEGIN
        // IF Cust."Bill-to Customer No." <> '' THEN
        // GenJnl."Account No.":=Cust."Bill-to Customer No."
        // ELSE
        GenJnl."Account No.":=Student;
        //END;

        GenJnl.Amount:=charges2;
        GenJnl.Validate(GenJnl."Account No.");
        GenJnl.Validate(GenJnl.Amount);
        GenJnl.Description:=charges1.Description;
        GenJnl."Bal. Account Type":=GenJnl."account type"::"G/L Account";
        GenJnl."Bal. Account No.":=charges1."G/L Account";

        GenJnl.Validate(GenJnl."Bal. Account No.");
        GenJnl."Shortcut Dimension 1 Code":=Cust."Global Dimension 1 Code";
        if prog.Get(StudentCharges.Programme) then begin
        prog.TestField(prog."Department Code");
        GenJnl."Shortcut Dimension 2 Code":=prog."Department Code";
        end;

        GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
        GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
        GenJnl."Due Date":=DueDate;
        GenJnl.Validate(GenJnl."Due Date");

        GenJnl."Recovery Priority":=25;
        if GenJnl."Bal. Account No."='' then Error('Balancing Account is Missing');
        if GenJnl."Account No."='' then Error('Account is Missing');

        if GenJnl.Amount<>0 then
        GenJnl.Insert;
    end;
}

