#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51725 "Students Clearance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Students Clearance.rdlc';

    dataset
    {
        dataitem(UnknownTable61357;UnknownTable61357)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "Student No.";
            column(ReportForNavId_4392; 4392)
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
            column(Clearance_Header__No__;"No.")
            {
            }
            column(Clearance_Header_Date;Date)
            {
            }
            column(Clearance_Header__Student_No__;"Student No.")
            {
            }
            column(Clearance_Header__Date_Completed_;"Date Completed")
            {
            }
            column(Clearance_Header_Programme;Programme)
            {
            }
            column(Clearance_Header__Library_Clearance_ID_;"Library Clearance ID")
            {
            }
            column(Clearance_Header__Sports_Clearance_ID_;"Sports Clearance ID")
            {
            }
            column(Clearance_Header__Finance_Clearance_ID_;"Finance Clearance ID")
            {
            }
            column(Clearance_Header__Faculty_Clearance_ID_;"Registrar Clearance ID")
            {
            }
            column(Clearance_Header__Library_Cleared_;"Library Cleared")
            {
            }
            column(Clearance_Header__Sports_Cleared_;"Sports Cleared")
            {
            }
            column(Clearance_Header__Finance_Cleared_;"Finance Cleared")
            {
            }
            column(Clearance_Header__Faculty_Cleared_;"Registrar Cleared")
            {
            }
            column(Clearance_HeaderCaption;Clearance_HeaderCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Clearance_Header__No__Caption;FieldCaption("No."))
            {
            }
            column(Clearance_Header_DateCaption;FieldCaption(Date))
            {
            }
            column(Clearance_Header__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(Clearance_Header__Date_Completed_Caption;FieldCaption("Date Completed"))
            {
            }
            column(Clearance_Header_ProgrammeCaption;FieldCaption(Programme))
            {
            }
            column(Clearance_Header__Library_Clearance_ID_Caption;FieldCaption("Library Clearance ID"))
            {
            }
            column(Clearance_Header__Sports_Clearance_ID_Caption;FieldCaption("Sports Clearance ID"))
            {
            }
            column(Clearance_Header__Finance_Clearance_ID_Caption;FieldCaption("Finance Clearance ID"))
            {
            }
            column(Clearance_Header__Faculty_Clearance_ID_Caption;FieldCaption("Registrar Clearance ID"))
            {
            }
            column(Clearance_Header__Library_Cleared_Caption;FieldCaption("Library Cleared"))
            {
            }
            column(Clearance_Header__Sports_Cleared_Caption;FieldCaption("Sports Cleared"))
            {
            }
            column(Clearance_Header__Finance_Cleared_Caption;FieldCaption("Finance Cleared"))
            {
            }
            column(Clearance_Header__Faculty_Cleared_Caption;FieldCaption("Registrar Cleared"))
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
        Clearance_HeaderCaptionLbl: label 'Clearance Header';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

