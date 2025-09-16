#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 328 "Vendor Document Nos."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Vendor Document Nos..rdlc';
    Caption = 'Vendor Document Nos.';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Vendor Ledger Entry";"Vendor Ledger Entry")
        {
            DataItemTableView = sorting("Document No.");
            RequestFilterFields = "Document Type","Document No.";
            column(ReportForNavId_4114; 4114)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(STRSUBSTNO_Text004_VendLedgerEntryFilter_;StrSubstNo(Text004,VendLedgerEntryFilter))
            {
            }
            column(VendLedgerEntryFilter;VendLedgerEntryFilter)
            {
            }
            column(PageGroupNo;PageGroupNo)
            {
            }
            column(Vendor_Ledger_Entry_Entry_No_;"Entry No.")
            {
            }
            column(Vendor_Document_Nos_Caption;Vendor_Document_Nos_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(VendLedgerEntry__Document_No__Caption;VendLedgerEntry.FieldCaption("Document No."))
            {
            }
            column(VendLedgerEntry__Source_Code_Caption;VendLedgerEntry.FieldCaption("Source Code"))
            {
            }
            column(VendLedgerEntry__User_ID_Caption;VendLedgerEntry.FieldCaption("User ID"))
            {
            }
            column(Vend_NameCaption;Vend_NameCaptionLbl)
            {
            }
            column(VendLedgerEntry__Vendor_No__Caption;VendLedgerEntry.FieldCaption("Vendor No."))
            {
            }
            column(SourceCode_DescriptionCaption;SourceCode_DescriptionCaptionLbl)
            {
            }
            column(VendLedgerEntry__Posting_Date_Caption;VendLedgerEntry__Posting_Date_CaptionLbl)
            {
            }
            column(VendLedgerEntry__Document_Type_Caption;VendLedgerEntry.FieldCaption("Document Type"))
            {
            }
            dataitem(ErrorLoop;"Integer")
            {
                DataItemTableView = sorting(Number);
                column(ReportForNavId_1162; 1162)
                {
                }
                column(ErrorText_Number_;ErrorText[Number])
                {
                }
                column(NewPage;NewPage)
                {
                }
                column(ErrorText_Number__Control15;ErrorText[Number])
                {
                }
                column(ErrorText_Number__Control15Caption;ErrorText_Number__Control15CaptionLbl)
                {
                }

                trigger OnPostDataItem()
                begin
                    ErrorCounter := 0;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Number,1,ErrorCounter);
                end;
            }
            dataitem(VendLedgerEntry;"Vendor Ledger Entry")
            {
                DataItemLink = "Entry No."=field("Entry No.");
                DataItemTableView = sorting("Entry No.");
                column(ReportForNavId_7908; 7908)
                {
                }
                column(VendLedgerEntry__User_ID_;"User ID")
                {
                }
                column(SourceCode_Description;SourceCode.Description)
                {
                }
                column(VendLedgerEntry__Source_Code_;"Source Code")
                {
                }
                column(Vend_Name;Vend.Name)
                {
                }
                column(VendLedgerEntry__Vendor_No__;"Vendor No.")
                {
                }
                column(VendLedgerEntry__Document_No__;"Document No.")
                {
                }
                column(VendLedgerEntry__Posting_Date_;Format("Posting Date"))
                {
                }
                column(VendLedgerEntry__Document_Type_;"Document Type")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                if "Vendor No." <> Vend."No." then
                  if not Vend.Get("Vendor No.") then
                    Vend.Init;
                if "Source Code" <> SourceCode.Code then
                  if not SourceCode.Get("Source Code") then
                    SourceCode.Init;
                if "No. Series" <> NoSeries.Code then
                  if not NoSeries.Get("No. Series") then
                    NoSeries.Init;

                if ("No. Series" <> LastNoSeriesCode) or ("Document Type" <> LastDocType) or FirstRecord then begin
                  if "No. Series" = '' then
                    AddError(Text000)
                  else
                    AddError(
                      StrSubstNo(
                        Text001,
                        "No. Series",NoSeries.Description));
                  if not FirstRecord then
                    PageGroupNo := PageGroupNo + 1;
                  NewPage := true;
                end else begin
                  if LastDocNo <> '' then
                    if not ("Document No." in [LastDocNo,IncStr(LastDocNo)]) then
                      AddError(Text002)
                    else
                      if "Posting Date" < LastPostingDate then
                        AddError(Text003);
                  NewPage := false;
                end;

                LastDocType := "Document Type";
                LastDocNo := "Document No.";
                LastPostingDate := "Posting Date";
                LastNoSeriesCode := "No. Series";
                FirstRecord := false;
            end;

            trigger OnPreDataItem()
            begin
                FirstRecord := true;
                PageGroupNo := 1;
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
        VendLedgerEntryFilter := "Vendor Ledger Entry".GetFilters;
    end;

    var
        Text000: label 'No number series has been used for the following entries:';
        Text001: label 'The number series %1 %2 has been used for the following entries:';
        Text002: label 'There is a gap in the number series.';
        Text003: label 'The documents are not listed according to Posting Date because they were not entered in that order.';
        Text004: label 'Vendor Entry: %1';
        Vend: Record Vendor;
        NoSeries: Record "No. Series";
        SourceCode: Record "Source Code";
        VendLedgerEntryFilter: Text;
        LastDocNo: Code[20];
        LastDocType: Integer;
        LastPostingDate: Date;
        LastNoSeriesCode: Code[10];
        FirstRecord: Boolean;
        NewPage: Boolean;
        ErrorText: array [10] of Text[250];
        ErrorCounter: Integer;
        PageGroupNo: Integer;
        Vendor_Document_Nos_CaptionLbl: label 'Vendor Document Nos.';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Vend_NameCaptionLbl: label 'Vendor Name';
        SourceCode_DescriptionCaptionLbl: label 'Source Description';
        VendLedgerEntry__Posting_Date_CaptionLbl: label 'Posting Date';
        ErrorText_Number__Control15CaptionLbl: label 'Warning!';

    local procedure AddError(Text: Text[250])
    begin
        ErrorCounter := ErrorCounter + 1;
        ErrorText[ErrorCounter] := Text;
    end;
}

