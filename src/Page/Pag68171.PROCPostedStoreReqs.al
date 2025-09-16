#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68171 "PROC-Posted Store Reqs"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61399;
    SourceTableView = where(Status=filter(Posted));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field("Requisition Type";"Requisition Type")
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
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Function Name";"Function Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Budget Center Name";"Budget Center Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Shortcut Dimension 3 Code";"Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Dim3;Dim3)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Shortcut Dimension 4 Code";"Shortcut Dimension 4 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Dim4;Dim4)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Request Description";"Request Description")
                {
                    ApplicationArea = Basic;
                }
                field("Issuing Store";"Issuing Store")
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
                field("Issue Date";"Issue Date")
                {
                    ApplicationArea = Basic;
                }
                field("SRN.No";"SRN.No")
                {
                    ApplicationArea = Basic;
                }
                field(Committed;Committed)
                {
                    ApplicationArea = Basic;
                    Editable = false;
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
                action(Details)
                {
                    ApplicationArea = Basic;
                    Caption = 'Details';
                    Image = List;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "PROC-Posted Store Req. Lines";
                    RunPageLink = "Requistion No"=field("No.");
                }
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

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //"Responsibility Center" := UserMgt.GetPurchasesFilter();
         //Add dimensions if set by default here
         "Global Dimension 1 Code":=UserMgt.GetSetDimensions(UserId,1);
         Validate("Global Dimension 1 Code");
         "Shortcut Dimension 2 Code":=UserMgt.GetSetDimensions(UserId,2);
         Validate("Shortcut Dimension 2 Code");
         "Shortcut Dimension 3 Code":=UserMgt.GetSetDimensions(UserId,3);
         Validate("Shortcut Dimension 3 Code");
         "Shortcut Dimension 4 Code":=UserMgt.GetSetDimensions(UserId,4);
         Validate("Shortcut Dimension 4 Code");
          "Responsibility Center":='MAIN';
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        if UserMgt.GetPurchasesFilter() <> '' then begin
          FilterGroup(2);
          SetRange("Responsibility Center" ,UserMgt.GetPurchasesFilter());
          FilterGroup(0);
        end;
        UpdateControls;
    end;

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

