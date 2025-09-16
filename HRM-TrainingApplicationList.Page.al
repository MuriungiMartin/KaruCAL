#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68867 "HRM-Training Application List"
{
    CardPageID = "HRM-Training Application Card";
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable61216;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Application No";"Application No")
                {
                    ApplicationArea = Basic;
                }
                field("Training Category";"Training Category")
                {
                    ApplicationArea = Basic;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                }
                field("Course Title";"Course Title")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Purpose of Training";"Purpose of Training")
                {
                    ApplicationArea = Basic;
                }
                field("From Date";"From Date")
                {
                    ApplicationArea = Basic;
                }
                field("To Date";"To Date")
                {
                    ApplicationArea = Basic;
                }
                field("Cost Of Training";"Cost Of Training")
                {
                    ApplicationArea = Basic;
                }
                field(Provider;"Training Institution")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = true;
                }
            }
        }
        area(factboxes)
        {
            part(Control1102755002;"HRM-Trainings Factbox")
            {
                SubPageLink = "Application No"=field("Application No");
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
                        DocumentType:=Documenttype::"Training Application";

                        //ApprovalComments.Setfilters(DATABASE::"HR Training Applications",DocumentType,"Application No");
                        //ApprovalComments.SetUpLine(DATABASE::"HR Training Applications",DocumentType,"Application No");
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
                    RunPageLink = "Training Code"=field("Application No");
                }
                action("Training Cost Elements")
                {
                    ApplicationArea = Basic;
                    Caption = 'Training Cost Elements';
                    Image = CalculateCost;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "HRM-Training Cost";
                    RunPageLink = "Training Id"=field("Application No");
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
                        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Store Requisition","Employee Requisition","Leave Application","Transport Requisition","Training Requisition","Job Approval";
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        DocumentType:=Documenttype::"Training Requisition";
                        ApprovalEntries.Setfilters(Database::"HRM-Training Applications",DocumentType,"Application No");
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
                        if ("No of Participants"<2)then  begin
                        Error('Participants should not be less than two');
                        end;
                        if ("No of Participants">"No of Required Participants") then
                        begin
                            Error('Nominated Participants cannot exceed the Number of Participants Required ');
                        end;
                        if ("No of Participants"<=0) then
                        begin
                            Error('Nominated Participants cannot be Less Than or Equal to Zero');
                        end;

                        if Confirm('Send this Application for Approval?',true)=false then exit;
                        //ApprovalMgt.SendTrainingAppApprovalRequest(Rec);
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
                        //ApprovalMgt.CancelTrainingAppApprovalReq(Rec,TRUE,TRUE);
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

                        HRTrainingApplications.SetRange(HRTrainingApplications."Application No","Application No");
                        if HRTrainingApplications.Find('-') then
                        Report.Run(39005484,true,true,HRTrainingApplications);
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

    var
        HREmp: Record UnknownRecord61188;
        EmpNames: Text[40];
        sDate: Date;
        HRTrainingApplications: Record UnknownRecord61216;
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
        TestField("Course Title");
        TestField("From Date");
        TestField("To Date");
        TestField("Duration Units");
        TestField(Duration);
        TestField("Cost Of Training");
        TestField(Location);
        TestField(Trainer);
        TestField("Purpose of Training");
        TestField(Description)
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

