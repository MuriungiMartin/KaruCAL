#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51174 "HR Disciplinary Cases"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HR Disciplinary Cases.rdlc';

    dataset
    {
        dataitem(UnknownTable61223;UnknownTable61223)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Case Number","Accused Employee";
            RequestFilterHeading = 'HR Disciplinary Cases';
            column(ReportForNavId_6792; 6792)
            {
            }
            column(CaseNumber_HRDisciplinaryCases;"HRM-Disciplinary Cases (B)"."Case Number")
            {
                IncludeCaption = true;
            }
            column(DateofComplaint_HRDisciplinaryCases;"HRM-Disciplinary Cases (B)"."Date of Complaint")
            {
                IncludeCaption = true;
            }
            column(TypeofDisciplinaryCase_HRDisciplinaryCases;"HRM-Disciplinary Cases (B)"."Type Complaint")
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
            column(Witness1Name_HRDisciplinaryCases;"HRM-Disciplinary Cases (B)"."Witness #1 Name")
            {
                IncludeCaption = true;
            }
            column(Witness2Name_HRDisciplinaryCases;"HRM-Disciplinary Cases (B)"."Witness #2  Name")
            {
                IncludeCaption = true;
            }
            column(DateToDiscussCase_HRDisciplinaryCases;"HRM-Disciplinary Cases (B)"."Date To Discuss Case")
            {
                IncludeCaption = true;
            }
            column(BodyHandlingTheComplaint_HRDisciplinaryCases;"HRM-Disciplinary Cases (B)"."Body Handling The Complaint")
            {
                IncludeCaption = true;
            }
            column(ModeofLodgingtheComplaint_HRDisciplinaryCases;"HRM-Disciplinary Cases (B)"."Mode of Lodging the Complaint")
            {
                IncludeCaption = true;
            }
            column(PolicyGuidlinesInEffect_HRDisciplinaryCases;"HRM-Disciplinary Cases (B)"."Policy Guidlines In Effect")
            {
                IncludeCaption = true;
            }
            column(Status_HRDisciplinaryCases;"HRM-Disciplinary Cases (B)".Status)
            {
                IncludeCaption = true;
            }
            column(DisciplinaryStageStatus_HRDisciplinaryCases;"HRM-Disciplinary Cases (B)"."Disciplinary Stage Status")
            {
                IncludeCaption = true;
            }
            column(RecommendedAction_HRDisciplinaryCases;"HRM-Disciplinary Cases (B)"."Recommended Action")
            {
                IncludeCaption = true;
            }
            column(ActionTaken_HRDisciplinaryCases;"HRM-Disciplinary Cases (B)"."Action Taken")
            {
                IncludeCaption = true;
            }
            column(Recomendations_HRDisciplinaryCases;"HRM-Disciplinary Cases (B)".Recomendations)
            {
                IncludeCaption = true;
            }
            column(Comments_HRDisciplinaryCases;"HRM-Disciplinary Cases (B)".Comments)
            {
                IncludeCaption = true;
            }
            column(EmpNo;HREmp."No.")
            {
                IncludeCaption = true;
            }
            column(EmpFName;HREmp."First Name")
            {
                IncludeCaption = true;
            }
            column(EmpMName;HREmp."Middle Name")
            {
                IncludeCaption = true;
            }
            column(EmpLName;HREmp."Last Name")
            {
                IncludeCaption = true;
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
            dataitem("Approval Entry";"Approval Entry")
            {
                DataItemLink = "Document No."=field("Case Number");
                DataItemTableView = sorting("Table ID","Document Type","Document No.","Sequence No.");
                column(ReportForNavId_1102755023; 1102755023)
                {
                }
                column(Comment_ApprovalEntry;"Approval Entry".Comment)
                {
                    IncludeCaption = true;
                }
                column(ApproverID_ApprovalEntry;"Approval Entry"."Approver ID")
                {
                    IncludeCaption = true;
                }
                column(DateTimeSentforApproval_ApprovalEntry;"Approval Entry"."Date-Time Sent for Approval")
                {
                    IncludeCaption = true;
                }
                column(SenderID_ApprovalEntry;"Approval Entry"."Sender ID")
                {
                    IncludeCaption = true;
                }
                column(LastDateTimeModified_ApprovalEntry;"Approval Entry"."Last Date-Time Modified")
                {
                    IncludeCaption = true;
                }
                column(LastModifiedByID_ApprovalEntry;"Approval Entry"."Last Modified By ID")
                {
                    IncludeCaption = true;
                }
                dataitem("User Setup";"User Setup")
                {
                    DataItemLink = "User ID"=field("Approver ID");
                    DataItemTableView = sorting("User ID") order(ascending);
                    column(ReportForNavId_2; 2)
                    {
                    }
                    column(UserID_UserSetup;"User Setup"."User ID")
                    {
                        IncludeCaption = true;
                    }
                }
            }

            trigger OnAfterGetRecord()
            begin
                                if HREmp.Get("HRM-Disciplinary Cases (B)"."Accused Employee") then
                                EmpName:=HREmp.FullName;
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
                         CI.Get();
                         CI.CalcFields(CI.Picture);
    end;

    var
        CI: Record "Company Information";
        EmpName: Text[40];
        HREmp: Record UnknownRecord61188;
        HR_Disciplinary_CasesCaptionLbl: label 'HR Disciplinary Cases';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Disciplinary_Case_ReportCaptionLbl: label 'Disciplinary Case Report';
        P_O__BoxCaptionLbl: label 'P.O. Box';
        Employee_NameCaptionLbl: label 'Employee Name';
}

