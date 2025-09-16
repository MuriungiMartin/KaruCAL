#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 60152 "Online Stores Requisition"
{

    trigger OnRun()
    begin
    end;

    var
        SRHeader: Record UnknownRecord61399;
        SRLine: Record UnknownRecord61400;
        ApprovalEntry: Record "Approval Entry";
        ApprovalCommentLine: Record "Approval Comment Line";
        PayLine: Record UnknownRecord61400;
        Commitments: Record UnknownRecord61071;
        RecordLink: Record "Record Link";
        appMngt: Codeunit "Export F/O Consolidation";
        docMngt: Codeunit "Item Transfer Management";
        CheckBudgetAvail: Codeunit "Procurement Controls Handler";


    procedure SendApproval(Doc_No: Code[20])
    begin
        SRHeader.Reset;
        SRHeader.SetRange(SRHeader."No.",Doc_No);
        if(SRHeader.Find('-'))then
        repeat
          appMngt.SendSRequestApprovalRequest(SRHeader);
        until SRHeader.Next=0;
    end;


    procedure CancelApproval(Doc_No: Code[20])
    begin
        SRHeader.Reset;
        SRHeader.SetRange(SRHeader."No.",Doc_No);
        if(SRHeader.Find('-'))then
        repeat
          appMngt.CancelSRRequestApprovalRequest(SRHeader,true,true);
        until SRHeader.Next=0;
    end;


    procedure CheckBudgetAvailability("Internal No": Code[20])
    begin
        SRHeader.Reset;
        SRHeader.SetRange(SRHeader."No.","Internal No");

        //IF(SRHeader.FIND('-'))THEN CheckBudgetAvail.CheckPurchase(SRHeader);
    end;


    procedure CancelBudget("No.": Code[20])
    begin
          Commitments.Reset;
          Commitments.SetRange(Commitments."Document Type",Commitments."document type"::"Payment Voucher");
          Commitments.SetRange(Commitments."Document No.","No.");
          Commitments.DeleteAll;

          PayLine.Reset;
          PayLine.SetRange(PayLine."Requistion No","No.");
          if PayLine.Find('-') then begin
            repeat
              PayLine.Committed:=false;
              PayLine.Modify;
            until PayLine.Next=0;
          end;
    end;


    procedure StoreRequisitionHeaderMgmt(No_: Code[20];"Request Description": Text[100];"Responsibility Center": Code[20];"Global Dimension 1 Code": Code[20];"Shortcut Dimension 2 Code": Code[20];"Required Date": Date;"Online User": Code[20];TransactionType: Option New,Modify,Delete,Cancel,Approve;"Issuing Store": Code[20];"Shortcut Dimension 3 Code": Code[20];"Shortcut Dimension 4 Code": Code[20]) No: Code[20]
    begin
        SRHeader.Init;

        case TransactionType of
          Transactiontype::New: begin
              SRHeader."User ID":="Online User";
              SRHeader."Requester ID":="Online User";
              SRHeader."Request date":=Today;

              SRHeader.Insert(true);
              SRHeader."Request Description":='Store Requisition No '+SRHeader."No.";
              SRHeader.Modify(true);
              No:=SRHeader."No.";

          end;

          Transactiontype::Modify: begin

              SRHeader.Reset;
              SRHeader.SetRange(SRHeader."No.",No_);

              if SRHeader.Find('-')then begin
                 SRHeader."Required Date":="Required Date";
                 SRHeader."Request Description":=          "Request Description";
                 SRHeader."Issuing Store":="Issuing Store";
                 SRHeader."Responsibility Center":="Responsibility Center";
                 SRHeader.Validate(SRHeader."Responsibility Center");
                 SRHeader."Global Dimension 1 Code":="Global Dimension 1 Code";
                 SRHeader.Validate(SRHeader."Global Dimension 1 Code");
                 SRHeader."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
                 SRHeader.Validate(SRHeader."Shortcut Dimension 2 Code");
                 SRHeader."Shortcut Dimension 3 Code":="Shortcut Dimension 3 Code";
                 SRHeader.Validate(SRHeader."Shortcut Dimension 3 Code");
                 SRHeader."Shortcut Dimension 4 Code":="Shortcut Dimension 4 Code";
                 SRHeader.Validate(SRHeader."Shortcut Dimension 4 Code");

                 SRHeader.Modify(true);
              end;
          end;

          Transactiontype::Cancel: begin
              SRHeader.Reset;

              SRHeader.SetRange(SRHeader."No.",No_);

              if SRHeader.Find('-')then begin
                 appMngt.CancelSRRequestApprovalRequest(SRHeader,false,true);
              end;
          end;

          Transactiontype::Approve: begin
              SRHeader.Reset;

              SRHeader.SetRange(SRHeader."No.",No_);

              if SRHeader.Find('-')then begin
                 appMngt.SendSRequestApprovalRequest(SRHeader);
              end;
          end;

        end;
    end;


    procedure StoreRequisitionLinesMgmt("Document No": Code[20];"Line No": Integer;Type: Option Type;No: Code[20];"Additional Description": Text[250];Workplan: Code[20];Quantity: Decimal;"Unit Cost": Decimal;TransactionType: Option New,Modify,Delete)
    begin
        SRHeader.Init;

        SRHeader.SetRange(SRHeader."No.","Document No");
        if(SRHeader.Find('-'))then begin

            SRLine.Init;

            case TransactionType of
              Transactiontype::New: begin
                  SRLine.Reset;

                  SRLine."Requistion No":="Document No";
                  SRLine.Type:=Type;
                  SRLine."No.":=No;
                  SRLine.Validate(SRLine."No.");

                  SRLine."Line No.":="Line No";

                  SRLine."Quantity Requested":=Quantity;
                  SRLine.Validate(SRLine."Quantity Requested");

                  SRLine."Unit Cost":="Unit Cost";
                  SRLine.Validate(SRLine."Unit Cost");

                  SRLine."Issuing Store":=SRHeader."Issuing Store";
                  SRLine."Shortcut Dimension 1 Code":=SRHeader."Global Dimension 1 Code";
                  SRLine."Shortcut Dimension 2 Code":=SRHeader."Shortcut Dimension 2 Code";


                  SRLine.Insert(true);
               end;

              Transactiontype::Delete: begin
                  SRLine.Reset;

                  SRLine.SetRange(SRLine."Requistion No","Document No");
                  SRLine.SetRange(SRLine."Line No.","Line No");

                  if SRLine.Find('-')then SRLine.Delete(true)
                  else Error('No record found');
              end;

            end;
        end;
    end;
}

