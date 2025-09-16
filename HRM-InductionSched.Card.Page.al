#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68984 "HRM-Induction Sched. Card"
{
    PageType = Card;
    SourceTable = UnknownTable61246;

    layout
    {
        area(content)
        {
            group(General)
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
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1102755000;"HRM-Induction Part. List")
            {
                SubPageLink = "Induction Code"=field("Induction Code");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(ActionGroup1102755014)
            {
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
            action("&Send Approval Request")
            {
                ApplicationArea = Basic;
                Caption = '&Send Approval Request';
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
            action("&Cancel Approval Request")
            {
                ApplicationArea = Basic;
                Caption = '&Cancel Approval Request';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Category4;
            }
            action("Induction Participants ")
            {
                ApplicationArea = Basic;
                Caption = 'Induction Participants';
                Image = PersonInCharge;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page "HRM-Induction Part. List";
                RunPageLink = "Induction Code"=field("Induction Code");

                trigger OnAction()
                begin
                    
                    /*DocumentType:=DocumentType::"Induction Approval";
                    Inductionschedule.RESET;
                    Inductionschedule.SETRANGE(Inductionschedule.Selected,TRUE);
                    Inductionschedule.SETRANGE(Inductionschedule."Department Code","Department Code");
                    IF Inductionschedule.FIND('-')THEN
                    BEGIN
                    
                        //ENSURE SELECTED RECORDS DO NOT EXCEED ONE
                        Number:=0;
                        Number:=Inductionschedule.COUNT;
                        IF Number > 1 THEN
                        BEGIN
                        ERROR('You cannot have more than one application selected');
                       // ERROR(FORMAT(Number)+' applications selected');
                    
                        END;
                    
                    ApprovalEntries.Setfilters(DATABASE::"HR Induction Schedule",DocumentType,Inductionschedule."Department Code");
                    ApprovalEntries.RUN;
                    END ELSE BEGIN
                    ERROR('No Application Selected');
                    END;
                    */

                end;
            }
            action("HR Staff  Induction Report")
            {
                ApplicationArea = Basic;
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
    end;


    procedure FillVariables()
    begin
        //GET THE APPLICANT DETAILS

        Department.Reset;
        if Department.Get("Department Code") then
        begin
        "Department Name":=Department.Name;
        end;
    end;


    procedure UpdateControls()
    begin
    end;


    procedure GetTrainingTypes("Course Title": Text[50])
    begin
    end;
}

