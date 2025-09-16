#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68925 "HRM-Posted Leave Applic."
{
    DeleteAllowed = true;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Functions,Comments';
    SourceTable = UnknownTable61125;
    SourceTableView = where(Status=filter(Posted));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Editable = "Responsibility CenterEditable";
                }
                field("Leave Type";"Leave Type")
                {
                    ApplicationArea = Basic;
                    Editable = "Leave TypeEditable";
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                                            GetLeaveStats("Leave Type");
                        //                    CurrPage.UPDATE;
                    end;
                }
                field("Return Date";"Return Date")
                {
                    ApplicationArea = Basic;
                }
                label("Employee Details")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Details';
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field("Employee No";"Employee No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee No.';
                    Editable = false;
                    Enabled = false;
                    Importance = Promoted;
                }
                field(EmpName;EmpName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Applicant Name';
                    Editable = false;
                    Enabled = false;
                    Importance = Promoted;
                }
                field(EmpJobDesc;EmpJobDesc)
                {
                    ApplicationArea = Basic;
                    Caption = 'Job Description';
                    Editable = false;
                    Enabled = false;
                    Importance = Promoted;
                }
                field(EmpDept;EmpDept)
                {
                    ApplicationArea = Basic;
                    Caption = 'Department';
                    Editable = false;
                    Enabled = false;
                }
                field(SupervisorName;SupervisorName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Supervisor Name';
                    Editable = false;
                }
                label(Control1102755082)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19010232;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field(dEarnd;dEarnd)
                {
                    ApplicationArea = Basic;
                    Caption = 'Total Leave Days';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = true;
                }
                field(dTaken;dTaken)
                {
                    ApplicationArea = Basic;
                    Caption = 'Total Leave Taken';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = true;
                }
                field(dLeft;dLeft)
                {
                    ApplicationArea = Basic;
                    Caption = 'Leave Balance';
                    Editable = false;
                    Enabled = false;
                    Style = Strong;
                    StyleExpr = true;
                }
                field("Reliever Name";"Reliever Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1102755004;Outlook)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Show")
            {
                Caption = '&Show';
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Comments';
                    Image = Comment;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    var
                        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Bank Slip",Grant,"Grant Surrender","Employee Requisition","Leave Application","Training Application","Transport Requisition";
                    begin
                        DocumentType:=Documenttype::"Leave Application";

                        //ApprovalComments.Setfilters(DATABASE::"HR Leave Application",DocumentType,"Application Code");
                        //ApprovalComments.SetUpLine(DATABASE::"HR Leave Application",DocumentType,"Application Code");
                        //ApprovalComments.RUN;
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("&Approvals")
                {
                    ApplicationArea = Basic;
                    Caption = '&Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        //DocumentType:=DocumentType::"Leave Application";
                        //ApprovalEntries.Setfilters(DATABASE::"HR Leave Application",DocumentType,"Application Code");
                        //''ApprovalEntries.RUN;
                    end;
                }
                action("&Send Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = '&Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        
                        TESTFIELDS;
                        /*
                        IF CONFIRM('Send this Application for Approval?',TRUE)=FALSE THEN EXIT;
                        Selected:=TRUE;
                        "User ID":=USERID;
                        
                        ApprovalMgt.SendLeaveAppApprovalReq(Rec);  */

                    end;
                }
                action("&Cancel Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = '&Cancel Approval Request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                }
                action("Re-Open")
                {
                    ApplicationArea = Basic;
                    Caption = 'Re-Open';
                    Image = ReopenCancelled;
                    Promoted = true;
                    PromotedCategory = Category4;
                }
                action(Print)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print';
                    Image = PrintForm;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        /*HRLeaveApp.RESET;
                        HRLeaveApp.SETRANGE(HRLeaveApp."Application Code","Application Code");
                        IF HRLeaveApp.FIND('-') THEN
                        REPORT.RUN(39005491,TRUE,TRUE,HRLeaveApp); */

                    end;
                }
                action("Create Leave Ledger Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Leave Ledger Entries';
                    Image = CreateLinesFromJob;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = false;

                    trigger OnAction()
                    begin
                                                    //CreateLeaveLedgerEntries;
                                                   // RESET;
                    end;
                }
                action("HR Leave Adjustments")
                {
                    ApplicationArea = Basic;
                    Caption = 'HR Leave Adjustments';
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "PROC-PRF Lines";
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin


                                   EmpDept:='';
                                   //PASS VALUES TO VARIABLES ON THE FORM
                                   FillVariables;
                                   //GET LEAVE STATS FOR THIS EMPLOYEE FROM THE EMPLOYEE TABLE
                                   GetLeaveStats("Leave Type");
                                   //TO PREVENT USER FROM SEEING OTHER PEOPLES LEAVE APPLICATIONS
                                  //SETFILTER("User ID",USERID);

                                   Updatecontrols;
    end;

    trigger OnInit()
    begin
        NumberofPreviousAttemptsEditab := true;
        "Date of ExamEditable" := true;
        "Details of ExaminationEditable" := true;
        "Cell Phone NumberEditable" := true;
        SupervisorEditable := true;
        RequestLeaveAllowanceEditable := true;
        RelieverEditable := true;
        "Leave Allowance AmountEditable" := true;
        "Start DateEditable" := true;
        "Responsibility CenterEditable" := true;
        "Days AppliedEditable" := true;
        "Leave TypeEditable" := true;
        "Application CodeEditable" := true;
    end;

    var
        HREmp: Record UnknownRecord61188;
        EmpJobDesc: Text[30];
        HRJobs: Record UnknownRecord61057;
        SupervisorName: Text[30];
        SMTP: Codeunit "SMTP Mail";
        URL: Text[500];
        dAlloc: Decimal;
        dEarnd: Decimal;
        dTaken: Decimal;
        dLeft: Decimal;
        cReimbsd: Decimal;
        cPerDay: Decimal;
        cbf: Decimal;
        HRSetup: Record UnknownRecord61675;
        EmpDept: Text[30];
        ApprovalMgt: Codeunit "Export F/O Consolidation";
        HRLeaveApp: Record UnknownRecord61125;
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Store Requisition","Employee Requisition","Leave Application","Transport Requisition","Training Requisition","Job Approval";
        ApprovalEntries: Page "Approval Entries";
        HRLeaveLedgerEntries: Record UnknownRecord61659;
        EmpName: Text[70];
        ApprovalComments: Page "Approval Comments";
        [InDataSet]
        "Application CodeEditable": Boolean;
        [InDataSet]
        "Leave TypeEditable": Boolean;
        [InDataSet]
        "Days AppliedEditable": Boolean;
        [InDataSet]
        "Responsibility CenterEditable": Boolean;
        [InDataSet]
        "Start DateEditable": Boolean;
        [InDataSet]
        "Leave Allowance AmountEditable": Boolean;
        [InDataSet]
        RelieverEditable: Boolean;
        [InDataSet]
        RequestLeaveAllowanceEditable: Boolean;
        [InDataSet]
        SupervisorEditable: Boolean;
        [InDataSet]
        "Cell Phone NumberEditable": Boolean;
        [InDataSet]
        "Details of ExaminationEditable": Boolean;
        [InDataSet]
        "Date of ExamEditable": Boolean;
        [InDataSet]
        NumberofPreviousAttemptsEditab: Boolean;
        Text19010232: label 'Leave Statistics';
        Text1: label 'Reliver Details';


    procedure FillVariables()
    begin
                                    //GET THE APPLICANT DETAILS
                               /*
                                    HREmp.RESET;
                                    IF HREmp.GET() THEN
                                    BEGIN
                                    EmpName:=HREmp.FullName;
                                    EmpDept:=HREmp."Department Name";
                                    END ELSE BEGIN
                                    EmpDept:='';
                                    END;
        
                                    //GET THE JOB DESCRIPTION FRON THE HR JOBS TABLE AND PASS IT TO THE VARIABLE
                                    HRJobs.RESET;
                                    IF HRJobs.GET("Job Tittle") THEN
                                    BEGIN
                                    EmpJobDesc:=HRJobs."Job Description";
                                    END ELSE BEGIN
                                    EmpJobDesc:='';
                                    END;
        
                                    //GET THE APPROVER NAMES
                                    HREmp.RESET;
                                    HREmp.SETRANGE(HREmp."User ID",Supervisor);
                                    IF HREmp.FIND('-') THEN
                                    BEGIN
                                    SupervisorName:=HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                                    END ELSE BEGIN
                                    SupervisorName:='';
                                    END;  */

    end;


    procedure GetLeaveStats(LeaveType: Text[50])
    begin

                                    dAlloc := 0;
                                    dEarnd := 0;
                                    dTaken := 0;
                                    dLeft := 0;
                                    cReimbsd := 0;
                                    cPerDay := 0;
                                    cbf:=0;
                                    if HREmp.Get("Employee No") then begin
                                    HREmp.SetFilter(HREmp."Leave Type Filter",LeaveType);
                                    HREmp.CalcFields(HREmp."Allocated Leave Days");
                                    dAlloc := HREmp."Allocated Leave Days";
                                    HREmp.Validate(HREmp."Allocated Leave Days");
                                    dEarnd := HREmp."Total (Leave Days)";
                                    HREmp.CalcFields(HREmp."Total Leave Taken");
                                    dTaken := HREmp."Total Leave Taken";
                                    dLeft :=  HREmp."Leave Balance";
                                    cReimbsd :=HREmp."Cash - Leave Earned";
                                    cPerDay := HREmp."Cash per Leave Day" ;
                                    cbf:=HREmp."Reimbursed Leave Days";
                                    end;
    end;


    procedure TESTFIELDS()
    begin
                                   /*     TESTFIELD("Leave Type");
                                        TESTFIELD("Days Applied");
                                        TESTFIELD("Start Date");
                                        TESTFIELD(Reliever);
                                        TESTFIELD(Supervisor);*/

    end;


    procedure Updatecontrols()
    begin
         /*
        IF Status=Status::New THEN BEGIN
        "Application CodeEditable" :=TRUE;
        "Leave TypeEditable" :=TRUE;
        "Days AppliedEditable" :=TRUE;
        "Responsibility CenterEditable" :=TRUE;
        "Start DateEditable" :=TRUE;
        "Leave Allowance AmountEditable" :=TRUE;
        RelieverEditable :=TRUE;
        RequestLeaveAllowanceEditable :=TRUE;
        SupervisorEditable :=TRUE;
        "Cell Phone NumberEditable" :=TRUE;
        //CurrForm."E-mail Address".EDITABLE:=TRUE;
        "Details of ExaminationEditable" :=TRUE;
        "Date of ExamEditable" :=TRUE;
        NumberofPreviousAttemptsEditab :=TRUE;
        END ELSE BEGIN
        "Application CodeEditable" :=FALSE;
        "Leave TypeEditable" :=FALSE;
        "Days AppliedEditable" :=FALSE;
        "Responsibility CenterEditable" :=FALSE;
        "Start DateEditable" :=FALSE;
        "Leave Allowance AmountEditable" :=FALSE;
        RelieverEditable :=FALSE;
        RequestLeaveAllowanceEditable :=FALSE;
        SupervisorEditable :=FALSE;
        "Cell Phone NumberEditable" :=FALSE;
        //CurrForm."E-mail Address".EDITABLE:=FALSE;
        "Details of ExaminationEditable" :=FALSE;
        "Date of ExamEditable" :=FALSE;
        NumberofPreviousAttemptsEditab :=FALSE;
        END;
          */

    end;
}

