#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51585 "Update Scores"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Update Scores.rdlc';

    dataset
    {
        dataitem(UnknownTable61549;UnknownTable61549)
        {
            DataItemTableView = sorting(Programme,Stage,Unit,Semester,"Reg. Transacton ID","Student No.");
            RequestFilterFields = Programme;
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
            column(Student_Units_Programme;Programme)
            {
            }
            column(Student_Units_Stage;Stage)
            {
            }
            column(Student_Units_Unit;Unit)
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
            column(Student_Units__Reg__Transacton_ID_Caption;FieldCaption("Reg. Transacton ID"))
            {
            }
            column(Student_Units__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(Student_Units_ProgrammeCaption;FieldCaption(Programme))
            {
            }
            column(Student_Units_StageCaption;FieldCaption(Stage))
            {
            }
            column(Student_Units_UnitCaption;FieldCaption(Unit))
            {
            }
            column(Student_Units__Total_Score_Caption;FieldCaption("Total Score"))
            {
            }
            column(Student_Units_Semester;Semester)
            {
            }
            column(Student_Units_ENo;ENo)
            {
            }

            trigger OnAfterGetRecord()
            begin
                "ACA-Student Units"."Final Score":="ACA-Student Units"."Total Score";
                if UnitsR.Get("ACA-Student Units".Programme,"ACA-Student Units".Stage,"ACA-Student Units".Unit) then //BEGIN
                "ACA-Student Units"."No. Of Units":=UnitsR."No. Units";
                //"Student Units"."Unit Type":=UnitsR."Unit Type";
                "ACA-Student Units".Modify;
                //END;
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
        UnitsR: Record UnknownRecord61517;
        Student_UnitsCaptionLbl: label 'Student Units';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

