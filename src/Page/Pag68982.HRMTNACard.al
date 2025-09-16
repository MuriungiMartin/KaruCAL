#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68982 "HRM-TNA Card"
{
    DeleteAllowed = true;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Functions,Show';
    SourceTable = UnknownTable61242;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    Editable = "Application NoEditable";
                }
                field("Application Date";"Application Date")
                {
                    ApplicationArea = Basic;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                }
                field("Training category";"Training category")
                {
                    ApplicationArea = Basic;
                }
                field("Quarter Offered";"Quarter Offered")
                {
                    ApplicationArea = Basic;
                    Editable = "Employee No.Editable";
                }
                field("Employee Name";"Employee Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Directorate;Directorate)
                {
                    ApplicationArea = Basic;
                    Editable = "Employee DepartmentEditable";
                }
                field("Directorate Name";"Directorate Name")
                {
                    ApplicationArea = Basic;
                }
                field(Station;Station)
                {
                    ApplicationArea = Basic;
                }
                field("Station Name";"Station Name")
                {
                    ApplicationArea = Basic;
                }
                field(Department;Department)
                {
                    ApplicationArea = Basic;
                }
                field("Department Name";"Department Name")
                {
                    ApplicationArea = Basic;
                }
                field("Need Source";"Need Source")
                {
                    ApplicationArea = Basic;
                }
                field("Course Code";"Course Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Editable = "Course TitleEditable";
                }
                field("Course Version";"Course Version")
                {
                    ApplicationArea = Basic;
                }
                field("Course Version Description";"Course Version Description")
                {
                    ApplicationArea = Basic;
                }
                field("Individual Course";"Individual Course")
                {
                    ApplicationArea = Basic;
                    MultiLine = false;
                }
                field("Proposed Start Date";"Proposed Start Date")
                {
                    ApplicationArea = Basic;
                }
                field("Proposed End Date";"Proposed End Date")
                {
                    ApplicationArea = Basic;
                }
                field(Duration;Duration)
                {
                    ApplicationArea = Basic;
                }
                field("Duration Units";"Duration Units")
                {
                    ApplicationArea = Basic;
                }
                field(Location;Location)
                {
                    ApplicationArea = Basic;
                }
                field("Cost Of Training";"Cost Of Training")
                {
                    ApplicationArea = Basic;
                }
                field("No of Participants";"No of Participants")
                {
                    ApplicationArea = Basic;
                }
                field("No of Required Participants";"No of Required Participants")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field(Status;Status)
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
                        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Store Requisition","Employee Requisition","Leave Application","Transport Requisition","Training Requisition","Job Approval","Induction Approval","Disciplinary Approvals","Activity Approval","Exit Approval","Medical Claim Approval",Jv,"BackToOffice ","Training Needs";
                    begin
                        DocumentType:=Documenttype::"Training Needs";

                        //ApprovalComments.Setfilters(DATABASE::"HR Training Needs Analysis",DocumentType,Code);
                        //ApprovalComments.SetUpLine(DATABASE::"HR Training Needs Analysis",DocumentType,Code);
                        //ApprovalComments.RUN;
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Training Participants")
                {
                    ApplicationArea = Basic;
                    Caption = 'Training Participants';
                    Image = PersonInCharge;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "HRM-Training Partcipants";
                    RunPageLink = "Training Code"=field(Code);
                }
                action("Training Cost Elements")
                {
                    ApplicationArea = Basic;
                    Caption = 'Training Cost Elements';
                    Image = CalculateCost;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "HRM-Training Cost";
                    RunPageLink = "Training Id"=field(Code);
                }
                action("&Approvals")
                {
                    ApplicationArea = Basic;
                    Caption = '&Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Store Requisition","Employee Requisition","Leave Application","Transport Requisition","Training Requisition","Job Approval","Induction Approval","Disciplinary Approvals","Activity Approval","Exit Approval","Medical Claim Approval",Jv,"BackToOffice ","Training Needs";
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        DocumentType:=Documenttype::"Training Needs";
                        ApprovalEntries.Setfilters(Database::"HRM-Training Needs Analysis",DocumentType,Code);
                        ApprovalEntries.Run;
                    end;
                }
                action("&Send Approval &Request")
                {
                    ApplicationArea = Basic;
                    Caption = '&Send Approval &Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        TESTFIELDS;
                        CalcFields("No of Participants");
                        if "Training category"="training category"::Group  then
                         if  ("No of Participants"<2)then   begin
                         Error('Participants should not be less than two');
                         if ("No of Participants">"No of Required Participants") then
                         begin
                          Error('Nominated Participants cannot exceed the Number of Participants Required ');
                           end;
                          if ("No of Participants"<=0) then
                           begin
                            Error('Nominated Participants cannot be Less Than or Equal to Zero');
                           end;
                        end;
                        if Confirm('Send this Application for Approval?',true)=false then exit;
                        //ApprovalMgt.SendTNAApprovalRequest(Rec);
                    end;
                }
                action("&Cancel Approval request")
                {
                    ApplicationArea = Basic;
                    Caption = '&Cancel Approval request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        if Confirm('Are you sure you want to cancel the approval request',true)=false then exit;
                        //ApprovalMgt.CancelTNAApprovalReq(Rec,TRUE,TRUE);
                    end;
                }
                action("&Print")
                {
                    ApplicationArea = Basic;
                    Caption = '&Print';
                    Image = PrintForm;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        TestField(Status,Status::Approved);
                        HRTNA.SetRange(HRTNA.Code,Code);
                        if HRTNA.Find('-') then
                        Report.Run(39005484,true,true,HRTNA);
                    end;
                }
                action("<A ction1102755042>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Re-Open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = false;

                    trigger OnAction()
                    begin
                        Status:=Status::New;
                        Modify;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

        if Status=Status::New then begin
        "Responsibility CenterEditable" :=true;
        "Application NoEditable" :=true;
        "Employee No.Editable" :=true;
        "Employee NameEditable" :=true;
        "Employee DepartmentEditable" :=true;
        "Purpose of TrainingEditable" :=true;
        "Course TitleEditable" :=true;
        end else begin
        "Responsibility CenterEditable" :=false;
        "Application NoEditable" :=false;
        "Employee No.Editable" :=false;
        "Employee NameEditable" :=false;
        "Employee DepartmentEditable" :=false;
        "Purpose of TrainingEditable" :=false;
        "Course TitleEditable" :=false;
        end;

             if "Training category"="training category"::Group then begin
             "Course TitleEditable":=true;
             end else begin
             "Course TitleEditable":=false;
             end;
    end;

    trigger OnInit()
    begin
        "Course TitleEditable" := true;
        "Purpose of TrainingEditable" := true;
        "Employee DepartmentEditable" := true;
        "Employee NameEditable" := true;
        "Employee No.Editable" := true;
        "Application NoEditable" := true;
        "Responsibility CenterEditable" := true;
        "Course DescriptionEditable":=true;
        "Course TitleEditable":=true;
    end;

    var
        HREmp: Record UnknownRecord61188;
        EmpNames: Text[40];
        sDate: Date;
        HRTNA: Record UnknownRecord61242;
        ApprovalMgt: Codeunit "Export F/O Consolidation";
        ApprovalComments: Page "Approval Comments";
        [InDataSet]
        "Responsibility CenterEditable": Boolean;
        [InDataSet]
        "Application NoEditable": Boolean;
        [InDataSet]
        "Employee No.Editable": Boolean;
        [InDataSet]
        "Employee NameEditable": Boolean;
        [InDataSet]
        "Employee DepartmentEditable": Boolean;
        [InDataSet]
        "Purpose of TrainingEditable": Boolean;
        [InDataSet]
        "Course TitleEditable": Boolean;
        "Course DescriptionEditable": Boolean;


    procedure TESTFIELDS()
    begin
        TestField(Description);
        TestField("Proposed Start Date");
        TestField("Proposed End Date");
        //TESTFIELD("Duration Units");
        TestField(Duration);
        TestField("Cost Of Training");
        TestField(Location);
        TestField("Course Version Description");
        //TESTFIELD("Individual Course");
        TestField("Need Source")
    end;


    procedure UpdateControls()
    begin
        
             /*IF "Training category"="Training category"::Group THEN BEGIN
             CurrPage.Description.EDITABLE:=TRUE;
             END ELSE BEGIN
             CurrPage.Description.EDITABLE:=FALSE;
             END;
        */

    end;
}

