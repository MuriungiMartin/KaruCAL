#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68328 "FIN-Posted staff Advance Surr."
{
    ApplicationArea = Basic;
    CardPageID = "FIN-PostedStaff Advance Acc.";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = true;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = UnknownTable61199;
    SourceTableView = where(Posted=const(Yes),
                            Status=const(Posted));
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field(No;No)
                {
                    ApplicationArea = Basic;
                }
                field("Imprest Issue Doc. No";"Imprest Issue Doc. No")
                {
                    ApplicationArea = Basic;
                }
                field("Surrender Date";"Surrender Date")
                {
                    ApplicationArea = Basic;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                }
                field("Account No.";"Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(Payee;Payee)
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field(Surrendered;Surrendered)
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
            group(Functions)
            {
                Caption = 'Functions';
            }
            action(Print)
            {
                ApplicationArea = Basic;
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Reset;
                    SetFilter(No,No);
                    Report.Run(39005757,true,true,Rec);
                    Reset;
                end;
            }
        }
    }

    var
        RecPayTypes: Record UnknownRecord61129;
        TarriffCodes: Record UnknownRecord61716;
        GenJnlLine: Record "Gen. Journal Line";
        DefaultBatch: Record "Gen. Journal Batch";
        CashierLinks: Record UnknownRecord61712;
        LineNo: Integer;
        NextEntryNo: Integer;
        CommitNo: Integer;
        ImprestDetails: Record UnknownRecord61203;
        EntryNo: Integer;
        GLAccount: Record "G/L Account";
        IsImprest: Boolean;
        ImprestRequestDet: Record UnknownRecord61503;
        GenledSetup: Record UnknownRecord61713;
        ImprestAmt: Decimal;
        DimName1: Text[60];
        DimName2: Text[60];
        CashPaymentLine: Record UnknownRecord61718;
        PaymentLine: Record UnknownRecord61198;
        CurrSurrDocNo: Code[20];
        JournalPostSuccessful: Codeunit PostCaferiaBatches;
        Commitments: Record UnknownRecord61722;
        BCSetup: Record UnknownRecord61721;
        BudgetControl: Codeunit "Procurement Controls Handler";
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash,PurchInvoice,StaffClaim,StaffAdvance,StaffSurrender;
        ImprestReq: Record UnknownRecord61197;
        UserMgt: Codeunit "HMS Patient Treatment Mgt";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender;
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        AccountName: Text[100];
        AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";
        TravAccHeader: Record UnknownRecord61199;
        CheckBudgetAvail: Codeunit "Procurement Controls Handler";
        Payline: Record UnknownRecord61203;
        Temp: Record UnknownRecord61712;
        SurrBatch: Code[10];
        SurrTemplate: Code[10];
        Text000: label 'You have not specified the Actual Amount Spent. This document will only reverse the committment and you will have to receipt the total amount returned.';
        Text001: label 'Document Not Posted';
        Text002: label 'Are you sure you want to Cancel this Document?';
        Text19053222: label 'Enter Advance Accounting Details below';


    procedure GetDimensionName(var "Code": Code[20];DimNo: Integer) Name: Text[60]
    var
        GLSetup: Record "General Ledger Setup";
        DimVal: Record "Dimension Value";
    begin
        /*Get the global dimension 1 and 2 from the database*/
        Name:='';
        
        GLSetup.Reset;
        GLSetup.Get();
        
        DimVal.Reset;
        DimVal.SetRange(DimVal.Code,Code);
        
        if DimNo=1 then
          begin
            DimVal.SetRange(DimVal."Dimension Code",GLSetup."Global Dimension 1 Code"  );
          end
        else if DimNo=2 then
          begin
            DimVal.SetRange(DimVal."Dimension Code",GLSetup."Global Dimension 2 Code");
          end;
        if DimVal.Find('-') then
          begin
            Name:=DimVal.Name;
          end;

    end;


    procedure GetCustName(No: Code[20]) Name: Text[100]
    var
        Cust: Record Customer;
    begin
        Name:='';
        if Cust.Get(No) then
           Name:=Cust.Name;
           exit(Name);
    end;


    procedure UpdateforNoActualSpent()
    begin
          Posted:=true;
          Status:=Status::Posted;
          "Date Posted":=Today;
          "Time Posted":=Time;
          "Posted By":=UserId;
          Modify;
        //Tag the Source Imprest Requisition as Surrendered
           ImprestReq.Reset;
           ImprestReq.SetRange(ImprestReq."No.","Imprest Issue Doc. No");
           if ImprestReq.Find('-') then begin
             ImprestReq."Surrender Status":=ImprestReq."surrender status"::Full;
             ImprestReq.Modify;
           end;
        //End Tag
        //Post Committment Reversals
        Doc_Type:=Doc_type::StaffSurrender;
        BudgetControl.ReverseEntries(Doc_Type,"Imprest Issue Doc. No");
    end;


    procedure CompareAllAmounts()
    begin
    end;


    procedure LinesCommitmentStatus() Exists: Boolean
    var
        BCsetup: Record UnknownRecord61721;
    begin
         if BCsetup.Get() then  begin
            if not BCsetup.Mandatory then begin
               Exists:=false;
               exit;
            end;
         end else begin
               Exists:=false;
               exit;
         end;
           Exists:=false;
          Payline.Reset;
          Payline.SetRange(Payline."Surrender Doc No.",No);
          Payline.SetRange(Payline.Committed,false);
          Payline.SetRange(Payline."Budgetary Control A/C",true);
           if Payline.Find('-') then
              Exists:=true;
    end;
}

