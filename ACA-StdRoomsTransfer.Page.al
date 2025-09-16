#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69172 "ACA-Std Rooms Transfer"
{
    PageType = Card;
    SourceTable = "ACA-Students Hostel Rooms";
    SourceTableView = where(Cleared=const(false));

    layout
    {
        area(content)
        {
            group(Control1102760000)
            {
                field(Student;Student)
                {
                    ApplicationArea = Basic;
                    Editable = false;

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
                          CReg.Reset;
                          CReg.SetRange(CReg."Student No.",Student);
                          CReg.SetRange(CReg.Semester,Sem.Code);
                         // Creg.SETRANGE(Creg.Posted,TRUE);
                          if CReg.Find('-') then
                          Registered:=CReg.Registered;

                           GenSetUp.Get;
                           if GenSetUp."Allow UnPaid Hostel Booking"=false then begin
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
            }
            group(CurrDetails)
            {
                Caption = 'Current Block/Room/Space';
                field("Hostel No";"Hostel No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Room No";"Room No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Space No";"Space No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            group(CurrDetails2)
            {
                Caption = 'New Block/Room/Space';
                field("Transfer to Hostel No";"Transfer to Hostel No")
                {
                    ApplicationArea = Basic;
                }
                field("Transfer to Room No";"Transfer to Room No")
                {
                    ApplicationArea = Basic;
                }
                field("Transfer to Space No";"Transfer to Space No")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Validation)
            {
                field("Reason for transfer";"Reason for transfer")
                {
                    ApplicationArea = Basic;
                }
                field("Transfered By";"Transfered By")
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
                RunObject = Page "ACA-Std Hostel Inventory Items";
                RunPageLink = "Student No."=field(Student),
                              "Hostel Block"=field("Hostel No"),
                              "Room Code"=field("Room No"),
                              "Space Code"=field("Space No"),
                              "Academic Year"=field("Academic Year"),
                              Semester=field(Semester);
                Visible = false;
            }
            action("Allocate Room")
            {
                ApplicationArea = Basic;
                Caption = 'Allocate Room';
                Image = "Action";
                Promoted = true;
                PromotedCategory = New;
                Visible = false;

                trigger OnAction()
                begin
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
                      Creg1.SetRange(Creg1."Academic Year","Academic Year");
                      if Creg1.Find('-') then begin
                        // Check if Prog is Special
                        if prog.Get(Creg1.Programme) then begin
                          if prog."Special Programme" then
                          settlementType:=Settlementtype::"Special Programme"
                          else if Creg1."Settlement Type"='JAB' then settlementType:=Settlementtype::JAB
                          else if Creg1."Settlement Type"='SSP' then settlementType:=Settlementtype::SSP;
                        end;

                      end;
                      //  "Book Room"(settlementType);
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
                            studItemInv.SetRange(studItemInv."Academic Year","Academic Year");
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
                      //  StudentCharges.INSERT();
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
                    
                    Message(Format(cou));

                end;
            }
            action("Print Invoice")
            {
                ApplicationArea = Basic;
                Caption = 'Print Invoice';
                Image = PrintReport;
                Promoted = true;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                      allocations.Reset;
                      allocations.SetRange(allocations.Student,Student);
                      allocations.SetRange(allocations."Hostel No","Hostel No");
                      allocations.SetRange(allocations."Room No","Room No");
                      allocations.SetRange(allocations."Space No","Space No");
                      allocations.SetRange(allocations."Academic Year","Academic Year");
                      allocations.SetRange(allocations.Semester,Semester);
                      if allocations.Find('-') then
                      Report.Run(52017900,true,false,allocations)
                end;
            }
            action(PostTransfer)
            {
                ApplicationArea = Basic;
                Caption = 'Post Transfer';
                Image = TransferFunds;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                          TestField(Cleared,false);
                        TestField("Transfer to Hostel No");
                       TestField("Transfer to Room No");
                       TestField("Transfer to Space No");
                       TestField("Hostel No");
                       TestField("Room No");
                       TestField("Space No");

                       CurrentStudent:=Student;
                       CurrentHostel:="Hostel No";
                       CurrentRoom:="Room No";
                       CurrentSpace:="Space No";
                       NewHostel:="Transfer to Hostel No";
                       NewRoom:="Transfer to Room No";
                       NewSpace:="Transfer to Space No";

                        if (("Transfer to Hostel No" = "Hostel No") and
                       ("Transfer to Room No"="Room No")
                       ) then Error('The two rooms are the same');

                    CourseReg.Reset;
                    CourseReg.SetRange(CourseReg."Student No.",Student);
                    CourseReg.SetRange(CourseReg.Semester,Semester);
                    //CourseReg.SETRANGE(CourseReg."Academic Year","Academic Year");
                    if CourseReg.Find('-') then begin
                        prog.Reset;
                        if prog.Get(CourseReg.Programme) then begin
                        end;
                    end else Error('The Student is not registered for the current Semester.');
                     // Check if the room costs are equal
                        rooms1.Reset;
                       rooms1.SetRange(rooms1."Hostel Code","Hostel No");
                       rooms1.SetRange(rooms1."Room Code","Room No");
                       if  rooms1.Find('-') then begin

                       rooms2.Reset;
                       rooms2.SetRange(rooms2."Hostel Code","Transfer to Hostel No");
                       rooms2.SetRange(rooms2."Room Code","Transfer to Room No");
                       if rooms2.Find('-') then begin
                       if not (prog."Special Programme") then begin
                       if CourseReg."Settlement Type"='KUCCPS' then begin
                        if not (rooms1."JAB Fees"=rooms2."JAB Fees") then Error('Fees for the destination room must be equat to '+Format(rooms1."JAB Fees"));
                        end else if CourseReg."Settlement Type"='PSSP' then begin
                        if not (rooms1."SSP Fees"=rooms2."SSP Fees") then Error('Fees for the destination room must be equat to '+Format(rooms1."SSP Fees"));
                        end;
                        end;// end if not special Programme
                       end;
                       end;

                             if Confirm('Tranfer student from '+"Space No"+' to '+"Transfer to Space No",false)=false then Error('Transfer cancelled');
                             // Clear Existing Room
                              clearFromRoom();
                              // Allocate a new room without Posting charges
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

                        Book_Room_Transfer(settlementType);
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
                                studItemInv."Hostel Block":="Transfer to Hostel No";
                                studItemInv."Room Code":="Transfer to Room No";
                                studItemInv."Space Code":="Transfer to Space No";
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



                    "Transfed from Hostel No":="Hostel No";
                    "Transfed from Room No" :="Room No";
                    "Transfed from Space No":="Space No";
                    //"Hostel No":="Transfer to Hostel No"  ;
                    //"Room No":="Transfer to Room No";
                    //"Space No":="Transfer to Space No";
                    //MODIFY;
                    Message('Student successfully transffered');

                    "Transfered By":=UserId;
                    "Time Transfered":=Time;
                    "Date Transfered":=Today;
                    Cleared:=true;
                    "Clearance Date":=Today;
                    Transfered:=true;
                    //MODIFY;
                end;
            }
        }
    }

    var
        CurrentStudent: Code[20];
        CurrentHostel: Code[20];
        CurrentRoom: Code[20];
        CurrentSpace: Code[20];
        NewHostel: Code[20];
        NewRoom: Code[20];
        NewSpace: Code[20];
        AccPayment: Boolean;
        courseReg1: Record UnknownRecord61532;
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
        rooms1: Record "ACA-Hostel Block Rooms";
        rooms2: Record "ACA-Hostel Block Rooms";
        prog2: Record UnknownRecord61511;
        "Settlement Type": Record UnknownRecord61522;


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
              GenJnlLine."Document No.":=StudentHostel."Space No" +' '+ StudentHostel."Room No";
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
        HostRooms: Record "ACA-Students Hostel Rooms";
    begin
         hostLedger.Reset;
         //hostLedger.SETRANGE(hostLedger."Hostel No","Hostel No");
         hostLedger.SetRange(hostLedger."Room No",CurrentRoom);
         hostLedger.SetRange(hostLedger."Space No",CurrentSpace);

         if hostLedger.Find('-') then begin
         repeat
         begin
        HostRooms.Reset;
        HostRooms.SetRange(HostRooms.Student,CurrentStudent);
        //HostRooms.SETRANGE(HostRooms."Academic Year",hostLedger."Academic Year");
        HostRooms.SetRange(HostRooms.Semester,Semester);
        HostRooms.SetRange(HostRooms."Hostel No",CurrentHostel);
        HostRooms.SetRange(HostRooms."Room No",CurrentRoom);
        HostRooms.SetRange(HostRooms."Space No",CurrentSpace);
        HostRooms.SetFilter(HostRooms.Cleared,'=%1',false);
        if HostRooms.Find('-') then begin
          HostRooms.Cleared:=true;
          HostRooms."Clearance Date":=Today;
          HostRooms.Modify;
        end;
        hostLedger.Delete(true);
          end;
          until hostLedger.Next=0;
         end;


        spaces.Reset;
        spaces.SetRange(spaces."Hostel Code",CurrentHostel);
        spaces.SetRange(spaces."Room Code",CurrentRoom);
        spaces.SetRange(spaces."Space Code",CurrentSpace);
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
         Rooms.SetRange(Rooms."Hostel Code",CurrentHostel);
         Rooms.SetRange(Rooms."Room Code",CurrentRoom);
         if Rooms.Find('-') then begin
          repeat
           Rooms.Validate(Rooms.Status);
          until Rooms.Next = 0;
         end;
    end;


    procedure Book_Room_Transfer(var settle_m: Option " ",JAB,SSP,"Special Programme")
    var
        rooms: Record "ACA-Hostel Block Rooms";
        billAmount: Decimal;
        counted: Integer;
    begin
            // -- Create a new allocation
            StudentHostel.Reset;
            if StudentHostel.Find('-') then counted:=StudentHostel.Count
            else counted:=1000;
                // --------Check If More Than One Room Has Been Selected
                counted:=counted+1;
        StudentHostel.Init;
        StudentHostel."Line No":=counted;
        StudentHostel.Student :=CurrentStudent;
        StudentHostel."Space No":=NewSpace;
        StudentHostel."Room No":=NewRoom;
        StudentHostel."Hostel No":=NewHostel;
        StudentHostel."Accomodation Fee":="Accomodation Fee";
        StudentHostel."Allocation Date":=Today;
        StudentHostel.Charges:= Charges;
        StudentHostel.Billed :=Billed;
        StudentHostel."Billed Date":="Billed Date";
        StudentHostel.Semester:=Semester;
        StudentHostel."Academic Year":="Academic Year";
        StudentHostel.Allocated :=true;
        StudentHostel."Transfed from Hostel No":=CurrentHostel;
        StudentHostel."Transfed from Room No":=CurrentRoom;
        StudentHostel."Transfed from Space No":=CurrentSpace ;
        StudentHostel.Gender:= Gender;
         StudentHostel.Insert(true);

            Rooms_Spaces.Reset;
            Rooms_Spaces.SetRange(Rooms_Spaces."Space Code",NewSpace);
            Rooms_Spaces.SetRange(Rooms_Spaces."Room Code",NewRoom);
            if Rooms_Spaces.Find('-') then begin
              Rooms_Spaces.Status:=Rooms_Spaces.Status::"Fully Occupied";
              Rooms_Spaces.Modify;
              end;
            //  CLEAR(counts);
          // Post to  the Ledger Tables
          Host_Ledger.Reset;
          if Host_Ledger.Find('-') then counts:=Host_Ledger.Count;
          Host_Ledger.Init;
            Host_Ledger."Space No":=NewSpace;
            Host_Ledger."Room No":=NewRoom;
            Host_Ledger."Hostel No":=NewHostel;
            Host_Ledger.No:=counts;
            Host_Ledger.Status:=Host_Ledger.Status::"Fully Occupied";
            Host_Ledger."Room Cost":=Charges;
            Host_Ledger."Student No":=CurrentStudent;
            Host_Ledger."Receipt No":='';
            Host_Ledger.Semester:=Semester;
            Host_Ledger.Gender:= Gender;
            Host_Ledger."Hostel Name":='';
            Host_Ledger.Campus:=Cust."Global Dimension 1 Code";
            Host_Ledger."Academic Year":="Academic Year";
          Host_Ledger.Insert;


        Hostel_Rooms.Reset;
        Hostel_Rooms.SetRange(Hostel_Rooms."Hostel Code",NewHostel);
        Hostel_Rooms.SetRange(Hostel_Rooms."Room Code",NewRoom);
        if Hostel_Rooms.Find('-') then Hostel_Rooms.Validate(Status);
    end;
}

