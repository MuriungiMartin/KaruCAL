#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51215 "Imprest Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Imprest Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61134;UnknownTable61134)
        {
            column(ReportForNavId_3752; 3752)
            {
            }
            column(Payments_No;No)
            {
            }
            column(Payments__Account_Name_;"Account Name")
            {
            }
            column(Payments__Account_No__;"Account No.")
            {
            }
            column(Payments_Date;Date)
            {
            }
            column(Payments_Department;Department)
            {
            }
            column(Payments_Department_Control1000000014;Department)
            {
            }
            column(Payments_Amount;Amount)
            {
            }
            column(Word_Text_1_;Word_Text[1])
            {
            }
            column(Payments_Department_Control1000000038;Department)
            {
            }
            column(Payments__Total_Allocation_;"Total Allocation")
            {
            }
            column(Budget_Bal;Budget_Bal)
            {
            }
            column(Payments_Balance;Balance)
            {
            }
            column(Payments__Balance_Less_this_Entry_;"Balance Less this Entry")
            {
            }
            column(Payments__Posted_By_;"Posted By")
            {
            }
            column(Payments__Date_Posted_;"Date Posted")
            {
            }
            column(Payments__Cheque_No_;"Cheque No")
            {
            }
            column(Payments__Payment_Date_;"Payment Date")
            {
            }
            column(Payments_Posted;Posted)
            {
            }
            column(KARATINA_UNIVERSITYCaption;KARATINA_UNIVERSITYCaptionLbl)
            {
            }
            column(IMPREST_WARRANTCaption;IMPREST_WARRANTCaptionLbl)
            {
            }
            column(Sr__No_Caption;Sr__No_CaptionLbl)
            {
            }
            column(Name_of_Imprest_holderCaption;Name_of_Imprest_holderCaptionLbl)
            {
            }
            column(PF_No_Caption;PF_No_CaptionLbl)
            {
            }
            column(Payments_DateCaption;FieldCaption(Date))
            {
            }
            column(DepartmentCaption;DepartmentCaptionLbl)
            {
            }
            column(FINANCE_DEPARTMENTCaption;FINANCE_DEPARTMENTCaptionLbl)
            {
            }
            column(Please_advance_KshsCaption;Please_advance_KshsCaptionLbl)
            {
            }
            column(In_WordsCaption;In_WordsCaptionLbl)
            {
            }
            column(For_Items_Mentioned_BelowCaption;For_Items_Mentioned_BelowCaptionLbl)
            {
            }
            column(Department_CodeCaption;Department_CodeCaptionLbl)
            {
            }
            column(NOTE__Caption;NOTE__CaptionLbl)
            {
            }
            column(all_imprest_must_be_accounted_within_48_hours_after_the_expenditureCaption;all_imprest_must_be_accounted_within_48_hours_after_the_expenditureCaptionLbl)
            {
            }
            column(DataItem1000000035;Signature____________________________________________________________________________________________________________________Lbl)
            {
            }
            column(DataItem1000000036;Authorization________________________________________________________________________________________________________________Lbl)
            {
            }
            column(Vote_Book_ControlCaption;Vote_Book_ControlCaptionLbl)
            {
            }
            column(Payments__Total_Allocation_Caption;FieldCaption("Total Allocation"))
            {
            }
            column(Less_Expenditure_plus_CommitmentsCaption;Less_Expenditure_plus_CommitmentsCaptionLbl)
            {
            }
            column(Payments_BalanceCaption;FieldCaption(Balance))
            {
            }
            column(Payments__Balance_Less_this_Entry_Caption;FieldCaption("Balance Less this Entry"))
            {
            }
            column(Kshs_Caption;Kshs_CaptionLbl)
            {
            }
            column(Kshs_Caption_Control1000000050;Kshs_Caption_Control1000000050Lbl)
            {
            }
            column(Kshs_Caption_Control1000000051;Kshs_Caption_Control1000000051Lbl)
            {
            }
            column(Kshs_Caption_Control1000000052;Kshs_Caption_Control1000000052Lbl)
            {
            }
            column(Authorization___I_CERTIFYCaption;Authorization___I_CERTIFYCaptionLbl)
            {
            }
            column(that_the_above_expenditure_will_be_incured_for_University_purposeCaption;that_the_above_expenditure_will_be_incured_for_University_purposeCaptionLbl)
            {
            }
            column(DataItem1000000055;Signature_________________________________________________________________________________________________________________000Lbl)
            {
            }
            column(DataItem1000000056;Date_________________________________________________________________________________________________________________________Lbl)
            {
            }
            column(Approved_ByCaption;Approved_ByCaptionLbl)
            {
            }
            column(Date_Caption;Date_CaptionLbl)
            {
            }
            column(DataItem1000000061;Passed_For_Payment___________________________________________________________________________________________________________Lbl)
            {
            }
            column(DataItem1000000062;Date______________________________________________________________________________________________________________________000Lbl)
            {
            }
            column(Finance_Officer___Chief_AccountantCaption;Finance_Officer___Chief_AccountantCaptionLbl)
            {
            }
            column(DataItem1000000064;Internal_Audit__Name_________________________________________________________________________________________________________Lbl)
            {
            }
            column(DataItem1000000065;Date______________________________________________________________________________________________________________________001Lbl)
            {
            }
            column(DataItem1000000066;Signature_________________________________________________________________________________________________________________001Lbl)
            {
            }
            column(CHEQUE_NOCaption;CHEQUE_NOCaptionLbl)
            {
            }
            column(DATECaption;DATECaptionLbl)
            {
            }
            column(POSTEDCaption;POSTEDCaptionLbl)
            {
            }
            column(CASH_BOOKCaption;CASH_BOOKCaptionLbl)
            {
            }
            column(PAYMENT_AND_CASHBOOK_SECTIONS_Caption;PAYMENT_AND_CASHBOOK_SECTIONS_CaptionLbl)
            {
            }
            column(Department_CodeCaption_Control1000000015;Department_CodeCaption_Control1000000015Lbl)
            {
            }
            dataitem(UnknownTable61126;UnknownTable61126)
            {
                DataItemLink = No=field(No);
                column(ReportForNavId_3307; 3307)
                {
                }
                column(Imprest_Details__Imprest_Details___Account_Name_;"FIN-Imprest Details"."Account Name")
                {
                }
                column(Imprest_Details__Imprest_Details___Account_No__;"FIN-Imprest Details"."Account No:")
                {
                }
                column(Imprest_Details__Imprest_Details__Amount;"FIN-Imprest Details".Amount)
                {
                }
                column(ItemCaption;ItemCaptionLbl)
                {
                }
                column(ACCOUNT_CODECaption;ACCOUNT_CODECaptionLbl)
                {
                }
                column(AMOUNT_Kshs_Caption;AMOUNT_Kshs_CaptionLbl)
                {
                }
                column(Imprest_Details_No;No)
                {
                }
                column(Imprest_Details_Line_No;"Line No")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                     Dim_Value.SetRange(Dim_Value.Code,"FIN-Payments".Department);
                     if Dim_Value.Find('-') then
                     begin
                       Department:=Dim_Value.Name;
                     end;
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

    var
        Department: Code[50];
        Dim_Value: Record "Dimension Value";
        Word_Text: array [2] of Text[30];
        CheckReport: Report Check;
        Budget_Bal: Decimal;
        KARATINA_UNIVERSITYCaptionLbl: label 'KARATINA UNIVERSITY';
        IMPREST_WARRANTCaptionLbl: label 'IMPREST WARRANT';
        Sr__No_CaptionLbl: label 'Sr. No.';
        Name_of_Imprest_holderCaptionLbl: label 'Name of Imprest holder';
        PF_No_CaptionLbl: label 'PF No.';
        DepartmentCaptionLbl: label 'Department';
        FINANCE_DEPARTMENTCaptionLbl: label 'FINANCE DEPARTMENT';
        Please_advance_KshsCaptionLbl: label 'Please advance Kshs';
        In_WordsCaptionLbl: label 'In Words';
        For_Items_Mentioned_BelowCaptionLbl: label 'For Items Mentioned Below';
        Department_CodeCaptionLbl: label 'Department Code';
        NOTE__CaptionLbl: label 'NOTE :';
        all_imprest_must_be_accounted_within_48_hours_after_the_expenditureCaptionLbl: label 'all imprest must be accounted within 48 hours after the expenditure';
        Signature____________________________________________________________________________________________________________________Lbl: label 'Signature..............................................................................................................................';
        Authorization________________________________________________________________________________________________________________Lbl: label 'Authorization.............................................................................................................................';
        Vote_Book_ControlCaptionLbl: label 'Vote Book Control';
        Less_Expenditure_plus_CommitmentsCaptionLbl: label 'Less Expenditure plus Commitments';
        Kshs_CaptionLbl: label 'Kshs.';
        Kshs_Caption_Control1000000050Lbl: label 'Kshs.';
        Kshs_Caption_Control1000000051Lbl: label 'Kshs.';
        Kshs_Caption_Control1000000052Lbl: label 'Kshs.';
        Authorization___I_CERTIFYCaptionLbl: label 'Authorization : I CERTIFY';
        that_the_above_expenditure_will_be_incured_for_University_purposeCaptionLbl: label 'that the above expenditure will be incured for University purpose';
        Signature_________________________________________________________________________________________________________________000Lbl: label 'Signature..............................................................................................................................';
        Date_________________________________________________________________________________________________________________________Lbl: label 'Date..............................................................................................................................';
        Approved_ByCaptionLbl: label 'Approved By';
        Date_CaptionLbl: label 'Date ';
        Passed_For_Payment___________________________________________________________________________________________________________Lbl: label 'Passed For Payment..............................................................................................................................';
        Date______________________________________________________________________________________________________________________000Lbl: label 'Date..............................................................................................................................';
        Finance_Officer___Chief_AccountantCaptionLbl: label 'Finance Officer / Chief Accountant';
        Internal_Audit__Name_________________________________________________________________________________________________________Lbl: label 'Internal Audit (Name)..............................................................................................................................';
        Date______________________________________________________________________________________________________________________001Lbl: label 'Date..............................................................................................................................';
        Signature_________________________________________________________________________________________________________________001Lbl: label 'Signature..............................................................................................................................';
        CHEQUE_NOCaptionLbl: label 'CHEQUE NO';
        DATECaptionLbl: label 'DATE';
        POSTEDCaptionLbl: label 'POSTED';
        CASH_BOOKCaptionLbl: label 'CASH BOOK';
        PAYMENT_AND_CASHBOOK_SECTIONS_CaptionLbl: label 'PAYMENT AND CASHBOOK SECTIONS:';
        Department_CodeCaption_Control1000000015Lbl: label 'Department Code';
        ItemCaptionLbl: label 'Item';
        ACCOUNT_CODECaptionLbl: label 'ACCOUNT CODE';
        AMOUNT_Kshs_CaptionLbl: label 'AMOUNT Kshs.';
}

