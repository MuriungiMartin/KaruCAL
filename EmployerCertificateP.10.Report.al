#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51044 "Employer Certificate P.10"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employer Certificate P.10.rdlc';

    dataset
    {
        dataitem(UnknownTable61081;UnknownTable61081)
        {
            DataItemTableView = sorting("Date Opened") order(ascending);
            column(ReportForNavId_4946; 4946)
            {
            }
            column(CompanySetup__Company_P_I_N_;CompanySetup."Company P.I.N")
            {
            }
            column(YR;YR)
            {
            }
            column(ABS__Tax_Paid__;Abs("Tax Paid"))
            {
            }
            column(UPPERCASE__Period_Name__;UpperCase("Period Name"))
            {
            }
            column(TotalTax;TotalTax)
            {
            }
            column(DOMESTIC_TAXES_DEPARTMENTCaption;DOMESTIC_TAXES_DEPARTMENTCaptionLbl)
            {
            }
            column(P_10Caption;P_10CaptionLbl)
            {
            }
            column(EMPLOYER_S_PINCaption;EMPLOYER_S_PINCaptionLbl)
            {
            }
            column(APPENDIX_5Caption;APPENDIX_5CaptionLbl)
            {
            }
            column(P_A_Y_E___EMPLOYER_S_CERTIFICATECaption;P_A_Y_E___EMPLOYER_S_CERTIFICATECaptionLbl)
            {
            }
            column(YEARCaption;YEARCaptionLbl)
            {
            }
            column(To_Senior_Assistant_CommissionerCaption;To_Senior_Assistant_CommissionerCaptionLbl)
            {
            }
            column(EmptyStringCaption;EmptyStringCaptionLbl)
            {
            }
            column(DataItem1102756011;We_I_forward_herewith_____________________Tax_Deduction_Cards__P9A_P9B__showing_the_total_tax_deducted__as_listed_on_P10A__amLbl)
            {
            }
            column(This_total_tax_has_been_paid_as_follows__Caption;This_total_tax_has_been_paid_as_follows__CaptionLbl)
            {
            }
            column(MONTHCaption;MONTHCaptionLbl)
            {
            }
            column(PAYE_Caption;PAYE_CaptionLbl)
            {
            }
            column(AUDIT_TAXCaption;AUDIT_TAXCaptionLbl)
            {
            }
            column(FRINGECaption;FRINGECaptionLbl)
            {
            }
            column(DATE_PAID__PERCaption;DATE_PAID__PERCaptionLbl)
            {
            }
            column(TAXCaption;TAXCaptionLbl)
            {
            }
            column(INTEREST_PENALTYCaption;INTEREST_PENALTYCaptionLbl)
            {
            }
            column(BENEFITCaption;BENEFITCaptionLbl)
            {
            }
            column(RECEIVING_BANKCaption;RECEIVING_BANKCaptionLbl)
            {
            }
            column(TAXCaption_Control1102756027;TAXCaption_Control1102756027Lbl)
            {
            }
            column(STAMP_Caption;STAMP_CaptionLbl)
            {
            }
            column(KSHS__Caption;KSHS__CaptionLbl)
            {
            }
            column(KSHS__Caption_Control1102756030;KSHS__Caption_Control1102756030Lbl)
            {
            }
            column(KSHS__Caption_Control1102756031;KSHS__Caption_Control1102756031Lbl)
            {
            }
            column(TOTAL_TAXCaption;TOTAL_TAXCaptionLbl)
            {
            }
            column(DataItem1102756045;DATE_________________________________________________________________________________________________________________________Lbl)
            {
            }
            column(DataItem1102756046;SIGNATURE____________________________________________________________________________________________________________________Lbl)
            {
            }
            column(DataItem1102756047;ADDRESS______________________________________________________________________________________________________________________Lbl)
            {
            }
            column(DataItem1102756048;NAME_OF_EMPLOYER_____________________________________________________________________________________________________________Lbl)
            {
            }
            column(We_I_certify_that_the_particulars_entered_above_are_correctCaption;We_I_certify_that_the_particulars_entered_above_are_correctCaptionLbl)
            {
            }
            column(V5_____Provide_Statistical_information_required_by_Central_Bureau_of_Statistics_Caption;V5_____Provide_Statistical_information_required_by_Central_Bureau_of_Statistics_CaptionLbl)
            {
            }
            column(Income_Tax_OfficeCaption;Income_Tax_OfficeCaptionLbl)
            {
            }
            column(not_later_than_28th_FEBRUARYCaption;not_later_than_28th_FEBRUARYCaptionLbl)
            {
            }
            column(V4_____Complete_this_certificate_in_triplicate_and_send_the_top_two_copies_with_the_enclosures_to_yourCaption;V4_____Complete_this_certificate_in_triplicate_and_send_the_top_two_copies_with_the_enclosures_to_yourCaptionLbl)
            {
            }
            column(V1_____Attach_Photostat_copies_ofCaption;V1_____Attach_Photostat_copies_ofCaptionLbl)
            {
            }
            column(ALL_the_Pay_In_Credit_Slips__P11s_Caption;ALL_the_Pay_In_Credit_Slips__P11s_CaptionLbl)
            {
            }
            column(for_the_yearCaption;for_the_yearCaptionLbl)
            {
            }
            column(NOTE__Caption;NOTE__CaptionLbl)
            {
            }
            column(prPayroll_Periods_Date_Opened;"Date Opened")
            {
            }

            trigger OnAfterGetRecord()
            begin
                       "PRL-Payroll Periods".CalcFields("PRL-Payroll Periods"."Tax Paid");
                       TotalTax:=TotalTax+Abs("PRL-Payroll Periods"."Tax Paid");
            end;

            trigger OnPreDataItem()
            begin
                   "PRL-Payroll Periods".SetRange("PRL-Payroll Periods"."Date Opened",StringDate,EndDate);
                     YR:=Date2dmy(StringDate,3);
                     TotalTax:=0;
            end;
        }
        dataitem("Integer";"Integer")
        {
            DataItemTableView = sorting(Number) order(ascending);
            column(ReportForNavId_5444; 5444)
            {
            }
            column(A;A)
            {
                DecimalPlaces = 0:5;
            }
            column(B;B)
            {
                DecimalPlaces = 0:5;
            }
            column(C;C)
            {
                DecimalPlaces = 0:5;
            }
            column(D;D)
            {
                DecimalPlaces = 0:5;
            }
            column(E;E)
            {
                DecimalPlaces = 0:5;
            }
            column(F;F)
            {
                DecimalPlaces = 0:5;
            }
            column(A_B_C_D_E_F;A+B+C+D+E+F)
            {
                DecimalPlaces = 0:5;
            }
            column(AF_BF_CF_DF_EF_FF;AF+BF+CF+DF+EF+FF)
            {
                DecimalPlaces = 0:5;
            }
            column(FF;FF)
            {
                DecimalPlaces = 0:5;
            }
            column(BF;BF)
            {
                DecimalPlaces = 0:5;
            }
            column(CF;CF)
            {
                DecimalPlaces = 0:5;
            }
            column(DF;DF)
            {
                DecimalPlaces = 0:5;
            }
            column(EF;EF)
            {
                DecimalPlaces = 0:5;
            }
            column(AF;AF)
            {
                DecimalPlaces = 0:5;
            }
            column(A_B_C_D_E_F_AF_BF_CF_DF_EF_FF;A+B+C+D+E+F+AF+BF+CF+DF+EF+FF)
            {
                DecimalPlaces = 0:5;
            }
            column(FF_F;FF+F)
            {
                DecimalPlaces = 0:5;
            }
            column(EF_E;EF+E)
            {
                DecimalPlaces = 0:5;
            }
            column(DF_D;DF+D)
            {
                DecimalPlaces = 0:5;
            }
            column(CF_C;CF+C)
            {
                DecimalPlaces = 0:5;
            }
            column(BF_B;BF+B)
            {
                DecimalPlaces = 0:5;
            }
            column(AF_A;AF+A)
            {
                DecimalPlaces = 0:5;
            }
            column(THE_CENTRAL_BUREAU_OF_STATISTICSCaption;THE_CENTRAL_BUREAU_OF_STATISTICSCaptionLbl)
            {
            }
            column(Please_provide_the_statistical_information_indicated_below_detailing_the_Caption;Please_provide_the_statistical_information_indicated_below_detailing_the_CaptionLbl)
            {
            }
            column(number_of_employees_by_Gender_within_each_Income_Bracket_Caption;number_of_employees_by_Gender_within_each_Income_Bracket_CaptionLbl)
            {
            }
            column(The_numbers_should_include_both_employees_who_are_liable_toCaption;The_numbers_should_include_both_employees_who_are_liable_toCaptionLbl)
            {
            }
            column(Income_Tax_and_those_who_are_not_liable_to_Income_TaxCaption;Income_Tax_and_those_who_are_not_liable_to_Income_TaxCaptionLbl)
            {
            }
            column(NUMBER_OF_EMPLOYEES_IN_EACH_INCOME_BRACKETCaption;NUMBER_OF_EMPLOYEES_IN_EACH_INCOME_BRACKETCaptionLbl)
            {
            }
            column(INCOME_BRACKETCaption;INCOME_BRACKETCaptionLbl)
            {
            }
            column(UNDERCaption;UNDERCaptionLbl)
            {
            }
            column(V115_220Caption;V115_220CaptionLbl)
            {
            }
            column(V224_640Caption;V224_640CaptionLbl)
            {
            }
            column(V334_080Caption;V334_080CaptionLbl)
            {
            }
            column(V443_520Caption;V443_520CaptionLbl)
            {
            }
            column(V552_960Caption;V552_960CaptionLbl)
            {
            }
            column(TOCaption;TOCaptionLbl)
            {
            }
            column(TOCaption_Control1102756079;TOCaption_Control1102756079Lbl)
            {
            }
            column(TOCaption_Control1102756080;TOCaption_Control1102756080Lbl)
            {
            }
            column(TOCaption_Control1102756081;TOCaption_Control1102756081Lbl)
            {
            }
            column(ANDCaption;ANDCaptionLbl)
            {
            }
            column(TOTALCaption;TOTALCaptionLbl)
            {
            }
            column(KSHS__PER_ANNUM_Caption;KSHS__PER_ANNUM_CaptionLbl)
            {
            }
            column(V115_220Caption_Control1102756086;V115_220Caption_Control1102756086Lbl)
            {
            }
            column(V224_640Caption_Control1102756087;V224_640Caption_Control1102756087Lbl)
            {
            }
            column(V334_080Caption_Control1102756088;V334_080Caption_Control1102756088Lbl)
            {
            }
            column(V443_520Caption_Control1102756089;V443_520Caption_Control1102756089Lbl)
            {
            }
            column(V552_960Caption_Control1102756090;V552_960Caption_Control1102756090Lbl)
            {
            }
            column(ABOVECaption;ABOVECaptionLbl)
            {
            }
            column(MALE_EMPLOYEESCaption;MALE_EMPLOYEESCaptionLbl)
            {
            }
            column(FEMALE_EMPLOYEESCaption;FEMALE_EMPLOYEESCaptionLbl)
            {
            }
            column(TOTALCaption_Control1102756132;TOTALCaption_Control1102756132Lbl)
            {
            }
            column(SIGNED_EMPLOYER______________________________________________________________________Caption;SIGNED_EMPLOYER______________________________________________________________________CaptionLbl)
            {
            }
            column(DATE_________________________________________________________________________Caption;DATE_________________________________________________________________________CaptionLbl)
            {
            }
            column(OFFICIAL_USECaption;OFFICIAL_USECaptionLbl)
            {
            }
            column(DataItem1102756144;INCOME_TAX_REFERENCE_________________________________________________________________________________________________________Lbl)
            {
            }
            column(DataItem1102756145;ECONOMIC_SECTOR______________________________________________________________________________________________________________Lbl)
            {
            }
            column(DataItem1102756146;STATISTICAL_CODING___________________________________________________________________________________________________________Lbl)
            {
            }
            column(P_10Caption_Control1102756147;P_10Caption_Control1102756147Lbl)
            {
            }
            column(Integer_Number;Number)
            {
            }

            trigger OnAfterGetRecord()
            begin
                    NoRun:=NoRun+1;
                       if NoRun>1 then
                         CurrReport.Break;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(strtDate;StringDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Start Date';
                    TableRelation = "PRL-Payroll Periods"."Date Opened";
                }
                field(endDate;EndDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'End Date';
                    TableRelation = "PRL-Payroll Periods"."Date Opened";
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
             NoRun:=0;
            if StringDate=0D then
              Error('Enter the Start Date');
            if EndDate=0D then
              Error('Enter the End Date');

            CompanySetup.Get;
            EmployeeLedger.Reset;
            EmployeeLedger.SetRange(EmployeeLedger."Payroll Period",EndDate);
            EmployeeLedger.SetRange(EmployeeLedger."Transaction Code",'BPAY');
            EmployeeLedger.SetRange(EmployeeLedger.Amount,10,115119);
            if EmployeeLedger.Find('-') then begin
              repeat
              Employees.Reset;
              Employees.SetRange(Employees."No.",EmployeeLedger."Employee Code");
              if Employees.Find('-') then begin
               if Employees.Gender=Employees.Gender::Male then
                A:=A+1
              else
                   AF:=AF+1;
               end;
              until EmployeeLedger.Next=0;
             end;
             //
            EmployeeLedger.Reset;
            EmployeeLedger.SetRange(EmployeeLedger."Payroll Period",EndDate);
            EmployeeLedger.SetRange(EmployeeLedger."Transaction Code",'BPAY');
            EmployeeLedger.SetRange(EmployeeLedger.Amount,115220,224639);

            if EmployeeLedger.Find('-') then begin
              repeat
              Employees.Reset;
              Employees.SetRange(Employees."No.",EmployeeLedger."Employee Code");
              if Employees.Find('-') then begin
              if Employees.Gender=Employees.Gender::Male then
                B:=B+1
              else
                   BF:=BF+1;
               end;
              until EmployeeLedger.Next=0;
             end;
             //
            EmployeeLedger.Reset;
            EmployeeLedger.SetRange(EmployeeLedger."Payroll Period",EndDate);
            EmployeeLedger.SetRange(EmployeeLedger."Transaction Code",'BPAY');
            EmployeeLedger.SetRange(EmployeeLedger.Amount,224640,334079);
            if EmployeeLedger.Find('-') then begin
              repeat
              Employees.Reset;
              Employees.SetRange(Employees."No.",EmployeeLedger."Employee Code");
              if Employees.Find('-') then begin
              if Employees.Gender=Employees.Gender::Male then
                C:=C+1
              else
                   CF:=CF+1;
               end;
              until EmployeeLedger.Next=0;
             end;
             //
            EmployeeLedger.Reset;
            EmployeeLedger.SetRange(EmployeeLedger."Payroll Period",EndDate);
            EmployeeLedger.SetRange(EmployeeLedger."Transaction Code",'BPAY');
            EmployeeLedger.SetRange(EmployeeLedger.Amount,334080,443519);

            if EmployeeLedger.Find('-') then begin
              repeat
              Employees.Reset;
              Employees.SetRange(Employees."No.",EmployeeLedger."Employee Code");
              if Employees.Find('-') then begin
              if Employees.Gender=Employees.Gender::Male then
                D:=D+1
              else
                   DF:=DF+1;
               end;
              until EmployeeLedger.Next=0;
             end;
              //
            EmployeeLedger.Reset;
            EmployeeLedger.SetRange(EmployeeLedger."Payroll Period",EndDate);
            EmployeeLedger.SetRange(EmployeeLedger."Transaction Code",'BPAY');
            EmployeeLedger.SetRange(EmployeeLedger.Amount,443520,552959);

            if EmployeeLedger.Find('-') then begin
              repeat
              Employees.Reset;
              Employees.SetRange(Employees."No.",EmployeeLedger."Employee Code");
              if Employees.Find('-') then begin
              if Employees.Gender=Employees.Gender::Male then
                E:=E+1
              else
                   EF:=EF+1;
               end;
              until EmployeeLedger.Next=0;
             end;
             //
            EmployeeLedger.Reset;
            EmployeeLedger.SetRange(EmployeeLedger."Payroll Period",EndDate);
            EmployeeLedger.SetRange(EmployeeLedger."Transaction Code",'BPAY');
            EmployeeLedger.SetRange(EmployeeLedger.Amount,552960,9999999);

            if EmployeeLedger.Find('-') then begin
              repeat
              Employees.Reset;
              Employees.SetRange(Employees."No.",EmployeeLedger."Employee Code");
              if Employees.Find('-') then begin
              if Employees.Gender=Employees.Gender::Male then
                F:=F+1
              else
                   FF:=FF+1;
               end;
              until EmployeeLedger.Next=0;
             end;
    end;

    var
        StringDate: Date;
        EndDate: Date;
        TotalTax: Decimal;
        NoRun: Integer;
        CompanySetup: Record UnknownRecord61119;
        YR: Integer;
        A: Decimal;
        B: Decimal;
        C: Decimal;
        D: Decimal;
        E: Decimal;
        F: Decimal;
        tOTALS: Decimal;
        AF: Decimal;
        BF: Decimal;
        CF: Decimal;
        DF: Decimal;
        EF: Decimal;
        FF: Decimal;
        tOTALSF: Decimal;
        Employees: Record UnknownRecord61118;
        EmployeeLedger: Record UnknownRecord61092;
        DOMESTIC_TAXES_DEPARTMENTCaptionLbl: label 'DOMESTIC TAXES DEPARTMENT';
        P_10CaptionLbl: label 'P.10';
        EMPLOYER_S_PINCaptionLbl: label 'EMPLOYER''S PIN';
        APPENDIX_5CaptionLbl: label 'APPENDIX 5';
        P_A_Y_E___EMPLOYER_S_CERTIFICATECaptionLbl: label 'P.A.Y.E - EMPLOYER''S CERTIFICATE';
        YEARCaptionLbl: label 'YEAR';
        To_Senior_Assistant_CommissionerCaptionLbl: label 'To Senior Assistant Commissioner';
        EmptyStringCaptionLbl: label '......................................................................';
        We_I_forward_herewith_____________________Tax_Deduction_Cards__P9A_P9B__showing_the_total_tax_deducted__as_listed_on_P10A__amLbl: label 'We/I forward herewith.....................Tax Deduction Cards (P9A/P9B) showing the total tax deducted (as listed on P10A) amounting to  Kshs.......................';
        This_total_tax_has_been_paid_as_follows__CaptionLbl: label 'This total tax has been paid as follows:-';
        MONTHCaptionLbl: label 'MONTH';
        PAYE_CaptionLbl: label 'PAYE ';
        AUDIT_TAXCaptionLbl: label 'AUDIT TAX';
        FRINGECaptionLbl: label 'FRINGE';
        DATE_PAID__PERCaptionLbl: label 'DATE PAID (PER';
        TAXCaptionLbl: label 'TAX';
        INTEREST_PENALTYCaptionLbl: label 'INTEREST/PENALTY';
        BENEFITCaptionLbl: label 'BENEFIT';
        RECEIVING_BANKCaptionLbl: label 'RECEIVING BANK';
        TAXCaption_Control1102756027Lbl: label 'TAX';
        STAMP_CaptionLbl: label 'STAMP)';
        KSHS__CaptionLbl: label '(KSHS.)';
        KSHS__Caption_Control1102756030Lbl: label '(KSHS.)';
        KSHS__Caption_Control1102756031Lbl: label '(KSHS.)';
        TOTAL_TAXCaptionLbl: label 'TOTAL TAX';
        DATE_________________________________________________________________________________________________________________________Lbl: label 'DATE......................................................................................................................................................';
        SIGNATURE____________________________________________________________________________________________________________________Lbl: label 'SIGNATURE.......................................................................................................................................';
        ADDRESS______________________________________________________________________________________________________________________Lbl: label 'ADDRESS..............................................................................................................................................';
        NAME_OF_EMPLOYER_____________________________________________________________________________________________________________Lbl: label 'NAME OF EMPLOYER....................................................................................................................';
        We_I_certify_that_the_particulars_entered_above_are_correctCaptionLbl: label 'We/I certify that the particulars entered above are correct';
        V5_____Provide_Statistical_information_required_by_Central_Bureau_of_Statistics_CaptionLbl: label '(5)    Provide Statistical information required by Central Bureau of Statistics.';
        Income_Tax_OfficeCaptionLbl: label 'Income Tax Office';
        not_later_than_28th_FEBRUARYCaptionLbl: label 'not later than 28th FEBRUARY';
        V4_____Complete_this_certificate_in_triplicate_and_send_the_top_two_copies_with_the_enclosures_to_yourCaptionLbl: label '(4)    Complete this certificate in triplicate and send the top two copies with the enclosures to your';
        V1_____Attach_Photostat_copies_ofCaptionLbl: label '(1)    Attach Photostat copies of';
        ALL_the_Pay_In_Credit_Slips__P11s_CaptionLbl: label 'ALL the Pay-In Credit Slips (P11s)';
        for_the_yearCaptionLbl: label 'for the year';
        NOTE__CaptionLbl: label 'NOTE:-';
        THE_CENTRAL_BUREAU_OF_STATISTICSCaptionLbl: label 'THE CENTRAL BUREAU OF STATISTICS';
        Please_provide_the_statistical_information_indicated_below_detailing_the_CaptionLbl: label 'Please provide the statistical information indicated below detailing the ';
        number_of_employees_by_Gender_within_each_Income_Bracket_CaptionLbl: label 'number of employees by Gender within each Income Bracket.';
        The_numbers_should_include_both_employees_who_are_liable_toCaptionLbl: label 'The numbers should include both employees who are liable to';
        Income_Tax_and_those_who_are_not_liable_to_Income_TaxCaptionLbl: label 'Income Tax and those who are not liable to Income Tax';
        NUMBER_OF_EMPLOYEES_IN_EACH_INCOME_BRACKETCaptionLbl: label 'NUMBER OF EMPLOYEES IN EACH INCOME BRACKET';
        INCOME_BRACKETCaptionLbl: label 'INCOME BRACKET';
        UNDERCaptionLbl: label 'UNDER';
        V115_220CaptionLbl: label '115,220';
        V224_640CaptionLbl: label '224,640';
        V334_080CaptionLbl: label '334,080';
        V443_520CaptionLbl: label '443,520';
        V552_960CaptionLbl: label '552,960';
        TOCaptionLbl: label 'TO';
        TOCaption_Control1102756079Lbl: label 'TO';
        TOCaption_Control1102756080Lbl: label 'TO';
        TOCaption_Control1102756081Lbl: label 'TO';
        ANDCaptionLbl: label 'AND';
        TOTALCaptionLbl: label 'TOTAL';
        KSHS__PER_ANNUM_CaptionLbl: label '(KSHS. PER ANNUM)';
        V115_220Caption_Control1102756086Lbl: label '115,220';
        V224_640Caption_Control1102756087Lbl: label '224,640';
        V334_080Caption_Control1102756088Lbl: label '334,080';
        V443_520Caption_Control1102756089Lbl: label '443,520';
        V552_960Caption_Control1102756090Lbl: label '552,960';
        ABOVECaptionLbl: label 'ABOVE';
        MALE_EMPLOYEESCaptionLbl: label 'MALE EMPLOYEES';
        FEMALE_EMPLOYEESCaptionLbl: label 'FEMALE EMPLOYEES';
        TOTALCaption_Control1102756132Lbl: label 'TOTAL';
        SIGNED_EMPLOYER______________________________________________________________________CaptionLbl: label 'SIGNED EMPLOYER......................................................................';
        DATE_________________________________________________________________________CaptionLbl: label 'DATE.........................................................................';
        OFFICIAL_USECaptionLbl: label 'OFFICIAL USE';
        INCOME_TAX_REFERENCE_________________________________________________________________________________________________________Lbl: label 'INCOME TAX REFERENCE...........................................................................................................';
        ECONOMIC_SECTOR______________________________________________________________________________________________________________Lbl: label 'ECONOMIC SECTOR.........................................................................................................................';
        STATISTICAL_CODING___________________________________________________________________________________________________________Lbl: label 'STATISTICAL CODING.................................................................................................................';
        P_10Caption_Control1102756147Lbl: label 'P.10';
}

