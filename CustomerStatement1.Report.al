#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51077 "Customer Statement1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Customer Statement1.rdlc';
    Caption = 'Customer - Statement';
    UseRequestPage = false;

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            column(ReportForNavId_6836; 6836)
            {
            }
            column(UPPERCASE_COMPANYNAME_;UpperCase(COMPANYNAME))
            {
            }
            column(Reg_No;"No.")
            {
            }
            column(Customer_Name;Name)
            {
            }
            column(StartBalAdjLCY;StartBalAdjLCY)
            {
                AutoFormatType = 1;
            }
            column(CustBalanceLCY;CustBalanceLCY)
            {
                AutoFormatType = 1;
            }
            column(Customer__Debit_Amount_;"Debit Amount")
            {
            }
            column(StartBalanceLCY___StartBalAdjLCY____Cust__Ledger_Entry___Amount__LCY_____Correction___ApplicationRounding;StartBalanceLCY + StartBalAdjLCY + "Cust. Ledger Entry"."Amount (LCY)" + Correction + ApplicationRounding)
            {
                AutoFormatType = 1;
            }
            column(StartBalanceLCY;StartBalanceLCY)
            {
                AutoFormatType = 1;
            }
            column(Cust__Ledger_Entry___Amount__LCY_____Correction___ApplicationRounding;"Cust. Ledger Entry"."Amount (LCY)" + Correction + ApplicationRounding)
            {
                AutoFormatType = 1;
            }
            column(StartBalAdjLCY_Control67;StartBalAdjLCY)
            {
                AutoFormatType = 1;
            }
            column(StartBalanceLCY___StartBalAdjLCY;StartBalanceLCY + StartBalAdjLCY)
            {
                AutoFormatType = 1;
            }
            column(STUDENT_STATEMENT_______Caption;STUDENT_STATEMENT_______CaptionLbl)
            {
            }
            column(Date_Caption;Date_CaptionLbl)
            {
            }
            column(Ref_No_Caption;Ref_No_CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry_DescriptionCaption;"Cust. Ledger Entry".FieldCaption(Description))
            {
            }
            column(Bal__KES__Caption;Bal__KES__CaptionLbl)
            {
            }
            column(CUSTOMER_NAME_Caption;CUSTOMER_NAME_CaptionLbl)
            {
            }
            column(OUR_NO_Caption;OUR_NO_CaptionLbl)
            {
            }
            column(PAYMENT_TODATE_Caption;PAYMENT_TODATE_CaptionLbl)
            {
            }
            column(INVOICED_AMOUNT_Caption;INVOICED_AMOUNT_CaptionLbl)
            {
            }
            column(EmptyStringCaption;EmptyStringCaptionLbl)
            {
            }
            column(TypeCaption;TypeCaptionLbl)
            {
            }
            column(Adj__of_Opening_BalanceCaption;Adj__of_Opening_BalanceCaptionLbl)
            {
            }
            column(Total__LCY__Before_PeriodCaption;Total__LCY__Before_PeriodCaptionLbl)
            {
            }
            column(Total__LCY_Caption;Total__LCY_CaptionLbl)
            {
            }
            column(Customer_Date_Filter;"Date Filter")
            {
            }
            column(Customer_Global_Dimension_2_Filter;"Global Dimension 2 Filter")
            {
            }
            column(CustBal;Customer.Balance)
            {
            }
            column(Customer_Global_Dimension_1_Filter;"Global Dimension 1 Filter")
            {
            }
            column(Faculty;Faculty)
            {
            }
            column(Stage;Stage)
            {
            }
            column(Campus;Customer."Global Dimension 1 Code")
            {
            }
            column(ClassCode;Customer."Class Code")
            {
            }
            column(CourseDet;Customer."Course Details")
            {
            }
            dataitem("Cust. Ledger Entry";"Cust. Ledger Entry")
            {
                DataItemLink = "Customer No."=field("No."),"Posting Date"=field("Date Filter"),"Global Dimension 2 Code"=field("Global Dimension 2 Filter"),"Global Dimension 1 Code"=field("Global Dimension 1 Filter"),"Date Filter"=field("Date Filter");
                DataItemTableView = sorting("Customer No.","Posting Date") where(Reversed=filter(false));
                column(ReportForNavId_8503; 8503)
                {
                }
                column(Cust__Ledger_Entry_Description;Description)
                {
                }
                column(CustBalanceLCY_Control56;CustBalanceLCY)
                {
                    AutoFormatType = 1;
                }
                column(Cust__Ledger_Entry__Credit_Amount_;"Credit Amount")
                {
                }
                column(Cust__Ledger_Entry__Debit_Amount_;"Debit Amount")
                {
                }
                column(Cust__Ledger_Entry__External_Document_No__;"External Document No.")
                {
                }
                column(Cust__Ledger_Entry__Posting_Date_;"Posting Date")
                {
                }
                column(Cust__Ledger_Entry__Document_No__;"Document No.")
                {
                }
                column(Cust__Ledger_Entry_Entry_No_;"Entry No.")
                {
                }
                column(Cust__Ledger_Entry_Customer_No_;"Customer No.")
                {
                }
                column(Cust__Ledger_Entry_Global_Dimension_2_Code;"Global Dimension 2 Code")
                {
                }
                column(Cust__Ledger_Entry_Global_Dimension_1_Code;"Global Dimension 1 Code")
                {
                }
                column(Cust__Ledger_Entry_Date_Filter;"Date Filter")
                {
                }
                column(companylogo;companyInfo.Picture)
                {
                }
                column(CompanyAddress;companyInfo.Address)
                {
                }
                column(Addresses;'Telephone: '+companyInfo."Phone No. 2"+', Phone: '+companyInfo."Phone No."+', Email: '+companyInfo."E-Mail"+', Fax: '+companyInfo."Fax No.")
                {
                }
                dataitem("Detailed Cust. Ledg. Entry";"Detailed Cust. Ledg. Entry")
                {
                    DataItemLink = "Cust. Ledger Entry No."=field("Entry No.");
                    DataItemTableView = sorting("Cust. Ledger Entry No.","Entry Type","Posting Date") where("Entry Type"=const("Correction of Remaining Amount"));
                    column(ReportForNavId_6942; 6942)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        Correction := Correction + "Amount (LCY)";
                        CustBalanceLCY := CustBalanceLCY + "Amount (LCY)";
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetFilter("Posting Date",CustDateFilter);
                    end;
                }
                dataitem("Detailed Cust. Ledg. Entry2";"Detailed Cust. Ledg. Entry")
                {
                    DataItemLink = "Cust. Ledger Entry No."=field("Entry No.");
                    DataItemTableView = sorting("Cust. Ledger Entry No.","Entry Type","Posting Date") where("Entry Type"=const("Appln. Rounding"));
                    column(ReportForNavId_7757; 7757)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        ApplicationRounding := ApplicationRounding + "Amount (LCY)";
                        CustBalanceLCY := CustBalanceLCY + "Amount (LCY)";
                        if Confirm('%1 %2',true,Text001,ApplicationRounding) then;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetFilter("Posting Date",CustDateFilter);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    CalcFields(Amount,"Remaining Amount","Amount (LCY)","Remaining Amt. (LCY)");
                    
                    CustLedgEntryExists := true;
                    if PrintAmountsInLCY then begin
                      CustAmount := "Amount (LCY)";
                      CustRemainAmount := "Remaining Amt. (LCY)";
                      CustCurrencyCode := '';
                    end else begin
                      CustAmount := Amount;
                      CustRemainAmount := "Remaining Amount";
                      CustCurrencyCode := "Currency Code";
                    end;
                    CustBalanceLCY := CustBalanceLCY + "Amount (LCY)";
                    if ("Document Type" = "document type"::Payment) or ("Document Type" = "document type"::Refund) then
                      CustEntryDueDate := 0D
                    else
                      CustEntryDueDate := "Due Date";
                    
                    /*
                    "Cust. Ledger Entry".CALCFIELDS("Cust. Ledger Entry".Amount);
                    clear(totals1);
                    detCustLedEntry.RESET;
                    detCustLedEntry.SETRANGE(detCustLedEntry."Document No.","Cust. Ledger Entry"."Document No.");
                    detCustLedEntry.SETRANGE(detCustLedEntry."Customer No.","Cust. Ledger Entry"."Customer No.");
                    detCustLedEntry.SETRANGE(detCustLedEntry."Posting Date","Cust. Ledger Entry"."Posting Date");
                    IF detCustLedEntry.FIND('-') THEN BEGIN
                    IF detCustLedEntry.COUNT<2 THEN BEGIN
                    CALCFIELDS(Amount,"Remaining Amount","Amount (LCY)","Remaining Amt. (LCY)");
                    
                    CustLedgEntryExists := TRUE;
                    IF PrintAmountsInLCY THEN BEGIN
                      CustAmount := "Amount (LCY)";
                      CustRemainAmount := "Remaining Amt. (LCY)";
                      CustCurrencyCode := '';
                    END ELSE BEGIN
                      CustAmount := Amount;
                      CustRemainAmount := "Remaining Amount";
                      CustCurrencyCode := "Currency Code";
                    END;
                    CustBalanceLCY := CustBalanceLCY + "Amount (LCY)";
                    IF ("Document Type" = "Document Type"::Payment) OR ("Document Type" = "Document Type"::Refund) THEN
                      CustEntryDueDate := 0D
                    ELSE
                      CustEntryDueDate := "Due Date";
                      END ELSE begin
                        repeat
                        totals1:=totals1+"Amount (LCY)";
                        until detCustLedEntry.next = 0;
                    
                    if totals1=0 THEN
                          CurrReport.SKIP
                    
                          ELSE BEGIN
                    CustLedgEntryExists := TRUE;
                    IF PrintAmountsInLCY THEN BEGIN
                      CustAmount := "Amount (LCY)";
                      CustRemainAmount := "Remaining Amt. (LCY)";
                      CustCurrencyCode := '';
                    END ELSE BEGIN
                      CustAmount := Amount;
                      CustRemainAmount := "Remaining Amount";
                      CustCurrencyCode := "Currency Code";
                    END;
                    CustBalanceLCY := CustBalanceLCY + "Amount (LCY)";
                    IF ("Document Type" = "Document Type"::Payment) OR ("Document Type" = "Document Type"::Refund) THEN
                      CustEntryDueDate := 0D
                    ELSE
                      CustEntryDueDate := "Due Date";
                    
                          END;
                      end;
                    END ELSE CurrReport.SKIP;
                    
                    */

                end;

                trigger OnPreDataItem()
                begin
                    CustLedgEntryExists := false;
                    CurrReport.CreateTotals(CustAmount,"Amount (LCY)");
                end;
            }
            dataitem("Integer";"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_5444; 5444)
                {
                }
                column(CustBalanceLCY_Control1102760012;CustBalanceLCY)
                {
                    AutoFormatType = 1;
                }
                column(USERID;UserId)
                {
                }
                column(FORMAT_TODAY_0_4_;Format(Today,0,4))
                {
                }
                column(TIME;Time)
                {
                }
                column(Customer__Credit_Amount__LCY__;Customer."Credit Amount (LCY)")
                {
                }
                column(Customer__Debit_Amount__LCY__;Customer."Debit Amount (LCY)")
                {
                }
                column(Totals___________________________________________________________Caption;Totals___________________________________________________________CaptionLbl)
                {
                }
                column(Statement_Issued_By_Caption;Statement_Issued_By_CaptionLbl)
                {
                }
                column(On_Caption;On_CaptionLbl)
                {
                }
                column(END_______________________________________________Caption;END_______________________________________________CaptionLbl)
                {
                }
                column(DataItem1102755005;There_will_be_no_refunds_until_completion_of_your_course_and_classification__Any_queries_to_be_addressed_to_Finance_OfficerCaLbl)
                {
                }
                column(Integer_Number;Number)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if not CustLedgEntryExists and ((StartBalanceLCY = 0) or ExcludeBalanceOnly) then begin
                      StartBalanceLCY := 0;
                      CurrReport.Skip;
                    end;
                    Customer.CalcFields(Customer."Credit Amount (LCY)");
                    Customer.CalcFields(Customer."Debit Amount (LCY)");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                StartBalanceLCY := 0;
                StartBalAdjLCY := 0;
                if CustDateFilter <> '' then begin
                  if GetRangeMin("Date Filter") <> 0D then begin
                    SetRange("Date Filter",0D,GetRangeMin("Date Filter") - 1);
                    CalcFields("Net Change (LCY)");
                    CalcFields(Balance);
                    StartBalanceLCY := "Net Change (LCY)";
                  end;
                  SetFilter("Date Filter",CustDateFilter);
                  CalcFields("Net Change (LCY)");
                  CalcFields(Balance);
                  StartBalAdjLCY := "Net Change (LCY)";
                  CustLedgEntry.SetCurrentkey("Customer No.","Posting Date");
                  CustLedgEntry.SetRange("Customer No.",Customer."No.");
                  CustLedgEntry.SetFilter("Posting Date",CustDateFilter);
                  if CustLedgEntry.Find('-') then
                    repeat
                      CustLedgEntry.SetFilter("Date Filter",CustDateFilter);
                      CustLedgEntry.CalcFields("Amount (LCY)");
                      StartBalAdjLCY := StartBalAdjLCY - CustLedgEntry."Amount (LCY)";
                      "Detailed Cust. Ledg. Entry".SetCurrentkey("Cust. Ledger Entry No.","Entry Type","Posting Date");
                      "Detailed Cust. Ledg. Entry".SetRange("Cust. Ledger Entry No.",CustLedgEntry."Entry No.");
                      "Detailed Cust. Ledg. Entry".SetFilter("Entry Type",'%1|%2',
                        "Detailed Cust. Ledg. Entry"."entry type"::"Correction of Remaining Amount",
                        "Detailed Cust. Ledg. Entry"."entry type"::"Appln. Rounding");
                      "Detailed Cust. Ledg. Entry".SetFilter("Posting Date",CustDateFilter);
                      if "Detailed Cust. Ledg. Entry".Find('-') then
                        repeat
                          StartBalAdjLCY := StartBalAdjLCY - "Detailed Cust. Ledg. Entry"."Amount (LCY)";
                        until "Detailed Cust. Ledg. Entry".Next = 0;
                      "Detailed Cust. Ledg. Entry".Reset;
                    until CustLedgEntry.Next = 0;
                end;
                CurrReport.PrintonlyIfDetail := ExcludeBalanceOnly or (StartBalanceLCY = 0);
                CustBalanceLCY := StartBalanceLCY + StartBalAdjLCY;

                Clear(Faculty);
                Clear(Stage);
                CalcFields("Student Programme");
                Prog.Reset;
                Prog.SetRange(Prog.Code,"Student Programme");
                if Prog.Find('-') then begin
                DimVal.Reset;
                DimVal.SetRange(DimVal.Code,Prog."School Code");
                if DimVal.Find('-') then begin
                Faculty:=UpperCase(DimVal.Name);
                end;
                end;

                //CALCFIELDS("Current Stage");
                ProgStages.Reset;
                ProgStages.SetRange(ProgStages.Code,"Current Semester");
                if ProgStages.Find('-') then begin
                Stage:=ProgStages.Description;
                end;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.NewPagePerRecord := PrintOnlyOnePerPage;
                CurrReport.CreateTotals("Cust. Ledger Entry"."Amount (LCY)",StartBalanceLCY, StartBalAdjLCY, Correction, ApplicationRounding);
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
        CustFilter := Customer.GetFilters;
        CustDateFilter := Customer.GetFilter("Date Filter");
        with "Cust. Ledger Entry" do
          if PrintAmountsInLCY then begin
            AmountCaption := FieldCaption("Amount (LCY)");
            RemainingAmtCaption := FieldCaption("Remaining Amt. (LCY)");
          end else begin
            AmountCaption := FieldCaption(Amount);
            RemainingAmtCaption := FieldCaption("Remaining Amount");
          end;

        companyInfo.Reset;
        if companyInfo.Find('-') then begin
        companyInfo.CalcFields(companyInfo.Picture);
        end;
    end;

    var
        Text000: label 'Period: %1';
        totals1: Decimal;
        CustLedgEntry: Record "Cust. Ledger Entry";
        PrintAmountsInLCY: Boolean;
        PrintOnlyOnePerPage: Boolean;
        ExcludeBalanceOnly: Boolean;
        CustFilter: Text[250];
        CustDateFilter: Text[30];
        AmountCaption: Text[30];
        RemainingAmtCaption: Text[30];
        CustAmount: Decimal;
        CustRemainAmount: Decimal;
        CustBalanceLCY: Decimal;
        CustCurrencyCode: Code[10];
        CustEntryDueDate: Date;
        StartBalanceLCY: Decimal;
        StartBalAdjLCY: Decimal;
        Correction: Decimal;
        ApplicationRounding: Decimal;
        CustLedgEntryExists: Boolean;
        Text001: label 'Appln Rounding:';
        STUDENT_STATEMENT_______CaptionLbl: label '***** STUDENT STATEMENT*******';
        Date_CaptionLbl: label 'Date:';
        Ref_No_CaptionLbl: label 'Ref No.';
        Bal__KES__CaptionLbl: label 'Bal (KES:)';
        CUSTOMER_NAME_CaptionLbl: label 'CUSTOMER NAME:';
        OUR_NO_CaptionLbl: label 'OUR NO:';
        PAYMENT_TODATE_CaptionLbl: label 'PAYMENT TODATE:';
        INVOICED_AMOUNT_CaptionLbl: label 'INVOICED AMOUNT:';
        EmptyStringCaptionLbl: label '_______________________________________________________________________________________________________________________________________________________________';
        TypeCaptionLbl: label 'Type';
        Adj__of_Opening_BalanceCaptionLbl: label 'Adj. of Opening Balance';
        Total__LCY__Before_PeriodCaptionLbl: label 'Total (LCY) Before Period';
        Total__LCY_CaptionLbl: label 'Total (LCY)';
        Totals___________________________________________________________CaptionLbl: label 'Totals:**********************************************************';
        Statement_Issued_By_CaptionLbl: label 'Statement Issued By:';
        On_CaptionLbl: label 'On:';
        END_______________________________________________CaptionLbl: label '************************************END***********************************************';
        There_will_be_no_refunds_until_completion_of_your_course_and_classification__Any_queries_to_be_addressed_to_Finance_OfficerCaLbl: label 'There will be no refunds until completion of your course and classification. Any queries to be addressed to Finance Officer';
        Faculty: Text[100];
        Prog: Record UnknownRecord61511;
        DimVal: Record "Dimension Value";
        Stage: Code[50];
        ProgStages: Record UnknownRecord61516;
        detCustLedEntry: Record "Cust. Ledger Entry";
        companyInfo: Record "Company Information";
}

