#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1128 "Cost Acctg. Journal"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Cost Acctg. Journal.rdlc';
    Caption = 'Cost Acctg. Journal';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Cost Journal Line";"Cost Journal Line")
        {
            DataItemTableView = sorting("Journal Template Name","Journal Batch Name","Line No.");
            RequestFilterFields = "Journal Template Name","Journal Batch Name","Posting Date","Line No.","Cost Center Code","Cost Object Code";
            column(ReportForNavId_7341; 7341)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column("Filter";Text011 + GetFilters)
            {
            }
            column(CostTypeNo_CostJourLine;"Cost Type No.")
            {
            }
            column(PostingDate_CostJourLine;Format("Posting Date"))
            {
            }
            column(DocNo_CostJourLine;"Document No.")
            {
                IncludeCaption = true;
            }
            column(Text_CostJourLine;Description)
            {
                IncludeCaption = true;
            }
            column(BalCostTypeNo_CostJourLine;"Bal. Cost Type No.")
            {
            }
            column(Amount_CostJourLine;Amount)
            {
                IncludeCaption = true;
            }
            column(CostCentCode_CostJourLine;"Cost Center Code")
            {
            }
            column(CostObjCode_CostJourLine;"Cost Object Code")
            {
            }
            column(BlCostCntCode_CostJourLine;"Bal. Cost Center Code")
            {
                IncludeCaption = true;
            }
            column(BlCostObjCode_CostJourLine;"Bal. Cost Object Code")
            {
                IncludeCaption = true;
            }
            column(Balance_CostJourLine;Balance)
            {
            }
            column(JourBatchName_CostJourLine;"Journal Batch Name")
            {
            }
            column(LineNo_CostJourLine;"Line No.")
            {
            }
            column(CAJournalCaption;CAJournalCaptionLbl)
            {
            }
            column(BalCTCaption;BalCTCaptionLbl)
            {
            }
            column(COCaption;COCaptionLbl)
            {
            }
            column(CCCaption;CCCaptionLbl)
            {
            }
            column(CostTypeCaption;CostTypeCaptionLbl)
            {
            }
            column(PostingDateCaption;PostingDateCaptionLbl)
            {
            }
            column(BalanceCaption;BalanceCaptionLbl)
            {
            }
            column(TotalAmountCaption;TotalAmountCaptionLbl)
            {
            }
            dataitem("Integer";"Integer")
            {
                DataItemTableView = sorting(Number);
                column(ReportForNavId_5444; 5444)
                {
                }
                column(ErrorlineNumber;Errorline[Number])
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Errorline[Number] = '' then
                      CurrReport.Skip;
                end;

                trigger OnPreDataItem()
                begin
                    if not WithError then
                      CurrReport.Break;

                    SetRange(Number,1,20);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if WithError then begin
                  Lineno := 0;
                  Clear(Errorline);

                  if "Posting Date" = 0D then
                    WriteErrorLine(Text000);

                  if "Document No." = '' then
                    WriteErrorLine(Text001);

                  if ("Cost Type No." = '') and ("Bal. Cost Type No." = '') then
                    WriteErrorLine(Text002);

                  if "Cost Type No." <> '' then begin
                    CostType.Get("Cost Type No.");
                    if CostType.Blocked then
                      WriteErrorLine(Text003);

                    if CostType.Type <> CostType.Type::"Cost Type" then
                      WriteErrorLine(StrSubstNo(Text004,CostType.Type));

                    if ("Cost Center Code" = '') and ("Cost Object Code" = '') then
                      WriteErrorLine(Text005);

                    if ("Cost Center Code" <> '') and ("Cost Object Code" <> '') then
                      WriteErrorLine(Text006);
                  end;

                  if "Bal. Cost Type No." <> '' then begin
                    CostType.Get("Bal. Cost Type No.");
                    if CostType.Blocked then
                      WriteErrorLine(Text007);

                    if CostType.Type <> CostType.Type::"Cost Type" then
                      WriteErrorLine(StrSubstNo(Text008,CostType.Type));

                    if ("Bal. Cost Center Code" = '') and ("Bal. Cost Object Code" = '') then
                      WriteErrorLine(Text009);

                    if ("Bal. Cost Center Code" <> '') and ("Bal. Cost Object Code" <> '') then
                      WriteErrorLine(Text010);
                  end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(Amount,Balance);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(WithErrorMessages;WithError)
                    {
                        ApplicationArea = Basic;
                        Caption = 'With Error Messages';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Text000: label 'Posting date is not defined.';
        Text001: label 'Document no. is not defined.';
        Text002: label 'Define cost type or balance cost type.';
        Text003: label 'Cost type is blocked.';
        Text004: label 'Cost type must not be line type %1.';
        Text005: label 'Cost center or cost object must be defined.';
        Text006: label 'Cost center and cost object cannot be both defined concurrently.';
        Text007: label 'Balance cost type is blocked.';
        Text008: label 'Balance cost type must have line type %1.';
        Text009: label 'Balance cost center or cost object must be defined.';
        Text010: label 'Balance cost center and cost object cannot be both defined concurrently.';
        Text011: label 'Filter: ';
        CostType: Record "Cost Type";
        WithError: Boolean;
        Errorline: array [20] of Text[80];
        Lineno: Integer;
        CAJournalCaptionLbl: label 'Cost Accounting Journal';
        BalCTCaptionLbl: label 'Balance CT';
        COCaptionLbl: label 'CO';
        CCCaptionLbl: label 'CC';
        CostTypeCaptionLbl: label 'CostType';
        PostingDateCaptionLbl: label 'Posting Date';
        BalanceCaptionLbl: label 'Balance';
        TotalAmountCaptionLbl: label 'Total Amount';

    local procedure WriteErrorLine(ErrorTxt: Text[80])
    begin
        Lineno := Lineno + 1;
        Errorline[Lineno] := ErrorTxt;
    end;
}

