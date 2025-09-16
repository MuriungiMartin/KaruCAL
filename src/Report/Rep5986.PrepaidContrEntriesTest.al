#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5986 "Prepaid Contr. Entries - Test"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Prepaid Contr. Entries - Test.rdlc';
    Caption = 'Prepaid Contr. Entries - Test';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Service Ledger Entry";"Service Ledger Entry")
        {
            DataItemTableView = sorting("Service Contract No.","Entry No.","Entry Type",Type,"Moved from Prepaid Acc.","Posting Date",Open,Prepaid) where(Type=const("Service Contract"),"Moved from Prepaid Acc."=const(false),Open=const(false));
            RequestFilterFields = "Service Contract No.";
            column(ReportForNavId_1141; 1141)
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
            column(Service_Ledger_Entry__User_ID_;"User ID")
            {
            }
            column(PostingDate;Format(PostingDate))
            {
            }
            column(UntilDate;Format(UntilDate))
            {
            }
            column(Service_Ledger_Entry__TABLECAPTION__________ServLedgerFilters;TableCaption + ': ' + ServLedgerFilters)
            {
            }
            column(ServLedgerFilters;ServLedgerFilters)
            {
            }
            column(Service_Ledger_Entry__Service_Contract_No__;"Service Contract No.")
            {
            }
            column(Service_Ledger_Entry__Serial_No___Serviced__;"Serial No. (Serviced)")
            {
            }
            column(Service_Ledger_Entry__Posting_Date_;Format("Posting Date"))
            {
            }
            column(Service_Ledger_Entry__Serv__Contract_Acc__Gr__Code_;"Serv. Contract Acc. Gr. Code")
            {
            }
            column(Service_Ledger_Entry__Amount__LCY__;"Amount (LCY)")
            {
            }
            column(Service_Ledger_Entry__Amount__LCY___Control7;"Amount (LCY)")
            {
            }
            column(Service_Ledger_Entry_Entry_No_;"Entry No.")
            {
            }
            column(Prepaid_Contract_Entries___TestCaption;Prepaid_Contract_Entries___TestCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(PostingDateCaption;PostingDateCaptionLbl)
            {
            }
            column(UntilDateCaption;UntilDateCaptionLbl)
            {
            }
            column(Service_Ledger_Entry__Service_Contract_No__Caption;FieldCaption("Service Contract No."))
            {
            }
            column(Service_Ledger_Entry__Serial_No___Serviced__Caption;FieldCaption("Serial No. (Serviced)"))
            {
            }
            column(Service_Ledger_Entry__Posting_Date_Caption;Service_Ledger_Entry__Posting_Date_CaptionLbl)
            {
            }
            column(Service_Ledger_Entry__Serv__Contract_Acc__Gr__Code_Caption;FieldCaption("Serv. Contract Acc. Gr. Code"))
            {
            }
            column(Service_Ledger_Entry__Amount__LCY__Caption;FieldCaption("Amount (LCY)"))
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            dataitem(ErrorLoop;"Integer")
            {
                DataItemTableView = sorting(Number) order(ascending);
                column(ReportForNavId_1162; 1162)
                {
                }
                column(ErrorText;ErrorText)
                {
                }
                column(Warning_Caption;Warning_CaptionLbl)
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

            trigger OnAfterGetRecord()
            begin
                ServContractHdr.SetFilter("Contract No.","Service Contract No.");
                if ServContractHdr.FindFirst then begin
                  ServContractHdr.CalcFields("No. of Unposted Credit Memos");
                  if ServContractHdr."No. of Unposted Credit Memos" <> 0 then
                    AddError(Text002);
                end;
            end;

            trigger OnPreDataItem()
            begin
                if UntilDate = 0D then
                  Error(Text000);
                if PostingDate = 0D then
                  Error(Text001);

                SetRange("Posting Date",0D,UntilDate);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(UntilDate;UntilDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Post until Date';
                    }
                    field(PostingDate;PostingDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posting Date';
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

    trigger OnInitReport()
    begin
        if PostingDate = 0D then
          PostingDate := WorkDate;
    end;

    trigger OnPreReport()
    begin
        ServLedgerFilters := "Service Ledger Entry".GetFilters;
    end;

    var
        Text000: label 'You must fill in the Post Until Date field.';
        Text001: label 'You must fill in the Posting Date field.';
        ServContractHdr: Record "Service Contract Header";
        UntilDate: Date;
        PostingDate: Date;
        ErrorText: Text[250];
        ServLedgerFilters: Text;
        Text002: label 'There is at least one unposted credit memo linked to this contract.';
        ErrorCounter: Integer;
        Prepaid_Contract_Entries___TestCaptionLbl: label 'Prepaid Contract Entries - Test';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        PostingDateCaptionLbl: label 'Posting Date';
        UntilDateCaptionLbl: label 'Post until Date';
        Service_Ledger_Entry__Posting_Date_CaptionLbl: label 'Posting Date';
        TotalCaptionLbl: label 'Total';
        Warning_CaptionLbl: label 'Warning!';


    procedure InitVariables(LocalUntilDate: Date;LocalPostingDate: Date)
    begin
        UntilDate := LocalUntilDate;
        PostingDate := LocalPostingDate;
    end;

    local procedure AddError(Text: Text[250])
    begin
        ErrorCounter += 1;
        ErrorText := Text;
    end;
}

