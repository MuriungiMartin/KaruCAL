#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 658 "Approval Entries"
{
    ApplicationArea = Basic;
    Caption = 'Approval Entries';
    Editable = false;
    PageType = List;
    SourceTable = "Approval Entry";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("Sequence No.";"Sequence No.")
                {
                    ApplicationArea = Basic;
                }
                field("Approval Code";"Approval Code")
                {
                    ApplicationArea = Basic;
                }
                field("Sender ID";"Sender ID")
                {
                    ApplicationArea = Basic;
                }
                field("Salespers./Purch. Code";"Salespers./Purch. Code")
                {
                    ApplicationArea = Basic;
                }
                field("Approver ID";"Approver ID")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Date-Time Sent for Approval";"Date-Time Sent for Approval")
                {
                    ApplicationArea = Basic;
                }
                field("Last Date-Time Modified";"Last Date-Time Modified")
                {
                    ApplicationArea = Basic;
                }
                field("Last Modified By ID";"Last Modified By ID")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Amount (LCY)";"Amount (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field("Approval Type";"Approval Type")
                {
                    ApplicationArea = Basic;
                }
                field("Limit Type";"Limit Type")
                {
                    ApplicationArea = Basic;
                }
                field("Available Credit Limit (LCY)";"Available Credit Limit (LCY)")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = true;
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
                Image = View;
                action(Document)
                {
                    ApplicationArea = Basic;
                    Caption = 'Document';
                    Image = Document;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Rec.ShowDocument;
                    end;
                }
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Approval Comments";
                    RunPageLink = "Table ID"=field("Table ID"),
                                  "Document Type"=field("Document Type"),
                                  "Document No."=field("Document No.");
                    RunPageView = sorting("Table ID","Document Type","Document No.");
                }
                action("O&verdue Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'O&verdue Entries';
                    Image = OverdueEntries;

                    trigger OnAction()
                    begin
                        SetFilter(Status,'%1|%2',Status::Created,Status::Open);
                        SetFilter("Due Date",'<%1',Today);
                    end;
                }
                action("All Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'All Entries';
                    Image = Entries;

                    trigger OnAction()
                    begin
                        SetRange(Status);
                        SetRange("Due Date");
                    end;
                }
            }
        }
        area(processing)
        {
            action(Approve)
            {
                ApplicationArea = Basic;
                Caption = '&Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ApproveVisible;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                begin
                    CurrPage.SetSelectionFilter(ApprovalEntry);
                    if ApprovalEntry.Find('-') then
                      repeat
                        ApprovalMgt.ApproveApprovalRequest(ApprovalEntry);
                      until ApprovalEntry.Next = 0;
                end;
            }
            action(Reject)
            {
                ApplicationArea = Basic;
                Caption = '&Reject';
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = RejectVisible;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalSetup: Record UnknownRecord452;
                    ApprovalCommentLine: Record "Approval Comment Line";
                    ApprovalComment: Page "Approval Comments";
                begin
                    CurrPage.SetSelectionFilter(ApprovalEntry);
                    if ApprovalEntry.Find('-') then
                      repeat
                        if not ApprovalSetup.Get then
                          Error(Text004);
                        if ApprovalSetup."Request Rejection Comment" = true then begin
                          ApprovalCommentLine.SetRange("Table ID",ApprovalEntry."Table ID");
                          ApprovalCommentLine.SetRange("Document Type",ApprovalEntry."Document Type");
                          ApprovalCommentLine.SetRange("Document No.",ApprovalEntry."Document No.");
                          ApprovalComment.SetTableview(ApprovalCommentLine);
                          if ApprovalComment.RunModal = Action::OK then
                            ApprovalMgt.RejectApprovalRequest(ApprovalEntry);
                        end else
                          ApprovalMgt.RejectApprovalRequest(ApprovalEntry);

                      until ApprovalEntry.Next = 0;
                end;
            }
            action("&Delegate")
            {
                ApplicationArea = Basic;
                Caption = '&Delegate';
                Image = Delegate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    TempApprovalEntry: Record "Approval Entry";
                    ApprovalSetup: Record UnknownRecord452;
                begin
                    CurrPage.SetSelectionFilter(ApprovalEntry);

                    CurrPage.SetSelectionFilter(TempApprovalEntry);
                    if TempApprovalEntry.FindFirst then begin
                      TempApprovalEntry.SetFilter(Status,'<>%1',TempApprovalEntry.Status::Open);
                      if not TempApprovalEntry.IsEmpty then
                        Error(Text001);
                    end;

                    if ApprovalEntry.Find('-') then begin
                      if ApprovalSetup.Get then;
                      if Usersetup.Get(UserId) then;
                      if (ApprovalEntry."Sender ID" = Usersetup."User ID") or
                         (ApprovalSetup."Approval Administrator" = Usersetup."User ID") or
                         (ApprovalEntry."Approver ID" = Usersetup."User ID")
                      then
                        repeat
                          ApprovalMgt.DelegateApprovalRequest(ApprovalEntry);
                        until ApprovalEntry.Next = 0;
                    end;

                    Message(Text002);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Overdue := Overdue::" ";
        if FormatField(Rec) then
          Overdue := Overdue::Yes;
    end;

    trigger OnInit()
    begin
        RejectVisible := true;
        ApproveVisible := true;
    end;

    trigger OnOpenPage()
    var
        Filterstring: Text;
    begin
         if Usersetup.Get(UserId) then begin
          FilterGroup(2);
          Filterstring := GetFilters;
          FilterGroup(0);
          if StrLen(Filterstring) = 0 then begin
            FilterGroup(2);
            SetCurrentkey("Approver ID");
            if Overdue = Overdue::Yes then
              SetRange("Approver ID",Usersetup."User ID");
            SetRange(Status,Status::Open);
            FilterGroup(0);
          end else
            SetCurrentkey("Table ID","Document Type","Document No.");
         end;
    end;

    var
        Usersetup: Record "User Setup";
        ApprovalMgt: Codeunit "Export F/O Consolidation";
        Text001: label 'You can only delegate open approval entries.';
        Text002: label 'The selected approval(s) have been delegated. ';
        Overdue: Option Yes," ";
        Text004: label 'Approval Setup not found.';
        [InDataSet]
        ApproveVisible: Boolean;
        [InDataSet]
        RejectVisible: Boolean;


    procedure Setfilters(TableId: Integer;DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application";DocumentNo: Code[20])
    begin
        if TableId <> 0 then begin
          FilterGroup(2);
          SetCurrentkey("Table ID","Document Type","Document No.");
          SetRange("Table ID",TableId);
          SetRange("Document Type",DocumentType);
          if DocumentNo <> '' then
            SetRange("Document No.",DocumentNo);
          FilterGroup(0);
        end;

        ApproveVisible := false;
        RejectVisible := false;
    end;


    procedure FormatField(Rec: Record "Approval Entry") OK: Boolean
    begin
        if Status in [Status::Created,Status::Open] then begin
          if Rec."Due Date" < Today then
            exit(true)
            else
          exit(false);
        end;
    end;


    procedure CalledFrom()
    begin
        Overdue := Overdue::" ";
    end;
}

