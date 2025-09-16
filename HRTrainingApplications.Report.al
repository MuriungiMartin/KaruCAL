#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51139 "HR Training Applications"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HR Training Applications.rdlc';

    dataset
    {
        dataitem(UnknownTable61216;UnknownTable61216)
        {
            DataItemTableView = sorting("Application No");
            RequestFilterFields = "Application No";
            column(ReportForNavId_6373; 6373)
            {
            }
            column(CourseTitle_HRTrainingApplications;"HRM-Training Applications"."Course Title")
            {
                IncludeCaption = true;
            }
            column(FromDate_HRTrainingApplications;"HRM-Training Applications"."From Date")
            {
                IncludeCaption = true;
            }
            column(ToDate_HRTrainingApplications;"HRM-Training Applications"."To Date")
            {
                IncludeCaption = true;
            }
            column(DurationUnits_HRTrainingApplications;"HRM-Training Applications"."Duration Units")
            {
                IncludeCaption = true;
            }
            column(Duration_HRTrainingApplications;"HRM-Training Applications".Duration)
            {
                IncludeCaption = true;
            }
            column(CostOfTraining_HRTrainingApplications;"HRM-Training Applications"."Cost Of Training")
            {
                IncludeCaption = true;
            }
            column(Location_HRTrainingApplications;"HRM-Training Applications".Location)
            {
                IncludeCaption = true;
            }
            column(ApplicationNo_HRTrainingApplications;"HRM-Training Applications"."Application No")
            {
                IncludeCaption = true;
            }
            column(EmployeeNo_HRTrainingApplications;"HRM-Training Applications"."Employee No.")
            {
                IncludeCaption = true;
            }
            column(EmployeeName_HRTrainingApplications;"HRM-Training Applications"."Employee Name")
            {
                IncludeCaption = true;
            }
            column(ApplicationDate_HRTrainingApplications;"HRM-Training Applications"."Application Date")
            {
                IncludeCaption = true;
            }
            column(EmployeeDepartment_HRTrainingApplications;"HRM-Training Applications".Directorate)
            {
                IncludeCaption = true;
            }
            column(Description_HRTrainingApplications;"HRM-Training Applications".Description)
            {
            }
            column(PurposeofTraining_HRTrainingApplications;"HRM-Training Applications"."Purpose of Training")
            {
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
            dataitem("Approval Comment Line";"Approval Comment Line")
            {
                DataItemLink = "Document No."=field("Application No");
                DataItemLinkReference = "HRM-Training Applications";
                DataItemTableView = sorting("Table ID","Document Type","Document No.");
                column(ReportForNavId_8731; 8731)
                {
                }
                column(UserID_ApprovalCommentLine;"Approval Comment Line"."User ID")
                {
                    IncludeCaption = true;
                }
                column(Comment_ApprovalCommentLine;"Approval Comment Line".Comment)
                {
                    IncludeCaption = true;
                }
            }
            dataitem("Approval Entry";"Approval Entry")
            {
                DataItemLink = "Document No."=field("Application No");
                DataItemLinkReference = "HRM-Training Applications";
                DataItemTableView = sorting("Table ID","Document Type","Document No.","Sequence No.");
                column(ReportForNavId_1171; 1171)
                {
                }
                column(SenderID_ApprovalEntry;"Approval Entry"."Sender ID")
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
                dataitem("User Setup";"User Setup")
                {
                    DataItemLink = "User ID"=field("Approver ID");
                    DataItemTableView = sorting("User ID");
                    column(ReportForNavId_7968; 7968)
                    {
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    /*HREmp.RESET;
                    HREmp.SETRANGE(HREmp."User ID","Approval Entry"."Approver ID");
                    IF HREmp.FIND('-') THEN
                    ApproverName:=HREmp.FullName
                    ELSE*/
                    ApproverName:='';

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
        CI: Record "Company Information";
        HREmp: Record UnknownRecord61067;
        ApproverName: Text[30];
        HR_Training_ApplicationsCaptionLbl: label 'HR Training Applications';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        P_O__BoxCaptionLbl: label 'P.O. Box';
        Training_Application_FormCaptionLbl: label 'Training Application Form';
        Name_of_Training_CourseCaptionLbl: label 'Name of Training Course';
        From__Date_CaptionLbl: label 'From (Date)';
        Duration_CaptionLbl: label 'Duration ';
        To__Date_CaptionLbl: label 'To (Date)';
        Cost_of_TrainingCaptionLbl: label 'Cost of Training';
        How_the_Training_Course_Will_Complement_Enhance_my_Skills_in_Relation_to_the_Job_RequirementsCaptionLbl: label 'How the Training Course Will Complement/Enhance my Skills in Relation to the Job Requirements';
        Brief_Description_of_Training_CourseCaptionLbl: label 'Brief Description of Training Course';
        CommentsCaptionLbl: label 'Comments';
        Comments_By_CaptionLbl: label 'Comments By:';
        End_of_CommentsCaptionLbl: label 'End of Comments';
        Approved_ByCaptionLbl: label 'Approved By';
        ApprovalsCaptionLbl: label 'Approvals';
        SignatureCaptionLbl: label 'Signature';
}

