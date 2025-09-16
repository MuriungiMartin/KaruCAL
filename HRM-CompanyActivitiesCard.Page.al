#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68720 "HRM-Company Activities Card"
{
    DeleteAllowed = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Functions';
    SaveValues = true;
    SourceTable = UnknownTable61637;

    layout
    {
        area(content)
        {
            group("Activity Details")
            {
                Caption = 'Activity Details';
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(Venue;Venue)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Employee Responsible";"Employee Responsible")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Employee Name";"Employee Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Name';
                    Editable = false;
                }
                field("Email Message";"Email Message")
                {
                    ApplicationArea = Basic;
                }
                field(Costs;Costs)
                {
                    ApplicationArea = Basic;
                }
                field("Contribution Amount (If Any)";"Contribution Amount (If Any)")
                {
                    ApplicationArea = Basic;
                }
                field(Directorate;Directorate)
                {
                    ApplicationArea = Basic;
                }
                field(Department;Department)
                {
                    ApplicationArea = Basic;
                }
                field(Station;Station)
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Center";"Responsibility Center")
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
                }
                field("Activity Status";"Activity Status")
                {
                    ApplicationArea = Basic;
                }
                field(Category;Category)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        HRMActivityParticipants.Reset;
                        HRMActivityParticipants.SetRange("Document No.",Code);
                        if HRMActivityParticipants.Find('-') then HRMActivityParticipants.DeleteAll;
                        if Category<>Category::ANY then begin
                          if Confirm('Auto-populate staff?',true)=false then exit;
                          HREmp.Reset;
                          HREmp.SetFilter(HREmp."Library Category",'%1',Category-1);
                          HREmp.SetFilter(HREmp.Status,'%1',HREmp.Status::Active);
                          if HREmp.Find('-') then begin
                            repeat
                                begin
                                  HRMActivityParticipants.Init;
                                  HRMActivityParticipants."Document No.":=Code;
                                  HRMActivityParticipants.Participant:=HREmp."No.";
                                  HRMActivityParticipants.Validate(Participant);
                                  HRMActivityParticipants.Insert;
                                end;
                              until HREmp.Next=0;
                            end;
                          end;

                        CurrPage.Update;
                    end;
                }
            }
            part(Control1102755011;"HRM-Activity Participants SF")
            {
                SubPageLink = "Document No."=field(Code);
            }
        }
        area(factboxes)
        {
            part(Control1102755024;"HRM-Company Activities Factbox")
            {
                SubPageLink = Code=field(Code);
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                action("Get Participants")
                {
                    ApplicationArea = Basic;
                    Image = SalesPurchaseTeam;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        TestField(Closed,false);
                        //TESTFIELD(Status,Status::New);

                        //DELETE ANY PREVIOS RECORDS RELATED TO THIS ACTIVITY
                        HRActivityApprovalEntry.SetRange(HRActivityApprovalEntry."Document No.",Code);
                        if HRActivityApprovalEntry.Find('-') then
                        HRActivityApprovalEntry.DeleteAll;

                        //GET ONLY ACTIVE EMPLOYEES
                        HREmp.Reset;
                        HREmp.SetRange(HREmp.Status,HREmp.Status::Active);
                        HREmp.SetFilter(HREmp."User ID",'<>%1','');
                        HREmp.FindFirst;
                        begin
                              HRActivityApprovalEntry.Reset;
                                  repeat
                                      HRActivityApprovalEntry.Init;
                                      HREmp.TestField(HREmp."User ID");
                                      HRActivityApprovalEntry.Participant:=HREmp."No.";
                                      HRActivityApprovalEntry."Partipant Name":=HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                                      HRActivityApprovalEntry."Document No.":=Code;
                                      HRActivityApprovalEntry.Validate(HRActivityApprovalEntry.Participant);
                                      HRActivityApprovalEntry.Insert();
                                  until HREmp.Next=0;
                        end;
                    end;
                }
                action("Notify Participants")
                {
                    ApplicationArea = Basic;
                    Image = SendMail;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin

                        TestField(Closed,false);

                        HRActivityApprovalEntry.Reset;
                        HRActivityApprovalEntry.SetRange(HRActivityApprovalEntry."Document No.",Code);

                        //IF NO PARTICIPANTS ARE IMPORTED
                        if HRActivityApprovalEntry.Count=0 then
                        Error('You must get participants to notify before using this function');

                        //ELSE
                        Get(Code);
                        HRActivityApprovalEntry.Reset;

                        with HRActivityApprovalEntry do begin


                        DocType:=Doctype::"Company Activity";


                        SetRange("Table ID",Database::"HRM-Activity Participants");
                        SetRange("Document Type",DocType);
                        SetRange("Document No.",Code);
                        SetRange("Activity Status","activity status"::Created);
                        if FindSet(true,false) then begin

                        repeat

                        //ApprovalsMgtNotification.SendActivityNotificationMail(Rec,HRActivityApprovalEntry);

                        HRActivityApprovalEntry.Notified:=true;
                        HRActivityApprovalEntry.Modify;

                        until HRActivityApprovalEntry.Next = 0;
                        Message('%1',Text001)
                        end
                        end
                    end;
                }
                action(Close)
                {
                    ApplicationArea = Basic;
                    Image = Close;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        Closed:=true;
                        Modify;
                        Message('Event :: %1 :: has been marked as Closed',Description);
                        CurrPage.Close;
                    end;
                }
                action("Re-Open")
                {
                    ApplicationArea = Basic;
                    Image = Open;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        Closed:=false;
                        Modify;
                        Message('Event :: %1 :: has been Re-Opened',Description);
                        CurrPage.Close;
                    end;
                }
                action(Print)
                {
                    ApplicationArea = Basic;
                    Image = PrintForm;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                         HRCompanyActivities.Reset;
                         HRCompanyActivities.SetRange(HRCompanyActivities.Code,Code);
                         if HRCompanyActivities.Find('-') then
                         Report.Run(39005492,true,true,HRCompanyActivities);
                    end;
                }
            }
            group(Approvals)
            {
                Caption = 'Approvals';
                action(Action1102755030)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Store Requisition","Employee Requisition","Leave Application","Transport Requisition","Training Requisition","Job Approval","Induction Approval","Activity Approval";
                        ApprovalEntries: Page "Approval Entries";
                    begin

                        DocumentType:=Documenttype::"Activity Approval";
                        ApprovalEntries.Setfilters(Database::"HRM-Company Activities",DocumentType,Code);
                        ApprovalEntries.Run;
                    end;
                }
                action("Send Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        if Confirm('Send this Company Activity for Approval?',true)=false then exit;
                        //AppMgmt.CancelJVApprovalRequest(Rec);
                    end;
                }
                action("Cancel Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Request';
                    Image = CancelAllLines;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        if Confirm('Cancel Approval Request for this Company Activity?',true)=false then exit;
                        //AppMgmt.FinishExitApprovalReq(Rec,TRUE,TRUE);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        // UpdateControls;
    end;

    trigger OnInit()
    begin
        //UpdateControls;
    end;

    trigger OnOpenPage()
    begin
        //UpdateControls;
    end;

    var
        D: Date;
        SMTP: Codeunit "SMTP Mail";
        CTEXTURL: Text[500];
        HREmp: Record UnknownRecord61188;
        ApprovalSetup: Record UnknownRecord452;
        ApprovalsMgtNotification: Codeunit "IC Setup Diagnostics";
        HRCompanyActivities: Record UnknownRecord61637;
        HRActivityApprovalEntry: Record UnknownRecord61644;
        DocType: Option "Company Activity";
        Text001: label 'All Participants have been notified via E-Mail';
        GenJournal: Record "Gen. Journal Line";
        LineNo: Integer;
        AppMgmt: Codeunit "Export F/O Consolidation";
        HRMActivityParticipants: Record UnknownRecord61644;


    procedure UpdateControls()
    begin
        if Closed then begin
        CurrPage.Editable:=false;
        end else begin
        CurrPage.Editable:=true;
        end;
    end;
}

