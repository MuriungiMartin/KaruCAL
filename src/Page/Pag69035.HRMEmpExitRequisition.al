#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69035 "HRM-Emp. Exit Requisition"
{
    PageType = Document;
    PromotedActionCategories = 'New,Process,Reports,Exit Interview';
    SourceTable = UnknownTable61215;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Exit Clearance No";"Exit Clearance No")
                {
                    ApplicationArea = Basic;
                }
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Name";"Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field("Directorate Code";"Directorate Code")
                {
                    ApplicationArea = Basic;
                }
                field("Directorate Name";"Directorate Name")
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
                field("Station Code";"Station Code")
                {
                    ApplicationArea = Basic;
                }
                field("Station Name";"Station Name")
                {
                    ApplicationArea = Basic;
                }
                field("Re Employ In Future";"Re Employ In Future")
                {
                    ApplicationArea = Basic;
                }
                field("Nature Of Separation";"Nature Of Separation")
                {
                    ApplicationArea = Basic;
                }
                field("Reason For Leaving (Other)";"Reason For Leaving (Other)")
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Clearance";"Date Of Clearance")
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Leaving";"Date Of Leaving")
                {
                    ApplicationArea = Basic;
                }
                field("Form Submitted";"Form Submitted")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1102755008;Outlook)
            {
            }
            systempart(Control1102755010;Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Exit Interview")
            {
                Caption = '&Exit Interview';
            }
            action("&Approvals")
            {
                ApplicationArea = Basic;
                Caption = '&Approvals';
                Enabled = true;
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category4;
                Visible = true;

                trigger OnAction()
                begin
                    ApprovalEntries.Setfilters(Database::"Misc. Article Information",DocumentType,ExitCl."Exit Clearance No");
                    ApprovalEntries.Run;
                end;
            }
            action("&Send Approval Request")
            {
                ApplicationArea = Basic;
                Caption = '&Send Approval Request';
                Enabled = true;
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                Visible = true;

                trigger OnAction()
                begin

                    if Confirm('Send this Exit Request for Approval?',true)=false then exit;

                    //ApprovalMgt.SendExitApprovalReq(Rec);
                end;
            }
            action("&Cancel Approval Request")
            {
                ApplicationArea = Basic;
                Caption = '&Cancel Approval Request';
                Enabled = true;
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Category4;
                Visible = true;

                trigger OnAction()
                begin
                    // IF CONFIRM('Cancel this Exit request Approval',TRUE)=FALSE THEN EXIT;
                     //ApprovalMgt.CancelExitAppRequest(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

        if HREmp.Get("Employee No.") then begin
        JobTitle:=HREmp."Job Title";
        sUserID:=HREmp."User ID";
        end else begin
        JobTitle:='';
        sUserID:='';
        end;


        SetRange("Employee No.");
        DAge:='';
        DService:='';
        DPension:='';
        DMedical:='';

        RecalcDates;
    end;

    var
        JobTitle: Text[30];
        Supervisor: Text[60];
        HREmp: Record UnknownRecord61188;
        Dates: Codeunit "HR Dates";
        DAge: Text[100];
        DService: Text[100];
        DPension: Text[100];
        DMedical: Text[100];
        HREmpForm: Page "HRM-Employee (C)";
        sUserID: Code[30];
        DoclLink: Record UnknownRecord61224;
        InteractTemplLanguage: Record "Interaction Tmpl. Language";
        D: Date;
        ExitCl: Record UnknownRecord61215;
        Text19062217: label 'Misc Articles';
        DepartmentName: Text[40];
        sDate: Date;
        Number: Integer;
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Budget Transfer","Employee Requisition","Leave Application","Transport Requisition","Training Requisition","Job Approval","Induction Approval","Medical Claims";
        ApprovalEntries: Page "Approval Entries";
        ApprovalMgt: Codeunit "Export F/O Consolidation";
        Department: Record "Dimension Value";


    procedure RecalcDates()
    begin
        //Recalculate Important Dates
          if (HREmp."Date Of Leaving" = 0D) then begin
            if  (HREmp."Date Of Birth" <> 0D) then
            DAge:= Dates.DetermineAge(HREmp."Date Of Birth",Today);
            if  (HREmp."Date Of Join" <> 0D) then
            DService:= Dates.DetermineAge(HREmp."Date Of Join",Today);
           /* IF  (HREmp."Pension Scheme Join Date" <> 0D) THEN
            DPension:= Dates.DetermineAge(HREmp."Pension Scheme Join Date",TODAY);
            IF  (HREmp."Medical Scheme Join Date" <> 0D) THEN
            DMedical:= Dates.DetermineAge(HREmp."Medical Scheme Join Date",TODAY);  */
            //MODIFY;
          end else begin
            if  (HREmp."Date Of Birth" <> 0D) then
            DAge:= Dates.DetermineAge(HREmp."Date Of Birth",HREmp."Date Of Leaving");
            if  (HREmp."Date Of Join" <> 0D) then
            DService:= Dates.DetermineAge(HREmp."Date Of Join",HREmp."Date Of Leaving");
           /* IF  (HREmp."Pension Scheme Join Date" <> 0D) THEN
            DPension:= Dates.DetermineAge(HREmp."Pension Scheme Join Date",HREmp."Date Of Leaving");
            IF  (HREmp."Medical Scheme Join Date" <> 0D) THEN
            DMedical:= Dates.DetermineAge(HREmp."Medical Scheme Join Date",HREmp."Date Of Leaving");*/
            //MODIFY;
          end;

    end;

    local procedure EmployeeNoOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        FilterGroup := 2;
        ExitCl.SetRange(ExitCl."Employee No.","Employee No.");
        FilterGroup := 0;
        if ExitCl.Find('-') then;
        CurrPage.Update(false);
    end;
}

