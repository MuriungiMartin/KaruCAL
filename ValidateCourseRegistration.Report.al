#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51693 "Validate Course Registration"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Validate Course Registration.rdlc';

    dataset
    {
        dataitem(CoReg;UnknownTable61532)
        {
            DataItemTableView = where("Year Of Study"=filter(0));
            RequestFilterFields = "Reg. Transacton ID",Semester;
            column(ReportForNavId_2901; 2901)
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
            column(Course_Registration__Reg__Transacton_ID_;"Reg. Transacton ID")
            {
            }
            column(Course_Registration__Student_No__;"Student No.")
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
            column(Course_RegistrationCaption;Course_RegistrationCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Course_Registration__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(Course_Registration_SemesterCaption;FieldCaption(Semester))
            {
            }
            column(Course_Registration_ProgrammeCaption;FieldCaption(Programme))
            {
            }
            column(Course_Registration__Register_for_Caption;FieldCaption("Register for"))
            {
            }
            column(Course_Registration__Reg__Transacton_ID_Caption;FieldCaption("Reg. Transacton ID"))
            {
            }
            column(Course_Registration_Stage;Stage)
            {
            }
            column(Course_Registration_Unit;Unit)
            {
            }
            column(Course_Registration_Student_Type;"Student Type")
            {
            }
            column(Course_Registration_Entry_No_;"Entry No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                CoReg.Validate(Stage);
                CoReg.Modify;
                // // // studUnits.RESET;
                // // // studUnits.SETRANGE(studUnits.Programme,"ACA-Course Registration".Programme);
                // // // studUnits.SETRANGE(studUnits.Stage,"ACA-Course Registration".Stage);
                // // // //studUnits.SETRANGE(studUnits."Reg. Transacton ID","ACA-Course Registration"."Reg. Transacton ID");
                // // // studUnits.SETRANGE(studUnits.Semester,"ACA-Course Registration".Semester);
                // // // studUnits.SETRANGE(studUnits."Student No.","ACA-Course Registration"."Student No.");
                // // // IF studUnits.FIND('-') THEN BEGIN
                // // // REPEAT
                // // // BEGIN
                // // //  studUnits."Academic Year":="ACA-Course Registration"."Academic Year";
                // // // studUnits.MODIFY;
                // // // END;
                // // // UNTIL studUnits.NEXT=0;
                // // // END;
            end;

            trigger OnPostDataItem()
            begin
                //MESSAGE('done');
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
        Course_RegistrationCaptionLbl: label 'Course Registration';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        studUnits: Record UnknownRecord61549;
}

