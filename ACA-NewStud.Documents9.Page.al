#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77570 "ACA-New Stud. Documents 9"
{
    Caption = 'DoDocuments';
    DataCaptionFields = "Document Code";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = UnknownTable77360;

    layout
    {
        area(content)
        {
            field("Document Code";"Document Code")
            {
                ApplicationArea = Basic;
            }
            field(Document_Image;Document_Image)
            {
                ApplicationArea = Basic;
                Image = Chart;
            }
            field("Approval Comments";"Approval Comments")
            {
                ApplicationArea = Basic;
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(ApproveDocument)
            {
                ApplicationArea = Basic;
                Caption = 'Approve';
                Image = Approve;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    HostelCode: Code[20];
                    Customs: Record Customer;
                begin
                    if Confirm('Approve Document?',true)= false then Error('Cancelled!');
                        Clear(KUCCPSImports);
                        KUCCPSImports.Reset;
                        KUCCPSImports.SetRange("Academic Year",Rec."Academic Year");
                        KUCCPSImports.SetRange(Index,Rec."Index Number");
                        if KUCCPSImports.Find('-') then;

                    Clear(ACANewStudDocSetup);
                    ACANewStudDocSetup.Reset;
                    ACANewStudDocSetup.SetRange("Academic Year",Rec."Academic Year");
                    ACANewStudDocSetup.SetRange("Document Code",Rec."Document Code");
                    if ACANewStudDocSetup.Find('-') then begin
                      if ACANewStudDocSetup."Final Stage" = false then
                      ACANewStudDocSetup.TestField("Next Sequence");
                      Clear(AdmissionApprovalEntries);
                      AdmissionApprovalEntries.Reset;
                      AdmissionApprovalEntries.SetRange("Document Code",Rec."Document Code");
                      AdmissionApprovalEntries.SetRange(Index,Rec."Index Number");
                      AdmissionApprovalEntries.SetRange(Approver_Id,UserId);
                      AdmissionApprovalEntries.SetRange("Academic Year",Rec."Academic Year");
                      if AdmissionApprovalEntries.Find('-') then begin
                        // The user Approved The document
                        AdmissionApprovalEntries."Approved The Document" := true;
                        AdmissionApprovalEntries."Approval Status" := AdmissionApprovalEntries."approval status"::Approved;
                        AdmissionApprovalEntries."Approved Date/Time" := CreateDatetime(Today,Time);
                        AdmissionApprovalEntries.Modify;
                        end;
                        /////////////////////////////////////////////////
                      Clear(AdmissionApprovalEntries);
                      AdmissionApprovalEntries.Reset;
                      AdmissionApprovalEntries.SetRange("Document Code",Rec."Document Code");
                      AdmissionApprovalEntries.SetFilter(Approver_Id,'<>%1',UserId);
                      AdmissionApprovalEntries.SetRange(Index,Rec."Index Number");
                      AdmissionApprovalEntries.SetRange("Academic Year",Rec."Academic Year");
                      if AdmissionApprovalEntries.Find('-') then begin
                        // The user Approved The document
                        repeat
                          begin
                        AdmissionApprovalEntries."Approval Status" := AdmissionApprovalEntries."approval status"::Approved;
                        AdmissionApprovalEntries."Approved Date/Time" := CreateDatetime(Today,Time);
                        AdmissionApprovalEntries.Modify;
                        end;
                        until AdmissionApprovalEntries.Next = 0;
                        end;
                        ////////////////////////////////////////////////////////
                      Rec."Approval Status" := Rec."approval status"::Approved;
                      Rec."Approved Date/Time" :=  CreateDatetime(Today,Time);
                      Rec.Approver_Id := UserId;
                      if Rec.Modify then  begin
                        Message(Format(Rec."Document Code")+', approved!');
                        //Set Next Level as ready
                      Clear(AdmissionApprovalEntries);
                      AdmissionApprovalEntries.Reset;
                      AdmissionApprovalEntries.SetRange("Approval Sequence",ACANewStudDocSetup."Next Sequence");
                      AdmissionApprovalEntries.SetRange(Index,Rec."Index Number");
                      AdmissionApprovalEntries.SetRange("Academic Year",Rec."Academic Year");
                      if AdmissionApprovalEntries.Find('-') then begin
                        repeat
                          begin
                        AdmissionApprovalEntries.Validate("Approval Status",AdmissionApprovalEntries."approval status"::Open);
                        AdmissionApprovalEntries.Modify;
                        end;
                        until AdmissionApprovalEntries.Next = 0;
                        end;
                        // Check if Approval Level is final and perform the hard Functions
                        if ACANewStudDocSetup."Final Stage" then begin
                        //- Check if Student has Booked for a room, if yes, check if billing for room is done if room still exists
                        // - If Resident, Check if Payment allow for allocation, pick a room if exists
                        Clear(HostelCode);
                        Clear(ACACharge);
                        ACACharge.Reset;
                        ACACharge.SetRange(Hostel,true);
                        if ACACharge.Find('-') then;// HostelCode := ACACharge.Code;
                        if KUCCPSImports.Accomodation = KUCCPSImports.Accomodation::Resident then begin
                          // Check if Room asigned still exists
                          if KUCCPSImports."Assigned Space" = '' then begin
                            //Student Wanted accomodation but delayted in payment and the routine removed the booking, if rooms still exists, check if fee paid meets the requirement
                            Clear(ACAAdmissionAccomRooms);
                            ACAAdmissionAccomRooms.Reset;
                            ACAAdmissionAccomRooms.SetRange("Allocation Status",ACAAdmissionAccomRooms."allocation status"::Vaccant);
                            ACAAdmissionAccomRooms.SetRange("Academic Year",KUCCPSImports."Academic Year");
                            if ACAAdmissionAccomRooms.Find('-') then begin
                              // A room exists, create a booking for the student
                              KUCCPSImports."Assigned Space" := ACAAdmissionAccomRooms."Space Code";
                              KUCCPSImports."Assigned Block" := ACAAdmissionAccomRooms."Block Code";
                              KUCCPSImports."Assigned Room" := ACAAdmissionAccomRooms."Room Code";
                              if KUCCPSImports.Modify then begin
                                ACAAdmissionAccomRooms."Allocation Status" := ACAAdmissionAccomRooms."allocation status"::Booked;
                                ACAAdmissionAccomRooms.Modify;
                                end;
                              end;
                            end;
                          end;
                          if KUCCPSImports."Assigned Space" <> '' then begin
                            // Create Hostel Charge
                            AdmissionsBillableItems.Init;
                            AdmissionsBillableItems.Index := KUCCPSImports.Index;
                            AdmissionsBillableItems.Admin := KUCCPSImports.Admin;
                            AdmissionsBillableItems."Charge Code" := ACACharge.Code;
                            AdmissionsBillableItems."Charge Amount" := ACACharge.Amount;
                            AdmissionsBillableItems."Charge Description" := 'Accomodation Charges';
                            if AdmissionsBillableItems.Insert then;
                            end else begin
                              // Delete hostel Charge if exists
                              Clear(AdmissionsBillableItems);
                              AdmissionsBillableItems.Reset;
                              AdmissionsBillableItems.SetRange(Index,KUCCPSImports.Index);
                              AdmissionsBillableItems.SetRange(Admin,KUCCPSImports.Admin);
                              AdmissionsBillableItems.SetRange("Charge Code",ACACharge.Code);
                              if AdmissionsBillableItems.Find('-') then begin
                                // The student is not a resident, delete the Accomodation Charge for the student...
                                AdmissionsBillableItems.DeleteAll;
                                end;
                              end;
                            ///  *******************************Populate Non-accomodation charges here*************************************
                            Clear(TuitionFeesAmount);
                            // Tuition Fees
                            ACAFeeByStage.Reset;
                    ACAFeeByStage.SetRange(ACAFeeByStage."Programme Code",KUCCPSImports.Prog);
                    ACAFeeByStage.SetRange(ACAFeeByStage."Stage Code",'Y1S1');
                    ACAFeeByStage.SetRange(ACAFeeByStage."Settlemet Type",'KUCCPS');
                    ACAFeeByStage.SetFilter(ACAFeeByStage."Break Down",'<>%1',0);
                    if not ACAFeeByStage.Find('-') then begin
                    Error('No fees structure defined for the settlement type  - ' + KUCCPSImports.Prog + ' - ' + 'Y1S1');
                    end
                    else begin
                    // Pick Tuition Fees & Update the Charges
                            AdmissionsBillableItems.Init;
                            AdmissionsBillableItems.Index := KUCCPSImports.Index;
                            AdmissionsBillableItems.Admin := KUCCPSImports.Admin;
                            AdmissionsBillableItems."Charge Code" := 'Tuition Fees';
                            AdmissionsBillableItems."Charge Amount" := ACAFeeByStage."Break Down";
                            AdmissionsBillableItems."Charge Description" := 'Tuition Fees';
                            if AdmissionsBillableItems.Insert then;
                            TuitionFeesAmount := ACAFeeByStage."Break Down";
                    end;
                    // Update other Charges
                            ACAStageCharges.Reset;
                            ACAStageCharges.SetRange(ACAStageCharges."Programme Code",KUCCPSImports.Prog);
                            ACAStageCharges.SetRange(ACAStageCharges."Stage Code",'Y1S1');
                            ACAStageCharges.SetRange(ACAStageCharges."Settlement Type",'KUCCPS');
                            ACAStageCharges.SetFilter(ACAStageCharges.Amount,'<>%1',0);
                            if ACAStageCharges.Find('-') then begin
                              repeat
                                begin
                    // Pick charge& Update the Billable Items Table
                            AdmissionsBillableItems.Init;
                            AdmissionsBillableItems.Index := KUCCPSImports.Index;
                            AdmissionsBillableItems.Admin := KUCCPSImports.Admin;
                            AdmissionsBillableItems."Charge Code" := ACAStageCharges.Code;
                            AdmissionsBillableItems."Charge Amount" := ACAFeeByStage."Break Down";
                            AdmissionsBillableItems."Charge Description" := ACAStageCharges.Description;
                            if AdmissionsBillableItems.Insert then;
                                end;
                              until ACAStageCharges.Next = 0;
                            end;
                            // According to Student Funding Category, Generate entries of -ve into the Billable Items table
                              Clear(AdmissionsBillableItems);
                              AdmissionsBillableItems.Reset;
                              AdmissionsBillableItems.SetRange(Index,KUCCPSImports.Index);
                              AdmissionsBillableItems.SetRange(Admin,KUCCPSImports.Admin);
                              AdmissionsBillableItems.SetFilter("Charge Amount",'<%1',0);
                              if AdmissionsBillableItems.Find('-') then begin
                                // Clear the funding entries
                                AdmissionsBillableItems.DeleteAll;
                                end;
                            if KUCCPSImports."Funding Category" <> '' then begin
                            Clear(CategoryFundingSources);
                            CategoryFundingSources.Reset;
                            CategoryFundingSources.SetRange("Category Code",KUCCPSImports."Funding Category");
                            CategoryFundingSources.SetFilter("Funding %",'>0',0);
                            if CategoryFundingSources.Find('-') then begin
                              repeat
                                begin
                    // Pick funding Parameters and Populate into billable Items with -ve Values
                    if TuitionFeesAmount > 0 then begin
                            AdmissionsBillableItems.Init;
                            AdmissionsBillableItems.Index := KUCCPSImports.Index;
                            AdmissionsBillableItems.Admin := KUCCPSImports.Admin;
                            AdmissionsBillableItems."Charge Code" := CategoryFundingSources."Category Code"+'-'+CategoryFundingSources."Funding Source Code";
                            AdmissionsBillableItems."Charge Amount" := -(TuitionFeesAmount*(CategoryFundingSources."Funding %"/100));
                            AdmissionsBillableItems."Charge Description" := CategoryFundingSources."Category Code"+
                            '-'+CategoryFundingSources."Funding Source Code"+
                            ' ('+Format(CategoryFundingSources."Funding %")+')';
                            if AdmissionsBillableItems.Insert then;
                            end;
                                end;
                                until CategoryFundingSources.Next = 0;
                              end;
                            end;
                            // Check if fees is Met and Admit Student
                            KUCCPSImports.CalcFields(Billable_Amount,"Receipt Amount");
                            if KUCCPSImports.Billable_Amount > KUCCPSImports."Receipt Amount" then Error('Fee policy is not met!');
                            //Admit Student
                            AdmitStudent(KUCCPSImports);
                            Clear(Customs);
                            Customs.Reset;
                            Customs.SetRange("No.",KUCCPSImports.Admin);
                            if Customs.Find('-') then begin
                            //Post Receipts for the Student if not yet posted
                            PostReceiptsFromBuffer(Customs);
                            //Post Billing
                            PostStudentcharges(Customs);
                              end;
                            //Allocate a room and post allocation
                            if KUCCPSImports."Assigned Space" <> '' then begin
                              // The student Booked for a space in the halls of residence
                              AllocateStudentHostel(KUCCPSImports);
                              end;
                            //Send Login Credentials to the student via SMS and email
                            SendAdmissionMailsHere(KUCCPSImports);
                            "Approval Comments" := 'Approved';
                        end;
                        end;
                      end;
                end;
            }
            action(RejectDocument)
            {
                ApplicationArea = Basic;
                Caption = 'Reject';
                Image = Reject;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    if Confirm('Reject?',false) = false then Error('Cancelled!');
                    Rec.TestField("Approval Comments");
                end;
            }
        }
    }

    var
        ACANewStudDocSetup: Record UnknownRecord77361;
        AdmissionApprovalEntries: Record UnknownRecord77391;
        KUCCPSImports: Record UnknownRecord70082;
        ACAAdmissionAccomRooms: Record UnknownRecord77364;
        ACACharge: Record UnknownRecord61515;
        AdmissionsBillableItems: Record UnknownRecord77389;
        ACAStageCharges: Record UnknownRecord61533;
        ACAFeeByStage: Record UnknownRecord61523;
        TuitionFeesAmount: Decimal;
        CategoryFundingSources: Record UnknownRecord77388;
        DegreeName1: Text[200];
        DegreeName2: Text[200];
        FacultyName1: Text[200];
        FacultyName2: Text[200];
        NationalityName: Text[200];
        CountryOfOriginName: Text[200];
        Age: Text[200];
        FormerSchoolName: Text[200];
        CustEntry: Record "Cust. Ledger Entry";
        Apps: Record UnknownRecord61358;
        recProgramme: Record UnknownRecord61511;
        FirstChoiceSemesterName: Text[200];
        FirstChoiceStageName: Text[200];
        SecondChoiceSemesterName: Text[200];
        SecondChoiceStageName: Text[200];
        [InDataSet]
        "Principal PassesVisible": Boolean;
        [InDataSet]
        "Subsidiary PassesVisible": Boolean;
        [InDataSet]
        "Mean Grade AcquiredVisible": Boolean;
        [InDataSet]
        "Points AcquiredVisible": Boolean;
        UserMgt: Codeunit "HMS Patient Treatment Mgt";
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,Admission;
        ApprovalEntries: Page "Approval Entries";
        AppSetup: Record UnknownRecord61367;
        SettlmentType: Record UnknownRecord61522;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Admissions: Record UnknownRecord61372;
        ApplicationSubject: Record UnknownRecord61362;
        AdmissionSubject: Record UnknownRecord61375;
        LineNo: Integer;
        PrintAdmission: Boolean;
        MedicalCondition: Record UnknownRecord61379;
        Immunization: Record UnknownRecord61380;
        AdmissionMedical: Record UnknownRecord61376;
        AdmissionImmunization: Record UnknownRecord61378;
        AdmissionFamily: Record UnknownRecord61377;
        FacultyName: Text[30];
        DegreeName: Text[200];
        AgeText: Text[100];
        ReligionName: Text[30];
        HasValue: Boolean;
        Cust: Record Customer;
        CourseRegistration: Record UnknownRecord61532;
        StudentKin: Record UnknownRecord61528;
        AdminKin: Record UnknownRecord61373;
        StudentGuardian: Record UnknownRecord61530;
        [InDataSet]
        "Guardian Full NameEnable": Boolean;
        [InDataSet]
        "Guardian OccupationEnable": Boolean;
        [InDataSet]
        "Spouse NameEnable": Boolean;
        [InDataSet]
        "Spouse Address 1Enable": Boolean;
        [InDataSet]
        "Spouse Address 2Enable": Boolean;
        [InDataSet]
        "Spouse Address 3Enable": Boolean;
        [InDataSet]
        "Family ProblemEnable": Boolean;
        [InDataSet]
        "Health ProblemEnable": Boolean;
        [InDataSet]
        "Overseas ScholarshipEnable": Boolean;
        [InDataSet]
        "Course Not PreferenceEnable": Boolean;
        [InDataSet]
        EmploymentEnable: Boolean;
        [InDataSet]
        "Other ReasonEnable": Boolean;

    local procedure AdmitStudent(ACAAdmImportedJABBuffer: Record UnknownRecord70082)
    var
        ACAApplicFormHeader: Record UnknownRecord61358;
    begin
              Report.Run(51348,false,false,ACAAdmImportedJABBuffer); // Process Admission for Selected Student
              //Admit student
              Clear(ACAApplicFormHeader);
              ACAApplicFormHeader.Reset;
              ACAApplicFormHeader.SetRange("Admission No",ACAAdmImportedJABBuffer.Admin);
              if ACAApplicFormHeader.Find('-') then begin

                ACAApplicFormHeader."Documents Verification Remarks" := 'Approved';
            //    TESTFIELD(County);
             //   TESTFIELD("ID Number");
             //   TESTFIELD("Date Of Birth");

                ACAApplicFormHeader.Status:=ACAApplicFormHeader.Status::Approved;
                ACAApplicFormHeader.Validate(Status);
                ACAApplicFormHeader."Documents Verified":=true;
                ACAApplicFormHeader."Payments Verified":=true;
                ACAApplicFormHeader.Modify;

        TransferToAdmission(ACAApplicFormHeader."Admission No",ACAApplicFormHeader);

                end;
    end;

    local procedure AllocateStudentHostel(KUCCPSImports12: Record UnknownRecord70082)
    var
        ACAStudentsHostelRooms: Record "ACA-Students Hostel Rooms";
        ACAStudentsHostelRooms12: Record "ACA-Students Hostel Rooms";
        userst: Record "User Setup";
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
        "Settlement Type": Record UnknownRecord61522;
    begin
         //Check the Policy
         semz.Reset;
        semz.SetRange(semz."Current Semester",true);
        if semz.Find('-') then;
         ACAStudentsHostelRooms.Init;
         ACAStudentsHostelRooms.Student := KUCCPSImports12.Admin;
         ACAStudentsHostelRooms."Space No" := KUCCPSImports12."Assigned Space";
         ACAStudentsHostelRooms."Room No" := KUCCPSImports12."Assigned Room";
         ACAStudentsHostelRooms."Hostel No" := KUCCPSImports12."Assigned Block";
         ACAStudentsHostelRooms."Academic Year"  := semz."Academic Year";
         ACAStudentsHostelRooms.Semester := semz.Code;
         ACAStudentsHostelRooms.Insert;

        Clear(ACAStudentsHostelRooms12);
        ACAStudentsHostelRooms12.Reset;
        ACAStudentsHostelRooms12.SetRange(Student,KUCCPSImports12.Admin);
        ACAStudentsHostelRooms12.SetRange("Space No",KUCCPSImports12."Assigned Space");
        ACAStudentsHostelRooms12.SetRange("Room No",KUCCPSImports12."Assigned Room");
        ACAStudentsHostelRooms12.SetRange("Hostel No",KUCCPSImports12."Assigned Block");
        ACAStudentsHostelRooms12.SetRange("Academic Year",semz."Academic Year");
        ACAStudentsHostelRooms12.SetRange(Semester,semz.Code);
        if ACAStudentsHostelRooms12.Find('-') then begin
          with ACAStudentsHostelRooms12 do begin
         if KUCCPSImports12."Assigned Space" = '' then exit;
         TestField(Allocated,false);
         if Cust.Get(Student) then begin
            Cust.CalcFields(Cust.Balance);

          CReg.Reset;
          CReg.SetRange(CReg."Student No.",Cust."No.");
          if semz.Find('-') then
          CReg.SetRange(CReg.Semester,semz.Code);
          CReg.SetRange(CReg.Posted,true);
          if CReg.Find('-') then begin  //2
          CReg.CalcFields(CReg."Total Billed");
          if CReg."Total Billed"<>0 then begin  // 1
          if Cust.Balance>(CReg."Total Billed"/2) then Error('Fees payment Accommodation policy error--Balance');
          allocations.Reset;
          allocations.SetRange(allocations.Student,Cust."No.");
          allocations.SetRange(allocations."Hostel No",Cust."Hostel No.");
          allocations.SetRange(allocations."Room No",Cust."Room Code");
          allocations.SetRange(allocations."Space No",Cust."Space Booked");
        //allocations.SETRANGE(allocations."Academic Year","Academic Year");
          allocations.SetRange(allocations.Semester,Cust.Semester);
         // IF Allocations.FIND('-') THEN
         // REPORT.RUN(52017900,TRUE,FALSE,Allocations);
          end else begin  //1
          Error('Fees payment Accommodation policy error --Billing');
          end; //1
          end else begin //2
          Error('Fees payment Accommodation policy error --Registration');
          end; //rec.2
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

            BookRoom(settlementType,ACAStudentsHostelRooms12);
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
         end;
         end;
         end;
    end;

    local procedure PostStudentcharges(custStudent: Record Customer)
    var
        PictureExists: Boolean;
        StudentPayments: Record UnknownRecord61536;
        StudentCharges: Record UnknownRecord61535;
        GenJnl: Record "Gen. Journal Line";
        Stages: Record UnknownRecord61516;
        Units: Record UnknownRecord61517;
        ExamsByStage: Record UnknownRecord61526;
        ExamsByUnit: Record UnknownRecord61527;
        Charges: Record UnknownRecord61515;
        Receipt: Record UnknownRecord61538;
        ReceiptItems: Record UnknownRecord61539;
        GenSetUp: Record UnknownRecord61534;
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
        VATEntry: Record "VAT Entry";
        CReg: Record UnknownRecord61532;
        StudCharges: Record UnknownRecord61535;
        CustLed2: Record "Cust. Ledger Entry";
        Receipt2: Record UnknownRecord61538;
        Cont: Boolean;
        Cust: Record Customer;
        CustPostGroup: Record "Customer Posting Group";
        window: Dialog;
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
        Receipts: Record UnknownRecord61538;
        CustLedg: Record "Cust. Ledger Entry";
        DueDate: Date;
        Sems: Record UnknownRecord61692;
        ChangeLog: Record "Change Log Entry";
        CurrentBal: Decimal;
        Prog: Record UnknownRecord61511;
        "Settlement Type": Record UnknownRecord61522;
        AccPayment: Boolean;
        SettlementType: Code[20];
        SettlementTypes: Record UnknownRecord61522;
    begin
        with custStudent do begin
          //BILLING
        AccPayment:=false;
        Clear(StudentCharges);
        StudentCharges.Reset;
        StudentCharges.SetRange(StudentCharges."Student No.","No.");
        StudentCharges.SetRange(StudentCharges.Recognized,false);
        StudentCharges.SetFilter(StudentCharges.Code,'<>%1','') ;
        if StudentCharges.Find('-') then begin
        //IF NOT CONFIRM('Un-billed charges will be posted. Do you wish to continue?',FALSE) = TRUE THEN
        // ERROR('You have selected to Abort Student Billing');


        SettlementType:='';
        Clear(CReg);
        CReg.Reset;
        CReg.SetFilter(CReg."Settlement Type",'<>%1','');
        CReg.SetRange(CReg."Student No.","No.");
        if CReg.Find('-') then
        SettlementType:=CReg."Settlement Type"
        else
        Error('The Settlement Type Does not Exists in the Course Registration');

        SettlementTypes.Get(SettlementType);
        SettlementTypes.TestField(SettlementTypes."Tuition G/L Account");




        // MANUAL APPLICATION OF ACCOMODATION FOR PREPAYED STUDENTS BY W-Tripple T...//
        if StudentCharges.Count=1 then begin
        CalcFields(Balance);
        if Balance<0 then begin
        if Abs(Balance)>StudentCharges.Amount then begin
        "Application Method":="application method"::Manual;
        AccPayment:=true;
        Modify;
        end;
        end;
        end;

        end;


        //ERROR('TESTING '+FORMAT("Application Method"));

        if Cust.Get("No.") then;

        GenJnl.Reset;
        GenJnl.SetRange("Journal Template Name",'SALES');
        GenJnl.SetRange("Journal Batch Name",'STUD PAY');
        GenJnl.DeleteAll;

        GenSetUp.Get();
        //GenSetUp.TESTFIELD(GenSetUp."Pre-Payment Account");

        //Charge Student if not charged
        StudentCharges.Reset;
        StudentCharges.SetRange(StudentCharges."Student No.","No.");
        StudentCharges.SetRange(StudentCharges.Recognized,false);
        if StudentCharges.Find('-') then begin

        repeat
        if StudentCharges.Amount<>0 then begin
        DueDate:=StudentCharges.Date;
        if Sems.Get(StudentCharges.Semester) then begin
        if Sems.From<>0D then begin
        if Sems.From > DueDate then
        DueDate:=Sems.From;
        end;
        end;


        GenJnl.Init;
        GenJnl."Line No." := GenJnl."Line No." + 10000;
        GenJnl."Posting Date":=Today;
        GenJnl."Document No.":=StudentCharges."Transacton ID";
        GenJnl.Validate(GenJnl."Document No.");
        GenJnl."Journal Template Name":='SALES';
        GenJnl."Journal Batch Name":='STUD PAY';
        GenJnl."Account Type":=GenJnl."account type"::Customer;
        //
        if Cust.Get("No.") then begin
        if Cust."Bill-to Customer No." <> '' then
        GenJnl."Account No.":=Cust."Bill-to Customer No."
        else
        GenJnl."Account No.":="No.";
        end;

        GenJnl.Amount:=StudentCharges.Amount;
        GenJnl.Validate(GenJnl."Account No.");
        GenJnl.Validate(GenJnl.Amount);
        GenJnl.Description:=CopyStr(StudentCharges.Description,1,50);
        GenJnl."Bal. Account Type":=GenJnl."account type"::"G/L Account";

        if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Stage Fees") and
           (StudentCharges.Charge = false) then begin
        GenJnl."Bal. Account No.":=SettlementTypes."Tuition G/L Account";

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
        GenJnl."Bal. Account No.":=SettlementTypes."Tuition G/L Account";


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
        if Charges.Get(StudentCharges.Code) then
        GenJnl."Bal. Account No.":=Charges."G/L Account";
        end;


        GenJnl.Validate(GenJnl."Bal. Account No.");
        GenJnl."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
        if Prog.Get(StudentCharges.Programme) then begin
        Prog.TestField(Prog."Department Code");
        GenJnl."Shortcut Dimension 2 Code":=Prog."Department Code";
        end;



        GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
        GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
        GenJnl."Due Date":=DueDate;
        GenJnl.Validate(GenJnl."Due Date");
        if StudentCharges."Recovery Priority" <> 0 then
        GenJnl."Recovery Priority":=StudentCharges."Recovery Priority"
        else
        GenJnl."Recovery Priority":=25;
        GenJnl.Insert;

        //Distribute Money
        if StudentCharges."Tuition Fee" = true then begin
        if Stages.Get(StudentCharges.Programme,StudentCharges.Stage) then begin
        if (Stages."Distribution Full Time (%)" > 0) or (Stages."Distribution Part Time (%)" > 0) then begin
        Stages.TestField(Stages."Distribution Account");
        StudentCharges.TestField(StudentCharges.Distribution);
        if Cust.Get("No.") then begin
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
        GenJnl."Account No.":=SettlementTypes."Tuition G/L Account";
        GenJnl.Amount:=StudentCharges.Amount * (StudentCharges.Distribution/100);
        GenJnl.Validate(GenJnl."Account No.");
        GenJnl.Validate(GenJnl.Amount);
        GenJnl.Description:='Fee Distribution';
        GenJnl."Bal. Account Type":=GenJnl."bal. account type"::"G/L Account";
        //GenJnl."Bal. Account No.":=Stages."Distribution Account";

        StudentCharges.CalcFields(StudentCharges."Settlement Type");
        SettlementTypes.Get(StudentCharges."Settlement Type");
        GenJnl."Bal. Account No.":=SettlementTypes."Tuition G/L Account";

        GenJnl.Validate(GenJnl."Bal. Account No.");
        GenJnl."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
        if Prog.Get(StudentCharges.Programme) then begin
        Prog.TestField(Prog."Department Code");
        GenJnl."Shortcut Dimension 2 Code":=Prog."Department Code";
        end;

        GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
        GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");

        GenJnl.Insert;

        end;
        end;
        end;
        end else begin
        //Distribute Charges
        if StudentCharges.Distribution > 0 then begin
        StudentCharges.TestField(StudentCharges."Distribution Account");
        if Charges.Get(StudentCharges.Code) then begin
        Charges.TestField(Charges."G/L Account");
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
        GenJnl."Bal. Account No.":=Charges."G/L Account";
        GenJnl.Validate(GenJnl."Bal. Account No.");
        GenJnl."Shortcut Dimension 1 Code":="Global Dimension 1 Code";

        if Prog.Get(StudentCharges.Programme) then begin
        Prog.TestField(Prog."Department Code");
        GenJnl."Shortcut Dimension 2 Code":=Prog."Department Code";
        end;
        GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
        GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
        GenJnl.Insert;

        end;
        end;
        end;
        //End Distribution


        StudentCharges.Recognized:=true;
        StudentCharges.Modify;
        //.......BY W-Tripple T
        StudentCharges.Posted:=true;
        StudentCharges.Modify;

        CReg.Posted:=true;
        CReg.Modify;


        //.....END W-Tripple T
        end;
        until StudentCharges.Next = 0;



        //Post New
        GenJnl.Reset;
        GenJnl.SetRange("Journal Template Name",'SALES');
        GenJnl.SetRange("Journal Batch Name",'STUD PAY');
        if GenJnl.Find('-') then begin
        Codeunit.Run(Codeunit::"Gen. Jnl.-Post Bill",GenJnl);
        end;

        //Post New


        "Application Method":="application method"::"Apply to Oldest";
        Cust.Status:=Cust.Status::Current;
        Cust.Modify;

        end;


        //BILLING

        StudentPayments.Reset;
        StudentPayments.SetRange(StudentPayments."Student No.","No.");
        if StudentPayments.Find('-') then
        StudentPayments.DeleteAll;


        StudentPayments.Reset;
        StudentPayments.SetRange(StudentPayments."Student No.","No.");
        if AccPayment=true then begin
         if Cust.Get("No.") then
         Cust."Application Method":=Cust."application method"::"Apply to Oldest";
         Cust. Modify;
        end;
          end;
    end;

    local procedure PostReceiptsFromBuffer(CustStudent4Receipting: Record Customer)
    var
        CoreBankingDetails: Record Core_Banking_Details;
        ACAStudentReceipts: Record UnknownRecord61536;
        ACACourseRegistration: Record UnknownRecord61532;
        ACAStudentReceipts2: Record UnknownRecord61536;
    begin
        Clear(ACACourseRegistration);
        ACACourseRegistration.Reset;
        ACACourseRegistration.SetRange("Student No.",CustStudent4Receipting."No.");
        ACACourseRegistration.SetRange(Reversed,false);
        if ACACourseRegistration.Find('-') then;
        Clear(CoreBankingDetails);
        CoreBankingDetails.Reset;
        CoreBankingDetails.SetRange("Student No.",CustStudent4Receipting."No.");
        CoreBankingDetails.SetRange(Posted,false);
        if CoreBankingDetails.Find('-') then begin
          repeat
            begin
            ACAStudentReceipts.Init;
            ACAStudentReceipts."Student No." := CoreBankingDetails."Student No.";
            ACAStudentReceipts."User ID" := UserId;
            ACAStudentReceipts."Cheque No" := CoreBankingDetails."Transaction Number";
            ACAStudentReceipts."Drawer Name" := 'AUTO';
           // ACAStudentReceipts."Drawer Bank" := ACAStudentReceipts."Drawer Bank"::;
            ACAStudentReceipts."Amount to pay" := CoreBankingDetails."Trans. Amount";
            ACAStudentReceipts."Payment Mode" := ACAStudentReceipts."payment mode"::"Bank Slip";
            ACAStudentReceipts.Programme := ACACourseRegistration.Programme;
            ACAStudentReceipts."Bank No." := CoreBankingDetails.Bank_Code;
            ACAStudentReceipts."Payment By" := CoreBankingDetails."Student No.";
            ACAStudentReceipts."Bank Slip Date" := CoreBankingDetails."Transaction Date";
            ACAStudentReceipts."Transaction Date" := CoreBankingDetails."Transaction Date";
            ACAStudentReceipts."Auto Post" := true;
            ACAStudentReceipts.Semester := ACACourseRegistration.Semester;
            ACAStudentReceipts.Insert;
            Clear(ACAStudentReceipts2);
            ACAStudentReceipts2.Reset;
            ACAStudentReceipts2.SetRange("Student No.",CoreBankingDetails."Student No.");
            ACAStudentReceipts2.SetRange("Cheque No",CoreBankingDetails."Transaction Number");
            ACAStudentReceipts2.SetRange(Semester,ACACourseRegistration.Semester);
            if ACAStudentReceipts2.Find('-') then
            Post(ACAStudentReceipts2);
            CoreBankingDetails.Posted:=true;
            CoreBankingDetails."Posting Status" := CoreBankingDetails."posting status"::Posted;
            CoreBankingDetails.Modify;
            end;
            until CoreBankingDetails.Next = 0;
          end;
    end;


    procedure GetCountry(var CountryCode: Code[20]) CountryName: Text[100]
    var
        Country: Record "Country/Region";
    begin
        /*This function gets the country name from the database and returns the resultant string value*/
        Country.Reset;
        if Country.Get(CountryCode) then
          begin
            CountryName:=Country.Name;
          end
        else
          begin
            CountryName:='';
          end;

    end;


    procedure GetDegree1(var DegreeCode: Code[20]) DegreeName: Text[100]
    var
        Programme: Record UnknownRecord61511;
    begin
        /*This function gets the programme name and returns the resultant string*/
        Programme.Reset;
        if Programme.Get(DegreeCode) then
          begin
            DegreeName:=Programme.Description;
          end
        else
          begin
            DegreeName:='';
          end;

    end;


    procedure GetFaculty(var DegreeCode: Code[20]) FacultyName: Text[100]
    var
        Programme: Record UnknownRecord61511;
        DimVal: Record "Dimension Value";
    begin
        /*The function gets and returns the faculty name to the calling client*/
        FacultyName:='';
        Programme.Reset;
        if Programme.Get(DegreeCode) then
          begin
            DimVal.Reset;
            DimVal.SetRange(DimVal."Dimension Code",'FACULTY');
        //    DimVal.SETRANGE(DimVal.Code,Programme."Base Date");
            if DimVal.Find('-') then
              begin
                FacultyName:=DimVal.Name;
              end;
          end;

    end;


    procedure GetAge(var StartDate: Date) AgeText: Text[100]
    var
        HrDates: Codeunit "HR Dates";
    begin
        /*This function gets the age of the applicant and returns the resultant age to the calling client*/
        AgeText:='';
        if StartDate=0D then begin StartDate:=Today end;
        AgeText := HrDates.DetermineAge(StartDate,Today);

    end;


    procedure GetFormerSchool(var FormerSchoolCode: Code[20]) FormerSchoolName: Text[30]
    var
        FormerSchool: Record UnknownRecord61366;
    begin
        /*This function gets the description of the former school and returns the result to the calling client*/
        FormerSchool.Reset;
        FormerSchoolName:='';
        if FormerSchool.Get(FormerSchoolCode) then
          begin
            FormerSchoolName:=FormerSchool.Description;
          end;

    end;

    local procedure OnAfterGetCurrRecord()
    begin
        // // // // xRec := Rec;
        // // // // Age:=GetAge("Date Of Birth");
        // // // // NationalityName:=GetCountry(Nationality);
        // // // // CountryOfOriginName:=GetCountry("Country of Origin");
        // // // // DegreeName1:=GetDegree1("First Degree Choice");
        // // // // DegreeName2:=GetDegree1("Second Degree Choice");
        // // // // FacultyName1:=GetFaculty("First Degree Choice");
        // // // // FacultyName2:=GetFaculty("Second Degree Choice");
        // // // // FormerSchoolName:=GetFormerSchool("Former School Code");
        // // // // IF (Examination=Examination::KCSE) OR (Examination=Examination::KCE) OR (Examination=Examination::EACE) THEN
        // // // //  BEGIN
        // // // //    "Principal PassesVisible" :=FALSE;
        // // // //    "Subsidiary PassesVisible" :=FALSE;
        // // // //    "Mean Grade AcquiredVisible" :=TRUE;
        // // // //    "Points AcquiredVisible" :=TRUE;
        // // // //  END
        // // // // ELSE
        // // // //  BEGIN
        // // // //    "Principal PassesVisible" :=TRUE;
        // // // //    "Subsidiary PassesVisible" :=TRUE;
        // // // //    "Mean Grade AcquiredVisible" :=FALSE;
        // // // //    "Points AcquiredVisible" :=FALSE;
        // // // //  END;
    end;


    procedure GetStageName(var StageCode: Code[20]) StageName: Text[200]
    var
        Stage: Record UnknownRecord61516;
    begin
        Stage.Reset;
        Stage.SetRange(Stage.Code,StageCode);
        if Stage.Find('-') then
          begin
            StageName:=Stage.Description;
          end;
    end;


    procedure GetSemesterName(var SemesterCode: Code[20]) SemesterName: Text[200]
    var
        Semester: Record UnknownRecord61692;
    begin
        Semester.Reset;
        Semester.SetRange(Semester.Code,SemesterCode);
        if Semester.Find('-') then
          begin
            SemesterName:=Semester.Description;
          end;
    end;


    procedure GetCounty(var CountyCode: Code[20]) CountyName: Text[100]
    var
        CountySetup: Record UnknownRecord61365;
    begin
        /*This function gets the county name from the database and returns the resultant string value*/
        CountySetup.Reset;
        if CountySetup.Get(CountyCode) then
          begin
            CountyName:=CountySetup.Description;
          end
        else
          begin
            CountyName:='';
          end;

    end;


    procedure TransferToAdmission(var AdmissionNumber: Code[20];ApplicationFormHeader: Record UnknownRecord61358)
    begin
        /*This function transfers the fieldsin the application to the fields in the admissions table*/
        /*Get the new admission code for the selected application*/
        with ApplicationFormHeader do begin
        TestField("Settlement Type");
        SettlmentType.Get("Settlement Type");
        //IF AdmissionNumber='' THEN BEGIN
           Cust.Init;
                Cust."No.":=ApplicationFormHeader."Admission No";
                Cust.Name:=CopyStr(ApplicationFormHeader.Surname + ' ' + ApplicationFormHeader."Other Names",1,80);
                Cust."Search Name":=UpperCase(CopyStr(ApplicationFormHeader.Surname + ' ' + ApplicationFormHeader."Other Names",1,80));
                Cust.Address:=ApplicationFormHeader."Address for Correspondence1";
                if ApplicationFormHeader."Address for Correspondence3"<>'' then
                Cust."Address 2":=CopyStr(ApplicationFormHeader."Address for Correspondence2" + ',' +  ApplicationFormHeader."Address for Correspondence3",1,30);
                if ApplicationFormHeader."Telephone No. 2"<>'' then
                Cust."Phone No.":=ApplicationFormHeader."Telephone No. 1" + ',' + ApplicationFormHeader."Telephone No. 2";
              //  Cust."Telex No.":=ApplicationFormHeader."Fax No.";
                Cust."E-Mail":=ApplicationFormHeader.Email;
                Cust.Gender:=ApplicationFormHeader.Gender;
                Cust."Date Of Birth":=ApplicationFormHeader."Date Of Birth";
                Cust."Date Registered":=Today;
                Cust."Customer Type":=Cust."customer type"::Student;
        //        Cust."Student Type":=FORMAT(Enrollment."Student Type");
        Cust."Date Of Birth":=ApplicationFormHeader."Date Of Birth";
               // Cust."ID No":=ApplicationFormHeader."ID Number";
                Cust."Application No." :=ApplicationFormHeader."Admission No";
                Cust."Marital Status":=ApplicationFormHeader."Marital Status";
                Cust.Citizenship:=Format(ApplicationFormHeader.Nationality);
                Cust."Current Programme":=ApplicationFormHeader."Admitted Degree";
                Cust."Current Semester":=ApplicationFormHeader."Admitted Semester";
                Cust."Current Stage":=ApplicationFormHeader."Admitted To Stage";
               // Cust.Religion:=FORMAT(ApplicationFormHeader.Religion);
                Cust."Application Method":=Cust."application method"::"Apply to Oldest";
                Cust."Customer Posting Group":='STUDENT';
                Cust.Validate(Cust."Customer Posting Group");
                Cust."ID No":=ApplicationFormHeader."ID Number";
                Cust.Password:=ApplicationFormHeader."ID Number";
                Cust."Changed Password":=true;
                Cust."Global Dimension 1 Code":=ApplicationFormHeader.Campus;
                Cust.County:=ApplicationFormHeader.County;
                Cust.Status:=Cust.Status::Registration;
                Cust.Insert();
        
        ////////////////////////////////////////////////////////////////////////////////////////
        
        
          Cust.Reset;
          Cust.SetRange("No.",ApplicationFormHeader."Admission No");
          //Customer.SETFILTER("Date Registered",'=%1',TODAY);
          if Cust.Find('-') then begin
                Cust.Status:=Cust.Status::"New Admission";
            if ApplicationFormHeader.Gender=ApplicationFormHeader.Gender::Female then begin
              Cust.Gender:=Cust.Gender::Female;
              end else begin
                 Cust.Gender:=Cust.Gender::Male;
                end;
                Cust.Modify;
                end;
        
         Cust.Reset;
          Cust.SetRange("No.",ApplicationFormHeader."Admission No");
          Cust.SetFilter("Date Registered",'=%1',Today);
          if Cust.Find('-') then begin
          CourseRegistration.Reset;
          CourseRegistration.SetRange("Student No.",ApplicationFormHeader."Admission No");
          CourseRegistration.SetRange("Settlement Type",ApplicationFormHeader."Settlement Type");
          CourseRegistration.SetRange(Programme,ApplicationFormHeader."First Degree Choice");
          CourseRegistration.SetRange(Semester,ApplicationFormHeader."Admitted Semester");
          if not CourseRegistration.Find('-') then begin
                    CourseRegistration.Init;
                       CourseRegistration."Reg. Transacton ID":='';
                       CourseRegistration.Validate(CourseRegistration."Reg. Transacton ID");
                       CourseRegistration."Student No.":=ApplicationFormHeader."Admission No";
                       CourseRegistration.Programme:=ApplicationFormHeader."Admitted Degree";
                       CourseRegistration.Semester:=ApplicationFormHeader."Admitted Semester";
                       CourseRegistration.Stage:=ApplicationFormHeader."Admitted To Stage";
                       CourseRegistration."Year Of Study":=1;
                       CourseRegistration."Student Type":=CourseRegistration."student type"::"Full Time";
                       CourseRegistration."Registration Date":=Today;
                       CourseRegistration."Settlement Type":=ApplicationFormHeader."Settlement Type";
                       CourseRegistration."Academic Year":=GetCurrYear();
                       CourseRegistration.Insert;
                  CourseRegistration.Reset;
                  CourseRegistration.SetRange("Student No.",ApplicationFormHeader."Admission No");
                  CourseRegistration.SetRange("Settlement Type",ApplicationFormHeader."Settlement Type");
                  CourseRegistration.SetRange(Programme,ApplicationFormHeader."First Degree Choice");
                  CourseRegistration.SetRange(Semester,ApplicationFormHeader."Admitted Semester");
          if  CourseRegistration.Find('-') then begin
                    CourseRegistration."Settlement Type":=ApplicationFormHeader."Settlement Type";
                    CourseRegistration.Validate(CourseRegistration."Settlement Type");
                    CourseRegistration."Academic Year":=GetCurrYear();
                    CourseRegistration."Registration Date":=Today;
                    CourseRegistration.Validate(CourseRegistration."Registration Date");
                    CourseRegistration.Modify;
                    end;
                    end else begin
                        CourseRegistration.Reset;
          CourseRegistration.SetRange("Student No.",ApplicationFormHeader."Admission No");
          CourseRegistration.SetRange("Settlement Type",ApplicationFormHeader."Settlement Type");
          CourseRegistration.SetRange(Programme,ApplicationFormHeader."First Degree Choice");
          CourseRegistration.SetRange(Semester,ApplicationFormHeader."Admitted Semester");
          CourseRegistration.SetFilter(Posted,'=%1',false);
          if  CourseRegistration.Find('-') then begin
                    CourseRegistration."Settlement Type":=ApplicationFormHeader."Settlement Type";
                    CourseRegistration.Validate(CourseRegistration."Settlement Type");
                    CourseRegistration."Academic Year":=GetCurrYear();
                    CourseRegistration."Registration Date":=Today;
                    CourseRegistration.Validate(CourseRegistration."Registration Date");
                    CourseRegistration.Modify;
        
                    end;
                      end;
                    end;
        
        ////////////////////////////////////////////////////////////////////////////////////////
        
        /*Get the record and transfer the details to the admissions database*/
        //ERROR('TEST- '+NewAdminCode);
            /*Transfer the details into the admission database table*/
              Init;
                Admissions."Admission No.":=AdmissionNumber;
                Admissions.Validate("Admission No.");
                Admissions.Date:=Today;
                Admissions."Application No.":=ApplicationFormHeader."Application No.";
                Admissions."Admission Type":=ApplicationFormHeader."Settlement Type";
                Admissions."Academic Year":=ApplicationFormHeader."Academic Year";
                Admissions.Surname:=ApplicationFormHeader.Surname;
                Admissions."Other Names":=ApplicationFormHeader."Other Names";
                Admissions.Status:=Admissions.Status::Admitted;
                Admissions."Degree Admitted To":=ApplicationFormHeader."Admitted Degree";
                Admissions.Validate("Degree Admitted To");
                Admissions."Date Of Birth":=ApplicationFormHeader."Date Of Birth";
                Admissions.Gender:=ApplicationFormHeader.Gender+1;
                Admissions."Marital Status":=ApplicationFormHeader."Marital Status";
                Admissions.County:=ApplicationFormHeader.County;
                Admissions.Campus:=ApplicationFormHeader.Campus;
                Admissions.Nationality:=ApplicationFormHeader.Nationality;
                Admissions."Correspondence Address 1":=ApplicationFormHeader."Address for Correspondence1";
                Admissions."Correspondence Address 2":=ApplicationFormHeader."Address for Correspondence2";
                Admissions."Correspondence Address 3":=ApplicationFormHeader."Address for Correspondence3";
                Admissions."Telephone No. 1":=ApplicationFormHeader."Telephone No. 1";
               Admissions."Telephone No. 2":=ApplicationFormHeader."Telephone No. 2";
                Admissions."Former School Code":=ApplicationFormHeader."Former School Code";
                Admissions."Index Number":=ApplicationFormHeader."Index Number";
                Admissions."Stage Admitted To":=ApplicationFormHeader."Admitted To Stage";
                Admissions."Semester Admitted To":= ApplicationFormHeader."Admitted Semester";
                Admissions."Settlement Type":=ApplicationFormHeader."Settlement Type";
                Admissions."Intake Code":=ApplicationFormHeader."Intake Code";
                Admissions."ID Number":=ApplicationFormHeader."ID Number";
                Admissions."E-Mail":=ApplicationFormHeader.Email;
               // Admissions."Telephone No. 1":=ApplicationFormHeader."Telephone No. 1";
               // Admissions."Telephone No. 2":=ApplicationFormHeader."Telephone No. 1";
              Admissions.Insert();
                ApplicationFormHeader."Admission No":=AdmissionNumber;
        /*Get the subject details and transfer the  same to the admissions subject*/
        ApplicationSubject.Reset;
        ApplicationSubject.SetRange(ApplicationSubject."Application No.",ApplicationFormHeader."Application No.");
        if ApplicationSubject.Find('-') then
          begin
            /*Get the last number in the admissions table*/
            AdmissionSubject.Reset;
            if AdmissionSubject.Find('+') then
              begin
                LineNo:=AdmissionSubject."Line No."+1;
              end
            else
              begin
                LineNo:=1;
              end;
        
          /*Insert the new records into the database table*/
          repeat
            with AdmissionSubject do
              begin
                Init;
                "Line No.":=LineNo +1;
                "Admission No.":=AdmissionNumber;
                "Subject Code":=ApplicationSubject."Subject Code";
                Grade:=Grade;
                Insert();
                LineNo:=LineNo + 1;
              end;
           until ApplicationSubject.Next=0;
          end;
        /*Insert the medical conditions into the admission database table containing the medical condition*/
        MedicalCondition.Reset;
        MedicalCondition.SetRange(MedicalCondition.Mandatory,true);
        if MedicalCondition.Find('-') then
          begin
            /*Get the last line number from the medical condition table for the admissions module*/
            AdmissionMedical.Reset;
            if AdmissionMedical.Find('+') then
              begin
                LineNo:=AdmissionMedical."Line No."+1;
              end
            else
              begin
                LineNo:=1;
              end;
            AdmissionMedical.Reset;
            /*Loop thru the medical conditions*/
            repeat
              AdmissionMedical.Init;
                AdmissionMedical."Line No.":=LineNo+ 1;
                AdmissionMedical."Admission No.":= AdmissionNumber;
                AdmissionMedical."Medical Condition Code":=MedicalCondition.Code;
              AdmissionMedical.Insert();
                LineNo:=LineNo +1;
            until MedicalCondition.Next=0;
          end;
        /*Insert the details into the family table*/
        MedicalCondition.Reset;
        MedicalCondition.SetRange(MedicalCondition.Mandatory,true);
        MedicalCondition.SetRange(MedicalCondition.Family,true);
        if MedicalCondition.Find('-') then
          begin
            /*Get the last number in the family table*/
            AdmissionFamily.Reset;
            if AdmissionFamily.Find('+') then
              begin
                LineNo:=AdmissionFamily."Line No.";
              end
            else
              begin
                LineNo:=0;
              end;
            repeat
              AdmissionFamily.Init;
                AdmissionFamily."Line No.":=LineNo + 1;
                AdmissionFamily."Medical Condition Code":=MedicalCondition.Code;
                AdmissionFamily."Admission No.":= AdmissionNumber ;
              AdmissionFamily.Insert();
              LineNo:=LineNo +1;
            until MedicalCondition.Next=0;
          end;
        
        /*Insert the immunization details into the database*/
        Immunization.Reset;
        //Immunization.SETRANGE(Immunization.Mandatory,TRUE);
        if Immunization.Find('-') then
          begin
            /*Get the last line number from the database*/
            AdmissionImmunization.Reset;
            if AdmissionImmunization.Find('+') then
              begin
                LineNo:=AdmissionImmunization."Line No."+1;
              end
            else
              begin
                LineNo:=1;
              end;
           /*loop thru the immunizations table adding the details into the admissions table for immunizations*/
           repeat
            AdmissionImmunization.Init;
              AdmissionImmunization."Line No.":=LineNo + 1;
              AdmissionImmunization."Admission No.":= AdmissionNumber ;
              AdmissionImmunization."Immunization Code":=Immunization.Code;
            AdmissionImmunization.Insert();
           until Immunization.Next=0;
          end;
        
        TakeStudentToRegistration(AdmissionNumber);
        end;

    end;


    procedure TakeStudentToRegistration(var AdmissNo: Code[20])
    begin
        Admissions.Reset;
        Admissions.SetRange("Admission No.",AdmissNo);
        if Admissions.Find('-') then begin
                  /*  Cust.INIT;
                Cust."No.":=Admissions."Admission No.";
                Cust.Name:=COPYSTR(Admissions.Surname + ' ' + Admissions."Other Names",1,30);
                Cust."Search Name":=UPPERCASE(COPYSTR(Admissions.Surname + ' ' + Admissions."Other Names",1,30));
                Cust.Address:=Admissions."Correspondence Address 1";
                Cust."Address 2":=COPYSTR(Admissions."Correspondence Address 2" + ',' +  Admissions."Correspondence Address 3",1,30);
                Cust."Phone No.":=Admissions."Telephone No. 1" + ',' + Admissions."Telephone No. 2";
                Cust."Telex No.":=Admissions."Fax No.";
                Cust."E-Mail":=Admissions."E-Mail";
                Cust.Gender:=Admissions.Gender;
                Cust."Date Of Birth":=Admissions."Date Of Birth";
                Cust."Date Registered":=TODAY;
                Cust."Customer Type":=Cust."Customer Type"::Student;
        //        Cust."Student Type":=FORMAT(Enrollment."Student Type");
        Cust."Date Of Birth":=Admissions."Date Of Birth";
                Cust."ID No":=ApplicationFormHeader."ID Number";
                Cust."Application No." :=Admissions."Admission No.";
                Cust."Marital Status":=Admissions."Marital Status";
                Cust.Citizenship:=FORMAT(Admissions.Nationality);
                Cust.Religion:=FORMAT(Admissions.Religion);
                Cust."Application Method":=Cust."Application Method"::"Apply to Oldest";
                Cust."Customer Posting Group":='STUDENT';
                Cust.VALIDATE(Cust."Customer Posting Group");
                Cust."ID No":=Admissions."ID Number";
                Cust."Global Dimension 1 Code":=Admissions.Campus;
                Cust.County:=Admissions.County;
                Cust.INSERT();
                */
        
        
        
        
                //insert the details related to the next of kin of the student into the database
                    AdminKin.Reset;
                    AdminKin.SetRange(AdminKin."Admission No.",Admissions."Admission No.");
                    if AdminKin.Find('-') then
                        begin
                            repeat
                                StudentKin.Reset;
                                StudentKin.Init;
                                    StudentKin."Student No":=Admissions."Admission No.";
                                    StudentKin.Relationship:=AdminKin.Relationship;
                                    StudentKin.Name:=AdminKin."Full Name";
                                    //StudentKin."Other Names":=EnrollmentNextofKin."Other Names";
                                    //StudentKin."ID No/Passport No":=EnrollmentNextofKin."ID No/Passport No";
                                    //StudentKin."Date Of Birth":=EnrollmentNextofKin."Date Of Birth";
                                    //StudentKin.Occupation:=EnrollmentNextofKin.Occupation;
                                    StudentKin."Office Tel No":=AdminKin."Telephone No. 1";
                                    StudentKin."Home Tel No":=AdminKin."Telephone No. 2";
                                    //StudentKin.Remarks:=EnrollmentNextofKin.Remarks;
                                StudentKin.Insert;
                            until AdminKin.Next=0;
                        end;
        
                //insert the details in relation to the guardian/sponsor into the database in relation to the current student
                if Admissions."Mother Alive Or Dead"=Admissions."mother alive or dead"::Alive then
                        begin
                         if Admissions."Mother Full Name"<>'' then begin
                          StudentGuardian.Reset;
                          StudentGuardian.Init;
                          StudentGuardian."Student No.":=Admissions."Admission No.";
                          StudentGuardian.Names:=Admissions."Mother Full Name";
                          StudentGuardian.Insert;
                          end;
                        end;
                if Admissions."Father Alive Or Dead"=Admissions."father alive or dead"::Alive then
                        begin
                        if Admissions."Father Full Name"<>'' then begin
                          StudentGuardian.Reset;
                          StudentGuardian.Init;
                          StudentGuardian."Student No.":=Admissions."Admission No.";
                          StudentGuardian.Names:=Admissions."Father Full Name";
                          StudentGuardian.Insert;
                          end;
                        end;
                if Admissions."Guardian Full Name"<>'' then
                        begin
                        if Admissions."Guardian Full Name"<>'' then begin
                          StudentGuardian.Reset;
                          StudentGuardian.Init;
                          StudentGuardian."Student No.":=Admissions."Admission No.";
                          StudentGuardian.Names:=Admissions."Guardian Full Name";
                          StudentGuardian.Insert;
                          end;
                        end;
        
        /*
        
                //insert the details in relation to the student history as detailed in the application
                    EnrollmentEducationHistory.RESET;
                    EnrollmentEducationHistory.SETRANGE(EnrollmentEducationHistory."Enquiry No.",Enrollment."Enquiry No.");
                    IF EnrollmentEducationHistory.FIND('-') THEN
                        BEGIN
                            REPEAT
                                EducationHistory.RESET;
                                EducationHistory.INIT;
                                    EducationHistory."Student No.":=ApplicationFormHeader."No.";
                                    EducationHistory.From:=EnrollmentEducationHistory.From;
                                    EducationHistory."To":=EnrollmentEducationHistory."To";
                                    EducationHistory.Qualifications:=EnrollmentEducationHistory.Qualifications;
                                    EducationHistory.Instituition:=EnrollmentEducationHistory.Instituition;
                                    EducationHistory.Remarks:=EnrollmentEducationHistory.Remarks;
                                    EducationHistory."Aggregate Result/Award":=EnrollmentEducationHistory."Aggregate Result/Award";
                                EducationHistory.INSERT;
                            UNTIL EnrollmentEducationHistory.NEXT=0;
                        END;
                //update the status of the application
                    Enrollment."Registration No":=ApplicationFormHeader."No.";
                    Enrollment.Status:=Enrollment.Status::Admitted;
                    Enrollment.MODIFY;
        
         */
        end;

    end;


    procedure GetSchoolName(var SchoolCode: Code[20];var SchoolName: Text[30])
    var
        FormerSchool: Record UnknownRecord61366;
    begin
        /*Get the former school name and display the results*/
        FormerSchool.Reset;
        SchoolName:='';
        if FormerSchool.Get(SchoolCode) then
          begin
            SchoolName:=FormerSchool.Description;
          end;

    end;


    procedure GetDegreeName(var DegreeCode: Code[20];var DegreeName: Text[200])
    var
        Programme: Record UnknownRecord61511;
    begin
        /*get the degree name and display the results*/
        Programme.Reset;
        DegreeName:='';
        if Programme.Get(DegreeCode) then
          begin
            DegreeName:=Programme.Description;
          end;

    end;


    procedure GetFacultyName(var DegreeCode: Code[20];var FacultyName: Text[30])
    var
        Programme: Record UnknownRecord61511;
        DimVal: Record "Dimension Value";
    begin
        /*Get the faculty name and return the result*/
        Programme.Reset;
        FacultyName:='';
        
        if Programme.Get(DegreeCode) then
          begin
            DimVal.Reset;
            DimVal.SetRange(DimVal."Dimension Code",'FACULTY');
            DimVal.SetRange(DimVal.Code,Programme.Faculty);
            if DimVal.Find('-') then
              begin
                FacultyName:=DimVal.Name;
              end;
          end;

    end;


    procedure GetReligionName(var ReligionCode: Code[20];var ReligionName: Text[30])
    var
        Religion: Record UnknownRecord61658;
    begin
        /*Get the religion name and display the result*/
        Religion.Reset;
        Religion.SetRange(Religion."Title Code",ReligionCode);
        Religion.SetRange(Religion.Category,Religion.Category::Religions);
        
        ReligionName:='';
        if Religion.Find('-') then
          begin
            ReligionName:=Religion.Description;
          end;

    end;


    procedure GetCurrYear() CurrYear: Text
    var
        acadYear: Record UnknownRecord61382;
    begin
        acadYear.Reset;
        acadYear.SetRange(acadYear.Current,true);
        if acadYear.Find('-') then begin
          CurrYear:=acadYear.Code;
        end else Error('No current academic year specified.');
    end;

    local procedure Post(ACAStdPayments: Record UnknownRecord61536)
    var
        cust2: Record Customer;
        StudentCharges: Record UnknownRecord61535;
        GenJnl: Record "Gen. Journal Line";
        Stages: Record UnknownRecord61516;
        Units: Record UnknownRecord61517;
        ExamsByStage: Record UnknownRecord61526;
        ExamsByUnit: Record UnknownRecord61527;
        Charges: Record UnknownRecord61515;
        Receipt: Record UnknownRecord61538;
        ReceiptItems: Record UnknownRecord61539;
        GenSetUp: Record UnknownRecord61534;
        TotalApplied: Decimal;
        Sems: Record UnknownRecord61692;
        DueDate: Date;
        Cust: Record Customer;
        CustPostGroup: Record "Customer Posting Group";
        window: Dialog;
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
        Receipts: Record UnknownRecord61538;
        CReg: Record UnknownRecord61532;
        CustLedg: Record "Cust. Ledger Entry";
        StudentPay: Record UnknownRecord61536;
        ProgrammeSetUp: Record UnknownRecord61511;
        CourseReg: Code[20];
        LastReceiptNo: Code[20];
        "No. Series Line": Record "No. Series Line";
        "Last No": Code[20];
        Prog: Record UnknownRecord61511;
        BankRec: Record "Bank Account";
        [InDataSet]
        "Amount to payEnable": Boolean;
        [InDataSet]
        "Cheque NoEnable": Boolean;
        [InDataSet]
        "Drawer NameEnable": Boolean;
        [InDataSet]
        "Bank No.Enable": Boolean;
        [InDataSet]
        "Bank Slip DateEnable": Boolean;
        [InDataSet]
        "Applies to Doc NoEnable": Boolean;
        [InDataSet]
        "Apply to OverpaymentEnable": Boolean;
        [InDataSet]
        "CDF AccountEnable": Boolean;
        [InDataSet]
        "CDF DescriptionEnable": Boolean;
        [InDataSet]
        ApplicationEnable: Boolean;
        [InDataSet]
        "Unref. Entry No.Enable": Boolean;
        [InDataSet]
        "Staff Invoice No.Enable": Boolean;
        [InDataSet]
        "Staff DescriptionEnable": Boolean;
        [InDataSet]
        "Payment ByEnable": Boolean;
        StudHostel: Record "ACA-Students Hostel Rooms";
        HostLedg: Record "ACA-Hostel Ledger";
        BankName: Text[100];
    begin
        with ACAStdPayments do begin

        Validate("Cheque No");
        if Posted then exit;//ERROR('Already Posted');
        TestField("Transaction Date");

        if Confirm('Do you want to post the transaction?',true) = false then begin
        exit;
        end;

        if (("Payment Mode"="payment mode"::"Bank Slip") or ("Payment Mode"="payment mode"::Cheque)) then begin
        TestField("Bank Slip Date");
        TestField("Bank No.");
        end;
        CustLedg.Reset;
        CustLedg.SetRange(CustLedg."Customer No.","Student No.");
        //CustLedg.SETRANGE(CustLedg."Apply to",TRUE);
        CustLedg.SetRange(CustLedg.Open,true);
        CustLedg.SetRange(CustLedg.Reversed,false);
        if CustLedg.Find('-') then begin
        repeat
        TotalApplied:=TotalApplied+CustLedg."Amount Applied";
        until CustLedg.Next = 0;
        end;

        if "Amount to pay" > TotalApplied then begin
        if Confirm('There is an overpayment. Do you want to continue?',false) = false then begin
        exit;
        end;

        end;


        if Cust.Get("Student No.") then begin
        Cust."Application Method":=Cust."application method"::"Apply to Oldest";
        Cust.CalcFields(Balance);
        if Cust.Status=Cust.Status::"New Admission" then begin
        if ((Cust.Balance=0) or (Cust.Balance<0)) then begin
        Cust.Status:=Cust.Status::Current;
        end else begin
        Cust.Status:=Cust.Status::"New Admission";
        end;
        end else begin
        Cust.Status:=Cust.Status::Current;
        end;
        Cust.Modify;
        end;

        if Cust.Get("Student No.") then

        GenJnl.Reset;
        GenJnl.SetRange("Journal Template Name",'SALES');
        GenJnl.SetRange("Journal Batch Name",'STUD PAY');
        GenJnl.DeleteAll;

        GenSetUp.Get();


        GenJnl.Reset;
        GenJnl.SetRange("Journal Template Name",'SALES');
        GenJnl.SetRange("Journal Batch Name",'STUD PAY');
        GenJnl.DeleteAll;

        GenSetUp.TestField(GenSetUp."Pre-Payment Account");



        //Charge Student if not charged
        StudentCharges.Reset;
        StudentCharges.SetRange(StudentCharges."Student No.","Student No.");
        StudentCharges.SetRange(StudentCharges.Recognized,false);
        if StudentCharges.Find('-') then begin

        repeat

        DueDate:=StudentCharges.Date;
        if Sems.Get(StudentCharges.Semester) then begin
        if Sems.From<>0D then begin
        if Sems.From > DueDate then
        DueDate:=Sems.From;
        end;
        end;


        GenJnl.Init;
        GenJnl."Line No." := GenJnl."Line No." + 10000;
        GenJnl."Posting Date":=Today;
        GenJnl."Document No.":=ACAStdPayments."Cheque No";//StudentCharges."Transacton ID";
        GenJnl.Validate(GenJnl."Document No.");
        GenJnl."Journal Template Name":='SALES';
        GenJnl."Journal Batch Name":='STUD PAY';
        GenJnl."Account Type":=GenJnl."account type"::Customer;
        //
        if Cust.Get("Student No.") then begin
        if Cust."Bill-to Customer No." <> '' then
        GenJnl."Account No.":=Cust."Bill-to Customer No."
        else
        GenJnl."Account No.":="Student No.";
        end;

        GenJnl.Amount:=StudentCharges.Amount;
        GenJnl.Validate(GenJnl."Account No.");
        GenJnl.Validate(GenJnl.Amount);
        GenJnl.Description:=StudentCharges.Description;
        GenJnl."Bal. Account Type":=GenJnl."account type"::"G/L Account";

        if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Stage Fees") and
           (StudentCharges.Charge = false) then begin
        GenJnl."Bal. Account No.":=GenSetUp."Pre-Payment Account";

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
        GenJnl."Bal. Account No.":=GenSetUp."Pre-Payment Account";

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
        if Charges.Get(StudentCharges.Code) then
        GenJnl."Bal. Account No.":=Charges."G/L Account";
        end;
        GenJnl.Validate(GenJnl."Bal. Account No.");

        CReg.Reset;
        CReg.SetRange(CReg."Student No.","Student No.");
        CReg.SetRange(CReg.Reversed,false) ;
        if CReg.Find('+') then begin
        if ProgrammeSetUp.Get(CReg.Programme) then begin
        ProgrammeSetUp.TestField(ProgrammeSetUp."Department Code");
        //ProgrammeSetUp.TESTFIELD(Cust."Global Dimension 1 Code");
        GenJnl."Shortcut Dimension 1 Code":=Cust."Global Dimension 1 Code";
        if cust2.Get("Student No.") then;
        if cust2."Global Dimension 2 Code"  = '' then
          cust2."Global Dimension 2 Code":=ProgrammeSetUp."Department Code";
        if cust2."Global Dimension 2 Code"<>'' then begin

        GenJnl."Shortcut Dimension 2 Code":=cust2."Global Dimension 2 Code"
        end
        else
          GenJnl."Shortcut Dimension 2 Code":=ProgrammeSetUp."Department Code";
          if cust2."Global Dimension 2 Code" = ''   then
           Error('Department code is missing!')

        //else
        //GenJnl."Shortcut Dimension 2 Code":=ProgrammeSetUp."Department Code";
        end;
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
        if Cust.Get("Student No.") then begin
        CustPostGroup.Get(Cust."Customer Posting Group");

        GenJnl.Init;
        GenJnl."Line No." := GenJnl."Line No." + 10000;
        GenJnl."Posting Date":=Today;
        GenJnl."Document No.":=ACAStdPayments."Cheque No";//StudentCharges."Transacton ID";
        //GenJnl."Document Type":=GenJnl."Document Type"::Payment;
        GenJnl.Validate(GenJnl."Document No.");
        GenJnl."Journal Template Name":='SALES';
        GenJnl."Journal Batch Name":='STUD PAY';
        GenJnl."Account Type":=GenJnl."account type"::"G/L Account";
        GenSetUp.TestField(GenSetUp."Pre-Payment Account");
        GenJnl."Account No.":=GenSetUp."Pre-Payment Account";
        GenJnl.Amount:=StudentCharges.Amount * (StudentCharges.Distribution/100);
        GenJnl.Validate(GenJnl."Account No.");
        GenJnl.Validate(GenJnl.Amount);
        GenJnl.Description:='Fee Distribution';
        GenJnl."Bal. Account Type":=GenJnl."bal. account type"::"G/L Account";
        GenJnl."Bal. Account No.":=Stages."Distribution Account";
        GenJnl.Validate(GenJnl."Bal. Account No.");

        CReg.Reset;
        CReg.SetRange(CReg."Student No.","Student No.");
        CReg.SetRange(CReg.Reversed,false) ;
        if CReg.Find('+') then begin
        if ProgrammeSetUp.Get(CReg.Programme) then begin
        ProgrammeSetUp.TestField(ProgrammeSetUp."Department Code");
        //ProgrammeSetUp.TESTFIELD(Cust."Global Dimension 1 Code");
        GenJnl."Shortcut Dimension 1 Code":=Cust."Global Dimension 1 Code";
        GenJnl."Shortcut Dimension 2 Code":=ProgrammeSetUp."Department Code";
        end;
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
        if Charges.Get(StudentCharges.Code) then begin
        Charges.TestField(Charges."G/L Account");
        GenJnl.Init;
        GenJnl."Line No." := GenJnl."Line No." + 10000;
        GenJnl."Posting Date":=Today;
        GenJnl."Document No.":=ACAStdPayments."Cheque No";//StudentCharges."Transacton ID";
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
        GenJnl."Bal. Account No.":=Charges."G/L Account";
        GenJnl.Validate(GenJnl."Bal. Account No.");

        //Stages.TESTFIELD(Stages.Department);
        CReg.Reset;
        CReg.SetRange(CReg."Student No.","Student No.");
        CReg.SetRange(CReg.Reversed,false) ;
        if CReg.Find('+') then begin
        if ProgrammeSetUp.Get(CReg.Programme) then begin
        ProgrammeSetUp.TestField(ProgrammeSetUp."Department Code");
        //ProgrammeSetUp.TESTFIELD(Cust."Global Dimension 1 Code");
        GenJnl."Shortcut Dimension 1 Code":=Cust."Global Dimension 1 Code";
        GenJnl."Shortcut Dimension 2 Code":=ProgrammeSetUp."Department Code";
        end;
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
        StudentCharges.Modify;

        until StudentCharges.Next = 0;



        //Post New
        GenJnl.Reset;
        GenJnl.SetRange("Journal Template Name",'SALES');
        GenJnl.SetRange("Journal Batch Name",'STUD PAY');
        if GenJnl.Find('-') then begin
        Codeunit.Run(Codeunit::"Gen. Jnl.-Post B2",GenJnl);
        end;

        //Post New



        end;


        //BILLING

        "Last No":='';
        "No. Series Line".Reset;
         BankRec.Get("Bank No.");
         BankRec.TestField(BankRec."Receipt No. Series");
         "No. Series Line".SetRange("No. Series Line"."Series Code",BankRec."Receipt No. Series");
         if "No. Series Line".Find('-')  then
           begin

              "Last No":=IncStr("No. Series Line"."Last No. Used");
             "No. Series Line"."Last No. Used":=IncStr("No. Series Line"."Last No. Used");
             "No. Series Line".Modify;
            end;


        GenJnl.Reset;
        GenJnl.SetRange("Journal Template Name",'SALES');
        GenJnl.SetRange("Journal Batch Name",'STUD PAY');
        GenJnl.DeleteAll;



        Cust.CalcFields(Balance);
        if Cust.Status=Cust.Status::"New Admission" then begin
        if ((Cust.Balance=0) or (Cust.Balance<0)) then begin
        Cust.Status:=Cust.Status::Current;
        end else begin
        Cust.Status:=Cust.Status::"New Admission";
        end;
        end else begin
        Cust.Status:=Cust.Status::Current;
        end;
        //Cust.MODIFY;


        if "Payment Mode"="payment mode"::"Applies to Overpayment" then
        Error('Overpayment must be applied manualy.');


        /////////////////////////////////////////////////////////////////////////////////
        //Receive payments
        if "Payment Mode"<>"payment mode"::"Applies to Overpayment" then begin

        //Over Payment
        TotalApplied:=0;

        CustLedg.Reset;
        CustLedg.SetRange(CustLedg."Customer No.","Student No.");
        //CustLedg.SETRANGE(CustLedg."Apply to",TRUE);
        CustLedg.SetRange(CustLedg.Open,true);
        CustLedg.SetRange(CustLedg.Reversed,false);
        if CustLedg.Find('-') then begin
        repeat
        TotalApplied:=TotalApplied+CustLedg."Amount Applied";
        until CustLedg.Next = 0;
        end;

        CReg.Reset;
        CReg.SetCurrentkey(CReg."Reg. Transacton ID");
        //CReg.SETRANGE(CReg."Reg. Transacton ID",StudentCharges."Reg. Transacton ID");
        CReg.SetRange(CReg."Student No.","Student No.");
        if CReg.Find('+') then
        CourseReg:=CReg."Reg. Transacton ID";





        Receipt.Init;
        Receipt."Receipt No.":="Last No";
        //Receipt.VALIDATE(Receipt."Receipt No.");
        Receipt."Student No.":="Student No.";
        Receipt.Date:="Transaction Date";
        Receipt."KCA Rcpt No":="KCA Receipt No";
        Receipt."Bank Slip Date":="Bank Slip Date";
        Receipt."Bank Slip/Cheque No":="Cheque No";
        Receipt.Validate("Bank Slip/Cheque No");
        Receipt."Bank Account":="Bank No.";
        if "Payment Mode"="payment mode"::"Bank Slip" then
        Receipt."Payment Mode":=Receipt."payment mode"::"Bank Slip" else
        if "Payment Mode"="payment mode"::Cheque then
        Receipt."Payment Mode":=Receipt."payment mode"::Cheque else
        if "Payment Mode"="payment mode"::Cash then
        Receipt."Payment Mode":=Receipt."payment mode"::Cash else
        Receipt."Payment Mode":="Payment Mode";
        Receipt.Amount:="Amount to pay";
        Receipt."Payment By":="Payment By";
        Receipt."Transaction Date":=Today;
        Receipt."Transaction Time":=Time;
        Receipt."User ID":=UserId;
        Receipt."Reg ID":=CourseReg;
        Receipt.Insert;

        Receipt.Reset;
        if Receipt.Find('+') then begin


        CustLedg.Reset;
        CustLedg.SetRange(CustLedg."Customer No.","Student No.");
        //CustLedg.SETRANGE(CustLedg."Apply to",TRUE);
        CustLedg.SetRange(CustLedg.Open,true);
        CustLedg.SetRange(CustLedg.Reversed,false);
        if CustLedg.Find('-') then begin

        GenSetUp.Get();


        end;

        end;

        //Bank Entry
        if BankRec.Get("Bank No.") then
        BankName:=BankRec.Name;

        if ("Payment Mode"<>"payment mode"::Unreferenced) and ("Payment Mode"<>"payment mode"::"Staff Invoice")
        and ("Payment Mode"<>"payment mode"::Weiver) and ("Payment Mode"<>"payment mode"::CDF)
        and ("Payment Mode"<>"payment mode"::HELB)then begin

        GenJnl.Init;
        GenJnl."Line No." := GenJnl."Line No." + 10000;
        GenJnl."Posting Date":="Bank Slip Date";
        GenJnl."Document No.":="Last No";
        GenJnl."External Document No.":="Cheque No";
        GenJnl.Validate(GenJnl."Document No.");
        GenJnl."Journal Template Name":='SALES';
        GenJnl."Journal Batch Name":='STUD PAY';
        GenJnl."Account Type":=GenJnl."account type"::"Bank Account";
        GenJnl."Account No.":="Bank No.";
        GenJnl.Amount:="Amount to pay";
        GenJnl.Validate(GenJnl."Account No.");
        GenJnl.Validate(GenJnl.Amount);
        GenJnl.Description:=Format("Payment Mode")+'-'+Format("Bank Slip Date")+'-'+BankName;
        GenJnl."Bal. Account Type":=GenJnl."bal. account type"::Customer;
        if Cust."Bill-to Customer No." <> '' then
        GenJnl."Bal. Account No.":=Cust."Bill-to Customer No."
        else
        GenJnl."Bal. Account No.":="Student No.";


        GenJnl.Validate(GenJnl."Bal. Account No.");

        CReg.Reset;
        CReg.SetRange(CReg."Student No.","Student No.");
        CReg.SetRange(CReg.Reversed,false) ;
        if CReg.Find('+') then begin
        if ProgrammeSetUp.Get(CReg.Programme) then begin
        ProgrammeSetUp.TestField(ProgrammeSetUp."Department Code");
        //ProgrammeSetUp.TESTFIELD(Cust."Global Dimension 1 Code");
        GenJnl."Shortcut Dimension 1 Code":=Cust."Global Dimension 1 Code";
        GenJnl."Shortcut Dimension 2 Code":=ProgrammeSetUp."Department Code";
        end;
        end;
        GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
        GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
        if GenJnl.Amount<>0 then
        GenJnl.Insert;
        end;
        if "Payment Mode"="payment mode"::Unreferenced then begin
        GenJnl.Init;
        GenJnl."Line No." := GenJnl."Line No." + 10000;
        GenJnl."Posting Date":="Bank Slip Date";
        GenJnl."Document No.":="Last No";
        GenJnl."External Document No.":="Drawer Name";
        GenJnl.Validate(GenJnl."Document No.");
        GenJnl."Journal Template Name":='SALES';
        GenJnl."Journal Batch Name":='STUD PAY';
        GenJnl."Account Type":=GenJnl."account type"::Customer;
        GenJnl."Account No.":='UNREF';
        GenJnl.Amount:="Amount to pay";
        GenJnl.Validate(GenJnl."Account No.");
        GenJnl.Validate(GenJnl.Amount);
        GenJnl.Description:=Cust.Name;
        GenJnl."Bal. Account Type":=GenJnl."bal. account type"::Customer;
        if Cust."Bill-to Customer No." <> '' then
        GenJnl."Bal. Account No.":=Cust."Bill-to Customer No."
        else
        GenJnl."Bal. Account No.":="Student No.";

        GenJnl."Applies-to Doc. No.":="Unref Document No.";
        GenJnl.Validate(GenJnl."Applies-to Doc. No.");
        if GenJnl.Amount<>0 then
        GenJnl.Insert;

        CReg.Reset;
        CReg.SetRange(CReg."Student No.","Student No.");
        CReg.SetRange(CReg.Reversed,false) ;
        if CReg.Find('+') then begin
        if ProgrammeSetUp.Get(CReg.Programme) then begin
        ProgrammeSetUp.TestField(ProgrammeSetUp."Department Code");
        //ProgrammeSetUp.TESTFIELD(Cust."Global Dimension 1 Code");
        GenJnl."Shortcut Dimension 1 Code":=Cust."Global Dimension 1 Code";
        GenJnl."Shortcut Dimension 2 Code":=ProgrammeSetUp."Department Code";
        end;
        end;
        GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
        GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");


        end;
        // Tripple - T...Staff Invoice
        if "Payment Mode"="payment mode"::"Staff Invoice" then begin
        GenJnl.Init;
        GenJnl."Line No." := GenJnl."Line No." + 10000;
        GenJnl."Posting Date":="Bank Slip Date";
        GenJnl."Document No.":="Last No";
        GenJnl."External Document No.":='';
        GenJnl.Validate(GenJnl."Document No.");
        GenJnl."Journal Template Name":='SALES';
        GenJnl."Journal Batch Name":='STUD PAY';
        GenJnl."Account Type":=GenJnl."account type"::Customer;
        GenJnl."Account No.":="Student No.";
        GenJnl.Amount:=-"Amount to pay";
        GenJnl.Validate(GenJnl."Account No.");
        GenJnl.Validate(GenJnl.Amount);
        GenJnl.Description:='Staff Invoice No. '+"Staff Invoice No.";
        GenJnl."Bal. Account Type":=GenJnl."bal. account type"::"G/L Account";
        GenJnl."Bal. Account No.":='200012';

        CReg.Reset;
        CReg.SetRange(CReg."Student No.","Student No.");
        CReg.SetRange(CReg.Reversed,false) ;
        if CReg.Find('+') then begin
        if ProgrammeSetUp.Get(CReg.Programme) then begin
        ProgrammeSetUp.TestField(ProgrammeSetUp."Department Code");
        //ProgrammeSetUp.TESTFIELD(Cust."Global Dimension 1 Code");
        GenJnl."Shortcut Dimension 1 Code":=Cust."Global Dimension 1 Code";
        GenJnl."Shortcut Dimension 2 Code":=ProgrammeSetUp."Department Code";
        end;
        end;
        GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
        GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
        if GenJnl.Amount<>0 then
        GenJnl.Insert;


        end;
        // Tripple - T...CDF
        if "Payment Mode"="payment mode"::CDF then begin
        GenSetUp.TestField(GenSetUp."CDF Account");
        GenJnl.Init;
        GenJnl."Line No." := GenJnl."Line No." + 10000;
        GenJnl."Posting Date":="Bank Slip Date";
        GenJnl."Document No.":="Last No";
        GenJnl."External Document No.":='CDF';
        GenJnl.Validate(GenJnl."Document No.");
        GenJnl."Journal Template Name":='SALES';
        GenJnl."Journal Batch Name":='STUD PAY';
        GenJnl."Account Type":=GenJnl."account type"::Customer;
        GenJnl."Account No.":="Student No.";
        GenJnl.Amount:=-"Amount to pay";
        GenJnl.Validate(GenJnl."Account No.");
        GenJnl.Validate(GenJnl.Amount);
        GenJnl.Description:="CDF Description";
        //GenJnl."Bal. Account Type":=GenJnl."Bal. Account Type"::"G/L Account";
        //GenJnl."Bal. Account No.":=;
        CReg.Reset;
        CReg.SetRange(CReg."Student No.","Student No.");
        CReg.SetRange(CReg.Reversed,false) ;
        if CReg.Find('+') then begin
        if ProgrammeSetUp.Get(CReg.Programme) then begin
        ProgrammeSetUp.TestField(ProgrammeSetUp."Department Code");
        //ProgrammeSetUp.TESTFIELD(Cust."Global Dimension 1 Code");
        GenJnl."Shortcut Dimension 1 Code":=Cust."Global Dimension 1 Code";
        GenJnl."Shortcut Dimension 2 Code":=ProgrammeSetUp."Department Code";
        end;
        end;
        GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
        GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
        if GenJnl.Amount<>0 then
        GenJnl.Insert;

        GenJnl.Init;
        GenJnl."Line No." := GenJnl."Line No." + 10000;
        GenJnl."Posting Date":="Bank Slip Date";
        GenJnl."Document No.":="Last No";
        GenJnl."External Document No.":='CDF';
        GenJnl.Validate(GenJnl."Document No.");
        GenJnl."Journal Template Name":='SALES';
        GenJnl."Journal Batch Name":='STUD PAY';
        GenJnl."Account Type":=GenJnl."account type"::"G/L Account";
        GenJnl."Account No.":=GenSetUp."CDF Account";
        GenJnl.Amount:="Amount to pay";
        GenJnl.Validate(GenJnl."Account No.");
        GenJnl.Validate(GenJnl.Amount);
        GenJnl.Description:="Student No.";

        CReg.Reset;
        CReg.SetRange(CReg."Student No.","Student No.");
        CReg.SetRange(CReg.Reversed,false) ;
        if CReg.Find('+') then begin
        if ProgrammeSetUp.Get(CReg.Programme) then begin
        ProgrammeSetUp.TestField(ProgrammeSetUp."Department Code");
        //ProgrammeSetUp.TESTFIELD(Cust."Global Dimension 1 Code");
        GenJnl."Shortcut Dimension 1 Code":=Cust."Global Dimension 1 Code";
        GenJnl."Shortcut Dimension 2 Code":=ProgrammeSetUp."Department Code";
        end;
        end;
        GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
        GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
        if GenJnl.Amount<>0 then
        GenJnl.Insert;


        end;


        if "Payment Mode"="payment mode"::HELB then begin
        GenSetUp.TestField(GenSetUp."Helb Account");
        GenJnl.Init;
        GenJnl."Line No." := GenJnl."Line No." + 10000;
        GenJnl."Posting Date":="Bank Slip Date";
        GenJnl."Document No.":="Last No";
        GenJnl."External Document No.":='';
        GenJnl.Validate(GenJnl."Document No.");
        GenJnl."Journal Template Name":='SALES';
        GenJnl."Journal Batch Name":='STUD PAY';
        GenJnl."Account Type":=GenJnl."account type"::Customer;
        GenJnl."Account No.":="Student No.";
        GenJnl.Amount:=-"Amount to pay";
        GenJnl.Validate(GenJnl."Account No.");
        GenJnl.Validate(GenJnl.Amount);
        GenJnl.Description:='HELB';
        GenJnl."Bal. Account Type":=GenJnl."bal. account type"::"G/L Account";
        GenJnl."Bal. Account No.":=GenSetUp."Helb Account";
        CReg.Reset;
        CReg.SetRange(CReg."Student No.","Student No.");
        CReg.SetRange(CReg.Reversed,false) ;
        if CReg.Find('+') then begin
        if ProgrammeSetUp.Get(CReg.Programme) then begin
        GenJnl."Shortcut Dimension 2 Code":=ProgrammeSetUp."Department Code";
        end;
        end;

        GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
        if GenJnl.Amount<>0 then
        GenJnl.Insert;


        end;

        //Post

        GenJnl.Reset;
        GenJnl.SetRange("Journal Template Name",'SALES');
        GenJnl.SetRange("Journal Batch Name",'STUD PAY');
        if GenJnl.Find('-') then begin

        Codeunit.Run(Codeunit::"Gen. Jnl.-Post B2",GenJnl);
        Modify;
        end;
        end;
        end;
    end;

    local procedure "*****************************"()
    begin
    end;


    procedure BookRoom(settle_m: Option " ",JAB,SSP,"Special Programme";ACAStudentsHostelRooms: Record "ACA-Students Hostel Rooms")
    var
        rooms: Record "ACA-Hostel Block Rooms";
        billAmount: Decimal;
        ACAStudentsHostelRooms12: Record "ACA-Students Hostel Rooms";
        userst: Record "User Setup";
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
        "Settlement Type": Record UnknownRecord61522;
    begin
           with ACAStudentsHostelRooms do begin
            // --------Check If More Than One Room Has Been Selected
          Clear(billAmount);
           rooms.Reset;
          rooms.SetRange(rooms."Hostel Code","Hostel No");
          rooms.SetRange(rooms."Room Code","Room No");
          if rooms.Find('-') then begin
            if settle_m=Settle_m::"Special Programme" then
              billAmount:=rooms."Special Programme"
            else if settle_m=Settle_m::JAB then
              billAmount:=rooms."JAB Fees"
            else if settle_m=Settle_m::SSP then
              billAmount:=rooms."SSP Fees"

          end;
          Cust.Reset;
          Cust.SetRange(Cust."No.",Student);
          if Cust.Find('-') then begin
          end;
          Clear(StudentHostel);
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
            Rooms_Spaces.Reset;
            Rooms_Spaces.SetRange(Rooms_Spaces."Space Code",StudentHostel."Space No");
            Rooms_Spaces.SetRange(Rooms_Spaces."Room Code",StudentHostel."Room No");
            Rooms_Spaces.SetRange(Rooms_Spaces."Hostel Code",StudentHostel."Hostel No");
            if Rooms_Spaces.Find('-') then begin
              if Rooms_Spaces.Status<>Rooms_Spaces.Status::Vaccant then Error('The selected room is nolonger vacant');
            end;
            // ----------Check If He has UnCleared Room
           StudentHostel.Reset;
           StudentHostel.SetRange(StudentHostel.Student,Cust."No.");
           StudentHostel.SetRange(StudentHostel.Cleared,false);
           if StudentHostel.Find('-') then begin
              if StudentHostel.Count>1 then begin
                Error('Please Note That You Must First Clear Your Old Rooms Before You Allocate Another Room')
              end;
           end;
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
           if Blocks.Get("Hostel No") then begin
           end;

           if not StudentCharges.Find('-') then begin
        coReg.Reset;
        coReg.SetRange(coReg."Student No.",Student);
        coReg.SetRange(coReg.Semester,Semester);
        if coReg.Find('-') then begin
            StudentCharges.Init;
            StudentCharges."Transacton ID":='';
            StudentCharges.Validate(StudentCharges."Transacton ID");
            StudentCharges."Student No.":=coReg."Student No.";
            StudentCharges."Reg. Transacton ID":=coReg."Reg. Transacton ID";
            StudentCharges."Transaction Type":=StudentCharges."transaction type"::Charges;
            StudentCharges.Code :=charges1.Code;
            StudentCharges.Description:='Accommodation Fees';
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
              StudentHostel.Allocated:=true;
              StudentHostel."Allocated By":=UserId;
              StudentHostel."Time allocated":=Time;
              StudentHostel.Modify;


            end;
            until StudentHostel.Next=0;
            Message('Room Allocated Successfully');
          end;

         postCharge(ACAStudentsHostelRooms);
         end;
    end;

    local procedure postCharge(ACAStudentsHostelRooms: Record "ACA-Students Hostel Rooms")
    var
        ACAStudentsHostelRooms12: Record "ACA-Students Hostel Rooms";
        userst: Record "User Setup";
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
        "Settlement Type": Record UnknownRecord61522;
    begin
        with ACAStudentsHostelRooms do begin
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


        CReg.Reset;
        CReg.SetRange(CReg."Student No.",Student);
        CReg.SetRange(CReg.Semester,Semester);
        if CReg.Find('-') then begin //10
        end // 10
        else   begin // 10.1
        Error('The Settlement Type Does not Exists in the Course Registration for: '+Student);
        end;//10.1



        if Cust.Get(Student) then;

        GenJnl.Reset;
        GenJnl.SetRange("Journal Template Name",'SALES');
        GenJnl.SetRange("Journal Batch Name",'STUD PAY');
        GenJnl.DeleteAll;

        GenSetUp.Get();

        // Charge Student - Accommodation- if not charged
        StudentCharges.Reset;
        StudentCharges.SetRange(StudentCharges."Student No.",Student);
        StudentCharges.SetRange(StudentCharges.Recognized,false);
        StudentCharges.SetFilter(StudentCharges.Code,'=%1',charges1.Code) ;
        if StudentCharges.Find('-') then begin

        repeat

        DueDate:=StudentCharges.Date;
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
        StudentCharges.CalcFields(StudentCharges."Settlement Type");


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
        GenJnl.Validate(GenJnl."Document No.");
        GenJnl."Journal Template Name":='SALES';
        GenJnl."Journal Batch Name":='STUD PAY';
        GenJnl."Account Type":=GenJnl."account type"::"G/L Account";
        GenJnl.Amount:=StudentCharges.Amount * (StudentCharges.Distribution/100);
        GenJnl.Validate(GenJnl."Account No.");
        GenJnl.Validate(GenJnl.Amount);
        GenJnl.Description:='Fee Distribution';
        GenJnl."Bal. Account Type":=GenJnl."bal. account type"::"G/L Account";

        StudentCharges.CalcFields(StudentCharges."Settlement Type");

        GenJnl.Validate(GenJnl."Bal. Account No.");
        GenJnl."Shortcut Dimension 1 Code":=Cust."Global Dimension 1 Code";
        if prog.Get(StudentCharges.Programme) then begin
        prog.TestField(prog."Department Code");
        GenJnl."Shortcut Dimension 2 Code":=prog."Department Code";
        end;

        GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
        GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");

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


        until StudentCharges.Next = 0;



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

         end;
    end;

    local procedure SendAdmissionMailsHere(KUCCPSImports2: Record UnknownRecord70082)
    var
        SendMailsEasy: Codeunit "Send Mails Easy";
        ResidentOrNonResidentInfo: Text[450];
    begin
        Clear(ResidentOrNonResidentInfo);
        KUCCPSImports2.CalcFields("Assigned Block","Assigned Room");
        if KUCCPSImports2."Assigned Space" <> '' then begin
          ResidentOrNonResidentInfo := 'You have beel allocated a space of resident in Block: '+KUCCPSImports2."Assigned Block"+', Room: '+KUCCPSImports2."Assigned Room"+
        ', at Space: '+KUCCPSImports2."Assigned Space"+', Kindly collect your key and other items at the Hostel Masters Office. Have a safe stay\Signed by hostel manager';
          end else begin
            ResidentOrNonResidentInfo :='You have not applied for a hostel allocation. You are therefore adviced to make personal arrangements for accomodation. '+
          'You can also visit the hostel manager to request for the same.';
            end;
        SendMailsEasy.SendEmailEasy('Dear,',KUCCPSImports2.Names,
        'Karatina University is glad to inform you that you admission process was successful.',ResidentOrNonResidentInfo,
        'Login in to your portal to Sign the Nominal Role and Register for the units.',
        'This Mail is system generated. Please do not reply.',
        KUCCPSImports2.Email,'ADMISSION INTO KARATINA UNIVERSITY');
    end;
}

