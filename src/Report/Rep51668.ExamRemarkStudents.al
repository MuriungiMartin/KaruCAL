#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51668 "Exam Remark Students"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Exam Remark Students.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            PrintOnlyIfDetail = true;
            column(ReportForNavId_6836; 6836)
            {
            }
            column(Customer_No_;"No.")
            {
            }
            dataitem(UnknownTable61572;UnknownTable61572)
            {
                DataItemLink = "Student No."=field("No.");
                DataItemTableView = sorting("Student No.",Programme,Stage,Semester,Unit,"Exam Code") where("Due for Refund"=const(Yes));
                RequestFilterFields = "Student No.";
                column(ReportForNavId_8466; 8466)
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
                column(Student_Exam_Registration_Exam__Student_No__;"Student No.")
                {
                }
                column(Student_Exam_Registration_Exam_Programme;Programme)
                {
                }
                column(Student_Exam_Registration_Exam_Stage;Stage)
                {
                }
                column(Student_Exam_Registration_Exam_Semester;Semester)
                {
                }
                column(Student_Exam_Registration_Exam_Unit;Unit)
                {
                }
                column(Student_Exam_Registration_Exam__Exam_Code_;"Exam Code")
                {
                }
                column(Student_Exam_Registration_Exam__Student_Type_;"Student Type")
                {
                }
                column(Student_Exam_Registration_Exam_ReceiptNo;ReceiptNo)
                {
                }
                column(KSPS_Exam_Remarking_Refunds_ReportCaption;KSPS_Exam_Remarking_Refunds_ReportCaptionLbl)
                {
                }
                column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
                {
                }
                column(Student_Exam_Registration_Exam__Student_No__Caption;FieldCaption("Student No."))
                {
                }
                column(Student_Exam_Registration_Exam_ProgrammeCaption;FieldCaption(Programme))
                {
                }
                column(Student_Exam_Registration_Exam_StageCaption;FieldCaption(Stage))
                {
                }
                column(Student_Exam_Registration_Exam_SemesterCaption;FieldCaption(Semester))
                {
                }
                column(Student_Exam_Registration_Exam_UnitCaption;FieldCaption(Unit))
                {
                }
                column(Student_Exam_Registration_Exam__Exam_Code_Caption;FieldCaption("Exam Code"))
                {
                }
                column(Student_Exam_Registration_Exam__Student_Type_Caption;FieldCaption("Student Type"))
                {
                }
                column(Student_Exam_Registration_Exam_ReceiptNoCaption;FieldCaption(ReceiptNo))
                {
                }
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
        KSPS_Exam_Remarking_Refunds_ReportCaptionLbl: label 'KSPS Exam Remarking Refunds Report';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

