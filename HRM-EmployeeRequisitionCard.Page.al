#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68717 "HRM-Employee Requisition Card"
{
    DeleteAllowed = false;
    InsertAllowed = true;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Functions,Job';
    SourceTable = UnknownTable61200;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Requisition No.";"Requisition No.")
                {
                    ApplicationArea = Basic;
                    Editable = "Requisition No.Editable";
                    Importance = Promoted;
                }
                field("Requisition Date";"Requisition Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                }
                field(Requestor;Requestor)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Job ID";"Job ID")
                {
                    ApplicationArea = Basic;
                }
                field("Job Description";"Job Description")
                {
                    ApplicationArea = Basic;
                }
                field("Job Ref No";"Job Ref No")
                {
                    ApplicationArea = Basic;
                }
                field("Job Grade";"Job Grade")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
                field("Reason For Request";"Reason For Request")
                {
                    ApplicationArea = Basic;
                    Editable = "Reason For RequestEditable";
                }
                field("Type of Contract Required";"Type of Contract Required")
                {
                    ApplicationArea = Basic;
                }
                field(Priority;Priority)
                {
                    ApplicationArea = Basic;
                    Editable = PriorityEditable;
                }
                field("Vacant Positions";"Vacant Positions")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Required Positions";"Required Positions")
                {
                    ApplicationArea = Basic;
                    Editable = "Required PositionsEditable";
                    HideValue = true;
                    Importance = Promoted;
                }
                field("Opening Date";"Opening Date")
                {
                    ApplicationArea = Basic;
                }
                field("Closing Date";"Closing Date")
                {
                    ApplicationArea = Basic;
                    Editable = "Closing DateEditable";
                    Importance = Promoted;
                }
                field("Requisition Type";"Requisition Type")
                {
                    ApplicationArea = Basic;
                    Editable = "Requisition TypeEditable";
                    Importance = Promoted;
                }
                field("Recruitment Criterion";"Recruitment Criterion")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Advertised;Advertised)
                {
                    ApplicationArea = Basic;
                }
                field(Closed;Closed)
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Importance = Promoted;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
            }
            group("Additional Information")
            {
                Caption = 'Additional Information';
                field("Any Additional Information";"Any Additional Information")
                {
                    ApplicationArea = Basic;
                    Editable = AnyAdditionalInformationEditab;
                }
                field("Reason for Request(Other)";"Reason for Request(Other)")
                {
                    ApplicationArea = Basic;
                    Editable = ReasonforRequestOtherEditable;
                }
            }
        }
        area(factboxes)
        {
            part(Control1102755022;"HRM-Employee Req. Factbox")
            {
                SubPageLink = "Job ID"=field("Job ID");
            }
            systempart(Control1102755020;Outlook)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Fu&nctions")
            {
                Caption = 'Fu&nctions';
                action(Advertise)
                {
                    ApplicationArea = Basic;
                    Caption = 'Advertise';
                    Image = Salutation;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                         //For external advertisement
                        //TESTFIELD("Requisition Type","Requisition Type"::Internal);
                        if "Requisition Type"<>"requisition type"::Internal then
                        if Advertised then
                        begin
                          if not Confirm('Are you sure you want to Un do advertisement for this job',false) then exit;
                         Advertised:=false;
                          Modify;
                         Message('Are you sure you want to Un do advertisement for this job',"Job Ref No");

                        end else
                        begin
                          if not Confirm('Are you sure you want to advertise this Job',false) then exit;
                         Advertised:=true;
                          Modify;
                          Message('Job vacancy %1 has been successfuly advertised',"Job Ref No");
                        end
                        else
                        //For Internal advertisement.
                        if "Requisition Type"="requisition type"::Internal then
                        HREmp.SetRange(HREmp.Status,HREmp.Status::Active);
                        if HREmp.Find('-') then

                        //GET E-MAIL PARAMETERS FOR JOB APPLICATIONS
                        HREmailParameters.Reset;
                        HREmailParameters.SetRange(HREmailParameters."Associate With",HREmailParameters."associate with"::"Vacancy Advertisements");
                        if HREmailParameters.Find('-') then
                        begin
                             repeat
                             HREmp.TestField(HREmp."Company E-Mail");
                             SMTP.CreateMessage(HREmailParameters."Sender Name",HREmailParameters."Sender Address",HREmp."Company E-Mail",
                             HREmailParameters.Subject,'Dear'+' '+ HREmp."First Name" +' '+
                             HREmailParameters.Body+' '+ "Job Description" +' '+ HREmailParameters."Body 2"+' '+ Format("Closing Date")+'. '+
                             HREmailParameters."Body 3",true);
                             SMTP.Send();
                             until HREmp.Next=0;

                        Message('All Employees have been notified about this vacancy');
                        HREmpReq.Advertised:=true;

                        end;
                    end;
                }
                action("&Approvals")
                {
                    ApplicationArea = Basic;
                    Caption = '&Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        DocumentType:=Documenttype::"Employee Requisition";
                        ApprovalEntries.Setfilters(Database::"HRM-Employee Requisitions",DocumentType,"Requisition No.");
                        ApprovalEntries.Run;
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
                        if Confirm('Send this Requisition for Approval?',true)=false then exit;

                        TESTFIELDS;

                        //ApprovalMgt.SendEmpRequisitionAppReq(Rec);
                    end;
                }
                action("&Cancel Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = '&Cancel Approval Request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        if Confirm('Cancel Approval Request?',true)=false then exit;

                        //ApprovalMgt.CancelEmpRequisitionAppRequest(Rec,TRUE,TRUE);
                    end;
                }
                action("Mark as Closed/Open")
                {
                    ApplicationArea = Basic;
                    Caption = 'Mark as Closed/Open';
                    Image = ReopenCancelled;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        if Closed then
                        begin
                          if not Confirm('Are you sure you want to Re-Open this Document',false) then exit;
                          Closed:=false;
                          Modify;
                          Message('Employee Requisition %1 has been Re-Opened',"Requisition No.");

                        end else
                        begin
                          if not Confirm('Are you sure you want to close this Document',false) then exit;
                          Closed:=true;
                          Modify;
                          Message('Employee Requisition %1 has been marked as Closed',"Requisition No.");
                        end;
                    end;
                }
                action("Re-Open")
                {
                    ApplicationArea = Basic;
                    Caption = 'Re-Open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Category5;
                    Visible = false;

                    trigger OnAction()
                    begin
                                  Status:=Status::New;
                                  Modify;
                    end;
                }
            }
            group(Job)
            {
                Caption = 'Job';
                action(Requirements)
                {
                    ApplicationArea = Basic;
                    Caption = 'Requirements';
                    Image = JobListSetup;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "HRM-Job Requirement Lines(B)";
                    RunPageLink = "Job Id"=field("Job ID");
                }
                action(Responsibilities)
                {
                    ApplicationArea = Basic;
                    Caption = 'Responsibilities';
                    Image = JobResponsibility;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "HRM-Job Resp. Lines";
                    RunPageLink = "Job ID"=field("Job ID");
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateControls;
        /*
        HRLookupValues.SETRANGE(HRLookupValues.Code,"Type of Contract Required");
        IF HRLookupValues.FIND('-') THEN
        ContractDesc:=HRLookupValues.Description;
        */

    end;

    trigger OnInit()
    begin
        TypeofContractRequiredEditable := true;
        AnyAdditionalInformationEditab := true;
        "Required PositionsEditable" := true;
        "Requisition TypeEditable" := true;
        "Closing DateEditable" := true;
        PriorityEditable := true;
        ReasonforRequestOtherEditable := true;
        "Reason For RequestEditable" := true;
        "Responsibility CenterEditable" := true;
        "Job IDEditable" := true;
        "Requisition DateEditable" := true;
        "Requisition No.Editable" := true;
    end;

    var
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Store Requisition","Employee Requisition","Leave Application","Transport Requisition","Training Requisition","Job Approval";
        ApprovalEntries: Page "Approval Entries";
        ApprovalMgt: Codeunit "Export F/O Consolidation";
        HREmpReq: Record UnknownRecord61200;
        SMTP: Codeunit "SMTP Mail";
        HRSetup: Record UnknownRecord61675;
        CTEXTURL: Text[30];
        HREmp: Record UnknownRecord61188;
        HREmailParameters: Record UnknownRecord61656;
        ContractDesc: Text[30];
        HRLookupValues: Record UnknownRecord61202;
        [InDataSet]
        "Requisition No.Editable": Boolean;
        [InDataSet]
        "Requisition DateEditable": Boolean;
        [InDataSet]
        "Job IDEditable": Boolean;
        [InDataSet]
        "Responsibility CenterEditable": Boolean;
        [InDataSet]
        "Reason For RequestEditable": Boolean;
        [InDataSet]
        ReasonforRequestOtherEditable: Boolean;
        [InDataSet]
        PriorityEditable: Boolean;
        [InDataSet]
        "Closing DateEditable": Boolean;
        [InDataSet]
        "Requisition TypeEditable": Boolean;
        [InDataSet]
        "Required PositionsEditable": Boolean;
        [InDataSet]
        AnyAdditionalInformationEditab: Boolean;
        [InDataSet]
        TypeofContractRequiredEditable: Boolean;


    procedure TESTFIELDS()
    begin
        TestField("Job ID");
        TestField("Closing Date");
        TestField("Type of Contract Required");
        TestField("Requisition Type");
        TestField("Required Positions");
        if "Reason For Request"="reason for request"::Other then
        TestField("Reason for Request(Other)");
    end;


    procedure UpdateControls()
    begin

        if Status=Status::New then begin
        "Requisition No.Editable" :=true;
        "Requisition DateEditable" :=true;
        "Job IDEditable" :=true;
        "Responsibility CenterEditable" :=true;
        "Reason For RequestEditable" :=true;
        ReasonforRequestOtherEditable :=true;
        PriorityEditable :=true;
        "Closing DateEditable" :=true;
        "Requisition TypeEditable" :=true;
        "Required PositionsEditable" :=true;
        "Required PositionsEditable" :=true;
        AnyAdditionalInformationEditab :=true;
        TypeofContractRequiredEditable :=true;
        end else begin
        "Requisition No.Editable" :=false;
        "Requisition DateEditable" :=false;
        "Job IDEditable" :=false;
        "Responsibility CenterEditable" :=false;
        "Reason For RequestEditable" :=false;
        ReasonforRequestOtherEditable :=false;
        PriorityEditable :=false;
        "Closing DateEditable" :=false;
        "Requisition TypeEditable" :=false;
        "Required PositionsEditable" :=false;
        "Required PositionsEditable" :=false;
        AnyAdditionalInformationEditab :=false;

        TypeofContractRequiredEditable :=false;
        end;
    end;
}

