#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 77740 "Commitment Report2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Commitment Report2.rdlc';

    dataset
    {
        dataitem(UnknownTable61722;UnknownTable61722)
        {
            DataItemTableView = where(Amount=filter(>0));
            RequestFilterFields = "G/L Account No.","Posting Date","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code";
            column(ReportForNavId_1; 1)
            {
            }
            column(DocumentNo_Committment;"FIN-Committment"."Document No.")
            {
            }
            column(GLAccountNo_Committment;"FIN-Committment"."G/L Account No.")
            {
            }
            column(CompanyInfoName;CompanyInfo.Name)
            {
            }
            column(CommitmentDate_Committment;"FIN-Committment"."Committed Date")
            {
            }
            column(PostingDate_Committment;"FIN-Committment"."Posting Date")
            {
            }
            column(Amount;"FIN-Committment".Amount)
            {
            }
            column(CompanyInfoPicture;CompanyInfo.Picture)
            {
            }
            column(GLAccountName;GLAccountName)
            {
            }
            column(Description;Description)
            {
            }
            column(Depa;"FIN-Committment"."Shortcut Dimension 2 Code")
            {
            }
            column(DocNo;"FIN-Committment"."Document No.")
            {
            }
            column(Doctype;"FIN-Committment"."Document Type")
            {
            }

            trigger OnAfterGetRecord()
            var
                PurchaseLine: Record "Purchase Line";
                ImprestLines: Record UnknownRecord61714;
                ImprestSurrenderDetails: Record UnknownRecord61733;
                StaffAdvanceDetails: Record UnknownRecord61198;
                StaffAdvanceSurrenderDetails: Record UnknownRecord61203;
                PaymentLine: Record UnknownRecord61705;
                StaffClaimLines: Record UnknownRecord61603;
            begin
                GLAccountName:='';

                GLAccount.Reset;
                if GLAccount.Get("FIN-Committment"."G/L Account No.") then
                begin
                    GLAccountName:=GLAccount."Search Name";
                end;

                Description := '';
                //LPO,Requisition,Imprest,Payment Voucher,PettyCash,PurchInvoice,StaffClaim,StaffAdvance,StaffSurrender,Grant Surrender,Cash Purchase,ImpSurr
                if ("Document Type" = "document type"::LPO) or ("Document Type" = "document type"::Requisition)  or ("Document Type" = "document type"::PurchInvoice) then
                begin
                  PurchaseLine.Reset;
                  PurchaseLine.SetRange("Document No.","Document No.");
                  //PurchaseLine.SETRANGE("Line No.","Document Line No.");
                  if PurchaseLine.FindFirst then
                  Description := PurchaseLine.Description + PurchaseLine."Description 2";
                end
                else
                if "Document Type" = "document type"::Imprest then
                begin
                  ImprestLines.Reset;
                  ImprestLines.SetRange(No,"Document No.");
                  //ImprestLines.SETRANGE(l,"Document Line No.");
                  if ImprestLines.FindFirst then
                  Description := ImprestLines."Account Name";
                end
                else
                if ("Document Type" = "document type"::"Payment Voucher") or ("Document Type" = "document type"::PettyCash) then
                begin
                  PaymentLine.Reset;
                  PaymentLine.SetRange(No,"Document No.");
                  //PaymentLine.SETRANGE("Line No.","Document Line No.");
                  if PaymentLine.FindFirst then
                  Description := PaymentLine."Account Name";
                end
                else
                if "Document Type" = "document type"::StaffClaim then
                begin
                  StaffClaimLines.Reset;
                  StaffClaimLines.SetRange(No,"Document No.");
                  //StaffClaimLines.SETRANGE("Line No.","Document Line No.");
                  if StaffClaimLines.FindFirst then
                  Description := StaffClaimLines.Purpose;
                end
                else
                if "Document Type" = "document type"::StaffAdvance then
                begin
                  StaffAdvanceDetails.Reset;
                  StaffAdvanceDetails.SetRange(No,"Document No.");
                 // StaffAdvanceDetails.SETRANGE("Line No.","Document Line No.");
                  if StaffAdvanceDetails.FindFirst then
                  Description := StaffAdvanceDetails.Purpose;
                end
                else
                if "Document Type" = "document type"::StaffSurrender then
                begin
                  StaffAdvanceSurrenderDetails.Reset;
                  StaffAdvanceSurrenderDetails.SetRange("Surrender Doc No.","Document No.");
                  //StaffAdvanceSurrenderDetails.SETRANGE("Line No.","Document Line No.");
                  if StaffAdvanceSurrenderDetails.FindFirst then
                  Description := StaffAdvanceSurrenderDetails."Account Name";
                end
                else
                if "Document Type" = "document type"::StaffSurrender then
                begin
                  ImprestSurrenderDetails.Reset;
                  ImprestSurrenderDetails.SetRange("Surrender Doc No.","Document No.");
                  //ImprestSurrenderDetails.SETRANGE("Line No.","Document Line No.");
                  if ImprestSurrenderDetails.FindFirst then
                  Description := ImprestSurrenderDetails."Account Name";
                end
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
          CompanyInfo.Reset;
          CompanyInfo.Get;
          CompanyInfo.CalcFields(CompanyInfo.Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        GLAccount: Record "G/L Account";
        GLAccountName: Text;
        Description: Text;
}

