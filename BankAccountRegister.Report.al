#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1403 "Bank Account Register"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Bank Account Register.rdlc';
    Caption = 'Bank Account Register';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("G/L Register";"G/L Register")
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(ReportForNavId_9922; 9922)
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
            column(PrintAmountsInLCY;PrintAmountsInLCY)
            {
            }
            column(G_L_Register__TABLECAPTION__________GLRegFilter;TableCaption + ': ' + GLRegFilter)
            {
            }
            column(GLRegFilter;GLRegFilter)
            {
            }
            column(G_L_Register__No__;"No.")
            {
            }
            column(Bank_Account_Ledger_Entry___Debit_Amount__LCY__;"Bank Account Ledger Entry"."Debit Amount (LCY)")
            {
            }
            column(Bank_Account_Ledger_Entry___Credit_Amount__LCY__;"Bank Account Ledger Entry"."Credit Amount (LCY)")
            {
            }
            column(Bank_Account_Ledger_Entry___Amount__LCY__;"Bank Account Ledger Entry"."Amount (LCY)")
            {
            }
            column(Bank_Account_RegisterCaption;Bank_Account_RegisterCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(All_amounts_are_in_LCYCaption;All_amounts_are_in_LCYCaptionLbl)
            {
            }
            column(Bank_Account_Ledger_Entry__Posting_Date_Caption;Bank_Account_Ledger_Entry__Posting_Date_CaptionLbl)
            {
            }
            column(Bank_Account_Ledger_Entry__Document_Type_Caption;Bank_Account_Ledger_Entry__Document_Type_CaptionLbl)
            {
            }
            column(Bank_Account_Ledger_Entry__Document_No__Caption;"Bank Account Ledger Entry".FieldCaption("Document No."))
            {
            }
            column(Bank_Account_Ledger_Entry_DescriptionCaption;"Bank Account Ledger Entry".FieldCaption(Description))
            {
            }
            column(Bank_Account_Ledger_Entry__Bank_Account_No__Caption;"Bank Account Ledger Entry".FieldCaption("Bank Account No."))
            {
            }
            column(BankAcc_NameCaption;BankAcc_NameCaptionLbl)
            {
            }
            column(BankAccAmountCaption;BankAccAmountCaptionLbl)
            {
            }
            column(Bank_Account_Ledger_Entry__Entry_No__Caption;"Bank Account Ledger Entry".FieldCaption("Entry No."))
            {
            }
            column(Bank_Account_Ledger_Entry_OpenCaption;CaptionClassTranslate("Bank Account Ledger Entry".FieldCaption(Open)))
            {
            }
            column(Bank_Account_Ledger_Entry__Remaining_Amount_Caption;"Bank Account Ledger Entry".FieldCaption("Remaining Amount"))
            {
            }
            column(G_L_Register__No__Caption;G_L_Register__No__CaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            column(Bank_Account_Ledger_Entry___Debit_Amount__LCY__Caption;Bank_Account_Ledger_Entry___Debit_Amount__LCY__CaptionLbl)
            {
            }
            column(Bank_Account_Ledger_Entry___Credit_Amount__LCY__Caption;Bank_Account_Ledger_Entry___Credit_Amount__LCY__CaptionLbl)
            {
            }
            column(Bank_Account_Ledger_Entry___Amount__LCY__Caption;Bank_Account_Ledger_Entry___Amount__LCY__CaptionLbl)
            {
            }
            dataitem("Bank Account Ledger Entry";"Bank Account Ledger Entry")
            {
                DataItemTableView = sorting("Entry No.");
                column(ReportForNavId_4920; 4920)
                {
                }
                column(Bank_Account_Ledger_Entry__Posting_Date_;Format("Posting Date"))
                {
                }
                column(Bank_Account_Ledger_Entry__Document_Type_;"Document Type")
                {
                }
                column(Bank_Account_Ledger_Entry__Document_No__;"Document No.")
                {
                }
                column(Bank_Account_Ledger_Entry_Description;Description)
                {
                }
                column(Bank_Account_Ledger_Entry__Bank_Account_No__;"Bank Account No.")
                {
                }
                column(BankAcc_Name;BankAcc.Name)
                {
                }
                column(BankAccAmount;BankAccAmount)
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                }
                column(Bank_Account_Ledger_Entry__Currency_Code_;"Currency Code")
                {
                }
                column(Bank_Account_Ledger_Entry__Entry_No__;"Entry No.")
                {
                }
                column(Bank_Account_Ledger_Entry_Open;Format(Open))
                {
                }
                column(Bank_Account_Ledger_Entry__Remaining_Amount_;"Remaining Amount")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if not BankAcc.Get("Bank Account No.") then
                      BankAcc.Init;

                    if PrintAmountsInLCY then begin
                      BankAccAmount := "Amount (LCY)";
                      "Currency Code" := '';
                    end else
                      BankAccAmount := Amount;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Entry No.","G/L Register"."From Entry No.","G/L Register"."To Entry No.");
                    CurrReport.CreateTotals("Amount (LCY)","Debit Amount (LCY)","Credit Amount (LCY)");
                end;
            }

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(
                  "Bank Account Ledger Entry"."Amount (LCY)",
                  "Bank Account Ledger Entry"."Debit Amount (LCY)",
                  "Bank Account Ledger Entry"."Credit Amount (LCY)");
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
                    field(PrintAmountsInLCY;PrintAmountsInLCY)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Show Amounts in $';
                        ToolTip = 'Specifies if the reported amounts are shown in the local currency.';
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

    trigger OnPreReport()
    begin
        GLRegFilter := "G/L Register".GetFilters;
    end;

    var
        BankAcc: Record "Bank Account";
        GLRegFilter: Text;
        BankAccAmount: Decimal;
        PrintAmountsInLCY: Boolean;
        Bank_Account_RegisterCaptionLbl: label 'Bank Account Register';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        All_amounts_are_in_LCYCaptionLbl: label 'All amounts are in $.';
        Bank_Account_Ledger_Entry__Posting_Date_CaptionLbl: label 'Posting Date';
        Bank_Account_Ledger_Entry__Document_Type_CaptionLbl: label 'Document Type';
        BankAcc_NameCaptionLbl: label 'Name';
        BankAccAmountCaptionLbl: label 'Amount';
        G_L_Register__No__CaptionLbl: label 'Register No.';
        TotalCaptionLbl: label 'Total';
        Bank_Account_Ledger_Entry___Debit_Amount__LCY__CaptionLbl: label 'Debit ($)';
        Bank_Account_Ledger_Entry___Credit_Amount__LCY__CaptionLbl: label 'Credit ($)';
        Bank_Account_Ledger_Entry___Amount__LCY__CaptionLbl: label 'Total ($)';
}

