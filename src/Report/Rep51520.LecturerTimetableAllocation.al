#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51520 "Lecturer Timetable Allocation"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Lecturer Timetable Allocation.rdlc';

    dataset
    {
        dataitem(UnknownTable61541;UnknownTable61541)
        {
            DataItemTableView = sorting(Programme,Stage,Unit,Semester,Lecturer);
            RequestFilterFields = Lecturer,Programme,Stage,Unit;
            column(ReportForNavId_5488; 5488)
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
            column(Lecturers_Units_Lecturer;Lecturer)
            {
            }
            column(Lecturers_Units_Programme;Programme)
            {
            }
            column(Lecturers_Units_Stage;Stage)
            {
            }
            column(Lecturers_Units_Unit;Unit)
            {
            }
            column(Lecturers_Units_Semester;Semester)
            {
            }
            column(Lecturers_Units__Minimum_Contracted_;"Minimum Contracted")
            {
            }
            column(Lecturers_Units__No__Of_Hours_Contracted_;"No. Of Hours Contracted")
            {
            }
            column(Lecturers_Units_Allocation;Allocation)
            {
            }
            column(Emp__First_Name__________Emp__Last_Name_;Emp."First Name" + ' ' + Emp."Last Name")
            {
            }
            column(Lecturers_Units_Time_AllocationCaption;Lecturers_Units_Time_AllocationCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Lecturers_Units_LecturerCaption;FieldCaption(Lecturer))
            {
            }
            column(Lecturers_Units_ProgrammeCaption;FieldCaption(Programme))
            {
            }
            column(Lecturers_Units_StageCaption;FieldCaption(Stage))
            {
            }
            column(Lecturers_Units_UnitCaption;FieldCaption(Unit))
            {
            }
            column(Lecturers_Units_SemesterCaption;FieldCaption(Semester))
            {
            }
            column(Lecturers_Units__Minimum_Contracted_Caption;FieldCaption("Minimum Contracted"))
            {
            }
            column(Lecturers_Units__No__Of_Hours_Contracted_Caption;FieldCaption("No. Of Hours Contracted"))
            {
            }
            column(Lecturers_Units_AllocationCaption;FieldCaption(Allocation))
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Emp.Get("ACA-Lecturers Units - Old".Lecturer) then
;
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
        Emp: Record UnknownRecord61188;
        Lecturers_Units_Time_AllocationCaptionLbl: label 'Lecturers Units Time Allocation';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        NameCaptionLbl: label 'Name';
}

