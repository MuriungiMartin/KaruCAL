#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68981 "HRM-Induction Schedule List"
{
    CardPageID = "HRM-Induction Sched. Card";
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable61246;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Induction Code";"Induction Code")
                {
                    ApplicationArea = Basic;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                }
                field(Selected;Selected)
                {
                    ApplicationArea = Basic;
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Department Code";"Department Code")
                {
                    ApplicationArea = Basic;
                }
                field("Department Name";"Department Name")
                {
                    ApplicationArea = Basic;
                }
                field("Induction Period";"Induction Period")
                {
                    ApplicationArea = Basic;
                }
                field("Induction Start date";"Induction Start date")
                {
                    ApplicationArea = Basic;
                }
                field("Induction End  date";"Induction End  date")
                {
                    ApplicationArea = Basic;
                }
                field(Comments;Comments)
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(ActionGroup1102755003)
            {
            }
            action("&Staff Induction Entries")
            {
                ApplicationArea = Basic;
                Caption = '&Staff Induction Entries';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin

                    DocumentType:=Documenttype::"Induction Approval";
                    Inductionschedule.Reset;
                    Inductionschedule.SetRange(Inductionschedule.Selected,true);
                    Inductionschedule.SetRange(Inductionschedule."Department Code","Department Code");
                    if Inductionschedule.Find('-')then
                    begin

                        //ENSURE SELECTED RECORDS DO NOT EXCEED ONE
                        Number:=0;
                        Number:=Inductionschedule.Count;
                        if Number > 1 then
                        begin
                        Error('You cannot have more than one application selected');
                       // ERROR(FORMAT(Number)+' applications selected');

                        end;

                    ApprovalEntries.Setfilters(Database::"HRM-Induction Schedule",DocumentType,Inductionschedule."Department Code");
                    ApprovalEntries.Run;
                    end else begin
                    Error('No Application Selected');
                    end;
                end;
            }
            action("Send Request to HOD/Superviisor")
            {
                ApplicationArea = Basic;
                Caption = 'Send Request to HOD/Superviisor';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin

                    Inductionschedule.Reset;
                    Inductionschedule.SetRange(Inductionschedule.Selected,true);
                    Inductionschedule.SetRange(Inductionschedule."Induction Code","Induction Code");
                    Inductionschedule.SetRange(Inductionschedule."Department Code","Department Code");
                    if Inductionschedule.Find('-') then
                    begin
                          //ENSURE THAT SELECTED RECORDS DO NOT EXCEED ONE
                          Number:=0;
                          Number:=Inductionschedule.Count;
                          if Number > 1 then
                          begin
                          Error('You cannot have more than one application selected');
                          end;

                    TESTFIELDS;

                    if Confirm('Send this Induction Schedule for Approval?',true)=false then exit;

                    //ApprovalMgt.SendInducAppApprovalRequest(Inductionschedule);

                    end else begin
                    Message('Please Select one Induction schedule');
                    end;
                end;
            }
            action("&Cancel Induction Request")
            {
                ApplicationArea = Basic;
                Caption = '&Cancel Induction Request';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Category4;
            }
            action("HR Staff  Induction Report")
            {
                ApplicationArea = Basic;
                Image = print;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Hostel Status Summary Report";
            }
        }
    }

    var
        "Induction`": Record UnknownRecord61246;
        DepartmentName: Text[40];
        sDate: Date;
        Inductionschedule: Record UnknownRecord61246;
        Number: Integer;
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Budget Transfer","Employee Requisition","Leave Application","Transport Requisition","Training Requisition","Job Approval","Induction Approval";
        ApprovalEntries: Page "Approval Entries";
        ApprovalMgt: Codeunit "Export F/O Consolidation";
        HRJobs: Record UnknownRecord61193;
        Department: Record "Dimension Value";


    procedure TESTFIELDS()
    begin

        Inductionschedule.TestField(Inductionschedule."Department Code");
        Inductionschedule.TestField(Inductionschedule."Induction Start date");
        Inductionschedule.TestField(Inductionschedule."Induction End  date");
        Inductionschedule.TestField(Inductionschedule."Induction Period");
        //Inductionschedule.TESTFIELD(HRTrainingApplications.Duration);
        //Inductionschedule.TESTFIELD(HRTrainingApplications."Cost Of Training");
        //Inductionschedule.TESTFIELD(HRTrainingApplications.Location);
        //Inductionschedule.TESTFIELD(HRTrainingApplications.Provider);
        //Inductionschedule.TESTFIELD(Inductionschedule.Comments");
    end;


    procedure FillVariables()
    begin
        //GET THE APPLICANT DETAILS
        
        Department.Reset;
        if Department.Get("Department Code") then
        begin
        "Department Name":=Department.Name;
        //Department:=HREmp."Global Dimension 2";
        //"Job Title":=HREmp."Job Description";
        //END ELSE BEGIN
        //Department:='';
        end;
        
        //GET THE JOB DESCRIPTION FRON THE HR JOBS TABLE AND PASS IT TO THE VARIABLE
        /*HRJobs.RESET;
        IF HRJobs.GET("Job Title") THEN
        BEGIN
        "Job Title":=HRJobs."Job Description";
        END ELSE BEGIN
        "Job Title":='';
        END;
        */
        //GET THE APPROVER NAMES
        /*HREmp.RESET;
        HREmp.SETRANGE(HREmp."User ID",Supervisor);
        IF HREmp.FIND('-') THEN
        BEGIN
        "Supervisor Name":=HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
        END ELSE BEGIN
        "Supervisor Name":='';
        END;
        */

    end;


    procedure UpdateControls()
    begin
        
        /* IF Status=Status::New THEN BEGIN
         CurrForm."Application No".EDITABLE:=TRUE;
         CurrForm."User ID".EDITABLE:=TRUE;
         CurrForm."Staff Names".EDITABLE:=TRUE;
         CurrForm."Job Title".EDITABLE:=TRUE;
         CurrForm.Supervisor.EDITABLE:=TRUE;
         CurrForm."Supervisor Name".EDITABLE:=TRUE;
         CurrForm."Course Title".EDITABLE:=TRUE;
         CurrForm."Purpose of Training".EDITABLE:=TRUE;
         CurrForm.Status.EDITABLE:=TRUE;
         CurrForm."Employee No.".EDITABLE:=TRUE;
         CurrForm.Selected.EDITABLE:=TRUE;
         CurrForm.Recommendations.EDITABLE:=TRUE;
         CurrForm.Status.EDITABLE:=TRUE;
         CurrForm."Responsibility Center".EDITABLE:=TRUE;
         END ELSE BEGIN
         CurrForm."Application No".EDITABLE:=FALSE;
         CurrForm."User ID".EDITABLE:=FALSE;
         CurrForm."Staff Names".EDITABLE:=FALSE;
         CurrForm."Job Title".EDITABLE:=FALSE;
         CurrForm.Supervisor.EDITABLE:=FALSE;
         CurrForm."Supervisor Name".EDITABLE:=FALSE;
         CurrForm."Course Title".EDITABLE:=FALSE;
         CurrForm."Purpose of Training".EDITABLE:=FALSE;
         CurrForm.Status.EDITABLE:=FALSE;
         CurrForm."Employee No.".EDITABLE:=FALSE;
         CurrForm.Selected.EDITABLE:=FALSE;
         CurrForm.Recommendations.EDITABLE:=FALSE;
         CurrForm.Status.EDITABLE:=FALSE;
         CurrForm."Responsibility Center".EDITABLE:=FALSE;
         END;
         */

    end;


    procedure GetTrainingTypes("Course Title": Text[50])
    begin
    end;
}

