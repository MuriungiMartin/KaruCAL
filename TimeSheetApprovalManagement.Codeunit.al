#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 951 "Time Sheet Approval Management"
{
    Permissions = TableData Employee=r;

    trigger OnRun()
    begin
    end;

    var
        Text001: label 'There is nothing to submit for line with %1=%2, %3=%4.', Comment='There is nothing to submit for line with Time Sheet No.=10, Line No.=10000.';
        Text002: label 'You are not authorized to approve time sheet lines. Contact your time sheet administrator.';
        Text003: label 'Time sheet line cannot be reopened because there are linked service lines.';
        Text004: label '&All open lines [%1 line(s)],&Selected line(s) only';
        Text005: label '&All submitted lines [%1 line(s)],&Selected line(s) only';
        Text006: label '&All approved lines [%1 line(s)],&Selected line(s) only';
        Text007: label 'Submit for approval';
        Text008: label 'Reopen for editing';
        Text009: label 'Approve for posting';
        Text010: label 'Reject for correction';


    procedure Submit(var TimeSheetLine: Record "Time Sheet Line")
    begin
        with TimeSheetLine do begin
          if Status = Status::Submitted then
            exit;
          if Type = Type::" " then
            FieldError(Type);
          TestStatus;
          CalcFields("Total Quantity");
          if "Total Quantity" = 0 then
            Error(
              Text001,
              FieldCaption("Time Sheet No."),
              "Time Sheet No.",
              FieldCaption("Line No."),
              "Line No.");
          case Type of
            Type::Job:
              begin
                TestField("Job No.");
                TestField("Job Task No.");
              end;
            Type::Absence:
              TestField("Cause of Absence Code");
            Type::Service:
              TestField("Service Order No.");
          end;
          UpdateApproverID;
          Status := Status::Submitted;
          Modify(true);
        end;
    end;


    procedure ReopenSubmitted(var TimeSheetLine: Record "Time Sheet Line")
    begin
        with TimeSheetLine do begin
          if Status = Status::Open then
            exit;
          TestField(Status,Status::Submitted);
          Status := Status::Open;
          Modify(true);
        end;
    end;


    procedure ReopenApproved(var TimeSheetLine: Record "Time Sheet Line")
    begin
        with TimeSheetLine do begin
          if Status = Status::Submitted then
            exit;
          TestField(Status,Status::Approved);
          TestField(Posted,false);
          CheckApproverPermissions(TimeSheetLine);
          CheckLinkedServiceDoc(TimeSheetLine);
          UpdateApproverID;
          Status := Status::Submitted;
          Modify(true);
        end;
    end;


    procedure Reject(var TimeSheetLine: Record "Time Sheet Line")
    begin
        with TimeSheetLine do begin
          if Status = Status::Rejected then
            exit;
          TestField(Status,Status::Submitted);
          CheckApproverPermissions(TimeSheetLine);
          Status := Status::Rejected;
          Modify(true);
        end;
    end;


    procedure Approve(var TimeSheetLine: Record "Time Sheet Line")
    begin
        with TimeSheetLine do begin
          if Status = Status::Approved then
            exit;
          TestField(Status,Status::Submitted);
          CheckApproverPermissions(TimeSheetLine);
          Status := Status::Approved;
          "Approved By" := UserId;
          "Approval Date" := Today;
          Modify(true);
          case Type of
            Type::Absence:
              PostAbsence(TimeSheetLine);
            Type::Service:
              AfterApproveServiceOrderTmeSheetEntries(TimeSheetLine);
          end;
        end;
    end;

    local procedure PostAbsence(var TimeSheetLine: Record "Time Sheet Line")
    var
        Resource: Record Resource;
        TimeSheetHeader: Record "Time Sheet Header";
        TimeSheetDetail: Record "Time Sheet Detail";
        Employee: Record Employee;
        EmployeeAbsence: Record "Employee Absence";
        TimeSheetMgt: Codeunit "Time Sheet Management";
    begin
        TimeSheetHeader.Get(TimeSheetLine."Time Sheet No.");
        Resource.Get(TimeSheetHeader."Resource No.");
        Employee.SetRange("Resource No.",TimeSheetHeader."Resource No.");
        Employee.FindFirst;
        TimeSheetDetail.SetRange("Time Sheet No.",TimeSheetLine."Time Sheet No.");
        TimeSheetDetail.SetRange("Time Sheet Line No.",TimeSheetLine."Line No.");
        if TimeSheetDetail.FindSet(true) then
          repeat
            EmployeeAbsence.Init;
            EmployeeAbsence.Validate("Employee No.",Employee."No.");
            EmployeeAbsence.Validate("From Date",TimeSheetDetail.Date);
            EmployeeAbsence.Validate("Cause of Absence Code",TimeSheetDetail."Cause of Absence Code");
            EmployeeAbsence.Validate("Unit of Measure Code",Resource."Base Unit of Measure");
            EmployeeAbsence.Validate(Quantity,TimeSheetDetail.Quantity);
            EmployeeAbsence.Insert(true);

            TimeSheetDetail.Posted := true;
            TimeSheetDetail.Modify;
            TimeSheetMgt.CreateTSPostingEntry(
              TimeSheetDetail,
              TimeSheetDetail.Quantity,
              TimeSheetDetail.Date,
              '',
              TimeSheetLine.Description);
          until TimeSheetDetail.Next = 0;

        TimeSheetLine.Posted := true;
        TimeSheetLine.Modify;
    end;

    local procedure CheckApproverPermissions(TimeSheetLine: Record "Time Sheet Line")
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        if not UserSetup."Time Sheet Admin." then begin
          if TimeSheetLine."Approver ID" <> UpperCase(UserId) then
            Error(Text002);
        end;
    end;

    local procedure CheckLinkedServiceDoc(TimeSheetLine: Record "Time Sheet Line")
    var
        ServiceLine: Record "Service Line";
    begin
        ServiceLine.SetRange("Document Type",ServiceLine."document type"::Order);
        ServiceLine.SetRange("Document No.",TimeSheetLine."Service Order No.");
        ServiceLine.SetRange("Time Sheet No.",TimeSheetLine."Time Sheet No.");
        ServiceLine.SetRange("Time Sheet Line No.",TimeSheetLine."Line No.");
        if not ServiceLine.IsEmpty then
          Error(Text003);
    end;


    procedure GetTimeSheetDialogText(ActionType: Option Submit,Reopen;LinesQty: Integer): Text[100]
    begin
        case ActionType of
          Actiontype::Submit:
            exit(StrSubstNo(Text004,LinesQty));
          Actiontype::Reopen:
            exit(StrSubstNo(Text005,LinesQty));
        end;
    end;


    procedure GetManagerTimeSheetDialogText(ActionType: Option Approve,Reopen,Reject;LinesQty: Integer): Text[100]
    begin
        case ActionType of
          Actiontype::Approve,
          Actiontype::Reject:
            exit(StrSubstNo(Text005,LinesQty));
          Actiontype::Reopen:
            exit(StrSubstNo(Text006,LinesQty));
        end;
    end;


    procedure GetTimeSheetDialogInstruction(ActionType: Option Submit,Reopen): Text[100]
    begin
        case ActionType of
          Actiontype::Submit:
            exit(Text007);
          Actiontype::Reopen:
            exit(Text008);
        end;
    end;


    procedure GetManagerTimeSheetDialogInstruction(ActionType: Option Approve,Reopen,Reject): Text[100]
    begin
        case ActionType of
          Actiontype::Approve:
            exit(Text009);
          Actiontype::Reject:
            exit(Text010);
          Actiontype::Reopen:
            exit(Text008);
        end;
    end;

    local procedure AfterApproveServiceOrderTmeSheetEntries(var TimeSheetLine: Record "Time Sheet Line")
    var
        ServHeader: Record "Service Header";
        ServMgtSetup: Record "Service Mgt. Setup";
        TimeSheetMgt: Codeunit "Time Sheet Management";
    begin
        if ServMgtSetup.Get and ServMgtSetup."Copy Time Sheet to Order" then begin
          ServHeader.Get(ServHeader."document type"::Order,TimeSheetLine."Service Order No.");
          TimeSheetMgt.CreateServDocLinesFromTSLine(ServHeader,TimeSheetLine);
        end;
    end;
}

