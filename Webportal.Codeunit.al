#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50118 Webportal
{
    Permissions = TableData "Approval Entry"=imd,
                  TableData "Approval Comment Line"=imd,
                  TableData "Posted Approval Entry"=imd,
                  TableData "Posted Approval Comment Line"=imd,
                  TableData "Overdue Approval Entry"=imd;

    trigger OnRun()
    begin
    end;

    var
        "Approvals management": Codeunit "Export F/O Consolidation";
        "HR Leave Application": Record UnknownRecord61146;
        LeaveT: Record UnknownRecord61146;
        "Employee Card": Record UnknownRecord61118;
        "Supervisor Card": Record "User Setup";
        HREmp: Record UnknownRecord61118;
        HRLeaveTypes: Record UnknownRecord61145;
        dAlloc: Decimal;
        dEarnd: Decimal;
        dTaken: Decimal;
        dLeft: Decimal;
        cReimbsd: Decimal;
        cPerDay: Decimal;
        cbf: Decimal;
        varDaysApplied: Integer;
        HRLeaveApp: Record UnknownRecord61146;
        HRSetup: Record UnknownRecord61144;
        BaseCalendarChange: Record UnknownRecord61073;
        ReturnDateLoop: Boolean;
        LeaveGjline: Record UnknownRecord61179;
        "LineNo.": Integer;
        HRLeave: Record UnknownRecord61146;
        ApprovalMgtNotification: Codeunit "IC Setup Diagnostics";
        ApprovalEntry: Record "Approval Entry";
        HREmployees: Query "Supervisor Application";
        ApprovalEntry_2: Record "Approval Entry";
        "Supervisor ID": Text;
        ApprovalSetup: Record UnknownRecord452;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NextLeaveApplicationNo: Code[20];
        HRAppraisalHeader: Record UnknownRecord39005606;
        HRAppraisalIndividualTargetHeader: Record UnknownRecord61214;
        HRAppraisalIndividualTargetLine: Record UnknownRecord39005669;
        NextAppraisalNumber: Code[20];
        HRAppraisalPeriod: Record UnknownRecord39005672;
        HRTransportRequisition: Record UnknownRecord39004387;
        HRTravellingStaff: Record UnknownRecord39004396;
        HRTransportRequisition_2: Record UnknownRecord39004387;
        AppraisalPeriod: Date;
        filename: Text[100];
        Customer: Record Customer;
        Member: Record Vendor;
        "Bsc Line2": Record UnknownRecord39005669;
        "Bsc Line": Record UnknownRecord39005669;
        "Bsc Head": Record UnknownRecord61214;
        i: Integer;
        BOSA: Record UnknownRecord39004418;
        FILESPATH: label 'E:\portal\Mwalimu Sacco\MwalimuTest31\Downloads\';
        HRAppraisalCompetencies: Record UnknownRecord61086;
        BSC: Record UnknownRecord61214;
        "Online Loan Application": Record UnknownRecord52018518;
        LnApp: Record UnknownRecord39004241;
        LoanApp: Record UnknownRecord39004241;
        BANDING: Record UnknownRecord39004066;
        GenSetUp: Record UnknownRecord39004243;
        CustMember: Record UnknownRecord39004418;
        MembContri: Record UnknownRecord39004398;
        MinShares: Decimal;


    procedure SendLeaveApprovalRequest(ApplicationCode: Code[20])
    begin
        "HR Leave Application".SetRange("HR Leave Application"."Application Code",ApplicationCode);
        if  "HR Leave Application".Find('-')
        then
            begin
              "Approvals management".SendLeaveAppApprovalReq("HR Leave Application");
              Message('Test');
            end
    end;


    procedure HRLeaveApplication(EmployeeNo: Text;LeaveType: Text;AppliedDays: Decimal;StartDate: Date;ReturnDate: Date;SenderComments: Text) successMessage: Text
    begin
        LeaveT.Init;
         HRSetup.Get;
         NextLeaveApplicationNo:=NoSeriesMgt.GetNextNo(HRSetup."Leave Application Nos.",0D,true);
        //Employee details
        "Employee Card".Reset;
        "Employee Card".SetRange("Employee Card"."No.",EmployeeNo);

        if "Employee Card".Find('-')
        then
          begin
            LeaveT."User ID":="Employee Card"."User ID";
            LeaveT."Employee No":=EmployeeNo;
            LeaveT."E-mail Address":="Employee Card"."Company E-Mail";
            LeaveT."Cell Phone Number":="Employee Card"."Cellular Phone Number";
            LeaveT.Names:="Employee Card"."Full Name";
            LeaveT."Job Tittle":="Employee Card"."Job Title";
            "Supervisor Card".Reset;
            "Supervisor Card".SetRange("Supervisor Card"."User ID","Employee Card"."User ID");
                if "Supervisor Card".Find('-')
                then
                begin
                    LeaveT.Supervisor:="Supervisor Card"."Approver ID";
                    LeaveT."Supervisor Email":="Supervisor Card"."E-Mail";
                end;
           end;

        LeaveT."Application Code":= NextLeaveApplicationNo;
        LeaveT."Leave Type":=LeaveType;
        LeaveT."Days Applied":=AppliedDays;
        LeaveT."Application Date":=Today;
        LeaveT."No series":='LEAVE';
        LeaveT."Start Date":=StartDate;
        LeaveT."Return Date":=ReturnDate;
        LeaveT."Applicant Comments":=SenderComments;
        LeaveT.Insert;
        "HR Leave Application".SetRange("HR Leave Application"."Application Code", NextLeaveApplicationNo);
        if  "HR Leave Application".Find('-')
        then
            begin
              "Approvals management".SendLeaveAppApprovalReq("HR Leave Application");
            end;

          // successMessage:='Your Leave Application was successfully submitted for approval.';
    end;


    procedure HRLeaveValidateDaysApplied(EmployeeNo: Text;"Leave Type": Text;"Days Applied": Integer)
    begin
        HREmp.Get(EmployeeNo);
         if "Days Applied"<0 then
           Error('Days applied cannot be less than zero');

        if "Leave Type"='ANNUAL' then begin
        HRGetLeaveStatics(EmployeeNo,"Leave Type");
          if "Days Applied">dLeft then
           Error('Days applied cannot exceed Employee leave balance for this leave');
        end else begin
         HRLeaveTypes.Reset;
         HRLeaveTypes.SetRange(HRLeaveTypes.Code,"Leave Type");
         if HRLeaveTypes.Find('-') then begin
          if "Days Applied">HRLeaveTypes.Days then
           Error('Days applied cannot exceed leave balance for this leave');
         end;

        end;

        if "Leave Type" = 'MATERNITY' then
        HRLeaveTypes.Reset;
        HRLeaveTypes.SetRange(HRLeaveTypes.Code,"Leave Type");
        if HRLeaveTypes.Find('-') then begin
        if "Days Applied" < HRLeaveTypes.Days then
        Error('Days applied cannot be less than '+Format(HRLeaveTypes.Days));
        end;
    end;


    procedure HRGetLeaveStatics(EmployeeNo: Text;LeaveType: Text)
    begin
           dAlloc := 0;
           dEarnd := 0;
           dTaken := 0;
           dLeft := 0;
           cReimbsd := 0;
           cPerDay := 0;
           cbf:=0;
           if HREmp.Get(EmployeeNo) then begin
           HREmp.SetFilter(HREmp."Leave Type Filter",LeaveType);
           HREmp.CalcFields(HREmp."Allocated Leave Days",HREmp."Leave Outstanding Bal");
           dAlloc := HREmp."Allocated Leave Days";
           HREmp.Validate(HREmp."Allocated Leave Days");
           dEarnd := HREmp."Total (Leave Days)";
           HREmp.CalcFields(HREmp."Total Leave Taken");
           dTaken := HREmp."Total Leave Taken";
           dLeft :=HREmp."Leave Outstanding Bal";
           cReimbsd :=HREmp."Cash - Leave Earned";
           cPerDay := HREmp."Cash per Leave Day" ;
           HREmp.CalcFields(HREmp."Reimbursed Leave Days");
           cbf:=HREmp."Reimbursed Leave Days";
           end;
    end;


    procedure HRReturnLeaveStatics(EmployeeNo: Text;"Leave Type": Text) dAllocated: Text
    begin
        HRGetLeaveStatics(EmployeeNo,"Leave Type");
        dAllocated:='dAlloc='+Format(dAlloc)+';dEarnd='+Format(dEarnd)+';dTaken='+Format(dTaken)+';dLeft='+Format(dLeft)+';cbf='+Format(cbf);
    end;


    procedure DetermineLeaveReturnDate(var fBeginDate: Date;var fDays: Decimal;"Leave Type": Code[10]) fReturnDate: Date
    begin
        varDaysApplied := fDays;
        fReturnDate := fBeginDate;
        repeat
          if DetermineIfIncludesNonWorking("Leave Type") =false then begin
            fReturnDate := CalcDate('1D', fReturnDate);
            if DetermineIfIsNonWorking(fReturnDate) then
              varDaysApplied := varDaysApplied + 1
            else
              varDaysApplied := varDaysApplied;
            varDaysApplied := varDaysApplied - 1
          end
          else begin
            fReturnDate := CalcDate('1D', fReturnDate);
            varDaysApplied := varDaysApplied - 1;
          end;
        until varDaysApplied = 0;
        exit(fReturnDate);
    end;


    procedure DetermineIfIncludesNonWorking(var fLeaveCode: Code[10]): Boolean
    begin
        if HRLeaveTypes.Get(fLeaveCode) then begin
        if HRLeaveTypes."Inclusive of Non Working Days" = true then
        exit(true);
        end;
    end;


    procedure DetermineIfIsNonWorking(var bcDate: Date) Isnonworking: Boolean
    begin

        HRSetup.Find('-');
        HRSetup.TestField(HRSetup."Base Calendar");
        BaseCalendarChange.SetFilter(BaseCalendarChange."Base Calendar Code",HRSetup."Base Calendar");
        BaseCalendarChange.SetRange(BaseCalendarChange.Date,bcDate);

        if BaseCalendarChange.Find('-') then begin
        if BaseCalendarChange.Nonworking = false then
        Error('Start date can only be a Working Day Date');
        exit(true);
        end;
    end;


    procedure DeterminethisLeaveEndDate(var fDate: Date) fEndDate: Date
    begin
        ReturnDateLoop := true;
        fEndDate := fDate;
        if fEndDate <> 0D then begin
          fEndDate := CalcDate('-1D', fEndDate);
          while (ReturnDateLoop) do begin
          if DetermineIfIsNonWorking(fEndDate) then
            fEndDate := CalcDate('-1D', fEndDate)
           else
            ReturnDateLoop := false;
          end
          end;
        exit(fEndDate);
    end;


    procedure HRUpdateLeaveApplication("Document No": Text;"Reliever No": Text;ApprovedDays: Integer;"Supervisor ID param": Text) SuccessMessage: Text
    begin

        LeaveT.Reset;
        LeaveT.SetRange(LeaveT."Application Code","Document No");

        if LeaveT.Find('-')
          then
            begin
            LeaveT.Reliever:="Reliever No";
            "Employee Card".Reset;
            "Employee Card".SetRange("Employee Card"."No.","Reliever No");

              if "Employee Card".Find('-')
              then
                begin
                    LeaveT."Reliever Name":="Employee Card"."Full Name";
              end;

            LeaveT."Approved days":=ApprovedDays;
            LeaveT.Modify;
            "Supervisor ID":="Supervisor ID param";

            ApprovalEntry.SetRange(ApprovalEntry."Document No.","Document No");
            ApprovalEntry.SetRange(ApprovalEntry."Approver ID","Supervisor ID param");
            ApprovalEntry.SetRange(ApprovalEntry.Status,ApprovalEntry.Status::Open);
            if ApprovalEntry.Find('-') then
            begin
                //Modify status to approved if there are no other approvers
                ApprovalEntry.Status:=ApprovalEntry.Status::Approved;
                ApprovalEntry.Modify;

                //Change next doc to open
                ApprovalEntry_2.Reset;
                ApprovalEntry_2.SetRange(ApprovalEntry_2."Document No.","Document No");
                ApprovalEntry_2.SetRange(ApprovalEntry_2.Status,ApprovalEntry_2.Status::Created);
                if ApprovalEntry_2.Find('-') then
                begin
                    ApprovalEntry_2.Status:=ApprovalEntry_2.Status::Open;
                    ApprovalEntry_2."Last Date-Time Modified" := CreateDatetime(Today,Time);
                    ApprovalEntry_2."Last Modified By ID" :="Supervisor ID param";
                    ApprovalEntry_2.Modify;
                    SuccessMessage:='Approval successful.';
                end;

            end;
            ApprovalEntry_2.Reset;
            ApprovalEntry_2.SetRange(ApprovalEntry_2."Document No.","Document No");
              if ApprovalEntry_2.FindLast then
                begin
                  if ApprovalEntry_2.Status=ApprovalEntry_2.Status::Approved  then
                      begin
                          HRLeave.Reset;
                          HRLeave.SetRange(HRLeave."Application Code","Document No");
                          if HRLeave.Find('-')then
                             begin
                                HRLeave.CreateLeaveLedgerEntries;
                                if ApprovalSetup.Approvals then
                                  ApprovalMgtNotification.SendLeaveApprovedMail(HRLeave,ApprovalEntry);

                             end;
                      end;
                end;

            end;
    end;


    procedure HRRejectLeave("Document No": Text;"Supervisor ID": Text)
    begin
        ApprovalEntry.SetRange("Document No.","Document No");
        if ApprovalEntry.Find('-') then
          repeat
            ApprovalEntry.Status := ApprovalEntry.Status::Rejected;
            ApprovalEntry."Last Date-Time Modified" := CreateDatetime(Today,Time);
            ApprovalEntry."Last Modified By ID" :="Supervisor ID";
            ApprovalEntry.Modify;
            ApprovalMgtNotification.SendLeaveRejectionsMail(HRLeaveApp,ApprovalEntry);
          until ApprovalEntry.Next = 0;

        HRLeaveApp.SetRange(HRLeaveApp."Application Code","Document No");
        if HRLeaveApp.Find('-') then
        begin
          HRLeaveApp.Status:=HRLeaveApp.Status::Rejected;
          HRLeaveApp.Modify;
          Message('You rejected Leave No, %1',"Document No" );
          end;
          // Message('You rejected Leave No '+"Document No" );
    end;


    procedure HRDetermineIfALeaveExistsForSameDate(EmployeeNo: Text;"Start Date": Date)
    begin
        HRLeaveApp.Reset;
        HRLeaveApp.SetRange(HRLeaveApp."Employee No",EmployeeNo);
        HRLeaveApp.SetRange(HRLeaveApp."Start Date","Start Date");
        //objLeaveApps.SETRANGE();
        if HRLeaveApp.Find('-') then begin
        //IF HRLeaveApp."Application Code"<>"Application Code" THEN
        Error('The Staff has an existing leave application starting on the same date, %1',HRLeaveApp."Application Code" );
        end;
    end;


    procedure HRAppraisalCreateIndividualTargetHeader(AppraisalType: Option;EmployeeNo: Text)
    var
        AppraisalYear: Integer;
    begin
        HRAppraisalIndividualTargetHeader.Reset;

        HRAppraisalPeriod.Reset;
        HRAppraisalPeriod.SetRange(HRAppraisalPeriod.Closed,false);
        if HRAppraisalPeriod.Find('-')  then
        begin
        AppraisalPeriod:=HRAppraisalPeriod."Appraisal Period";
        AppraisalYear:=HRAppraisalPeriod."Appraisal Year";
        end;
        HRAppraisalIndividualTargetHeader.SetRange(HRAppraisalIndividualTargetHeader."Employee No",EmployeeNo);
        HRAppraisalIndividualTargetHeader.SetRange(HRAppraisalIndividualTargetHeader."Appraisal Period", AppraisalPeriod);

        if HRAppraisalIndividualTargetHeader.FindSet then
        Error('You already created appraisal for this period');


        NextAppraisalNumber:=NoSeriesMgt.GetNextNo('EMP APP',0D,true);
        HRAppraisalIndividualTargetHeader.Init;
        HRAppraisalPeriod.Reset;
        HRAppraisalPeriod.SetRange(HRAppraisalPeriod.Closed,false);
        if HRAppraisalPeriod.Find('-')  then
        begin
        HRAppraisalIndividualTargetHeader."Appraisal Period":=HRAppraisalPeriod."Appraisal Period";
        HRAppraisalIndividualTargetHeader."Appraisal Date":=Today;
        HRAppraisalIndividualTargetHeader."Appraisal Year":=HRAppraisalPeriod."Appraisal Year";
        HRAppraisalIndividualTargetHeader."Appraisal Type":=AppraisalType;//HRAppraisalIndividualTargetHeader."Appraisal Type"::"Target Setting";
        end;
        "Employee Card".Reset;
        "Employee Card".SetRange("Employee Card"."No.",EmployeeNo);

        if "Employee Card".Find('-')
        then
          begin
             HRAppraisalIndividualTargetHeader."Employee No":=EmployeeNo;
             HRAppraisalIndividualTargetHeader."Employee Name":="Employee Card"."Full Name";
             HRAppraisalIndividualTargetHeader."User ID":="Employee Card"."User ID";
          end;

        HRAppraisalIndividualTargetHeader."No series":='EMP APP';
        HRAppraisalIndividualTargetHeader."Appraisal no":=NextAppraisalNumber;
        HRAppraisalIndividualTargetHeader.Insert;

             if AppraisalType<>HRAppraisalPeriod."appraisal type"::"Target Setting" then
            loadtheyearsTarget(EmployeeNo,AppraisalYear,NextAppraisalNumber,AppraisalPeriod);



        Message('1%',NextAppraisalNumber);
    end;


    procedure HRAppraisalCreateIndividualHeaderLines(AppraisalNumber: Text;PerspectiveCode: Integer;TargetScore: Decimal;Objective: Text)
    begin
        HRAppraisalIndividualTargetLine.Init;

        HRAppraisalIndividualTargetHeader.SetRange(HRAppraisalIndividualTargetHeader."Appraisal no",AppraisalNumber);
        if HRAppraisalIndividualTargetHeader.Find('-')
        then
          begin
           HRAppraisalIndividualTargetLine."Appraisal Period":=HRAppraisalIndividualTargetHeader."Appraisal Period";
          end;


        HRAppraisalIndividualTargetLine."Appraisal No":=AppraisalNumber;
        HRAppraisalIndividualTargetLine."Perspective Code":=PerspectiveCode;
        HRAppraisalIndividualTargetLine."Targeted Score":=TargetScore;
        HRAppraisalIndividualTargetLine.Objective:=Objective;
        HRAppraisalIndividualTargetLine.Insert;
    end;


    procedure HRAppraisalApprovals(AppraisalNumber: Text)
    begin
        HRAppraisalIndividualTargetHeader.SetRange(HRAppraisalIndividualTargetHeader."Appraisal no",AppraisalNumber);
        if HRAppraisalIndividualTargetHeader.Find('-')
        then
          begin
          "Approvals management".SendBSCApprovalReq(HRAppraisalIndividualTargetHeader);
          Message('1%',HRAppraisalIndividualTargetHeader."Employee No");
          end;
    end;


    procedure HRTransportRequisitionCreate("Employee No": Text;Commencement: Text;Destination: Text;"Date Of Trip": Date;"Purpose of Trip": Text;Comments: Text;"No Days Requested": Integer)
    begin

        HRTransportRequisition.Init;
        HRTransportRequisition."Time Requested":=Time;
        HRTransportRequisition."Transport Requisition No":=NoSeriesMgt.GetNextNo('T_REQ',0D,true);
        HRTransportRequisition."Requested By":="Employee No";
        HRTransportRequisition.Commencement:=Commencement;
        HRTransportRequisition.Destination:=Destination;
        HRTransportRequisition."Date of Request":=Today;
        HRTransportRequisition.Validate("Date of Trip","Date Of Trip");
        HRTransportRequisition."Purpose of Trip":="Purpose of Trip";
        HRTransportRequisition.Comments:=Comments;
        HRTransportRequisition.Validate("No of Days Requested","No Days Requested");
        HRTransportRequisition.Insert(true);
    end;


    procedure HRTravelRequisitionCreate("Requistion No": Text;"Employee Number": Text)
    begin
        HRTransportRequisition.Reset;
        HRTransportRequisition.SetRange(HRTransportRequisition."Transport Requisition No","Requistion No");
        HRTransportRequisition.SetRange(HRTransportRequisition.Status,HRTransportRequisition_2.Status::Open);

          if  HRTransportRequisition.Find('-') then
          begin


        HRTravellingStaff.Reset;

        HRTravellingStaff.SetRange(HRTravellingStaff."Employee No","Employee Number");
        HRTravellingStaff.SetRange(HRTravellingStaff."Req No","Requistion No");

        if HRTravellingStaff.FindSet then
        Error('This staff member already exists for this ticket');

        HRTravellingStaff.Reset;
        HRTravellingStaff.Init;
           "Employee Card".SetRange("Employee Card"."No.","Employee Number");

              if "Employee Card".Find('-')
              then
                begin
                   HRTravellingStaff."Employee Name":="Employee Card"."Full Name";
                   HRTravellingStaff.Position:="Employee Card"."Job Title";
              end;

        HRTravellingStaff."Req No":="Requistion No";
        HRTravellingStaff."Employee No":="Employee Number";
        HRTravellingStaff.Insert(true);
        end
        else
          begin
              Error('You can only add staff to an open ticket');
          end
    end;


    procedure HRTravellingStaffRemove("Entry Number": Integer)
    begin
          HRTravellingStaff.Reset;
          HRTravellingStaff.SetRange(HRTravellingStaff.EntryNo,"Entry Number");
          if HRTravellingStaff.FindSet then
          HRTravellingStaff.Delete;
    end;


    procedure HRTravelRequisitionCancel("Req No": Text)
    begin
         HRTransportRequisition.Reset;
          HRTransportRequisition.SetRange(HRTransportRequisition."Transport Requisition No","Req No");
          HRTransportRequisition.SetRange(HRTransportRequisition.Status,HRTransportRequisition_2.Status::Open);

          if  HRTransportRequisition.Find('-') then
          begin
           HRTransportRequisition.Status:=HRTransportRequisition_2.Status::Cancelled;
           HRTransportRequisition.Modify;
          end
          else
          begin
              Error('You can only cancel open ticket');
          end
    end;


    procedure HRAppraisalApprovalUpdate("Document No": Text;"Supervisor ID param": Text)
    begin
        HRAppraisalIndividualTargetHeader.Reset;
        HRAppraisalIndividualTargetHeader.SetRange(HRAppraisalIndividualTargetHeader."Appraisal no","Document No");

        if HRAppraisalIndividualTargetHeader.Find('-')
          then
            begin
            "Supervisor ID":="Supervisor ID param";
            ApprovalEntry.SetRange(ApprovalEntry."Document No.","Document No");
            ApprovalEntry.SetRange(ApprovalEntry."Approver ID","Supervisor ID param");
            ApprovalEntry.SetRange(ApprovalEntry.Status,ApprovalEntry.Status::Open);
            if ApprovalEntry.Find('-') then
            begin
                //Modify status to approved if there are no other approvers
                ApprovalEntry.Status:=ApprovalEntry.Status::Approved;
                ApprovalEntry.Modify;

                //Change next doc to open
                ApprovalEntry_2.Reset;
                ApprovalEntry_2.SetRange(ApprovalEntry_2."Document No.","Document No");
                ApprovalEntry_2.SetRange(ApprovalEntry_2.Status,ApprovalEntry_2.Status::Created);
                if ApprovalEntry_2.Find('-') then
                begin
                    ApprovalEntry_2.Status:=ApprovalEntry_2.Status::Open;
                    ApprovalEntry_2."Last Date-Time Modified" := CreateDatetime(Today,Time);
                    ApprovalEntry_2."Last Modified By ID" :="Supervisor ID param";
                    ApprovalEntry_2.Modify;
                    //SuccessMessage:='Approval successful.';
                end;

            end;
            ApprovalEntry_2.Reset;
            ApprovalEntry_2.SetRange(ApprovalEntry_2."Document No.","Document No");
              if ApprovalEntry_2.FindLast then
                begin
                  if ApprovalEntry_2.Status=ApprovalEntry_2.Status::Approved  then
                      begin
                          HRAppraisalIndividualTargetHeader.Reset;
                           HRAppraisalIndividualTargetHeader.SetRange(HRAppraisalIndividualTargetHeader."Appraisal no","Document No");
                          if HRAppraisalIndividualTargetHeader.Find('-')then
                             begin
                             HRAppraisalIndividualTargetHeader.Status:=HRAppraisalIndividualTargetHeader.Status::Approved;
                               // HRLeave.CreateLeaveLedgerEntries;
                                if ApprovalSetup.Approvals then
                                  ApprovalMgtNotification.SendBSCApprovalsMail(HRAppraisalIndividualTargetHeader,ApprovalEntry);

                             end;
                      end;
                end;

            end;
    end;


    procedure HRAppraisalReject("Document No": Text;"Supervisor Id": Text)
    begin
        ApprovalEntry.SetRange("Document No.","Document No");
        if ApprovalEntry.Find('-') then
          repeat
            ApprovalEntry.Status := ApprovalEntry.Status::Rejected;
            ApprovalEntry."Last Date-Time Modified" := CreateDatetime(Today,Time);
            ApprovalEntry."Last Modified By ID" :="Supervisor Id";
            ApprovalEntry.Modify;
            ApprovalMgtNotification.SendBSCCancellationsMail(HRAppraisalIndividualTargetHeader,ApprovalEntry);
          until ApprovalEntry.Next = 0;

        HRAppraisalIndividualTargetHeader.SetRange(HRAppraisalIndividualTargetHeader."Appraisal no","Document No");
        if  HRAppraisalIndividualTargetHeader.Find('-') then
        begin  HRAppraisalIndividualTargetHeader.Status:=HRAppraisalIndividualTargetHeader.Status::Open;
          HRAppraisalIndividualTargetHeader.Modify;
          Message('You rejected Document No %1',"Document No" );
          end;
    end;


    procedure GeneratePaySlipReport(EmployeeNo: Text;Period: Date;filenameFromApp: Text): Text[100]
    begin
        filename :=FILESPATH+filenameFromApp;
         if Exists(filename) then
          Erase(filename);

        "Employee Card".Reset;
        "Employee Card".SetRange("Employee Card"."No.",EmployeeNo);
        "Employee Card".SetRange("Employee Card"."Current Month Filter",Period);

        if "Employee Card".Find('-') then begin
        Report.SaveAsPdf(39005514,filename,"Employee Card");
         end;
        exit(filename);
    end;


    procedure GenerateFOSAStatement(MemberNo: Text;filenameFromApp: Text;"Start Date": Date;"End Date": Date): Text[100]
    var
        filename: Text;
    begin
        filename :=FILESPATH+filenameFromApp;
         if Exists(filename) then
          Erase(filename);
        Member.Reset;
        Member.SetRange(Member."No.",MemberNo);
        Member.SetRange(Member."Date Filter","Start Date","End Date");
        if Member.Find('-') then begin
          Report.SaveAsPdf(Report::"Account Statement",filename,Member);
        end;
        exit(filename);
    end;


    procedure GenerateFOSALoanGuarantorsReport("BOSA Number": Text;filenameFromApp: Text): Text[100]
    var
        filename: Text;
    begin
        filename :=FILESPATH+filenameFromApp;
         if Exists(filename) then
          Erase(filename);
        Member.Reset;
        Member.SetRange(Member."BOSA Account No","BOSA Number");
        if Member.Find('-') then begin
          Report.SaveAsPdf(Report::"Loans Guarantors FOSA",filename,Member);
        end;
        exit(filename);
    end;


    procedure loadtheyearsTarget("Employee No": Text;"Appraisal Year": Integer;"Appraisal no": Text;"Appraisal Period": Date)
    var
        AppraisalYear: Integer;
    begin
           i:=0;
           "Bsc Line".Reset;
           "Bsc Line".FindLast;
            i:="Bsc Line"."Line No";
            i:=i+1;


          "Bsc Head".Reset;
          "Bsc Head".SetRange("Bsc Head"."Appraisal Year","Appraisal Year");
          "Bsc Head".SetRange("Bsc Head"."Employee No","Employee No");
          "Bsc Head".SetRange("Bsc Head"."Appraisal Type","Bsc Head"."appraisal type"::"Target Setting");
          if "Bsc Head".Find('-') then begin
          //MESSAGE('TESTING');
            "Bsc Line".Reset;
            "Bsc Line".SetRange("Bsc Line"."Appraisal No","Bsc Head"."Appraisal no");
            if "Bsc Line".Find('-') then begin

            repeat
            //I:=I+1;
            //MESSAGE('LINE NO %1',i);
           Message("Appraisal no");
           "Bsc Line2".Init;
           "Bsc Line2"."Line No":=i;
           "Bsc Line2"."Appraisal No":="Appraisal no";
           "Bsc Line2"."Perspective Code":="Bsc Line"."Perspective Code";
           "Bsc Line2"."Targeted Score":="Bsc Line"."Targeted Score";
           //"Bsc Line2"."Achieved Score":="Bsc Line"."Achieved Score";
           "Bsc Line2"."Unachieved Targets":="Bsc Line"."Unachieved Targets";
           "Bsc Line2"."Appraisee Comments":="Bsc Line"."Appraisee Comments";
           "Bsc Line2".Objective:="Bsc Line".Objective;
           "Bsc Line2"."Start Date":="Bsc Line"."Start Date";
           "Bsc Line2"."End Date":="Bsc Line"."End Date";
           //"Bsc Line2"."Self Rating":="Bsc Line"."Self Rating";
           //"Bsc Line2"."Supervisor Rating":="Bsc Line"."Supervisor Rating";
           //"Bsc Line2"."Agreed Rating":="Bsc Line"."Agreed Rating";
           "Bsc Line2"."Appraisal Period":="Appraisal Period";
           "Bsc Line2"."Perspective Description":="Bsc Line"."Perspective Description";
           "Bsc Line2"."Perspective type":="Bsc Line"."Perspective type";
          // "Bsc Line2"."Appraisal Type":="Bsc Line"."Appraisal Type";
           "Bsc Line2".Insert;
           i:=i+1;
            until "Bsc Line".Next=0
            end
          end
    end;


    procedure HRAppraisalReview(AppraisalReviewLine: Integer;"Appraisal Comments": Text)
    begin
         HRAppraisalIndividualTargetLine.Reset;
         HRAppraisalIndividualTargetLine.SetRange(HRAppraisalIndividualTargetLine."Line No",AppraisalReviewLine);

        if HRAppraisalIndividualTargetLine.Find('-') then begin
           HRAppraisalIndividualTargetLine."Appraisee Comments":="Appraisal Comments";
           HRAppraisalIndividualTargetLine.Modify;
        end;
    end;


    procedure GenerateBOSAStatement(MemberNo: Text;filenameFromApp: Text;"Start Date": Date;"End Date": Date): Text[100]
    var
        filename: Text;
    begin
        filename :=FILESPATH+filenameFromApp;
         if Exists(filename) then
          Erase(filename);
        BOSA.Reset;
        BOSA.SetRange(BOSA."No.",MemberNo);
        BOSA.SetRange(BOSA."Date Filter","Start Date","End Date");
        if BOSA.Find('-') then begin
          Report.SaveAsPdf(39004260,filename,BOSA);
        end;
        exit(filename);
    end;


    procedure GenerateFOSALoanGuaranteedReport(MemberNo: Text;filenameFromApp: Text): Text[100]
    var
        filename: Text;
    begin
        filename :=FILESPATH+filenameFromApp+'.pdf';
         if Exists(filename) then
          Erase(filename);
        BOSA.Reset;
        BOSA.SetRange(BOSA."No.",MemberNo);
        if BOSA.Find('-') then begin
          Report.SaveAsPdf(Report::"Loans Guaranteed",filename,BOSA);
        end;
        exit(filename);
    end;


    procedure GenerateDividendsReport(MemberNo: Text;filenameFromApp: Text): Text[100]
    var
        filename: Text;
    begin
        filename :=FILESPATH+filenameFromApp;
         if Exists(filename) then
          Erase(filename);
        BOSA.Reset;
        BOSA.SetRange(BOSA."No.",MemberNo);
        if BOSA.Find('-') then begin
          Report.SaveAsPdf(Report::"Dividends Report",filename,BOSA);
        end;
        exit(filename);
    end;


    procedure HRAppraisalEndYearReview(AppraisalReviewLine: Integer;"Appraisal Comments": Text;"Achieved Targets": Decimal)
    var
        "Unachieved Targets": Decimal;
        "Achieved Score": Decimal;
    begin
         HRAppraisalIndividualTargetLine.Reset;
         HRAppraisalIndividualTargetLine.SetRange(HRAppraisalIndividualTargetLine."Line No",AppraisalReviewLine);

        if HRAppraisalIndividualTargetLine.Find('-') then begin
          HRAppraisalIndividualTargetLine."Unachieved Targets":=HRAppraisalIndividualTargetLine."Targeted Score"-"Achieved Targets";
          if (HRAppraisalIndividualTargetLine."Targeted Score"<>0) and ("Achieved Targets"<>0) then
          HRAppraisalIndividualTargetLine."Achieved Score":="Achieved Targets"/HRAppraisalIndividualTargetLine."Targeted Score"*100;
          "Achieved Score":="Achieved Targets"/HRAppraisalIndividualTargetLine."Targeted Score"*100;
          if "Achieved Score"<>0 then
           HRAppraisalIndividualTargetLine.Score:="Achieved Score"*20/100;
           HRAppraisalIndividualTargetLine."Appraisee Comments":="Appraisal Comments";
           HRAppraisalIndividualTargetLine."Achieved Target":="Achieved Targets";
           HRAppraisalIndividualTargetLine.Modify;
        end;
    end;


    procedure HRAppraisalAddCompetency(AppraisalNo: Code[20];Target: Option;Competency: Code[50];"Self Rating": Option;EmployNo: Text)
    begin

        HRAppraisalCompetencies.Reset;
        HRAppraisalCompetencies.SetRange(HRAppraisalCompetencies.Competency,Competency);
        HRAppraisalCompetencies.SetRange(HRAppraisalCompetencies."Appraisal No.",AppraisalNo);
        if HRAppraisalCompetencies.Find('-') then
        Error('You have already added this competency');
        HRAppraisalCompetencies.Competency:=Competency;
        HRAppraisalCompetencies."Emp No.":=EmployNo;
        HRAppraisalCompetencies."Appraisal No.":=AppraisalNo;
        HRAppraisalCompetencies.Target := Target;
        HRAppraisalCompetencies."Self Rating":="Self Rating";
        //HRAppraisalCompetencies."Rating Score":="Rating Score";
        //HRAppraisalCompetencies.Comment:=Comments;

        HRAppraisalCompetencies.Insert(true);
    end;


    procedure HRAppraisalCalculateBSC("Appraisal no": Text) returnedValues: Text[200]
    var
        returnValue: Text;
    begin
         BSC.Reset;
         BSC.SetRange(BSC."Appraisal no","Appraisal no");
         if BSC.Find('-') then begin
         BSC.CalcFields(BSC."Finance Rating",BSC.Finance,BSC."Service Rating",BSC.Service,BSC."Customer Rating",BSC.Customer,BSC."Training Rating",BSC.Training,BSC."Competence Rating");
         if (BSC."Finance Rating"<>0) and (BSC.Finance<>0) then
          BSC."Finance Perc Score":=BSC."Finance Rating"/BSC.Finance;
         if (BSC."Customer Rating"<>0) and (BSC.Customer<>0) then
          BSC."Customer Perc Score":=BSC."Customer Rating"/BSC.Customer;
         if (BSC."Training Rating"<>0) and (BSC.Training<>0) then
          BSC."Training Perc Score":=BSC."Training Rating"/BSC.Training;
         if (BSC."Service Rating"<>0) and (BSC.Service<>0) then
          BSC."Service Perc Score":=BSC."Service Rating"/BSC.Service;
         if BSC."Competence Rating"<>0 then
          BSC."Competencies Score":=BSC."Competence Rating"/32*20;
          BSC."Overall Perc Score":=BSC."Finance Perc Score"+BSC."Customer Perc Score"+BSC."Training Perc Score"+BSC."Service Perc Score";
          BSC.Modify;
          //MESSAGE('%1,TEST',BSC."Service Perc Score");
         end
    end;


    procedure HRAppraisalCompetencyUpdate(LineNo: Integer;Target: Integer;"Self Rating": Integer)
    begin
        HRAppraisalCompetencies.Reset;

        HRAppraisalCompetencies.SetRange(HRAppraisalCompetencies."Line No",LineNo);

        if HRAppraisalCompetencies.Find('-') then
        begin
            HRAppraisalCompetencies.Target:=Target;
            HRAppraisalCompetencies."Self Rating":="Self Rating";
            HRAppraisalCompetencies.Modify;
        end;
    end;


    procedure OnlineLoansCreate(MemberNo: Text;"Product Code": Text;"Loan Amount": Decimal)
    begin
          "Online Loan Application".Reset;
          "Online Loan Application".Init;
          "Online Loan Application"."Application Date":=Today;
          "Online Loan Application"."Membership No":=MemberNo;
          "Online Loan Application".Insert(true);
    end;


    procedure LNMemberShareBanding("Client Code": Text;"Approved Amount": Decimal): Decimal
    var
        TEMP: Decimal;
        MAXIMUM: Decimal;
        MAXNEW: Decimal;
        MAXBAND: Decimal;
        "Band Shares": Decimal;
    begin
            //+++++++++++Bonface!!Added to Accomodate New Share Banding
            //ASSIGN BAND
            LnApp.Reset;
            LnApp.SetRange(LnApp."Client Code","Client Code");
            if LoanApp.Find('-') then begin
             repeat
             LnApp.CalcFields(LnApp."Outstanding Balance");
              if LnApp."Outstanding Balance" > 0 then begin
               TEMP:="Approved Amount";
                if MAXIMUM < TEMP then
                MAXIMUM:= TEMP ;
              end;
             until LnApp.Next=0;
            end;

           MAXNEW:=LnApp."Shares Balance"; //Commented by safaricom

            if BANDING.Find('-') then begin
            repeat
            if ( MAXNEW >= BANDING."Minimum Amount" ) and ( MAXNEW <= BANDING."Maximum Amount" ) then begin
            MAXBAND:="Approved Amount"*(BANDING."Pro Rata Rate"/100);
            end;
            until BANDING.Next=0;
            end;

            if MAXBAND > GenSetUp."Min. Contribution" then begin
            "Band Shares":=MAXBAND;
            //MODIFY;
            end else
            "Band Shares":=GenSetUp."Min. Contribution";
            //MODIFY;

            CustMember.Reset;
            CustMember.SetRange(CustMember."No.","Client Code");
            if CustMember.Find('-') then begin

            MembContri.Reset;
            MembContri.SetRange(MembContri."No.","Client Code");
            if MembContri.Find('-') then
            repeat
            if MembContri.Type=MembContri.Type::"Deposit Contribution" then
            MinShares:=MembContri.Amount;
            until MembContri.Next=0;
            end;

            if "Band Shares" < MinShares then begin
            CustMember."Shares Band":=MinShares
            end else
            CustMember."Shares Band":="Band Shares";
            CustMember.Modify;
            "Band Shares":=CustMember."Shares Band";
            exit("Band Shares");
            //+++++++++++Bonface!!Added to Accomodate New Share Banding
    end;
}

