#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 128 "Customer Document Nos."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Customer Document Nos..rdlc';
    Caption = 'Customer Document Nos.';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Cust. Ledger Entry";"Cust. Ledger Entry")
        {
            DataItemTableView = sorting("Document No.");
            RequestFilterFields = "Document Type","Document No.";
            column(ReportForNavId_8503; 8503)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(STRSUBSTNO_Text004_CustLedgerEntryFilter_;StrSubstNo(Text004,CustLedgerEntryFilter))
            {
            }
            column(ShowFilter;CustLedgerEntryFilter)
            {
            }
            column(RecGroups;PageGroupNo)
            {
            }
            column(Customer_Document_Nos_Caption;Customer_Document_Nos_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(CustLedgerEntry__Document_No__Caption;CustLedgerEntry.FieldCaption("Document No."))
            {
            }
            column(CustLedgerEntry__Source_Code_Caption;CustLedgerEntry.FieldCaption("Source Code"))
            {
            }
            column(CustLedgerEntry__User_ID_Caption;CustLedgerEntry.FieldCaption("User ID"))
            {
            }
            column(Cust_NameCaption;Cust_NameCaptionLbl)
            {
            }
            column(CustLedgerEntry__Customer_No__Caption;CustLedgerEntry.FieldCaption("Customer No."))
            {
            }
            column(SourceCode_DescriptionCaption;SourceCode_DescriptionCaptionLbl)
            {
            }
            column(CustLedgerEntry__Posting_Date_Caption;CustLedgerEntry__Posting_Date_CaptionLbl)
            {
            }
            column(CustLedgerEntry__Document_Type_Caption;CustLedgerEntry.FieldCaption("Document Type"))
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
                column(ShowErrors;NewPage)
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
            dataitem(CustLedgerEntry;"Cust. Ledger Entry")
            {
                DataItemLink = "Entry No."=field("Entry No.");
                DataItemTableView = sorting("Entry No.");
                column(ReportForNavId_8586; 8586)
                {
                }
                column(CustLedgerEntry__User_ID_;"User ID")
                {
                }
                column(SourceCode_Description;SourceCode.Description)
                {
                }
                column(CustLedgerEntry__Source_Code_;"Source Code")
                {
                }
                column(Cust_Name;Cust.Name)
                {
                }
                column(CustLedgerEntry__Customer_No__;"Customer No.")
                {
                }
                column(CustLedgerEntry__Document_No__;"Document No.")
                {
                }
                column(CustLedgerEntry__Posting_Date_;Format("Posting Date"))
                {
                }
                column(CustLedgerEntry__Document_Type_;"Document Type")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                if "Customer No." <> Cust."No." then
                  if not Cust.Get("Customer No.") then
                    Cust.Init;
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
        CustLedgerEntryFilter := "Cust. Ledger Entry".GetFilters;
    end;

    var
        Text000: label 'No number series has been used for the following entries:';
        Text001: label 'The number series %1 %2 has been used for the following entries:';
        Text002: label 'There is a gap in the number series.';
        Text003: label 'The documents are not listed according to Posting Date because they were not entered in that order.';
        Text004: label 'Customer Entry: %1';
        Cust: Record Customer;
        NoSeries: Record "No. Series";
        SourceCode: Record "Source Code";
        CustLedgerEntryFilter: Text;
        LastDocNo: Code[20];
        LastDocType: Integer;
        LastPostingDate: Date;
        LastNoSeriesCode: Code[10];
        FirstRecord: Boolean;
        NewPage: Boolean;
        ErrorText: array [10] of Text[250];
        ErrorCounter: Integer;
        PageGroupNo: Integer;
        Customer_Document_Nos_CaptionLbl: label 'Customer Document Nos.';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Cust_NameCaptionLbl: label 'Customer Name';
        SourceCode_DescriptionCaptionLbl: label 'Source Description';
        CustLedgerEntry__Posting_Date_CaptionLbl: label 'Posting Date';
        ErrorText_Number__Control15CaptionLbl: label 'Warning!';

    local procedure AddError(Text: Text[250])
    begin
        ErrorCounter := ErrorCounter + 1;
        ErrorText[ErrorCounter] := Text;
    end;
}

