#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 127 "Finance Charge Memo Nos."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Finance Charge Memo Nos..rdlc';
    Caption = 'Finance Charge Memo Nos.';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Issued Fin. Charge Memo Header";"Issued Fin. Charge Memo Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Issued Finance Charge Memo';
            column(ReportForNavId_6218; 6218)
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
            column(STRSUBSTNO_Text004_FinChrgMemoHeaderFilter_;StrSubstNo(Text004,FinChrgMemoHeaderFilter))
            {
            }
            column(FinChrgMemoHeaderFilter;FinChrgMemoHeaderFilter)
            {
            }
            column(Finance_Charge_Memo_Nos_Caption;Finance_Charge_Memo_Nos_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(IssuedFinChrgMemoHeader__No__Caption;IssuedFinChrgMemoHeader.FieldCaption("No."))
            {
            }
            column(IssuedFinChrgMemoHeader__Source_Code_Caption;IssuedFinChrgMemoHeader.FieldCaption("Source Code"))
            {
            }
            column(IssuedFinChrgMemoHeader__User_ID_Caption;IssuedFinChrgMemoHeader.FieldCaption("User ID"))
            {
            }
            column(IssuedFinChrgMemoHeader_NameCaption;IssuedFinChrgMemoHeader.FieldCaption(Name))
            {
            }
            column(IssuedFinChrgMemoHeader__Customer_No__Caption;IssuedFinChrgMemoHeader.FieldCaption("Customer No."))
            {
            }
            column(SourceCode_DescriptionCaption;SourceCode_DescriptionCaptionLbl)
            {
            }
            column(IssuedFinChrgMemoHeader__Posting_Date_Caption;IssuedFinChrgMemoHeader__Posting_Date_CaptionLbl)
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
            dataitem(IssuedFinChrgMemoHeader;"Issued Fin. Charge Memo Header")
            {
                DataItemLink = "No."=field("No.");
                DataItemTableView = sorting("No.");
                column(ReportForNavId_5890; 5890)
                {
                }
                column(IssuedFinChrgMemoHeader__User_ID_;"User ID")
                {
                }
                column(SourceCode_Description;SourceCode.Description)
                {
                }
                column(IssuedFinChrgMemoHeader__Source_Code_;"Source Code")
                {
                }
                column(IssuedFinChrgMemoHeader_Name;Name)
                {
                }
                column(IssuedFinChrgMemoHeader__Customer_No__;"Customer No.")
                {
                }
                column(IssuedFinChrgMemoHeader__No__;"No.")
                {
                }
                column(IssuedFinChrgMemoHeader__Posting_Date_;Format("Posting Date"))
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                if "Source Code" <> SourceCode.Code then
                  if not SourceCode.Get("Source Code") then
                    SourceCode.Init;
                if "No. Series" <> NoSeries.Code then
                  if not NoSeries.Get("No. Series") then
                    NoSeries.Init;

                if ("No. Series" <> LastNoSeriesCode) or FirstRecord then begin
                  if "No. Series" = '' then
                    AddError(Text000)
                  else
                    AddError(
                      StrSubstNo(
                        Text001,
                        "No. Series",NoSeries.Description));
                  if not FirstRecord then
                    CurrReport.Newpage;
                  NewPage := true;
                end else begin
                  if LastNo <> '' then
                    if not ("No." in [LastNo,IncStr(LastNo)]) then
                      AddError(Text002)
                    else
                      if "Posting Date" < LastPostingDate then
                        AddError(Text003);
                  NewPage := false;
                end;

                LastNo := "No.";
                LastPostingDate := "Posting Date";
                LastNoSeriesCode := "No. Series";
                FirstRecord := false;
            end;

            trigger OnPreDataItem()
            begin
                FirstRecord := true;
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
        FinChrgMemoHeaderFilter := "Issued Fin. Charge Memo Header".GetFilters;
    end;

    var
        Text000: label 'No number series has been used for the following entries:';
        Text001: label 'The number series %1 %2 has been used for the following entries:';
        Text002: label 'There is a gap in the number series.';
        Text003: label 'The documents are not listed according to Posting Date because they were not entered in that order.';
        Text004: label 'Issued Finance Charge Memo: %1';
        NoSeries: Record "No. Series";
        SourceCode: Record "Source Code";
        FinChrgMemoHeaderFilter: Text;
        LastNo: Code[20];
        LastPostingDate: Date;
        LastNoSeriesCode: Code[10];
        FirstRecord: Boolean;
        NewPage: Boolean;
        ErrorText: array [10] of Text[250];
        ErrorCounter: Integer;
        Finance_Charge_Memo_Nos_CaptionLbl: label 'Finance Charge Memo Nos.';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        SourceCode_DescriptionCaptionLbl: label 'Description';
        IssuedFinChrgMemoHeader__Posting_Date_CaptionLbl: label 'Posting Date';
        ErrorText_Number__Control15CaptionLbl: label 'Warning!';

    local procedure AddError(Text: Text[250])
    begin
        ErrorCounter := ErrorCounter + 1;
        ErrorText[ErrorCounter] := Text;
    end;
}

