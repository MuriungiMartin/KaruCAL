#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51189 "HR Disciplinary Cases List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HR Disciplinary Cases List.rdlc';

    dataset
    {
        dataitem(UnknownTable61223;UnknownTable61223)
        {
            PrintOnlyIfDetail = false;
            RequestFilterFields = "Case Number",Accuser,"Type Complaint","Date of Complaint",Status;
            RequestFilterHeading = 'HR Disciplinary Cases';
            column(ReportForNavId_1102755000; 1102755000)
            {
            }
            column(CaseNumber_HRDisciplinaryCases;"HRM-Disciplinary Cases (B)"."Case Number")
            {
                IncludeCaption = true;
            }
            column(CaseDescription_HRDisciplinaryCases;"HRM-Disciplinary Cases (B)"."Description of Complaint")
            {
                IncludeCaption = true;
            }
            column(AccuserName_HRDisciplinaryCases;"HRM-Disciplinary Cases (B)"."Accuser Name")
            {
                IncludeCaption = true;
            }
            column(AccusedEmployeeName_HRDisciplinaryCases;"HRM-Disciplinary Cases (B)"."Accused Employee Name")
            {
                IncludeCaption = true;
            }
            column(ActionTaken_HRDisciplinaryCases;"HRM-Disciplinary Cases (B)"."Action Taken")
            {
                IncludeCaption = true;
            }
            column(DateofComplaint_HRDisciplinaryCases;"HRM-Disciplinary Cases (B)"."Date of Complaint")
            {
            }
            column(DisciplinaryStageStatus_HRDisciplinaryCases;"HRM-Disciplinary Cases (B)"."Disciplinary Stage Status")
            {
            }
            column(Num;Num)
            {
            }
            column(CI_Picture;CI.Picture)
            {
                IncludeCaption = true;
            }
            column(CI_Name;CI.Name)
            {
                IncludeCaption = true;
            }
            column(CI_Address;CI.Address)
            {
                IncludeCaption = true;
            }
            column(CI_Address2;CI."Address 2")
            {
                IncludeCaption = true;
            }
            column(CI_City;CI.City)
            {
                IncludeCaption = true;
            }
            column(CI_PhoneNo;CI."Phone No.")
            {
                IncludeCaption = true;
            }
            column(Picture;CI.Picture)
            {
            }
            column(ClosedBy;"HRM-Disciplinary Cases (B)"."Closed By")
            {
            }

            trigger OnAfterGetRecord()
            begin
                Num:=Num+1;
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

    trigger OnPreReport()
    begin
        CI.Reset;
        CI.Get;
        CI.CalcFields(CI.Picture);
    end;

    var
        Num: Integer;
        CI: Record "Company Information";
}

