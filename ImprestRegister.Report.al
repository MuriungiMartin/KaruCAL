#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51225 "Imprest Register"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Imprest Register.rdlc';

    dataset
    {
        dataitem(UnknownTable61126;UnknownTable61126)
        {
            DataItemTableView = sorting(No,"Account No:");
            RequestFilterFields = No,"Imprest Holder",Purpose,Remarks,"Type of Surrender","Department Filter";
            column(ReportForNavId_3307; 3307)
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
            column(USERID;UserId)
            {
            }
            column(Imprest_Details__Imprest_Holder_;"Imprest Holder")
            {
            }
            column(Imprest_Details_No;No)
            {
            }
            column(Imprest_Details_Amount;Amount)
            {
            }
            column(Reason;Reason)
            {
            }
            column(Imprest_Details__Due_Date_;"Due Date")
            {
            }
            column(Imprest_Details__Surrender_Date_;"Surrender Date")
            {
            }
            column(Imprest_Details__Actual_Spent_;"Actual Spent")
            {
            }
            column(Imprest_Details_Remarks;Remarks)
            {
            }
            column(Imprest_Details_Balance;Balance)
            {
            }
            column(DeptName;DeptName)
            {
            }
            column(Imprest_Details__Surrender_Type_No_;"Surrender Type No")
            {
            }
            column(Imprest_Details__Type_of_Surrender_;"Type of Surrender")
            {
            }
            column(Imprest_Details_Amount_Control1000000047;Amount)
            {
            }
            column(Imprest_Details__Actual_Spent__Control1000000049;"Actual Spent")
            {
            }
            column(Imprest_Details_Balance_Control1000000051;Balance)
            {
            }
            column(Imprest_DetailsCaption;Imprest_DetailsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(IMPREST_REGISTERCaption;IMPREST_REGISTERCaptionLbl)
            {
            }
            column(Imprest_Details__Imprest_Holder_Caption;FieldCaption("Imprest Holder"))
            {
            }
            column(Imprest_Details_NoCaption;FieldCaption(No))
            {
            }
            column(Imprest_Details_AmountCaption;FieldCaption(Amount))
            {
            }
            column(PurposeCaption;PurposeCaptionLbl)
            {
            }
            column(Imprest_Details__Due_Date_Caption;FieldCaption("Due Date"))
            {
            }
            column(Imprest_Details__Surrender_Date_Caption;FieldCaption("Surrender Date"))
            {
            }
            column(Imprest_Details__Actual_Spent_Caption;FieldCaption("Actual Spent"))
            {
            }
            column(Imprest_Details_RemarksCaption;FieldCaption(Remarks))
            {
            }
            column(Imprest_Details_BalanceCaption;FieldCaption(Balance))
            {
            }
            column(DepartmentCaption;DepartmentCaptionLbl)
            {
            }
            column(Imprest_Details__Surrender_Type_No_Caption;FieldCaption("Surrender Type No"))
            {
            }
            column(Imprest_Details__Type_of_Surrender_Caption;FieldCaption("Type of Surrender"))
            {
            }
            column(Imprest_Details_Amount_Control1000000047Caption;FieldCaption(Amount))
            {
            }
            column(Imprest_Details__Actual_Spent__Control1000000049Caption;FieldCaption("Actual Spent"))
            {
            }
            column(Imprest_Details_Balance_Control1000000051Caption;FieldCaption(Balance))
            {
            }
            column(Imprest_Details_Account_No_;"Account No:")
            {
            }
            column(Imprest_Details_Line_No;"Line No")
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo(No);
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        Dept: Code[30];
        Purpose: Code[30];
        PayRec: Record UnknownRecord61134;
        DeptName: Text[50];
        Dimensions: Record "Dimension Value";
        GL: Record "G/L Account";
        Reason: Text[100];
        Imprest_DetailsCaptionLbl: label 'Imprest Details';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        IMPREST_REGISTERCaptionLbl: label 'IMPREST REGISTER';
        PurposeCaptionLbl: label 'Purpose';
        DepartmentCaptionLbl: label 'Department';
}

