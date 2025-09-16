#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10407 "Bank Rec. Test Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Bank Rec. Test Report.rdlc';
    Caption = 'Bank Rec. Test Report';

    dataset
    {
        dataitem(UnknownTable10120;UnknownTable10120)
        {
            DataItemTableView = sorting("Bank Account No.","Statement No.");
            RequestFilterFields = "Bank Account No.","Statement No.";
            column(ReportForNavId_8875; 8875)
            {
            }
            column(USERID;UserId)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(TIME;Time)
            {
            }
            column(CompanyInformation_Name;CompanyInformation.Name)
            {
            }
            column(Statement_Balance_____Outstanding_Deposits______Outstanding_Checks_;("Statement Balance" + "Outstanding Deposits") - "Outstanding Checks")
            {
            }
            column(Bank_Rec__Header__Outstanding_Checks_;"Outstanding Checks")
            {
            }
            column(Statement_Balance_____Outstanding_Deposits_;"Statement Balance" + "Outstanding Deposits")
            {
            }
            column(Positive_Adjustments_____Negative_Bal__Adjustments_;"Positive Adjustments" - "Negative Bal. Adjustments")
            {
            }
            column(Negative_Adjustments_____Positive_Bal__Adjustments_;"Negative Adjustments" - "Positive Bal. Adjustments")
            {
            }
            column(Bank_Rec__Header__Outstanding_Deposits_;"Outstanding Deposits")
            {
            }
            column(G_L_Balance______Positive_Adjustments_____Negative_Bal__Adjustments__;"G/L Balance" + ("Positive Adjustments" - "Negative Bal. Adjustments"))
            {
            }
            column(DataItem1020013;"G/L Balance" + ("Positive Adjustments" - "Negative Bal. Adjustments") + ("Negative Adjustments" - "Positive Bal. Adjustments"))
            {
            }
            column(Difference;("G/L Balance" + ("Positive Adjustments" - "Negative Bal. Adjustments") + ("Negative Adjustments" - "Positive Bal. Adjustments")) - (("Statement Balance" + "Outstanding Deposits") - "Outstanding Checks"))
            {
            }
            column(Bank_Rec__Header__G_L_Balance__LCY__;"G/L Balance (LCY)")
            {
            }
            column(Bank_Rec__Header__Statement_Balance_;"Statement Balance")
            {
            }
            column(Bank_Rec__Header__Statement_Date_;"Statement Date")
            {
            }
            column(Bank_Rec__Header__Currency_Code_;"Currency Code")
            {
            }
            column(Bank_Rec__Header__Statement_No__;"Statement No.")
            {
            }
            column(Bank_Rec__Header__Bank_Account_No__;"Bank Account No.")
            {
            }
            column(Bank_Rec__Header__G_L_Balance_;"G/L Balance")
            {
            }
            column(PrintDetails;PrintDetails)
            {
            }
            column(PrintChecks;PrintChecks)
            {
            }
            column(PrintDeposits;PrintDeposits)
            {
            }
            column(PrintAdjustments;PrintAdjustments)
            {
            }
            column(PrintOutstandingChecks;PrintOutstandingChecks)
            {
            }
            column(PrintOutstandingDeposits;PrintOutstandingDeposits)
            {
            }
            column(Amount_BalAmount;Amount_BalAmount)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Bank_Rec__Test_ReportCaption;Bank_Rec__Test_ReportCaptionLbl)
            {
            }
            column(Statement_Balance_____Outstanding_Deposits______Outstanding_Checks_Caption;Statement_Balance_____Outstanding_Deposits______Outstanding_Checks_CaptionLbl)
            {
            }
            column(Bank_Rec__Header__Outstanding_Checks_Caption;FieldCaption("Outstanding Checks"))
            {
            }
            column(Statement_Balance_____Outstanding_Deposits_Caption;Statement_Balance_____Outstanding_Deposits_CaptionLbl)
            {
            }
            column(Positive_Adjustments_____Negative_Bal__Adjustments_Caption;Positive_Adjustments_____Negative_Bal__Adjustments_CaptionLbl)
            {
            }
            column(Negative_Adjustments_____Positive_Bal__Adjustments_Caption;Negative_Adjustments_____Positive_Bal__Adjustments_CaptionLbl)
            {
            }
            column(Bank_Rec__Header__Outstanding_Deposits_Caption;FieldCaption("Outstanding Deposits"))
            {
            }
            column(G_L_Balance______Positive_Adjustments_____Negative_Bal__Adjustments__Caption;G_L_Balance______Positive_Adjustments_____Negative_Bal__Adjustments__CaptionLbl)
            {
            }
            column(DataItem1020019;G_L_Balance______Positive_Adjustments_____Negative_Bal__Adjustments_______Negative_Adjustments_____Positive_Bal__Adjustments_Lbl)
            {
            }
            column(DifferenceCaption;DifferenceCaptionLbl)
            {
            }
            column(Bank_Rec__Header__G_L_Balance__LCY__Caption;FieldCaption("G/L Balance (LCY)"))
            {
            }
            column(Bank_Rec__Header__Statement_Balance_Caption;FieldCaption("Statement Balance"))
            {
            }
            column(Bank_Rec__Header__Statement_Date_Caption;FieldCaption("Statement Date"))
            {
            }
            column(Bank_Rec__Header__Currency_Code_Caption;FieldCaption("Currency Code"))
            {
            }
            column(Bank_Rec__Header__Statement_No__Caption;FieldCaption("Statement No."))
            {
            }
            column(Bank_Rec__Header__Bank_Account_No__Caption;FieldCaption("Bank Account No."))
            {
            }
            column(Bank_Rec__Header__G_L_Balance_Caption;FieldCaption("G/L Balance"))
            {
            }
            column(DifferenceCaption_Control1020058;DifferenceCaption_Control1020058Lbl)
            {
            }
            column(Cleared___Balance_Amt_Caption;Cleared___Balance_Amt_CaptionLbl)
            {
            }
            column(AmountCaption;AmountCaptionLbl)
            {
            }
            column(Bal__Account_No_Caption;Bal__Account_No_CaptionLbl)
            {
            }
            column(Bal__Account_TypeCaption;Bal__Account_TypeCaptionLbl)
            {
            }
            column(DescriptionCaption;DescriptionCaptionLbl)
            {
            }
            column(Account_No_Caption;Account_No_CaptionLbl)
            {
            }
            column(Account_TypeCaption;Account_TypeCaptionLbl)
            {
            }
            column(Document_No_Caption;Document_No_CaptionLbl)
            {
            }
            column(Document_TypeCaption;Document_TypeCaptionLbl)
            {
            }
            column(Posting_DateCaption;Posting_DateCaptionLbl)
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
                column(ErrorLoop_Number;Number)
                {
                }

                trigger OnPostDataItem()
                begin
                    Clear(ErrorText);
                    ErrorCounter := 0;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Number,1,ErrorCounter);
                end;
            }
            dataitem(Checks;UnknownTable10121)
            {
                DataItemLink = "Bank Account No."=field("Bank Account No."),"Statement No."=field("Statement No.");
                DataItemTableView = sorting("Bank Account No.","Statement No.","Record Type","Line No.") where("Record Type"=const(Check),Cleared=const(Yes));
                column(ReportForNavId_1885; 1885)
                {
                }
                column(Checks__Posting_Date_;"Posting Date")
                {
                }
                column(Checks__Document_Type_;"Document Type")
                {
                }
                column(Checks__Document_No__;"Document No.")
                {
                }
                column(Checks_Description;Description)
                {
                }
                column(Checks_Amount;Amount)
                {
                }
                column(Checks__Cleared_Amount_;"Cleared Amount")
                {
                }
                column(Amount____Cleared_Amount_;Amount - "Cleared Amount")
                {
                }
                column(Checks__Bal__Account_No__;"Bal. Account No.")
                {
                }
                column(Checks__Bal__Account_Type_;"Bal. Account Type")
                {
                }
                column(Checks__Account_No__;"Account No.")
                {
                }
                column(Checks__Account_Type_;"Account Type")
                {
                }
                column(Checks_Amount_Control1020059;Amount)
                {
                }
                column(Checks__Cleared_Amount__Control1020060;"Cleared Amount")
                {
                }
                column(Amount____Cleared_Amount__Control1020061;Amount - "Cleared Amount")
                {
                }
                column(Checks_Bank_Account_No_;"Bank Account No.")
                {
                }
                column(Checks_Statement_No_;"Statement No.")
                {
                }
                column(Checks_Record_Type;"Record Type")
                {
                }
                column(Checks_Line_No_;"Line No.")
                {
                }
                column(ChecksCaption;ChecksCaptionLbl)
                {
                }
                column(ChecksCaption_Control1020052;ChecksCaption_Control1020052Lbl)
                {
                }
                column(Total_ChecksCaption;Total_ChecksCaptionLbl)
                {
                }
            }
            dataitem(Deposits;UnknownTable10121)
            {
                DataItemLink = "Bank Account No."=field("Bank Account No."),"Statement No."=field("Statement No.");
                DataItemTableView = sorting("Bank Account No.","Statement No.","Record Type","Line No.") where("Record Type"=const(Deposit),Cleared=const(Yes));
                column(ReportForNavId_6582; 6582)
                {
                }
                column(Deposits_Amount;Amount)
                {
                }
                column(Amount____Cleared_Amount__Control1020129;Amount - "Cleared Amount")
                {
                }
                column(Deposits__Cleared_Amount_;"Cleared Amount")
                {
                }
                column(Deposits__Bal__Account_No__;"Bal. Account No.")
                {
                }
                column(Deposits__Bal__Account_Type_;"Bal. Account Type")
                {
                }
                column(Deposits_Description;Description)
                {
                }
                column(Deposits__Account_No__;"Account No.")
                {
                }
                column(Deposits__Account_Type_;"Account Type")
                {
                }
                column(Deposits__Document_No__;"Document No.")
                {
                }
                column(Deposits__Document_Type_;"Document Type")
                {
                }
                column(Deposits__Posting_Date_;"Posting Date")
                {
                }
                column(Amount____Cleared_Amount__Control1020094;Amount - "Cleared Amount")
                {
                }
                column(Deposits__Cleared_Amount__Control1020095;"Cleared Amount")
                {
                }
                column(Deposits_Amount_Control1020096;Amount)
                {
                }
                column(Deposits_Bank_Account_No_;"Bank Account No.")
                {
                }
                column(Deposits_Statement_No_;"Statement No.")
                {
                }
                column(Deposits_Record_Type;"Record Type")
                {
                }
                column(Deposits_Line_No_;"Line No.")
                {
                }
                column(DepositsCaption;DepositsCaptionLbl)
                {
                }
                column(DepositsCaption_Control1020062;DepositsCaption_Control1020062Lbl)
                {
                }
                column(Total_DepositsCaption;Total_DepositsCaptionLbl)
                {
                }
                column(Deposit__External_Document_No_;"External Document No.")
                {
                }
            }
            dataitem(Adjustments;UnknownTable10121)
            {
                DataItemLink = "Bank Account No."=field("Bank Account No."),"Statement No."=field("Statement No.");
                DataItemTableView = sorting("Bank Account No.","Statement No.","Record Type","Line No.") where("Record Type"=const(Adjustment),Cleared=const(Yes));
                column(ReportForNavId_4845; 4845)
                {
                }
                column(Adjustments_Amount;Amount)
                {
                }
                column(BalAmount;-BalAmount)
                {
                }
                column(Adjustments__Bal__Account_No__;"Bal. Account No.")
                {
                }
                column(Adjustments__Bal__Account_Type_;"Bal. Account Type")
                {
                }
                column(Adjustments_Description;Description)
                {
                }
                column(Adjustments__Account_No__;"Account No.")
                {
                }
                column(Adjustments__Account_Type_;"Account Type")
                {
                }
                column(Adjustments__Document_No__;"Document No.")
                {
                }
                column(Adjustments__Document_Type_;"Document Type")
                {
                }
                column(Adjustments__Posting_Date_;"Posting Date")
                {
                }
                column(Adjustments_Amount_Control1020131;Amount)
                {
                }
                column(BalAmount_Control1020074;-BalAmount)
                {
                }
                column(Adjustments_Bank_Account_No_;"Bank Account No.")
                {
                }
                column(Adjustments_Statement_No_;"Statement No.")
                {
                }
                column(Adjustments_Record_Type;"Record Type")
                {
                }
                column(Adjustments_Line_No_;"Line No.")
                {
                }
                column(AdjustmentsCaption;AdjustmentsCaptionLbl)
                {
                }
                column(AdjustmentsCaption_Control1020063;AdjustmentsCaption_Control1020063Lbl)
                {
                }
                column(Total_AdjustmentsCaption;Total_AdjustmentsCaptionLbl)
                {
                }
                column(Warning___Balance_must_be_zero_for_adjustments_Caption;Warning___Balance_must_be_zero_for_adjustments_CaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if "Bal. Account No." = '' then
                      BalAmount := 0
                    else
                      BalAmount := Amount;
                    Amount_BalAmount := Amount - BalAmount
                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.CreateTotals(BalAmount);
                end;
            }
            dataitem(OutstandingChecks;UnknownTable10121)
            {
                DataItemLink = "Bank Account No."=field("Bank Account No."),"Statement No."=field("Statement No.");
                DataItemTableView = sorting("Bank Account No.","Statement No.","Record Type","Line No.") where("Record Type"=const(Check),Cleared=const(No));
                column(ReportForNavId_4661; 4661)
                {
                }
                column(OutstandingChecks_Amount;Amount)
                {
                }
                column(Amount____Cleared_Amount__Control1020157;Amount - "Cleared Amount")
                {
                }
                column(OutstandingChecks__Cleared_Amount_;"Cleared Amount")
                {
                }
                column(OutstandingChecks__Bal__Account_No__;"Bal. Account No.")
                {
                }
                column(OutstandingChecks__Bal__Account_Type_;"Bal. Account Type")
                {
                }
                column(OutstandingChecks_Description;Description)
                {
                }
                column(OutstandingChecks__Account_No__;"Account No.")
                {
                }
                column(OutstandingChecks__Account_Type_;"Account Type")
                {
                }
                column(OutstandingChecks__Document_No__;"Document No.")
                {
                }
                column(OutstandingChecks__Document_Type_;"Document Type")
                {
                }
                column(OutstandingChecks__Posting_Date_;"Posting Date")
                {
                }
                column(OutstandingChecks_Amount_Control1020136;Amount)
                {
                }
                column(OutstandingChecks_Bank_Account_No_;"Bank Account No.")
                {
                }
                column(OutstandingChecks_Statement_No_;"Statement No.")
                {
                }
                column(OutstandingChecks_Record_Type;"Record Type")
                {
                }
                column(OutstandingChecks_Line_No_;"Line No.")
                {
                }
                column(Outstanding_ChecksCaption;Outstanding_ChecksCaptionLbl)
                {
                }
                column(Outstanding_ChecksCaption_Control1020064;Outstanding_ChecksCaption_Control1020064Lbl)
                {
                }
                column(Total_Outstanding_ChecksCaption;Total_Outstanding_ChecksCaptionLbl)
                {
                }
            }
            dataitem(OutstandingDeposits;UnknownTable10121)
            {
                DataItemLink = "Bank Account No."=field("Bank Account No."),"Statement No."=field("Statement No.");
                DataItemTableView = sorting("Bank Account No.","Statement No.","Record Type","Line No.") where("Record Type"=const(Deposit),Cleared=const(No));
                column(ReportForNavId_9067; 9067)
                {
                }
                column(OutstandingDeposits_Amount;Amount)
                {
                }
                column(Amount____Cleared_Amount__Control1020168;Amount - "Cleared Amount")
                {
                }
                column(OutstandingDeposits__Cleared_Amount_;"Cleared Amount")
                {
                }
                column(OutstandingDeposits__Bal__Account_No__;"Bal. Account No.")
                {
                }
                column(OutstandingDeposits__Bal__Account_Type_;"Bal. Account Type")
                {
                }
                column(OutstandingDeposits_Description;Description)
                {
                }
                column(OutstandingDeposits__Account_No__;"Account No.")
                {
                }
                column(OutstandingDeposits__Account_Type_;"Account Type")
                {
                }
                column(OutstandingDeposits__Document_No__;"Document No.")
                {
                }
                column(OutstandingDeposits__Document_Type_;"Document Type")
                {
                }
                column(OutstandingDeposits__Posting_Date_;"Posting Date")
                {
                }
                column(OutstandingDeposits_Amount_Control1020187;Amount)
                {
                }
                column(OutstandingDeposits_Bank_Account_No_;"Bank Account No.")
                {
                }
                column(OutstandingDeposits_Statement_No_;"Statement No.")
                {
                }
                column(OutstandingDeposits_Record_Type;"Record Type")
                {
                }
                column(OutstandingDeposits_Line_No_;"Line No.")
                {
                }
                column(Outstanding_DepositsCaption;Outstanding_DepositsCaptionLbl)
                {
                }
                column(Outstanding_DepositsCaption_Control1020069;Outstanding_DepositsCaption_Control1020069Lbl)
                {
                }
                column(Total_Outstanding_DepositsCaption;Total_Outstanding_DepositsCaptionLbl)
                {
                }
                column(Outstanding__External_Document_No__;"External Document No.")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                SetupRecord;

                CalculateBalance;
                Difference :=
                  ("G/L Balance" +
                   ("Positive Adjustments" - "Negative Bal. Adjustments") +
                   ("Negative Adjustments" - "Positive Bal. Adjustments")) -
                  (("Statement Balance" + "Outstanding Deposits") - "Outstanding Checks");
                if Difference <> 0 then
                  AddError(StrSubstNo('Difference %1 must be zero before statement can be posted!',Difference));

                if "Statement Date" = 0D then
                  AddError('Statement date must be entered!');
                if "Statement No." = '' then
                  AddError('Statement number must be entered!');
                if "Bank Account No." = '' then
                  AddError('Bank account number must be entered!');
            end;

            trigger OnPreDataItem()
            begin
                Clear(ErrorText);
                ErrorCounter := 0;
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
                    field(PrintDetails;PrintDetails)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Print details';
                        ToolTip = 'Specifies if individual transactions are included in the report. Clear the check box to include only totals.';

                        trigger OnValidate()
                        begin
                            if PrintDetails then begin
                              PrintChecks := true;
                              PrintDeposits := true;
                              PrintAdjustments := true;
                              PrintOutstandingChecks := true;
                              PrintOutstandingDeposits := true;
                            end;
                            PrintDetailsOnAfterValidate;
                        end;
                    }
                    field(PrintChecks;PrintChecks)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Print checks';
                        Editable = PrintChecksEditable;
                        ToolTip = 'Specifies if the report includes bank reconciliation lines for checks.';
                    }
                    field(PrintDeposits;PrintDeposits)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Print deposits';
                        Editable = PrintDepositsEditable;
                        ToolTip = 'Specifies if the report includes bank reconciliation lines for deposits.';
                    }
                    field(PrintAdj;PrintAdjustments)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Print adjustments';
                        Editable = PrintAdjEditable;
                        ToolTip = 'Specifies if the report includes bank reconciliation lines for adjustments.';
                    }
                    field(PrintOutChecks;PrintOutstandingChecks)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Print outstanding checks';
                        Editable = PrintOutChecksEditable;
                        ToolTip = 'Specifies if the report includes bank reconciliation lines for outstanding checks.';
                    }
                    field(PrintOutDeposits;PrintOutstandingDeposits)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Print outstanding deposits';
                        Editable = PrintOutDepositsEditable;
                        ToolTip = 'Specifies if the report includes bank reconciliation lines for outstanding deposits.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            PrintChecksEditable := true;
            PrintDepositsEditable := true;
            PrintAdjEditable := true;
            PrintOutDepositsEditable := true;
            PrintOutChecksEditable := true;
        end;

        trigger OnOpenPage()
        begin
            SetupRequestForm;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInformation.Get;
    end;

    var
        PrintDetails: Boolean;
        PrintChecks: Boolean;
        PrintDeposits: Boolean;
        PrintAdjustments: Boolean;
        PrintOutstandingChecks: Boolean;
        PrintOutstandingDeposits: Boolean;
        Difference: Decimal;
        BalAmount: Decimal;
        ErrorCounter: Integer;
        ErrorText: array [50] of Text[250];
        CompanyInformation: Record "Company Information";
        Amount_BalAmount: Decimal;
        [InDataSet]
        PrintOutChecksEditable: Boolean;
        [InDataSet]
        PrintOutDepositsEditable: Boolean;
        [InDataSet]
        PrintAdjEditable: Boolean;
        [InDataSet]
        PrintDepositsEditable: Boolean;
        [InDataSet]
        PrintChecksEditable: Boolean;
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Bank_Rec__Test_ReportCaptionLbl: label 'Bank Rec. Test Report';
        Statement_Balance_____Outstanding_Deposits______Outstanding_Checks_CaptionLbl: label 'Ending Balance';
        Statement_Balance_____Outstanding_Deposits_CaptionLbl: label 'Subtotal';
        Positive_Adjustments_____Negative_Bal__Adjustments_CaptionLbl: label 'Positive Adjustments';
        Negative_Adjustments_____Positive_Bal__Adjustments_CaptionLbl: label 'Negative Adjustments';
        G_L_Balance______Positive_Adjustments_____Negative_Bal__Adjustments__CaptionLbl: label 'Subtotal';
        G_L_Balance______Positive_Adjustments_____Negative_Bal__Adjustments_______Negative_Adjustments_____Positive_Bal__Adjustments_Lbl: label 'Ending G/L Balance';
        DifferenceCaptionLbl: label 'Difference';
        DifferenceCaption_Control1020058Lbl: label 'Difference';
        Cleared___Balance_Amt_CaptionLbl: label 'Cleared / Balance Amt.';
        AmountCaptionLbl: label 'Amount';
        Bal__Account_No_CaptionLbl: label 'Bal. Account No.';
        Bal__Account_TypeCaptionLbl: label 'Bal. Account Type';
        DescriptionCaptionLbl: label 'Description';
        Account_No_CaptionLbl: label 'Account No.';
        Account_TypeCaptionLbl: label 'Account Type';
        Document_No_CaptionLbl: label 'Document No.';
        Document_TypeCaptionLbl: label 'Document Type';
        Posting_DateCaptionLbl: label 'Posting Date';
        ChecksCaptionLbl: label 'Checks';
        ChecksCaption_Control1020052Lbl: label 'Checks';
        Total_ChecksCaptionLbl: label 'Total Checks';
        DepositsCaptionLbl: label 'Deposits';
        DepositsCaption_Control1020062Lbl: label 'Deposits';
        Total_DepositsCaptionLbl: label 'Total Deposits';
        AdjustmentsCaptionLbl: label 'Adjustments';
        AdjustmentsCaption_Control1020063Lbl: label 'Adjustments';
        Total_AdjustmentsCaptionLbl: label 'Total Adjustments';
        Warning___Balance_must_be_zero_for_adjustments_CaptionLbl: label 'Warning!  Balance must be zero for adjustments!';
        Outstanding_ChecksCaptionLbl: label 'Outstanding Checks';
        Outstanding_ChecksCaption_Control1020064Lbl: label 'Outstanding Checks';
        Total_Outstanding_ChecksCaptionLbl: label 'Total Outstanding Checks';
        Outstanding_DepositsCaptionLbl: label 'Outstanding Deposits';
        Outstanding_DepositsCaption_Control1020069Lbl: label 'Outstanding Deposits';
        Total_Outstanding_DepositsCaptionLbl: label 'Total Outstanding Deposits';


    procedure SetupRecord()
    begin
        with "Bank Rec. Header" do begin
          SetRange("Date Filter","Statement Date");
          CalcFields("Positive Adjustments",
            "Positive Bal. Adjustments",
            "Negative Adjustments",
            "Negative Bal. Adjustments",
            "Outstanding Deposits",
            "Outstanding Checks");
        end;
    end;


    procedure SetupRequestForm()
    begin
        PageSetupRequestForm;
    end;

    local procedure AddError(Text: Text[250])
    begin
        ErrorCounter := ErrorCounter + 1;
        ErrorText[ErrorCounter] := StrSubstNo('Warning!  %1',Text);
    end;

    local procedure PrintDetailsOnAfterValidate()
    begin
        SetupRequestForm;
    end;

    local procedure PageSetupRequestForm()
    begin
        if not PrintDetails then begin
          PrintChecks := false;
          PrintDeposits := false;
          PrintAdjustments := false;
          PrintOutstandingChecks := false;
          PrintOutstandingDeposits := false;
        end;

        PrintOutChecksEditable := PrintDetails;
        PrintOutDepositsEditable := PrintDetails;
        PrintAdjEditable := PrintDetails;
        PrintDepositsEditable := PrintDetails;
        PrintChecksEditable := PrintDetails;
    end;
}

