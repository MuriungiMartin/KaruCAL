#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51522 "Units Lectuer can take"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Units Lectuer can take.rdlc';

    dataset
    {
        dataitem(UnknownTable61565;UnknownTable61565)
        {
            DataItemTableView = sorting(Programme,Stage,Unit,Semester,Lecturer);
            RequestFilterFields = Programme,Stage,Unit;
            column(ReportForNavId_5696; 5696)
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
            column(Lecturers_Qualified_Units_Lecturer;Lecturer)
            {
            }
            column(Lecturers_Qualified_Units_Programme;Programme)
            {
            }
            column(Lecturers_Qualified_Units_Stage;Stage)
            {
            }
            column(Lecturers_Qualified_Units_Unit;Unit)
            {
            }
            column(Emp__First_Name___________Emp__Last_Name_;Emp."First Name" + '  ' + Emp."Last Name")
            {
            }
            column(Lecturers_Units_Can_TakeCaption;Lecturers_Units_Can_TakeCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Lecturers_Qualified_Units_LecturerCaption;FieldCaption(Lecturer))
            {
            }
            column(Lecturers_Qualified_Units_ProgrammeCaption;FieldCaption(Programme))
            {
            }
            column(Lecturers_Qualified_Units_StageCaption;FieldCaption(Stage))
            {
            }
            column(Lecturers_Qualified_Units_UnitCaption;FieldCaption(Unit))
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            column(Lecturers_Qualified_Units_Semester;Semester)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Emp.Get("ACA-Lecturers Qualified Units".Lecturer) then
;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo(Programme);
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
        Emp: Record UnknownRecord61188;
        Lecturers_Units_Can_TakeCaptionLbl: label 'Lecturers Units Can Take';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        NameCaptionLbl: label 'Name';
}

