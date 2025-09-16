#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51157 "HR Company Activities"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HR Company Activities.rdlc';

    dataset
    {
        dataitem(UnknownTable61637;UnknownTable61637)
        {
            RequestFilterFields = "Code";
            column(ReportForNavId_7865; 7865)
            {
            }
            column(Code_HRCompanyActivities;"HRM-Company Activities".Code)
            {
                IncludeCaption = true;
            }
            column(Description_HRCompanyActivities;"HRM-Company Activities".Description)
            {
                IncludeCaption = true;
            }
            column(Date_HRCompanyActivities;"HRM-Company Activities".Date)
            {
                IncludeCaption = true;
            }
            column(Venue_HRCompanyActivities;"HRM-Company Activities".Venue)
            {
                IncludeCaption = true;
            }
            column(Costs_HRCompanyActivities;"HRM-Company Activities".Costs)
            {
                IncludeCaption = true;
            }
            column(Posted_HRCompanyActivities;"HRM-Company Activities".Posted)
            {
                IncludeCaption = true;
            }
            column(EmployeeName_HRCompanyActivities;"HRM-Company Activities"."Employee Name")
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
            column(CI_Address2;CI."Address 2" )
            {
                IncludeCaption = true;
            }
            column(CI_PhoneNo;CI."Phone No.")
            {
                IncludeCaption = true;
            }
            column(CI_Picture;CI.Picture)
            {
                IncludeCaption = true;
            }
            column(CI_City;CI.City)
            {
                IncludeCaption = true;
            }
            dataitem(UnknownTable61644;UnknownTable61644)
            {
                DataItemLink = "Document No."=field(Code);
                DataItemTableView = sorting("Approver ID","Document No.") order(ascending);
                column(ReportForNavId_2303; 2303)
                {
                }
                column(Participant_HRActivityParticipants;"HRM-Activity Participants".Participant)
                {
                    IncludeCaption = true;
                }
                column(Notified_HRActivityParticipants;"HRM-Activity Participants".Notified)
                {
                    IncludeCaption = true;
                }
                column(FullName;HREmp."First Name"+' '+HREmp."Middle Name"+' '+HREmp."Last Name")
                {
                }

                trigger OnAfterGetRecord()
                begin
                                                HREmp.Get("HRM-Activity Participants".Participant);
                end;
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

    trigger OnPreReport()
    begin
                               CI.Get();
                               CI.CalcFields(CI.Picture);
    end;

    var
        HREmp: Record UnknownRecord61188;
        CI: Record "Company Information";
        HR_Company_ActivitiesCaptionLbl: label 'HR Company Activities';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Company_Activities_and_ParticipantsCaptionLbl: label 'Company Activities and Participants';
        P_O__BoxCaptionLbl: label 'P.O. Box';
        Activity_Event_DetailsCaptionLbl: label 'Activity/Event Details';
        Date___TimeCaptionLbl: label 'Date & Time';
        Participant_NoCaptionLbl: label 'Participant No';
        NotifiedCaptionLbl: label 'Notified';
        Participant_NameCaptionLbl: label 'Participant Name';
        ParticipantsCaptionLbl: label 'Participants';
}

