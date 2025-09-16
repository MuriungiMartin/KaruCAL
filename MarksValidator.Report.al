#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51424 "Marks Validator"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Marks Validator.rdlc';

    dataset
    {
        dataitem(UnknownTable61549;UnknownTable61549)
        {
            DataItemTableView = sorting(Programme,Stage,Unit,Semester,"Reg. Transacton ID","Student No.");
            RequestFilterFields = "Total Score";
            column(ReportForNavId_2992; 2992)
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
            column(Student_Units__Student_No__;"Student No.")
            {
            }
            column(Student_Units__Total_Marks_;"Total Marks")
            {
            }
            column(Student_Units__Total_Score_;"Total Score")
            {
            }
            column(Student_UnitsCaption;Student_UnitsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Student_Units__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(Student_Units__Total_Marks_Caption;FieldCaption("Total Marks"))
            {
            }
            column(Student_Units__Total_Score_Caption;FieldCaption("Total Score"))
            {
            }
            column(Student_Units_Programme;Programme)
            {
            }
            column(Student_Units_Stage;Stage)
            {
            }
            column(Student_Units_Unit;Unit)
            {
            }
            column(Student_Units_Semester;Semester)
            {
            }
            column(Student_Units_Reg__Transacton_ID;"Reg. Transacton ID")
            {
            }
            column(Student_Units_ENo;ENo)
            {
            }

            trigger OnAfterGetRecord()
            begin
                // "Student Units".calcfields("Student Units"."Total Score");
                 "ACA-Student Units"."Total Marks":="ACA-Student Units"."Total Score";
                 "ACA-Student Units".Modify;
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
        Student_UnitsCaptionLbl: label 'Student Units';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

