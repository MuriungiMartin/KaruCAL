#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51712 "Update Student Units Reg ID"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61549;UnknownTable61549)
        {
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
            column(Student_Units__Reg__Transacton_ID_;"Reg. Transacton ID")
            {
            }
            column(Student_Units__Student_No__;"Student No.")
            {
            }
            column(Student_Units_Semester;Semester)
            {
            }
            column(Student_Units_Programme;Programme)
            {
            }
            column(Student_Units__Register_for_;"Register for")
            {
            }
            column(Student_Units_Stage;Stage)
            {
            }
            column(Student_Units_Unit;Unit)
            {
            }
            column(Student_UnitsCaption;Student_UnitsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Student_Units__Reg__Transacton_ID_Caption;FieldCaption("Reg. Transacton ID"))
            {
            }
            column(Student_Units__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(Student_Units_SemesterCaption;FieldCaption(Semester))
            {
            }
            column(Student_Units_ProgrammeCaption;FieldCaption(Programme))
            {
            }
            column(Student_Units__Register_for_Caption;FieldCaption("Register for"))
            {
            }
            column(Student_Units_StageCaption;FieldCaption(Stage))
            {
            }
            column(Student_Units_UnitCaption;FieldCaption(Unit))
            {
            }
            column(Student_Units_ENo;ENo)
            {
            }

            trigger OnAfterGetRecord()
            begin
                /*CourseReg.RESET;
                CourseReg.SETRANGE(CourseReg."Student No.","Student Units"."Student No.");
                CourseReg.SETRANGE(CourseReg.Stage,"Student Units".Stage);
                IF CourseReg.FIND('-') THEN BEGIN
                IF "Student Units"."Reg. Transacton ID" <> CourseReg."Reg. Transacton ID" THEN BEGIN
                "Student Units"."Reg. Transacton ID":=CourseReg."Reg. Transacton ID";
                "Student Units".MODIFY;
                END;
                END;*/
                /*
                "ACA-Student Units".LOCKTABLE;
                
                
                IF "ACA-Student Units".Programme<>'EDUMGT' THEN
                BEGIN
                "ACA-Student Units".Programme:='EDUMGT';
                "ACA-Student Units".MODIFY;
                END;*/
                //"ACA-Student Units".SETRANGE("ACA-Student Units".Programme,'p100');
                //"ACA-Student Units".SETRANGE("ACA-Student Units".Semester,'SEM1 18/19');
                //IF "ACA-Student Units".FINDFIRST THEN
                "ACA-Student Units".Delete;

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
        CourseReg: Record UnknownRecord61532;
        Student_UnitsCaptionLbl: label 'Student Units';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

