#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 662 "Approval Request Entries"
{
    ApplicationArea = Basic;
    Caption = 'Approval Request Entries';
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
                        ShowDocument;
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

    trigger OnOpenPage()
    begin
        if Usersetup.Get(UserId) then begin
          if ApprovalSetup.Get then begin
          if not (Usersetup."User ID" = ApprovalSetup."Approval Administrator") then //BEGIN
            FilterGroup(2);
            SetCurrentkey("Sender ID");
            SetFilter("Sender ID",'=%1',Usersetup."User ID");
            FilterGroup(0);
           // END;
          end;
        end;

        SetRange(Status);
        SetRange("Due Date");
    end;

    var
        Usersetup: Record "User Setup";
        ApprovalSetup: Record UnknownRecord452;
        ApprovalMgt: Codeunit "Export F/O Consolidation";
        Text001: label 'You can only delegate open approvals entries.';
        Text002: label 'The selected approvals have been delegated. ';
        Overdue: Option Yes," ";


    procedure FormatField(Rec: Record "Approval Entry"): Boolean
    begin
        if Status in [Status::Created,Status::Open] then begin
          if Rec."Due Date" < Today then
            exit(true);

          exit(false);
        end;
    end;
}

