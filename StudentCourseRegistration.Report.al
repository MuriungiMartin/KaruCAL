#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51477 "Student Course Registration"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student Course Registration.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Customer Type","Semester Filter","Date Registered",Status;
            column(ReportForNavId_6836; 6836)
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
            column(Customer__No__;"No.")
            {
            }
            column(Customer_Name;Name)
            {
            }
            column(Students_Course_RegistrationCaption;Students_Course_RegistrationCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Customer__No__Caption;FieldCaption("No."))
            {
            }
            column(Customer_NameCaption;FieldCaption(Name))
            {
            }
            column(Course_Registration__Settlement_Type_Caption;"ACA-Course Registration".FieldCaption("Settlement Type"))
            {
            }
            column(Course_Registration_SemesterCaption;"ACA-Course Registration".FieldCaption(Semester))
            {
            }
            column(Course_Registration_UnitCaption;"ACA-Course Registration".FieldCaption(Unit))
            {
            }
            column(Course_Registration_StageCaption;"ACA-Course Registration".FieldCaption(Stage))
            {
            }
            column(Course_Registration__Register_for_Caption;"ACA-Course Registration".FieldCaption("Register for"))
            {
            }
            column(Course_Registration_ProgrammeCaption;"ACA-Course Registration".FieldCaption(Programme))
            {
            }
            column(Course_Registration__Registration_Date_Caption;"ACA-Course Registration".FieldCaption("Registration Date"))
            {
            }
            column(BalanceCaption;BalanceCaptionLbl)
            {
            }
            column(Total_PaidCaption;Total_PaidCaptionLbl)
            {
            }
            column(Total_BilledCaption;Total_BilledCaptionLbl)
            {
            }
            column(Customer_Semester_Filter;"Semester Filter")
            {
            }
            dataitem(UnknownTable61532;UnknownTable61532)
            {
                DataItemLink = "Student No."=field("No."),Semester=field("Semester Filter");
                DataItemTableView = where(Reversed=const(No));
                column(ReportForNavId_2901; 2901)
                {
                }
                column(Course_Registration_Semester;Semester)
                {
                }
                column(Course_Registration_Programme;Programme)
                {
                }
                column(Course_Registration__Register_for_;"Register for")
                {
                }
                column(Course_Registration_Stage;Stage)
                {
                }
                column(Course_Registration_Unit;Unit)
                {
                }
                column(Course_Registration__Settlement_Type_;"Settlement Type")
                {
                }
                column(Course_Registration__Registration_Date_;"Registration Date")
                {
                }
                column(Total_Billed___Total_Paid_;"Total Billed"-"Total Paid")
                {
                }
                column(Course_Registration__Total_Paid_;"Total Paid")
                {
                }
                column(Course_Registration__Total_Billed_;"Total Billed")
                {
                }
                column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
                {
                }
                column(Course_Registration_Student_No_;"Student No.")
                {
                }
                column(Course_Registration_Student_Type;"Student Type")
                {
                }
                column(Course_Registration_Entry_No_;"Entry No.")
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
        Students_Course_RegistrationCaptionLbl: label 'Students Course Registration';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        BalanceCaptionLbl: label 'Balance';
        Total_PaidCaptionLbl: label 'Total Paid';
        Total_BilledCaptionLbl: label 'Total Billed';
}

