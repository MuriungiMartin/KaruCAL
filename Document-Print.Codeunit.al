#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 229 "Document-Print"
{

    trigger OnRun()
    begin
    end;

    var
        Text001: label '%1 is missing for %2 %3.';
        Text002: label '%1 for %2 is missing in %3.';
        SalesSetup: Record "Sales & Receivables Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        QuoteTxt: label 'Quote';
        OrderTxt: label 'Order';


    procedure EmailSalesHeader(SalesHeader: Record "Sales Header")
    begin
        DoPrintSalesHeader(SalesHeader,true);
    end;


    procedure PrintSalesHeader(SalesHeader: Record "Sales Header")
    begin
        DoPrintSalesHeader(SalesHeader,false);
    end;

    local procedure DoPrintSalesHeader(SalesHeader: Record "Sales Header";SendAsEmail: Boolean)
    var
        ReportSelections: Record "Report Selections";
        DocName: Text[10];
    begin
        SalesHeader.SetRange("No.",SalesHeader."No.");
        CalcSalesDisc(SalesHeader);
        if SendAsEmail then begin
          case SalesHeader."Document Type" of
            SalesHeader."document type"::Quote:
              DocName := QuoteTxt;
            SalesHeader."document type"::Order:
              DocName := OrderTxt;
          end;
          ReportSelections.SendEmailToCust(
            GetSalesDocTypeUsage(SalesHeader),SalesHeader,SalesHeader."No.",DocName,true,SalesHeader."Bill-to Customer No.")
        end else
          ReportSelections.Print(GetSalesDocTypeUsage(SalesHeader),SalesHeader,SalesHeader."Bill-to Customer No.");
    end;


    procedure PrintPurchHeader(PurchHeader: Record "Purchase Header")
    var
        ReportSelections: Record "Report Selections";
    begin
        PurchHeader.SetRange("No.",PurchHeader."No.");
        CalcPurchDisc(PurchHeader);

        ReportSelections.Print(GetPurchDocTypeUsage(PurchHeader),PurchHeader,'');
    end;


    procedure PrintBankAccStmt(BankAccStmt: Record "Bank Account Statement")
    var
        ReportSelections: Record "Report Selections";
    begin
        BankAccStmt.SetRecfilter;

        ReportSelections.Print(ReportSelections.Usage::"B.Stmt",BankAccStmt,'');
    end;


    procedure PrintBankRecStmt(PostedBankRecHdr: Record UnknownRecord10123)
    var
        ReportSelection: Record "Report Selections";
    begin
        PostedBankRecHdr.SetRecfilter;

        ReportSelection.Print(ReportSelection.Usage::"B.Stmt",PostedBankRecHdr,'');
    end;


    procedure PrintCheck(var NewGenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlLine: Record "Gen. Journal Line";
        ReportSelections: Record "Report Selections";
    begin
        GenJnlLine.Copy(NewGenJnlLine);
        GenJnlLine.OnCheckGenJournalLinePrintCheckRestrictions;

        ReportSelections.Print(ReportSelections.Usage::"B.Check",GenJnlLine,'');
    end;


    procedure PrintTransferHeader(TransHeader: Record "Transfer Header")
    var
        ReportSelections: Record "Report Selections";
    begin
        TransHeader.SetRange("No.",TransHeader."No.");

        ReportSelections.Print(ReportSelections.Usage::Inv1,TransHeader,'');
    end;


    procedure PrintServiceContract(ServiceContract: Record "Service Contract Header")
    var
        ReportSelection: Record "Report Selections";
    begin
        ServiceContract.SetRange("Contract No.",ServiceContract."Contract No.");

        ReportSelection.FilterPrintUsage(GetServContractTypeUsage(ServiceContract));
        if ReportSelection.IsEmpty then
          Error(Text001,ReportSelection.TableCaption,Format(ServiceContract."Contract Type"),ServiceContract."Contract No.");

        ReportSelection.Print(GetServContractTypeUsage(ServiceContract),ServiceContract,ServiceContract."Bill-to Customer No.");
    end;


    procedure PrintServiceHeader(ServiceHeader: Record "Service Header")
    var
        ReportSelection: Record "Report Selections";
    begin
        ServiceHeader.SetRange("No.",ServiceHeader."No.");
        CalcServDisc(ServiceHeader);

        ReportSelection.FilterPrintUsage(GetServHeaderDocTypeUsage(ServiceHeader));
        if ReportSelection.IsEmpty then
          Error(Text002,ReportSelection.FieldCaption("Report ID"),ServiceHeader.TableCaption,ReportSelection.TableCaption);

        ReportSelection.Print(GetServHeaderDocTypeUsage(ServiceHeader),ServiceHeader,ServiceHeader."Customer No.");
    end;


    procedure PrintAsmHeader(AsmHeader: Record "Assembly Header")
    var
        ReportSelections: Record "Report Selections";
    begin
        AsmHeader.SetRange("No.",AsmHeader."No.");

        ReportSelections.Print(GetAsmHeaderDocTypeUsage(AsmHeader),AsmHeader,'');
    end;


    procedure PrintSalesOrder(SalesHeader: Record "Sales Header";Usage: Option "Order Confirmation","Work Order","Pick Instruction")
    var
        ReportSelection: Record "Report Selections";
    begin
        if SalesHeader."Document Type" <> SalesHeader."document type"::Order then
          exit;

        SalesHeader.SetRange("No.",SalesHeader."No.");
        CalcSalesDisc(SalesHeader);

        ReportSelection.PrintWithGUIYesNo(GetSalesOrderUsage(Usage),SalesHeader,GuiAllowed,SalesHeader."Bill-to Customer No.");
    end;


    procedure PrintSalesHeaderArch(SalesHeaderArch: Record "Sales Header Archive")
    var
        ReportSelection: Record "Report Selections";
    begin
        SalesHeaderArch.SetRecfilter;

        ReportSelection.Print(GetSalesArchDocTypeUsage(SalesHeaderArch),SalesHeaderArch,SalesHeaderArch."Bill-to Customer No.");
    end;


    procedure PrintPurchHeaderArch(PurchHeaderArch: Record "Purchase Header Archive")
    var
        ReportSelection: Record "Report Selections";
    begin
        PurchHeaderArch.SetRecfilter;

        ReportSelection.Print(GetPurchArchDocTypeUsage(PurchHeaderArch),PurchHeaderArch,'');
    end;

    local procedure GetSalesDocTypeUsage(SalesHeader: Record "Sales Header"): Integer
    var
        ReportSelections: Record "Report Selections";
    begin
        case SalesHeader."Document Type" of
          SalesHeader."document type"::Quote:
            exit(ReportSelections.Usage::"S.Quote");
          SalesHeader."document type"::"Blanket Order":
            exit(ReportSelections.Usage::"S.Blanket");
          SalesHeader."document type"::Order:
            exit(ReportSelections.Usage::"S.Order");
          SalesHeader."document type"::"Return Order":
            exit(ReportSelections.Usage::"S.Return");
          SalesHeader."document type"::Invoice:
            exit(ReportSelections.Usage::"S.Invoice Draft");
          SalesHeader."document type"::"Credit Memo":
            exit(ReportSelections.Usage::"S.Cr.Memo");
          else
            Error('');
        end;
    end;

    local procedure GetPurchDocTypeUsage(PurchHeader: Record "Purchase Header"): Integer
    var
        ReportSelections: Record "Report Selections";
    begin
        case PurchHeader."Document Type" of
          PurchHeader."document type"::Quote:
            exit(ReportSelections.Usage::"P.Quote");
          PurchHeader."document type"::"Blanket Order":
            exit(ReportSelections.Usage::"P.Blanket");
          PurchHeader."document type"::Order:
            exit(ReportSelections.Usage::"P.Order");
          PurchHeader."document type"::"Return Order":
            exit(ReportSelections.Usage::"P.Return");
          else
            Error('');
        end;
    end;

    local procedure GetServContractTypeUsage(ServiceContractHeader: Record "Service Contract Header"): Integer
    var
        ReportSelections: Record "Report Selections";
    begin
        case ServiceContractHeader."Contract Type" of
          ServiceContractHeader."contract type"::Quote:
            exit(ReportSelections.Usage::"SM.Contract Quote");
          ServiceContractHeader."contract type"::Contract:
            exit(ReportSelections.Usage::"SM.Contract");
          else
            Error('');
        end;
    end;

    local procedure GetServHeaderDocTypeUsage(ServiceHeader: Record "Service Header"): Integer
    var
        ReportSelections: Record "Report Selections";
    begin
        case ServiceHeader."Document Type" of
          ServiceHeader."document type"::Quote:
            exit(ReportSelections.Usage::"SM.Quote");
          ServiceHeader."document type"::Order:
            exit(ReportSelections.Usage::"SM.Order");
          ServiceHeader."document type"::Invoice:
            exit(ReportSelections.Usage::"SM.Invoice");
          ServiceHeader."document type"::"Credit Memo":
            exit(ReportSelections.Usage::"SM.Credit Memo");
          else
            Error('');
        end;
    end;

    local procedure GetAsmHeaderDocTypeUsage(AsmHeader: Record "Assembly Header"): Integer
    var
        ReportSelections: Record "Report Selections";
    begin
        case AsmHeader."Document Type" of
          AsmHeader."document type"::Quote,
          AsmHeader."document type"::"Blanket Order",
          AsmHeader."document type"::Order:
            exit(ReportSelections.Usage::"Asm. Order");
          else
            Error('');
        end;
    end;

    local procedure GetSalesOrderUsage(Usage: Option "Order Confirmation","Work Order","Pick Instruction"): Integer
    var
        ReportSelections: Record "Report Selections";
    begin
        case Usage of
          Usage::"Order Confirmation":
            exit(ReportSelections.Usage::"S.Order");
          Usage::"Work Order":
            exit(ReportSelections.Usage::"S.Work Order");
          Usage::"Pick Instruction":
            exit(ReportSelections.Usage::"S.Order Pick Instruction");
          else
            Error('');
        end;
    end;

    local procedure GetSalesArchDocTypeUsage(SalesHeaderArchive: Record "Sales Header Archive"): Integer
    var
        ReportSelections: Record "Report Selections";
    begin
        case SalesHeaderArchive."Document Type" of
          SalesHeaderArchive."document type"::Quote:
            exit(ReportSelections.Usage::"S.Arch. Quote");
          SalesHeaderArchive."document type"::Order:
            exit(ReportSelections.Usage::"S.Arch. Order");
          SalesHeaderArchive."document type"::"Return Order":
            exit(ReportSelections.Usage::"S. Arch. Return Order");
          else
            Error('');
        end
    end;

    local procedure GetPurchArchDocTypeUsage(PurchHeaderArchive: Record "Purchase Header Archive"): Integer
    var
        ReportSelections: Record "Report Selections";
    begin
        case PurchHeaderArchive."Document Type" of
          PurchHeaderArchive."document type"::Quote:
            exit(ReportSelections.Usage::"P.Arch. Quote");
          PurchHeaderArchive."document type"::Order:
            exit(ReportSelections.Usage::"P.Arch. Order");
          PurchHeaderArchive."document type"::"Return Order":
            exit(ReportSelections.Usage::"P. Arch. Return Order");
          else
            Error('');
        end;
    end;

    local procedure CalcSalesDisc(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        SalesSetup.Get;
        if SalesSetup."Calc. Inv. Discount" then begin
          SalesLine.Reset;
          SalesLine.SetRange("Document Type",SalesHeader."Document Type");
          SalesLine.SetRange("Document No.",SalesHeader."No.");
          SalesLine.FindFirst;
          Codeunit.Run(Codeunit::"Sales-Calc. Discount",SalesLine);
          SalesHeader.Get(SalesHeader."Document Type",SalesHeader."No.");
          Commit;
        end;
    end;

    local procedure CalcPurchDisc(var PurchHeader: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
    begin
        PurchSetup.Get;
        if PurchSetup."Calc. Inv. Discount" then begin
          PurchLine.Reset;
          PurchLine.SetRange("Document Type",PurchHeader."Document Type");
          PurchLine.SetRange("Document No.",PurchHeader."No.");
          PurchLine.FindFirst;
          Codeunit.Run(Codeunit::"Purch.-Calc.Discount",PurchLine);
          PurchHeader.Get(PurchHeader."Document Type",PurchHeader."No.");
          Commit;
        end;
    end;

    local procedure CalcServDisc(var ServHeader: Record "Service Header")
    var
        ServLine: Record "Service Line";
    begin
        SalesSetup.Get;
        if SalesSetup."Calc. Inv. Discount" then begin
          ServLine.Reset;
          ServLine.SetRange("Document Type",ServHeader."Document Type");
          ServLine.SetRange("Document No.",ServHeader."No.");
          ServLine.FindFirst;
          Codeunit.Run(Codeunit::"Service-Calc. Discount",ServLine);
          ServHeader.Get(ServHeader."Document Type",ServHeader."No.");
          Commit;
        end;
    end;
}

