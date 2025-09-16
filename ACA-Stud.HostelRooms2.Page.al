#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 70026 "ACA-Stud. Hostel Rooms2"
{
    PageType = ListPart;
    SourceTable = "ACA-Students Hostel Rooms";
    SourceTableView = sorting("Allocation Date")
                      order(descending);

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
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
                }
                field(Charges;Charges)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Allocated;Allocated)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Allocation Date";"Allocation Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Hostel Name";"Hostel Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Student Name";"Student Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Campus Code";"Campus Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Cleared;Cleared)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Clearance Date";"Clearance Date")
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
            action(Vacate)
            {
                ApplicationArea = Basic;
                Caption = 'Vacate';
                Image = ClearLog;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ACAHostelPermissions.PermissionMan(UserId,2);

                          if Confirm('Clear Space?',false)=true then begin
                              clearFromRoom_Clear();
                          end;
                end;
            }
            action(Allocate)
            {
                ApplicationArea = Basic;
                Caption = 'Allocate Room';
                Image = "Action";
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                Visible = true;

                trigger OnAction()
                begin

                    ACAHostelPermissions.PermissionMan(UserId,1);

                     Rooms_Spaces.Reset;
                     Rooms_Spaces.SetRange("Hostel Code",Rec."Hostel No");
                     Rooms_Spaces.SetRange("Room Code",Rec."Room No");
                     Rooms_Spaces.SetRange("Space Code",Rec."Space No");
                     if not Rooms_Spaces.Find('-') then Error('The specified spacedoes not exist.');

                     //Check the Policy
                     TestField(Allocated,false);
                     if Cust.Get(Student) then begin
                        Cust.CalcFields(Cust.Balance);
                       if "GenSetUp.".Get() then begin end;

                    semz.Reset;
                    semz.SetRange(semz."Current Semester",true);
                      CReg.Reset;
                      CReg.SetRange(CReg."Student No.",Cust."No.");
                      if semz.Find('-') then
                      CReg.SetRange(CReg.Semester,semz.Code);
                      CReg.SetRange(CReg.Posted,true);
                      if CReg.Find('-') then begin  //2
                      CReg.CalcFields(CReg."Total Billed");
                      if CReg."Total Billed"<>0 then begin  // 1
                     // IF Cust.Balance>(CReg."Total Billed"/2) THEN ERROR('Fees payment Accommodation policy error--Balance');
                      allocations.Reset;
                      allocations.SetRange(allocations.Student,Cust."No.");
                      allocations.SetRange(allocations."Hostel No",Rec."Hostel No");
                      allocations.SetRange(allocations."Room No",Rec."Room No");
                      allocations.SetRange(allocations."Space No",Rec."Space No");
                    //allocations.SETRANGE(allocations."Academic Year","Academic Year");
                      allocations.SetRange(allocations.Semester,CReg.Semester);
                      if allocations.Find('-') then begin
                          if ((Cust.Balance)>((("GenSetUp."."% of Accomodation"/100)*Rec.Charges)+
                            (("GenSetUp."."% of Billed Fees/Balance"/100)*CReg."Total Billed"))) then begin
                             // ERROR('FAIL:\Hostel Allocation policy Fails. Less amount Paid.')
                              end;
                        end;
                     // END ELSE BEGIN  //1
                     // ERROR('FAIL:\The Student to Visit the Finance department for more advice.');
                      end; //1
                      end else begin //2
                      Error('FAIL:\Student not registered for the current Semester.');
                      end; //2
                     end;

                      Clear(settlementType);
                     Cust.Reset;
                     Cust.SetRange(Cust."No.",Student);
                     if Cust.Find ('-') then
                     if Cust."Hostel Black Listed"=false then
                     begin
                      if Confirm('Allocate the Specified Room?', true)=false then Error('Cancelled by user!');
                      Creg1.Reset;
                      Creg1.SetRange(Creg1."Student No.",Student);
                      Creg1.SetRange(Creg1.Semester,Semester);
                    //  Creg1.SETRANGE(Creg1."Academic Year","Academic Year");
                      if Creg1.Find('-') then begin
                        // Check if Prog is Special
                        if prog.Get(Creg1.Programme) then begin
                          if prog."Special Programme" then
                          settlementType:=Settlementtype::"Special Programme"
                          else if Creg1."Settlement Type"='KUCCPS' then settlementType:=Settlementtype::JAB
                          else if Creg1."Settlement Type"='PSSP' then settlementType:=Settlementtype::SSP;
                        end;

                      end;

                        "Book Room"(settlementType);
                        // Assign Items
                        hostcard.Reset;
                        hostcard.SetRange(hostcard."Asset No","Hostel No");
                        if hostcard.Find('-') then begin
                          invItems.Reset;
                          if hostcard.Gender=hostcard.Gender::Male then
                          invItems.SetFilter(invItems."Hostel Gender",'%1|%2',1,2);
                          if invItems.Find('-') then begin
                            studItemInv.Reset;
                            studItemInv.SetRange(studItemInv."Student No.",Student);
                           // studItemInv.SETRANGE(studItemInv."Academic Year","Academic Year");
                            studItemInv.SetRange(studItemInv.Semester,Semester);
                            if studItemInv.Find('-') then studItemInv.DeleteAll;
                            repeat
                              begin
                                studItemInv.Init;
                                studItemInv."Hostel Block":="Hostel No";
                                studItemInv."Room Code":="Room No";
                                studItemInv."Space Code":="Space No";
                                studItemInv."Item Code":=invItems.Item;
                                studItemInv."Academic Year":="Academic Year";
                                studItemInv.Semester:=Semester;
                                studItemInv.Quantity:=invItems."Quantity Per Room";
                                studItemInv."Fine Amount":=invItems."Fine Amount";
                                studItemInv.Insert(true);
                              end;
                            until invItems.Next=0;
                          end;
                        end;
                     end else begin
                     Message('The student' +' '+Student +' '+'has been blacklisted!');
                     end;
                end;
            }
            action("Print Invoice")
            {
                ApplicationArea = Basic;
                Caption = 'Print Invoice';
                Image = Invoice;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ACAHostelPermissions.PermissionMan(UserId,6);
                    
                     /* IF Cust.GET(Student) THEN BEGIN
                      WITH Cust DO BEGIN
                        CALCFIELDS(Balance);
                      CReg.RESET;
                      CReg.SETRANGE(CReg."Student No.",Student);
                      CReg.SETRANGE(CReg.Semester,Semester);
                      CReg.SETRANGE(CReg.Posted,TRUE);
                      IF CReg.FIND('-') THEN BEGIN
                      CReg.CALCFIELDS(CReg."Total Billed");
                      IF CReg."Total Billed"<>0 THEN BEGIN
                      IF Balance>(CReg."Total Billed"/2) THEN ERROR('Fees payment Accommodation policy error--Balance');    */
                      allocations.Reset;
                      allocations.SetRange(allocations.Student,Student);
                      allocations.SetRange(allocations."Hostel No","Hostel No");
                      allocations.SetRange(allocations."Room No","Room No");
                      allocations.SetRange(allocations."Space No","Space No");
                    //  allocations.SETRANGE(allocations."Academic Year","Academic Year");
                      allocations.SetRange(allocations.Semester,Semester);
                      if allocations.Find('-') then
                      Report.Run(51795,true,false,allocations);
                     /* END ELSE BEGIN
                      ERROR('Fees payment Accommodation policy error --Billing');
                      END;
                      END ELSE BEGIN
                      ERROR('Fees payment Accommodation policy error --Registration');
                      END;
                      END;
                      END;*/

                end;
            }
            action("Print Agreement")
            {
                ApplicationArea = Basic;
                Caption = 'Print Agreement';
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                       CReg.Reset;
                       CReg.SetFilter(CReg."Student No.",Student);
                       CReg.SetFilter(CReg.Semester,Semester);
                       if CReg.Find('-') then
                       Report.Run(39005953,true,true,CReg);
                end;
            }
            action("Inventroy Items")
            {
                ApplicationArea = Basic;
                Caption = 'Inventroy Items';
                Image = InventoryJournal;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "ACA-Std Hostel Inventory Items";
                RunPageLink = "Student No."=field(Student),
                              "Hostel Block"=field("Hostel No"),
                              "Room Code"=field("Room No"),
                              "Space Code"=field("Space No"),
                              "Academic Year"=field("Academic Year"),
                              Semester=field(Semester);
            }
            action("Book Batch")
            {
                ApplicationArea = Basic;
                Caption = 'Book Batch';
                Image = PostBatch;
                Promoted = true;
                Visible = false;

                trigger OnAction()
                begin
                        studRoomBlock.Reset;
                        studRoomBlock.SetFilter(studRoomBlock.Student,'<>%1','');
                        studRoomBlock.SetFilter(studRoomBlock."Hostel No",'<>%1','');
                        studRoomBlock.SetFilter(studRoomBlock."Room No",'<>%1','');
                        studRoomBlock.SetFilter(studRoomBlock."Space No",'<>%1','');
                        studRoomBlock.SetFilter(studRoomBlock.Semester,'<>%1','');
                        studRoomBlock.SetFilter(studRoomBlock."Academic Year",'<>%1','');
                        if  studRoomBlock.Find('-') then begin
                        repeat
                        cou:=cou+1;
                    //////////////////////////////////////////////////////////////////////////////////////////////////////////
                      Cust.Reset;
                      Cust.SetRange(Cust."No.",studRoomBlock.Student);
                      if Cust.Find('-') then begin
                      end;
                    
                      StudentHostel.Reset;
                      NoRoom:=0;
                      StudentHostel.SetRange(StudentHostel.Student,Cust."No.");
                     // StudentHostel.SETRANGE(StudentHostel.Billed,FALSE);
                      StudentHostel.SetFilter(StudentHostel."Space No",'<>%1','');
                      if StudentHostel.Find('-') then begin
                        repeat
                        // Get the Hostel Name
                        //StudentHostel.TESTFIELD(StudentHostel.Semester);
                       // StudentHostel.TESTFIELD(StudentHostel."Academic Year");
                       // StudentHostel.TESTFIELD(StudentHostel."Space No");
                        NoRoom:=NoRoom+1;
                        if NoRoom>1 then begin
                       //   ERROR('Please Note That You Can Not Select More Than One Room')
                        end;
                        // check if the room is still vacant
                        Rooms_Spaces.Reset;
                        Rooms_Spaces.SetRange(Rooms_Spaces."Space Code",StudentHostel."Space No");
                        Rooms_Spaces.SetRange(Rooms_Spaces."Room Code",StudentHostel."Room No");
                        Rooms_Spaces.SetRange(Rooms_Spaces."Hostel Code",StudentHostel."Hostel No");
                        if Rooms_Spaces.Find('-') then
                        if Rooms_Spaces.Status=Rooms_Spaces.Status::Vaccant then begin;//ERROR('The selected room is nolonger vacant');
                    
                        // ----------Check If He has UnCleared Room
                       StudentHostel.Reset;
                       StudentHostel.SetRange(StudentHostel.Student,Cust."No.");
                       StudentHostel.SetRange(StudentHostel.Cleared,false);
                       if StudentHostel.Find('-') then begin
                          if StudentHostel.Count>1 then begin
                          // EXIT;// ERROR('Please Note That You Must First Clear Your Old Rooms Before You Allocate Another Room')
                          end;
                       end;
                       //---Check if The Student Have Paid The Accomodation Fee
                       StudentCharges.Reset;
                       StudentCharges.SetRange(StudentCharges."Student No.",studRoomBlock.Student);
                       StudentCharges.SetRange(StudentCharges.Semester,studRoomBlock.Semester);
                       StudentCharges.SetRange(StudentCharges.Code,'ACCOMMODATION');
                       //StudentCharges.SETRANGE(Posted,TRUE);
                      /* IF StudentCharges.FIND('-') THEN BEGIN
                         ChargesRec.SETRANGE(ChargesRec.Code,StudentCharges.Code);
                         IF ChargesRec.FIND('-') THEN BEGIN
                           PaidAmt:=ChargesRec.Amount
                         END;
                       END; */
                    
                       if not StudentCharges.Find('-') then begin
                    coReg.Reset;
                    coReg.SetRange(coReg."Student No.",studRoomBlock.Student);
                    coReg.SetRange(coReg.Semester,studRoomBlock.Semester);
                    coReg.SetRange(coReg."Academic Year",studRoomBlock."Academic Year");
                    if coReg.Find('-') then begin
                        StudentCharges.Init;
                        StudentCharges."Transacton ID":='';
                        StudentCharges.Validate(StudentCharges."Transacton ID");
                        StudentCharges."Student No.":=coReg."Student No.";
                        StudentCharges."Reg. Transacton ID":=coReg."Reg. Transacton ID";
                        StudentCharges."Transaction Type":=StudentCharges."transaction type"::Charges;
                        StudentCharges.Code :='ACCOMMODATION';
                        StudentCharges.Description:='Accommodation Fees';
                        if Blocks.Get(studRoomBlock."Hostel No") then
                        StudentCharges.Amount:=Blocks."Cost Per Occupant"
                        else
                        StudentCharges.Amount:=0;
                        StudentCharges.Date:=Today;
                        StudentCharges.Programme:=coReg.Programme;
                        StudentCharges.Stage:=coReg.Stage;
                        StudentCharges.Semester:=coReg.Semester;
                        StudentCharges.Insert();
                    end;
                         end;
                    
                       if PaidAmt>StudentHostel."Accomodation Fee" then begin
                           StudentHostel."Over Paid":=true;
                           StudentHostel."Over Paid Amt":=PaidAmt-StudentHostel."Accomodation Fee";
                           StudentHostel.Modify;
                      /*
                       END ELSE BEGIN
                         IF PaidAmt<>StudentHostel."Accomodation Fee" THEN BEGIN
                    
                          ERROR('Accomodation Fee Paid Can Not Allocate This Room The Paid Amount is '+FORMAT(PaidAmt))
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
                        Host_Ledger.Gender:= studRoomBlock.Gender;
                        Host_Ledger."Hostel Name":='';
                        Host_Ledger.Campus:=Cust."Global Dimension 1 Code";
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
                        end;
                      //  IF StudentHostel."Over Paid" THEN BEGIN
                      //    PostOverPayment();
                        // END;
                        until StudentHostel.Next=0;
                       // MESSAGE('Room Allocateed Successfully');
                      end;
                    
                    //////////////////////////////////////////////////////////////////////////////////////////////////////////
                        until  studRoomBlock.Next=0;
                        end;
                    
                    //MESSAGE(FORMAT(cou));

                end;
            }
            action(Rev_Allocation)
            {
                ApplicationArea = Basic;
                Caption = 'Reverse Allocation';
                Enabled = true;
                Image = ReverseLines;
                Promoted = true;
                PromotedIsBig = true;
                Visible = true;

                trigger OnAction()
                begin


                    ACAHostelPermissions.PermissionMan(UserId,5);
                     TestField(Cleared,false);
                     TestField(Allocated,true);
                    if Confirm('This will reverse finance. Continue?',false)=false then Error('Cancelled by user!');
                     if Confirm('Reverse allocation?',false)=false then Error('Cancelled!');
                       // Clear Room
                          clearFromRoom_Reversal();
                       // Post charge Reversal
                          postChargeReversal();
                end;
            }
            action(trans)
            {
                ApplicationArea = Basic;
                Caption = 'Transfer Student';
                Image = TransferOrder;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin

                    ACAHostelPermissions.PermissionMan(UserId,4);

                    if ((Allocated=false) or (Cleared=true)) then Error('You can only transfer posted allocations');
                    hostStus.Reset;
                    hostStus.SetRange(hostStus."Hostel No","Hostel No");
                    hostStus.SetRange(hostStus."Room No","Room No");
                    hostStus.SetRange(hostStus."Space No","Space No");
                    hostStus.SetRange(hostStus.Student,Student);
                    hostStus.SetRange(hostStus.Semester,Semester);
                    hostStus.SetRange(hostStus."Academic Year","Academic Year");
                    if hostStus.Find('-') then begin
                      Page.Run(69172,hostStus);
                    end;
                end;
            }
            action(Switch_Rooms)
            {
                ApplicationArea = Basic;
                Caption = 'Switch Rooms';
                Image = TransferReceipt;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin

                    ACAHostelPermissions.PermissionMan(UserId,3);
                    if ((Allocated=false) or (Cleared=true)) then Error('You can only Swap/Switch posted allocations');
                    hostStus.Reset;
                    hostStus.SetRange(hostStus."Hostel No","Hostel No");
                    hostStus.SetRange(hostStus."Room No","Room No");
                    hostStus.SetRange(hostStus."Space No","Space No");
                    hostStus.SetRange(hostStus.Student,Student);
                    hostStus.SetRange(hostStus.Semester,Semester);
                    //hostStus.SETRANGE(hostStus."Academic Year","Academic Year");
                    if hostStus.Find('-') then begin
                      Page.Run(69173,hostStus);
                    end;
                end;
            }
            action("Clear Room")
            {
                ApplicationArea = Basic;
                Caption = 'Clear Room';
                Image = New;
                Promoted = true;
                Visible = false;

                trigger OnAction()
                begin


                    //IF "Student No" = '' THEN
                     // ERROR('Select a student with a room space firsts.');

                    if Confirm('Are you sure you want to clear this student from the Hostels?',false) = false then
                    exit;

                    Message('Ensure that all the facilities in the room are in a good condition before clearing the room!');
                    clearFromRoom();

                     Message(''''+"Student Name"+''' has been successfully cleared from '+"Hostel Name");
                     CurrPage.Update
                end;
            }
        }
    }

    var
        ACAHostelPermissions: Record "ACA-Hostel Permissions";
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
        StudentHostel: Record "ACA-Students Hostel Rooms";
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


    procedure PostOverPayment()
    begin
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name",'PAYMENTs');
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",'CHARGES');
        if GenJnlLine.Find('-') then begin
          GenJnlLine.DeleteAll
        end;

          StudentHostel.Reset;
          StudentHostel.SetRange(StudentHostel.Student,Cust."No.");
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
              GenJnlLine."Account No.":=Cust."No.";
              GenJnlLine.Validate(GenJnlLine."Account No.");
              GenJnlLine."Posting Date":=Today;
              GenJnlLine."Document Type":=GenJnlLine."document type"::Payment;
              GenJnlLine."Document No.":=CopyStr((StudentHostel."Space No" +' '+ StudentHostel."Room No"),1,20);
             //GenJnlLine."External Document No.":="Cheque No";
              GenJnlLine.Amount:=-StudentHostel."Over Paid Amt";
              GenJnlLine.Validate(GenJnlLine.Amount);
              GenJnlLine."Bal. Account Type":=GenJnlLine."bal. account type"::"G/L Account";
              GenJnlLine."Bal. Account No.":='300202';
             // GenJnlLine.Description:=Name;
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


    procedure clearFromRoom()
    var
        Rooms: Record "ACA-Hostel Block Rooms";
        spaces: Record UnknownRecord61824;
        hostLedger: Record "ACA-Hostel Ledger";
    begin
         hostLedger.Reset;
         hostLedger.SetRange(hostLedger."Hostel No","Hostel No");
         hostLedger.SetRange(hostLedger."Room No","Room No");
         hostLedger.SetRange(hostLedger."Space No","Space No");
         if hostLedger.Find('-') then begin
          hostLedger.DeleteAll;
         end;


        studRoomBlock.Reset;
        studRoomBlock.SetRange(studRoomBlock.Student,Student);
        studRoomBlock.SetRange(studRoomBlock."Space No","Space No");
        if studRoomBlock.Find ('-') then

        begin
        studRoomBlock.Cleared:=true;
        studRoomBlock."Clearance Date":=Today;
        studRoomBlock."Eviction Code":='CLEARED';
        studRoomBlock."Hostel Assigned":=false;
        studRoomBlock.Allocated:=true;
        studRoomBlock.Modify;
        end;



        spaces.Reset;
        spaces.SetRange(spaces."Hostel Code","Hostel No");
        spaces.SetRange(spaces."Room Code","Room No");
        spaces.SetRange(spaces."Space Code","Space No");
        if spaces.Find('-') then begin
        spaces.Status:=spaces.Status::Vaccant;
        spaces."Student No":='';
        spaces."Receipt No":='';
        spaces."Black List reason":='';
        spaces.Modify;
        spaces.Validate(spaces.Status);
        end;

         Rooms.Reset;
         Rooms.SetRange(Rooms."Hostel Code","Hostel No");
         Rooms.SetRange(Rooms."Room Code","Room No");
         if Rooms.Find('-') then begin

         Rooms.Validate(Rooms.Status);

         end;
    end;


    procedure "Book Room"(var settle_m: Option " ",KUCCPS,PSSP,"Special Programme")
    var
        rooms: Record "ACA-Hostel Block Rooms";
        billAmount: Decimal;
    begin
            // --------Check If More Than One Room Has Been Selected
          Clear(billAmount);
           rooms.Reset;
          rooms.SetRange(rooms."Hostel Code","Hostel No");
          rooms.SetRange(rooms."Room Code","Room No");
          if rooms.Find('-') then begin
            if settle_m=Settle_m::"Special Programme" then
              billAmount:=rooms."Special Programme"
            else if settle_m=Settle_m::KUCCPS then
              billAmount:=rooms."JAB Fees"
            else if settle_m=Settle_m::PSSP then
              billAmount:=rooms."SSP Fees";
            if billAmount=0 then billAmount:=rooms."JAB Fees";
        
          end;
          Cust.Reset;
          Cust.SetRange(Cust."No.",Student);
          if Cust.Find('-') then begin
          end;
        
          StudentHostel.Reset;
          NoRoom:=0;
          StudentHostel.SetRange(StudentHostel.Student,Cust."No.");
          StudentHostel.SetRange(StudentHostel.Cleared,false);
          StudentHostel.SetFilter(StudentHostel."Space No",'<>%1','');
          if StudentHostel.Find('-') then begin
        
            repeat
            // Get the Hostel Name
            StudentHostel.TestField(StudentHostel.Semester);
           // StudentHostel.TESTFIELD(StudentHostel."Academic Year");
            StudentHostel.TestField(StudentHostel."Space No");
            NoRoom:=NoRoom+1;
            if NoRoom>1 then begin
              Error('Please Note That You Can Not Select More Than One Room')
            end;
            // check if the room is still vacant
            if StudentHostel."Space No"='' then begin
            Rooms_Spaces.Reset;
            Rooms_Spaces.SetRange(Rooms_Spaces."Space Code",StudentHostel."Space No");
            Rooms_Spaces.SetRange(Rooms_Spaces."Room Code",StudentHostel."Room No");
            Rooms_Spaces.SetRange(Rooms_Spaces."Hostel Code",StudentHostel."Hostel No");
            if Rooms_Spaces.Find('-') then
            if Rooms_Spaces.Status<>Rooms_Spaces.Status::Vaccant then Error('The selected room is nolonger vacant.'+StudentHostel."Space No"+'-'+StudentHostel."Room No"+'-'
            +StudentHostel."Hostel No");
            end;
           /*
            // ----------Check If He has UnCleared Room
           StudentHostel.RESET;
           StudentHostel.SETRANGE(StudentHostel.Student,Cust."No.");
           StudentHostel.SETRANGE(StudentHostel.Cleared,FALSE);
           IF StudentHostel.FIND('-') THEN BEGIN
              IF StudentHostel.COUNT>1 THEN BEGIN
                ERROR('Please Note That You Must First Clear Your Old Rooms Before You Allocate Another Room')
              END;
           END;
           */
           //---Check if The Student Have Paid The Accomodation Fee
           charges1.Reset;
           charges1.SetRange(charges1.Hostel,true);
           if charges1.Find('-') then begin
           end else Error('Accommodation not setup.');
        
           StudentCharges.Reset;
           StudentCharges.SetRange(StudentCharges."Student No.",Student);
           StudentCharges.SetRange(StudentCharges.Semester,Semester);
           StudentCharges.SetRange(StudentCharges.Code,charges1.Code);
           //StudentCharges.SETRANGE(Posted,TRUE);
          /* IF StudentCharges.FIND('-') THEN BEGIN
             ChargesRec.SETRANGE(ChargesRec.Code,StudentCharges.Code);
             IF ChargesRec.FIND('-') THEN BEGIN
               PaidAmt:=ChargesRec.Amount
             END;
           END; */
           if Blocks.Get("Hostel No") then begin
           end;
        
           if not StudentCharges.Find('-') then begin
        coReg.Reset;
        coReg.SetRange(coReg."Student No.",Student);
        coReg.SetRange(coReg.Semester,Semester);
        //coReg.SETRANGE(coReg."Academic Year","Academic Year");
        if coReg.Find('-') then begin
            StudentCharges.Init;
            StudentCharges."Transacton ID":='';
            StudentCharges.Validate(StudentCharges."Transacton ID");
            StudentCharges."Student No.":=coReg."Student No.";
            StudentCharges."Reg. Transacton ID":=coReg."Reg. Transacton ID";
            StudentCharges."Transaction Type":=StudentCharges."transaction type"::Charges;
            StudentCharges.Code :=charges1.Code;
            StudentCharges.Description:='Accommodation Fees';
           // IF Blocks.GET("Hostel No") THEN
           // StudentCharges.Amount:=Blocks."Cost Per Occupant"
           // ELSE
            StudentCharges.Amount:=billAmount;
            StudentCharges.Date:=Today;
            StudentCharges.Programme:=coReg.Programme;
            StudentCharges.Stage:=coReg.Stage;
            StudentCharges.Semester:=coReg.Semester;
            StudentCharges.Insert();
        end;
             end;
        
           if PaidAmt>StudentHostel."Accomodation Fee" then begin
               StudentHostel."Over Paid":=true;
               StudentHostel."Over Paid Amt":=PaidAmt-StudentHostel."Accomodation Fee";
               StudentHostel.Modify;
          /*
           END ELSE BEGIN
             IF PaidAmt<>StudentHostel."Accomodation Fee" THEN BEGIN
        
              ERROR('Accomodation Fee Paid Can Not Allocate This Room The Paid Amount is '+FORMAT(PaidAmt))
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
            Host_Ledger."Space No":="Space No";
            Host_Ledger."Room No":="Room No";
            Host_Ledger."Hostel No":="Hostel No";
            Host_Ledger.No:=counts;
            Host_Ledger.Status:=Host_Ledger.Status::"Fully Occupied";
            Host_Ledger."Room Cost":=StudentHostel.Charges;
            Host_Ledger."Student No":=StudentHostel.Student;
            Host_Ledger."Receipt No":='';
            Host_Ledger.Semester:=StudentHostel.Semester;
            Host_Ledger.Gender:= Gender;
            Host_Ledger."Hostel Name":='';
            Host_Ledger.Campus:=Cust."Global Dimension 1 Code";
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
              StudentHostel."Allocated By":=UserId;
              StudentHostel."Time allocated":=Time;
              StudentHostel.Allocated:=true;
              StudentHostel.Modify;
        
        
            end;
          //  IF StudentHostel."Over Paid" THEN BEGIN
          //    PostOverPayment();
        
            until StudentHostel.Next=0;
        
          end;
        
         postCharge();
           Message('Room Allocateed Successfully');

    end;

    local procedure postCharge()
    begin
        //BILLING
        charges1.Reset;
        charges1.SetRange(charges1.Hostel,true);
        if not charges1.Find('-') then begin
          Error('The charges Setup does not have an item tagged as Hostel.');
        end;
        
        AccPayment:=false;
        StudentCharges.Reset;
        StudentCharges.SetRange(StudentCharges."Student No.",Student);
        StudentCharges.SetRange(StudentCharges.Recognized,false);
        StudentCharges.SetFilter(StudentCharges.Code,'=%1',charges1.Code) ;
        if not StudentCharges.Find('-') then begin //3
        // The charge does not exist. Created it, but check first if it exists as unrecognized
        StudentCharges.Reset;
        StudentCharges.SetRange(StudentCharges."Student No.",Student);
        //StudentCharges.SETRANGE(StudentCharges.Recognized,FALSE);
        StudentCharges.SetFilter(StudentCharges.Code,'=%1',charges1.Code) ;
        if not StudentCharges.Find('-') then begin //4
        // Does not exist hence just create
        CReg.Reset;
        CReg.SetRange(CReg."Student No.",Student);
        CReg.SetRange(CReg.Semester,Semester);
        if CReg.Find('-') then begin //5
          GenSetUp.Get();
          if GenSetUp.Find('-') then
          begin  //6
            NoSeries.Reset;
            NoSeries.SetRange(NoSeries."Series Code",GenSetUp."Transaction Nos.");
            if NoSeries.Find('-') then
            begin // 7
              LastNo:=NoSeries."Last No. Used"
            end;  // 7
          end; // 6
             //message(LastNo);
             LastNo:=IncStr(LastNo);
             NoSeries."Last No. Used":=LastNo;
             NoSeries.Modify;
             StudentCharges.Init();
             StudentCharges."Transacton ID":=LastNo;
             StudentCharges.Validate(StudentCharges."Transacton ID");
             StudentCharges."Student No.":=Student;
             StudentCharges."Transaction Type":=StudentCharges."transaction type"::Charges;
             StudentCharges."Reg. Transacton ID":=CReg."Reg. Transacton ID";
             StudentCharges.Description:='Hostel Charges '+"Space No";
             StudentCharges.Amount:=Charges;
             StudentCharges.Date:=Today;
             StudentCharges.Code:=charges1.Code;
             StudentCharges.Charge:=true;
             StudentCharges.Insert(true);
             Billed:=true;
             "Billed Date":=Today;
             Modify;
        end; //5
        
        end else begin//4
        // Charge Exists, Delete from the charges then create a new one
          StudentCharges.Delete;
        
        CReg.Reset;
        CReg.SetRange(CReg."Student No.",Student);
        CReg.SetRange(CReg.Semester,Semester);
        if CReg.Find('-') then begin //5
          GenSetUp.Get();
          if GenSetUp.Find('-') then
          begin  //6
            NoSeries.Reset;
            NoSeries.SetRange(NoSeries."Series Code",GenSetUp."Transaction Nos.");
            if NoSeries.Find('-') then
            begin // 7
              LastNo:=NoSeries."Last No. Used"
            end;  // 7
          end; // 6
             //message(LastNo);
             LastNo:=IncStr(LastNo);
             NoSeries."Last No. Used":=LastNo;
             NoSeries.Modify;
             StudentCharges.Init();
             StudentCharges."Transacton ID":=LastNo;
             StudentCharges.Validate(StudentCharges."Transacton ID");
             StudentCharges."Student No.":=Student;
             StudentCharges."Transaction Type":=StudentCharges."transaction type"::Charges;
             StudentCharges."Reg. Transacton ID":=CReg."Reg. Transacton ID";
             StudentCharges.Description:='Hostel Charges '+"Space No";
             StudentCharges.Amount:=Charges;
             StudentCharges.Date:=Today;
             StudentCharges.Code:=charges1.Code;
             StudentCharges.Charge:=true;
             StudentCharges.Insert(true);
            // Billed:=TRUE;
            // "Billed Date":=TODAY;
            // MODIFY;
        end; //5
        end;//4
        
        end; //3
        
        
        //SettlementType1:='';
        CReg.Reset;
        CReg.SetRange(CReg."Student No.",Student);
        CReg.SetRange(CReg.Semester,Semester);
        if CReg.Find('-') then begin //10
        "Settlement TypeR".Get(CReg."Settlement Type");
        "Settlement TypeR".TestField("Settlement TypeR"."Tuition G/L Account");
        end // 10
        else   begin // 10.1
        Error('The Settlement Type Does not Exists in the Course Registration for: '+Student);
        end;//10.1
        
        
        
        /*
        
        // MANUAL APPLICATION OF ACCOMODATION FOR PREPAYED STUDENTS BY Wanjala.....//
        StudentCharges.RESET;
        StudentCharges.SETRANGE(StudentCharges."Student No.",student);
        StudentCharges.SETRANGE(StudentCharges.Recognized,FALSE);
        StudentCharges.SETFILTER(StudentCharges.Code,'=%1',Charges1.Code) ;
        
        IF StudentCharges.COUNT=1 THEN BEGIN
        CALCFIELDS(Balance);
        IF Balance<0 THEN BEGIN
        IF ABS(Balance)>StudentCharges.Amount THEN BEGIN
        "Application Method":="Application Method"::Manual;
        AccPayment:=TRUE;
        MODIFY;
        END;
        END;
        END; */
        
        //END;
        
        
        //ERROR('TESTING '+FORMAT("Application Method"));
        
        if Cust.Get(Student) then;
        
        GenJnl.Reset;
        GenJnl.SetRange("Journal Template Name",'SALES');
        GenJnl.SetRange("Journal Batch Name",'STUD PAY');
        GenJnl.DeleteAll;
        
        GenSetUp.Get();
        //GenSetUp.TESTFIELD(GenSetUp."Pre-Payment Account");
        
        // Charge Student - Accommodation- if not charged
        StudentCharges.Reset;
        StudentCharges.SetRange(StudentCharges."Student No.",Student);
        StudentCharges.SetRange(StudentCharges.Recognized,false);
        StudentCharges.SetFilter(StudentCharges.Code,'=%1',charges1.Code) ;
        if StudentCharges.Find('-') then begin
        
        repeat
        
        DueDate:=StudentCharges.Date;
        //IF Sems.GET(StudentCharges.Semester) THEN BEGIN
        //IF Sems.From<>0D THEN BEGIN
        //IF Sems.From > DueDate THEN
        //DueDate:=Sems.From;
        //END;
        //END;
         if DueDate=0D then DueDate:=Today;
        
        GenJnl.Init;
        GenJnl."Line No." := GenJnl."Line No." + 10000;
        GenJnl."Posting Date":=Today;
        GenJnl."Document No.":=StudentCharges."Transacton ID";
        GenJnl.Validate(GenJnl."Document No.");
        GenJnl."Journal Template Name":='SALES';
        GenJnl."Journal Batch Name":='STUD PAY';
        GenJnl."Account Type":=GenJnl."account type"::Customer;
        //
        if Cust.Get(Student) then begin
        if Cust."Bill-to Customer No." <> '' then
        GenJnl."Account No.":=Cust."Bill-to Customer No."
        else
        GenJnl."Account No.":=Student;
        end;
        
        GenJnl.Amount:=StudentCharges.Amount;
        GenJnl.Validate(GenJnl."Account No.");
        GenJnl.Validate(GenJnl.Amount);
        GenJnl.Description:=StudentCharges.Description;
        GenJnl."Bal. Account Type":=GenJnl."account type"::"G/L Account";
        
        if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Stage Fees") and
           (StudentCharges.Charge = false) then begin
        GenJnl."Bal. Account No.":="Settlement TypeR"."Tuition G/L Account";
        
        CReg.Reset;
        CReg.SetCurrentkey(CReg."Reg. Transacton ID");
        CReg.SetRange(CReg."Reg. Transacton ID",StudentCharges."Reg. Transacton ID");
        CReg.SetRange(CReg."Student No.",StudentCharges."Student No.");
        if CReg.Find('-') then begin
        if CReg."Register for"=CReg."register for"::Stage then begin
        Stages.Reset;
        Stages.SetRange(Stages."Programme Code",CReg.Programme);
        Stages.SetRange(Stages.Code,CReg.Stage);
        if Stages.Find('-') then begin
        if (Stages."Modules Registration" = true) and (Stages."Ignore No. Of Units"= false) then begin
        CReg.CalcFields(CReg."Units Taken");
        if CReg. Modules <> CReg."Units Taken" then
        Error('Units Taken must be equal to the no of modules registered for.');
        
        end;
        end;
        end;
        
        CReg.Posted:=true;
        CReg.Modify;
        end;
        
        
        end else if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Unit Fees") and
                    (StudentCharges.Charge = false) then begin
        //GenJnl."Bal. Account No.":=GenSetUp."Pre-Payment Account";
        StudentCharges.CalcFields(StudentCharges."Settlement Type");
        GenJnl."Bal. Account No.":="Settlement TypeR"."Tuition G/L Account";
        
        
        CReg.Reset;
        CReg.SetCurrentkey(CReg."Reg. Transacton ID");
        CReg.SetRange(CReg."Reg. Transacton ID",StudentCharges."Reg. Transacton ID");
        if CReg.Find('-') then begin
        CReg.Posted:=true;
        CReg.Modify;
        end;
        
        
        
        end else if StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Stage Exam Fees" then begin
        if ExamsByStage.Get(StudentCharges.Programme,StudentCharges.Stage,StudentCharges.Semester,StudentCharges.Code) then
        GenJnl."Bal. Account No.":=ExamsByStage."G/L Account";
        
        end else if StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Unit Exam Fees" then begin
        if ExamsByUnit.Get(StudentCharges.Programme,StudentCharges.Stage,ExamsByUnit."Unit Code",StudentCharges.Semester,
        StudentCharges.Code) then
        GenJnl."Bal. Account No.":=ExamsByUnit."G/L Account";
        
        end else if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::Charges) or
                    (StudentCharges.Charge = true) then begin
        if charges1.Get(StudentCharges.Code) then
        GenJnl."Bal. Account No.":=charges1."G/L Account";
        end;
        
        
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
        if StudentCharges."Recovery Priority" <> 0 then
        GenJnl."Recovery Priority":=StudentCharges."Recovery Priority"
        else
        GenJnl."Recovery Priority":=25;
        if GenJnl.Amount<>0 then
        GenJnl.Insert;
        
        //Distribute Money
        if StudentCharges."Tuition Fee" = true then begin
        if Stages.Get(StudentCharges.Programme,StudentCharges.Stage) then begin
        if (Stages."Distribution Full Time (%)" > 0) or (Stages."Distribution Part Time (%)" > 0) then begin
        Stages.TestField(Stages."Distribution Account");
        StudentCharges.TestField(StudentCharges.Distribution);
        if Cust.Get(Student) then begin
        CustPostGroup.Get(Cust."Customer Posting Group");
        
        GenJnl.Init;
        GenJnl."Line No." := GenJnl."Line No." + 10000;
        GenJnl."Posting Date":=Today;
        GenJnl."Document No.":=StudentCharges."Transacton ID";
        //GenJnl."Document Type":=GenJnl."Document Type"::Payment;
        GenJnl.Validate(GenJnl."Document No.");
        GenJnl."Journal Template Name":='SALES';
        GenJnl."Journal Batch Name":='STUD PAY';
        GenJnl."Account Type":=GenJnl."account type"::"G/L Account";
        //GenSetUp.TESTFIELD(GenSetUp."Pre-Payment Account");
        GenJnl."Account No.":="Settlement TypeR"."Tuition G/L Account";
        GenJnl.Amount:=StudentCharges.Amount * (StudentCharges.Distribution/100);
        GenJnl.Validate(GenJnl."Account No.");
        GenJnl.Validate(GenJnl.Amount);
        GenJnl.Description:='Fee Distribution';
        GenJnl."Bal. Account Type":=GenJnl."bal. account type"::"G/L Account";
        //GenJnl."Bal. Account No.":=Stages."Distribution Account";
        
        StudentCharges.CalcFields(StudentCharges."Settlement Type");
        "Settlement TypeR".Get(StudentCharges."Settlement Type");
        GenJnl."Bal. Account No.":="Settlement TypeR"."Tuition G/L Account";
        
        GenJnl.Validate(GenJnl."Bal. Account No.");
        GenJnl."Shortcut Dimension 1 Code":=Cust."Global Dimension 1 Code";
        if prog.Get(StudentCharges.Programme) then begin
        prog.TestField(prog."Department Code");
        GenJnl."Shortcut Dimension 2 Code":=prog."Department Code";
        end;
        
        GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
        GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
        if GenJnl.Amount<>0 then
        GenJnl.Insert;
        
        end;
        end;
        end;
        end else begin
        //Distribute Charges
        if StudentCharges.Distribution > 0 then begin
        StudentCharges.TestField(StudentCharges."Distribution Account");
        if charges1.Get(StudentCharges.Code) then begin
        charges1.TestField(charges1."G/L Account");
        GenJnl.Init;
        GenJnl."Line No." := GenJnl."Line No." + 10000;
        GenJnl."Posting Date":=Today;
        GenJnl."Document No.":=StudentCharges."Transacton ID";
        GenJnl.Validate(GenJnl."Document No.");
        GenJnl."Journal Template Name":='SALES';
        GenJnl."Journal Batch Name":='STUD PAY';
        GenJnl."Account Type":=GenJnl."account type"::"G/L Account";
        GenJnl."Account No.":=StudentCharges."Distribution Account";
        GenJnl.Amount:=StudentCharges.Amount * (StudentCharges.Distribution/100);
        GenJnl.Validate(GenJnl."Account No.");
        GenJnl.Validate(GenJnl.Amount);
        GenJnl.Description:='Fee Distribution';
        GenJnl."Bal. Account Type":=GenJnl."bal. account type"::"G/L Account";
        GenJnl."Bal. Account No.":=charges1."G/L Account";
        GenJnl.Validate(GenJnl."Bal. Account No.");
        GenJnl."Shortcut Dimension 1 Code":=Cust."Global Dimension 1 Code";
        
        if prog.Get(StudentCharges.Programme) then begin
        prog.TestField(prog."Department Code");
        GenJnl."Shortcut Dimension 2 Code":=prog."Department Code";
        end;
        GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
        GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
        if GenJnl.Amount<>0 then
        GenJnl.Insert;
        
        end;
        end;
        end;
        //End Distribution
        
        
        StudentCharges.Recognized:=true;
        //StudentCharges.MODIFY;
        //.......BY Wanjala
        StudentCharges.Posted:=true;
        StudentCharges.Modify;
        
        //CReg.Posted:=TRUE;
        //CReg.MODIFY;
        
        
        //.....END Wanjala
        
        until StudentCharges.Next = 0;
        
        
        /*
        GenJnl.SETRANGE("Journal Template Name",'SALES');
        GenJnl.SETRANGE("Journal Batch Name",'STUD PAY');
        IF GenJnl.FIND('-') THEN BEGIN
        REPEAT
        GLPosting.RUN(GenJnl);
        UNTIL GenJnl.NEXT = 0;
        END;
        
        
        GenJnl.RESET;
        GenJnl.SETRANGE("Journal Template Name",'SALES');
        GenJnl.SETRANGE("Journal Batch Name",'STUD PAY');
        GenJnl.DELETEALL;
        */
        
        //Post New
        GenJnl.Reset;
        GenJnl.SetRange("Journal Template Name",'SALES');
        GenJnl.SetRange("Journal Batch Name",'STUD PAY');
        if GenJnl.Find('-') then begin
        Codeunit.Run(Codeunit::"Gen. Jnl.-Post Bill",GenJnl);
        end;
        
        //Post New
        
        
        Cust."Application Method":=Cust."application method"::"Apply to Oldest";
        //Cust.Status:=Cust.Status::Current;
        Cust.Modify;
        
        end;
        
         /*
        //BILLING
        
        StudentPayments.RESET;
        StudentPayments.SETRANGE(StudentPayments."Student No.",student);
        IF StudentPayments.FIND('-') THEN
        StudentPayments.DELETEALL;
        
        
        StudentPayments.RESET;
        StudentPayments.SETRANGE(StudentPayments."Student No.",student);
        IF AccPayment=TRUE THEN BEGIN
         IF Cust.GET(student) THEN
         Cust."Application Method":=Cust."Application Method"::"Apply to Oldest";
         Cust. MODIFY;
        END;*/
        
        //MESSAGE('The Accommodation charge was generated and posted.');

    end;

    local procedure postChargeReversal()
    begin
        //BILLING
        charges1.Reset;
        charges1.SetRange(charges1.Hostel,true);
        if not charges1.Find('-') then begin
          Error('The charges Setup does not have an item tagged as Hostel.');
        end;

        AccPayment:=false;
        CReg.Reset;
        CReg.SetRange(CReg."Student No.",Student);
        CReg.SetRange(CReg.Semester,Semester);
        if CReg.Find('-') then begin //5
          GenSetUp.Get();
          if GenSetUp.Find('-') then
          begin  //6
            NoSeries.Reset;
            NoSeries.SetRange(NoSeries."Series Code",GenSetUp."Transaction Nos.");
            if NoSeries.Find('-') then
            begin // 7
              LastNo:=NoSeries."Last No. Used"
            end;  // 7
          end; // 6
             //message(LastNo);
        end; //5

        CReg.Reset;
        CReg.SetRange(CReg."Student No.",Student);
        CReg.SetRange(CReg.Semester,Semester);
        if CReg.Find('-') then begin //10
        "Settlement TypeR".Get(CReg."Settlement Type");
        "Settlement TypeR".TestField("Settlement TypeR"."Tuition G/L Account");
        end // 10
        else   begin // 10.1
        Error('The Settlement Type Does not Exists in the Course Registration for: '+Student);
        end;//10.1

        if prog.Get(CReg.Programme) then;

        if Cust.Get(Student) then;

        GenJnl.Reset;
        GenJnl.SetRange("Journal Template Name",'SALES');
        GenJnl.SetRange("Journal Batch Name",'STUD PAY');
        GenJnl.DeleteAll;

        GenSetUp.Get();

        // Reverse Accomodation if charged

        DueDate:=Today;

         if DueDate=0D then DueDate:=Today;

        GenJnl.Init;
        GenJnl."Line No." := GenJnl."Line No." + 10000;
        GenJnl."Posting Date":=Today;
        GenJnl."Document No.":=CopyStr((CReg."Reg. Transacton ID"+'-'+"Space No"),1,20);
        GenJnl.Validate(GenJnl."Document No.");
        GenJnl."Journal Template Name":='SALES';
        GenJnl."Journal Batch Name":='STUD PAY';
        GenJnl."Account Type":=GenJnl."account type"::Customer;
        //
        if Cust.Get(Student) then begin
        if Cust."Bill-to Customer No." <> '' then
        GenJnl."Account No.":=Cust."Bill-to Customer No."
        else
        GenJnl."Account No.":=Student;
        end;

        GenJnl.Amount:=-Charges;
        GenJnl.Validate(GenJnl."Account No.");
        GenJnl.Validate(GenJnl.Amount);
        GenJnl.Description:='Accommodation Reversal '+"Space No";
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
        GenJnl."Recovery Priority":=1;
        if GenJnl.Amount<>0 then
        GenJnl.Insert;


        //Post New
        GenJnl.Reset;
        GenJnl.SetRange("Journal Template Name",'SALES');
        GenJnl.SetRange("Journal Batch Name",'STUD PAY');
        if GenJnl.Find('-') then begin
        Codeunit.Run(Codeunit::"Gen. Jnl.-Post Bill",GenJnl);
        end;

        //Post New

        Message('The Accommodation charge was Reversed.');
    end;


    procedure clearFromRoom_Reversal()
    var
        Rooms: Record "ACA-Hostel Block Rooms";
        spaces: Record UnknownRecord61824;
        hostLedger: Record "ACA-Hostel Ledger";
        HostRooms: Record "ACA-Students Hostel Rooms";
    begin
         hostLedger.Reset;
         hostLedger.SetRange(hostLedger."Hostel No","Hostel No");
         hostLedger.SetRange(hostLedger."Room No","Room No");
         hostLedger.SetRange(hostLedger."Space No","Space No");

         if hostLedger.Find('-') then begin
         repeat
         begin
        HostRooms.Reset;
        HostRooms.SetRange(HostRooms.Student,hostLedger."Student No");
        //HostRooms.SETRANGE(HostRooms."Academic Year",hostLedger."Academic Year");
        HostRooms.SetRange(HostRooms.Semester,hostLedger.Semester);
        HostRooms.SetRange(HostRooms."Hostel No",hostLedger."Hostel No");
        HostRooms.SetRange(HostRooms."Room No",hostLedger."Room No");
        HostRooms.SetRange(HostRooms."Space No",hostLedger."Space No");
        HostRooms.SetFilter(HostRooms.Cleared,'=%1',false);
        if HostRooms.Find('-') then begin
          HostRooms.Cleared:=true;
          HostRooms."Clearance Date":=Today;
          HostRooms.Modify;
        end;

          end;
          until hostLedger.Next=0;
        hostLedger.DeleteAll;
         end;

        spaces.Reset;
        spaces.SetRange(spaces."Hostel Code","Hostel No");
        spaces.SetRange(spaces."Room Code","Room No");
        spaces.SetRange(spaces."Space Code","Space No");
        if spaces.Find('-') then begin
        repeat
        begin
        spaces.Status:=spaces.Status::Vaccant;
        spaces."Student No":='';
        spaces."Receipt No":='';
        spaces."Black List reason":='';
        spaces.Modify;
        spaces.Validate(Status);
        end;
        until spaces.Next=0;
        end;

          Rooms.Reset;
         Rooms.SetRange(Rooms."Hostel Code","Hostel No");
         Rooms.SetRange(Rooms."Room Code","Room No");
         if Rooms.Find('-') then begin
          repeat
           Rooms.Validate(Rooms.Status);
          until Rooms.Next = 0;
         end;
    end;


    procedure clearFromRoom_Clear()
    var
        Rooms: Record "ACA-Hostel Block Rooms";
        spaces: Record UnknownRecord61824;
        hostLedger: Record "ACA-Hostel Ledger";
        HostRooms: Record "ACA-Students Hostel Rooms";
    begin
         hostLedger.Reset;
         hostLedger.SetRange(hostLedger."Hostel No",Rec."Hostel No");
         hostLedger.SetRange(hostLedger."Room No","Room No");
         hostLedger.SetRange(hostLedger."Space No","Space No");

         if hostLedger.Find('-') then begin
         repeat
         begin
        HostRooms.Reset;
        HostRooms.SetRange(HostRooms.Student,hostLedger."Student No");
        HostRooms.SetRange(HostRooms."Academic Year",hostLedger."Academic Year");
        HostRooms.SetRange(HostRooms.Semester,hostLedger.Semester);
        HostRooms.SetRange(HostRooms."Hostel No",hostLedger."Hostel No");
        HostRooms.SetRange(HostRooms."Room No",hostLedger."Room No");
        HostRooms.SetRange(HostRooms."Space No",hostLedger."Space No");
        if HostRooms.Find('-') then begin
          HostRooms.Cleared:=true;
          HostRooms."Clearance Date":=Today;
          HostRooms.Modify;
        end;
        hostLedger.Delete;
          end;
          until hostLedger.Next=0;
         end;


        spaces.Reset;
        spaces.SetRange(spaces."Hostel Code","Hostel No");
        spaces.SetRange(spaces."Room Code","Room No");
        spaces.SetRange(spaces."Space Code","Space No");
        if spaces.Find('-') then begin
        repeat
        begin
        spaces.Status:=spaces.Status::Vaccant;
        spaces."Student No":='';
        spaces."Receipt No":='';
        spaces."Black List reason":='';
        spaces.Modify;
        end;
        until spaces.Next=0;
        end;

          Rooms.Reset;
         Rooms.SetRange(Rooms."Hostel Code","Hostel No");
         Rooms.SetRange(Rooms."Room Code","Space No");
         if Rooms.Find('-') then begin
          repeat
           Rooms.Validate(Rooms.Status);
          until Rooms.Next = 0;
         end;
    end;
}

