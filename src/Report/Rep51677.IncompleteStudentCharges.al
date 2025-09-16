#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51677 "Incomplete Student Charges"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Incomplete Student Charges.rdlc';

    dataset
    {
        dataitem(UnknownTable61535;UnknownTable61535)
        {
            DataItemTableView = sorting("Transacton ID","Student No.") where(Amount=const(0));
            column(ReportForNavId_6235; 6235)
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
            column(Student_Charges__Student_No__;"Student No.")
            {
            }
            column(Student_Charges__Reg__Transacton_ID_;"Reg. Transacton ID")
            {
            }
            column(Student_Charges__Transaction_Type_;"Transaction Type")
            {
            }
            column(Student_Charges_Code;Code)
            {
            }
            column(Student_Charges_Description;Description)
            {
            }
            column(Student_Charges_Amount;Amount)
            {
            }
            column(Student_Charges_Date;Date)
            {
            }
            column(Student_ChargesCaption;Student_ChargesCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Student_Charges__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(Student_Charges__Reg__Transacton_ID_Caption;FieldCaption("Reg. Transacton ID"))
            {
            }
            column(Student_Charges__Transaction_Type_Caption;FieldCaption("Transaction Type"))
            {
            }
            column(Student_Charges_CodeCaption;FieldCaption(Code))
            {
            }
            column(Student_Charges_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Student_Charges_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Student_Charges_DateCaption;FieldCaption(Date))
            {
            }
            column(Student_Charges_Transacton_ID;"Transacton ID")
            {
            }
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
        Student_ChargesCaptionLbl: label 'Student Charges';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

