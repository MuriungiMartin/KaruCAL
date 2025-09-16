#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51592 "Check Multiple Units"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Check Multiple Units.rdlc';

    dataset
    {
        dataitem(UnknownTable61549;UnknownTable61549)
        {
            RequestFilterFields = "System Created";
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
                StudentUnits.Reset;
                StudentUnits.SetRange(StudentUnits."Student No.","ACA-Student Units"."Student No.");
                StudentUnits.SetRange(StudentUnits.Unit,"ACA-Student Units".Unit);
                StudentUnits.SetRange(StudentUnits.Multiple,true);
                //IF StudentUnits.COUNT > 1 THEN BEGIN
                //StudentUnits.MODIFYALL(StudentUnits.Multiple,TRUE);
                if StudentUnits.Find('-') then begin

                repeat
                if StudentUnits."Entry No." <> "ACA-Student Units"."Entry No." then begin
                "ACA-Student Units".Delete;
                end;

                until StudentUnits.Next = 0;
                end;
            end;

            trigger OnPreDataItem()
            begin
                //StudentUnits.RESET;
                //StudentUnits.MODIFYALL(StudentUnits.Multiple,FALSE);
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
        StudentUnits: Record UnknownRecord61549;
        Student_UnitsCaptionLbl: label 'Student Units';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

