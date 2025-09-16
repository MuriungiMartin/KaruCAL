#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 60140 "Online Internal Requisition"
{

    trigger OnRun()
    begin
    end;

    var
        InternalHeader: Record "Purchase Header";
        InternalLine: Record "Purchase Line";
        ApprovalEntry: Record "Approval Entry";
        PayLine: Record "Purchase Line";
        Commitments: Record UnknownRecord61071;
        appMngt: Codeunit "Export F/O Consolidation";
        docMngt: Codeunit "Item Transfer Management";
        CheckBudgetAvail: Codeunit "Procurement Controls Handler";
        I: Integer;


    procedure SendApproval(Doc_No: Code[20])
    begin
        InternalHeader.Reset;
        InternalHeader.SetRange(InternalHeader."No.",Doc_No);
        if(InternalHeader.Find('-'))then
        repeat
          appMngt.SendPurchaseApprovalRequest(InternalHeader);
        until InternalHeader.Next=0;
    end;


    procedure CancelApproval(Doc_No: Code[20])
    begin
        InternalHeader.Reset;
        InternalHeader.SetRange(InternalHeader."No.",Doc_No);
        if(InternalHeader.Find('-'))then
        repeat
          appMngt.CancelPurchaseApprovalRequest(InternalHeader,true,true);
        until InternalHeader.Next=0;
    end;


    procedure CheckBudgetAvailability("Internal No": Code[20])
    begin
        InternalHeader.Reset;
        InternalHeader.SetRange(InternalHeader."No.","Internal No");

        if(InternalHeader.Find('-'))then CheckBudgetAvail.CheckPurchase(InternalHeader);
    end;


    procedure CancelBudget("No.": Code[20])
    begin
          Commitments.Reset;
          Commitments.SetRange(Commitments."Document Type",Commitments."document type"::"Payment Voucher");
          Commitments.SetRange(Commitments."Document No.","No.");
          Commitments.DeleteAll;

          PayLine.Reset;
          PayLine.SetRange(PayLine."Document No.","No.");
          if PayLine.Find('-') then begin
            repeat
              PayLine.Committed:=false;
              PayLine.Modify;
            until PayLine.Next=0;
          end;
    end;


    procedure InternalHeaderMgmt(TransactionType: Option New,Modify,Delete;No: Code[20];Station: Code[20];Process: Code[20];RC: Code[20];Requestor: Code[20];"Posting Description": Text[250]) "Header No": Code[20]
    begin

        InternalHeader.Init;

        case TransactionType of
          Transactiontype::New: begin
              InternalHeader."Document Type":=InternalHeader."document type"::Quote;
              InternalHeader.DocApprovalType:=InternalHeader.Docapprovaltype::Requisition;
              InternalHeader."Assigned User ID":=Requestor;
              InternalHeader."Order Date":=Today;
              InternalHeader."Document Date":=Today;

              InternalHeader.Insert(true);
              InternalHeader."Posting Description":='Internal Requisition '+InternalHeader."No.";
              InternalHeader.Modify(true);

              "Header No":=InternalHeader."No.";
          end;

          Transactiontype::Modify: begin

              InternalHeader.Reset;
              InternalHeader.SetRange(InternalHeader."No.",No);
              InternalHeader.SetRange(InternalHeader."Document Type",InternalHeader."document type"::Quote);
              InternalHeader.SetRange(InternalHeader.DocApprovalType,InternalHeader.Docapprovaltype::Requisition);

              if InternalHeader.Find('-')then begin

                 InternalHeader."Shortcut Dimension 1 Code":=Station;
                 InternalHeader."Shortcut Dimension 2 Code":=Process;
                 InternalHeader."Responsibility Center":=RC;
                 InternalHeader."Posting Description":="Posting Description";

                 InternalHeader.Modify(true);
              end;
          end;

          Transactiontype::Delete: begin

              InternalHeader.Reset;
              InternalHeader.SetRange(InternalHeader."No.",No);
              InternalHeader.SetRange(InternalHeader."Document Type",InternalHeader."document type"::Quote);
              InternalHeader.SetRange(InternalHeader.DocApprovalType,InternalHeader.Docapprovaltype::Requisition);

              if InternalHeader.Find('-')then InternalHeader.Delete(true);
          end;


        end;
    end;


    procedure InternalLinesMgmt(TransactionType: Option New,Modify,Delete;"Header No": Code[20];Line: Integer;"Expense Code": Code[20];No: Code[20];Workplan: Code[20];Specifications: Text[250];Location: Code[20];Quantity: Integer;"Unit Cost": Decimal)
    begin
        InternalLine.Reset;
        InternalLine.SetRange(InternalLine."Line No.");
        if InternalLine.Find('+')then I:=InternalLine."Line No."+10000;

        InternalLine.Init;

        case TransactionType of
          Transactiontype::New: begin
              InternalLine.Reset;

               InternalLine."Line No.":=I;
              InternalLine."Document No.":="Header No";
              InternalLine."Document Type":=InternalLine."document type"::Quote;
              InternalLine."Posting Date":=Today;
              InternalLine.Type:=InternalLine.Type::"G/L Account";

              InternalLine."Expense Code":="Expense Code";
              InternalLine.Validate(InternalLine."Expense Code");

              InternalLine."No.":=No;
              InternalLine.Validate(InternalLine."No.");

              InternalLine."Location Code":=Location;
              InternalLine."Description 2":=Specifications;

              InternalLine.Quantity:=Quantity;
              InternalLine.Validate(InternalLine.Quantity);

              InternalLine."Direct Unit Cost":="Unit Cost";
              InternalLine.Validate(InternalLine."Direct Unit Cost");
              InternalLine."Currency Code":='KSH';
              InternalLine.Validate(InternalLine."Currency Code");

              InternalLine.Insert(true);

           end;

          Transactiontype::Modify: begin
              InternalLine.Reset;

              InternalLine.SetRange(InternalLine."Document No.","Header No");
              InternalLine.SetRange(InternalLine."Document Type",InternalLine."document type"::Quote);
              InternalLine.SetRange(InternalLine."Line No.",Line);

              if InternalLine.Find('-')then begin
                 InternalLine.Type:=InternalLine.Type::"G/L Account";

                 InternalLine."Expense Code":="Expense Code";
                 InternalLine.Validate(InternalLine."Expense Code");

                 InternalLine."No.":=No;
                 InternalLine.Validate(InternalLine."No.");

                 InternalLine."Location Code":=Location;
                 InternalLine."Description 2":=Specifications;

                 InternalLine.Quantity:=Quantity;
                 InternalLine.Validate(InternalLine.Quantity);

                 InternalLine."Direct Unit Cost":="Unit Cost";
                 InternalLine.Validate(InternalLine."Direct Unit Cost");

                 InternalLine.Modify(true);
              end;

          end;

          Transactiontype::Delete: begin
              InternalLine.Reset;

              InternalLine.SetRange(InternalLine."Document No.","Header No");
              InternalLine.SetRange(InternalLine."Document Type",InternalLine."document type"::Quote);
              InternalLine.SetRange(InternalLine."Line No.",Line);

              if InternalLine.Find('-')then InternalLine.Delete()
              else Error('No record found');

          end;

        end;
    end;
}

