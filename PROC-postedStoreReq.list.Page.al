#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68186 "PROC-posted Store Req. list"
{
    ApplicationArea = Basic;
    CardPageID = "PROC-Posted Store Reqs";
    PageType = List;
    SourceTable = UnknownTable61399;
    SourceTableView = where(Status=filter(=Posted));
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field("Request date";"Request date")
                {
                    ApplicationArea = Basic;
                }
                field("Required Date";"Required Date")
                {
                    ApplicationArea = Basic;
                }
                field("Requester ID";"Requester ID")
                {
                    ApplicationArea = Basic;
                }
                field("Request Description";"Request Description")
                {
                    ApplicationArea = Basic;
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field(Supplier;Supplier)
                {
                    ApplicationArea = Basic;
                }
                field("Action Type";"Action Type")
                {
                    ApplicationArea = Basic;
                }
                field(Justification;Justification)
                {
                    ApplicationArea = Basic;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Function Name";"Function Name")
                {
                    ApplicationArea = Basic;
                }
                field("Budget Center Name";"Budget Center Name")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 3 Code";"Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 4 Code";"Shortcut Dimension 4 Code")
                {
                    ApplicationArea = Basic;
                }
                field(Dim3;Dim3)
                {
                    ApplicationArea = Basic;
                }
                field(Dim4;Dim4)
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field(TotalAmount;TotalAmount)
                {
                    ApplicationArea = Basic;
                }
                field("Issuing Store";"Issuing Store")
                {
                    ApplicationArea = Basic;
                }
                field("Store Requisition Type";"Store Requisition Type")
                {
                    ApplicationArea = Basic;
                }
                field("Issue Date";"Issue Date")
                {
                    ApplicationArea = Basic;
                }
                field(Committed;Committed)
                {
                    ApplicationArea = Basic;
                }
                field("SRN.No";"SRN.No")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;

                    trigger OnAction()
                    begin
                        DocumentType:=Documenttype::Requisition;
                        ApprovalEntries.Setfilters(Database::"PROC-Store Requistion Header",DocumentType,"No.");
                        ApprovalEntries.Run;
                    end;
                }
                action("Print/Preview")
                {
                    ApplicationArea = Basic;
                    Caption = 'Print/Preview';

                    trigger OnAction()
                    begin
                        Reset;
                        SetFilter("No.","No.");
                        Report.Run(39005677,true,true,Rec);
                        Reset;
                    end;
                }
            }
        }
    }

    var
        UserMgt: Codeunit "HMS Patient Treatment Mgt";
        ApprovalMgt: Codeunit "Export F/O Consolidation";
        ReqLine: Record UnknownRecord61724;
        InventorySetup: Record "Inventory Setup";
        GenJnline: Record "Item Journal Line";
        LineNo: Integer;
        Post: Boolean;
        JournlPosted: Codeunit PostCaferiaBatches;
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition;
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        FixedAsset: Record "Fixed Asset";
        MinorAssetsIssue: Record UnknownRecord61725;
        Commitment: Codeunit "Procurement Controls Handler";
        BCSetup: Record UnknownRecord61721;
        DeleteCommitment: Record UnknownRecord61722;
        Loc: Record Location;
        ApprovalEntries: Page "Approval Entries";


    procedure LinesExists(): Boolean
    var
        PayLines: Record UnknownRecord61724;
    begin
         HasLines:=false;
         PayLines.Reset;
         PayLines.SetRange(PayLines."Requistion No","No.");
          if PayLines.Find('-') then begin
             HasLines:=true;
             exit(HasLines);
          end;
    end;


    procedure UpdateControls()
    begin
        
            /* IF Status<>Status::Released THEN BEGIN
             CurrForm."Issue Date".EDITABLE:=FALSE;
             CurrForm.UPDATECONTROLS();
                 END ELSE BEGIN
             CurrForm."Issue Date".EDITABLE:=TRUE;
             CurrForm.UPDATECONTROLS();
             END;
                IF Status=Status::Open THEN BEGIN
             CurrForm."Global Dimension 1 Code".EDITABLE:=TRUE;
             CurrForm."Request date" .EDITABLE:=TRUE;
             CurrForm."Responsibility Center" .EDITABLE:=TRUE;
             CurrForm."Issuing Store" .EDITABLE:=TRUE;
             CurrForm."Request Description".EDITABLE:=TRUE;
             CurrForm."Shortcut Dimension 2 Code".EDITABLE:=TRUE;
             CurrForm."Request Description".EDITABLE:=TRUE;
             CurrForm."Shortcut Dimension 3 Code".EDITABLE:=TRUE;
             CurrForm."Shortcut Dimension 4 Code".EDITABLE:=TRUE;
             CurrForm."Required Date".EDITABLE:=TRUE;
             CurrForm.UPDATECONTROLS();
             END ELSE BEGIN
             CurrForm."Responsibility Center".EDITABLE:=FALSE;
             CurrForm."Global Dimension 1 Code".EDITABLE:=FALSE;
             CurrForm."Request Description".EDITABLE:=FALSE;
             CurrForm."Shortcut Dimension 2 Code".EDITABLE:=FALSE;
             CurrForm."Required Date".EDITABLE:=FALSE;
             CurrForm."Shortcut Dimension 3 Code".EDITABLE:=FALSE;
             CurrForm."Shortcut Dimension 4 Code".EDITABLE:=FALSE;
             CurrForm."Required Date".EDITABLE:=FALSE;
              CurrForm."Request date".EDITABLE:=FALSE;
             CurrForm.UPDATECONTROLS();
             END
             */

    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        UpdateControls();
    end;
}

