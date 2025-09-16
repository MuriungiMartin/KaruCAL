#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 60138 "Online Imprest Requisition"
{

    trigger OnRun()
    begin
    end;

    var
        ImprestHeader: Record UnknownRecord61592;
        ImprestLine: Record UnknownRecord61593;
        ApprovalEntry: Record "Approval Entry";
        appMngt: Codeunit "Export F/O Consolidation";
        docMngt: Codeunit "Item Transfer Management";


    procedure SendApproval(Doc_No: Code[20])
    begin
        ImprestHeader.Reset;
        ImprestHeader.SetRange(ImprestHeader."No.",Doc_No);
        if(ImprestHeader.Find('-'))then
        repeat
          appMngt.SendImprestApprovalRequest(ImprestHeader);
        until ImprestHeader.Next=0;
    end;


    procedure CancelApproval(Doc_No: Code[20])
    begin
        ImprestHeader.Reset;
        ImprestHeader.SetRange(ImprestHeader."No.",Doc_No);
        if(ImprestHeader.Find('-'))then
        repeat
          appMngt.CancelImprestApprovalRequest(ImprestHeader,true,true);
        until ImprestHeader.Next=0;
    end;


    procedure ImprestHeaderMgmt(TransactionType: Option New,Modify,Delete;No: Code[20];Station: Code[20];Process: Code[20];RC: Code[20];Account: Code[20];Purpose: Text[250];User: Code[20]) "Header No": Code[20]
    begin

        ImprestHeader.Init;

        case TransactionType of
          Transactiontype::New: begin
              ImprestHeader.Cashier:=User;
              ImprestHeader.Insert(true);

              ImprestHeader.Cashier:=User;
              ImprestHeader.Modify();
              "Header No":=ImprestHeader."No.";

          end;

          Transactiontype::Modify: begin

              ImprestHeader.Reset;
              ImprestHeader.SetRange(ImprestHeader."No.",No);

              if ImprestHeader.Find('-')then begin

                 ImprestHeader."Global Dimension 1 Code":=Station;
                 ImprestHeader."Shortcut Dimension 2 Code":=Process;
                 ImprestHeader."Responsibility Center":=RC;
                 ImprestHeader."Account No.":=Account;
                 ImprestHeader.Purpose:=Purpose;
                 //ImprestHeader."Currency Code":='KSH';
                 //ImprestHeader.VALIDATE(ImprestHeader."Currency Code");

                 ImprestHeader.Modify(true);
              end;
          end;

          Transactiontype::Delete: begin

              ImprestHeader.Reset;
              ImprestHeader.SetRange(ImprestHeader."No.",No);

              if ImprestHeader.Find('-')then ImprestHeader.Delete(true)
              else Error('No record found');

          end;


        end;
    end;


    procedure ImprestLinesMgmt(TransactionType: Option New,Modify,Delete;"Header No": Code[20];"Imprest Type": Code[20];Workplan: Code[20];Amount: Decimal;Purpose: Text[250];"Account No": Code[20]) Line: Integer
    begin
        ImprestLine.Init;

        case TransactionType of
          Transactiontype::New: begin
              ImprestLine.Reset;

              ImprestLine.No:="Header No";
              ImprestLine."Advance Type":="Imprest Type";
              ImprestLine.Validate(ImprestLine."Advance Type");

              ImprestLine."EFT Bank Account No":=Workplan;
              ImprestLine.Amount:=Amount;
              ImprestLine.Purpose:=Purpose;
              ImprestLine.Insert(true);

           end;

          Transactiontype::Modify: begin
              ImprestLine.Reset;

              ImprestLine.SetRange(ImprestLine."EFT Account Name","Header No");
              ImprestLine.SetRange(ImprestLine."Account No:","Account No");

              if ImprestLine.Find('-')then begin
                 ImprestLine."EFT Bank Account No":=Workplan;
                 ImprestLine.Amount:=Amount;
                 ImprestLine.Purpose:=Purpose;

                 ImprestLine.Modify(true);
              end;

          end;

          Transactiontype::Delete: begin
              ImprestLine.Reset;
              ImprestLine.SetRange(ImprestLine."EFT Account Name","Header No");
              ImprestLine.SetRange(ImprestLine."Account No:","Account No");

              if ImprestLine.Find('-')then ImprestLine.Delete(true)
              else Error('No record found');

          end;

        end;
    end;
}

