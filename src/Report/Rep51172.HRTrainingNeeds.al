#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51172 "HR Training Needs"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HR Training Needs.rdlc';

    dataset
    {
        dataitem(UnknownTable61238;UnknownTable61238)
        {
            RequestFilterFields = "Course Code",Closed,Department;
            column(ReportForNavId_1905; 1905)
            {
            }
            column(Location_HRTrainingNeeds;"HRM-Training Courses".Location)
            {
                IncludeCaption = true;
            }
            column(GlobalDimension2Code_HRTrainingNeeds;"HRM-Training Courses".Department)
            {
                IncludeCaption = true;
            }
            column(Closed_HRTrainingNeeds;"HRM-Training Courses".Closed)
            {
                IncludeCaption = true;
            }
            column(QualificationCode_HRTrainingNeeds;"HRM-Training Courses"."Qualification Code")
            {
                IncludeCaption = true;
            }
            column(QualificationType_HRTrainingNeeds;"HRM-Training Courses"."Qualification Type")
            {
                IncludeCaption = true;
            }
            column(QualificationDescription_HRTrainingNeeds;"HRM-Training Courses"."Qualification Description")
            {
                IncludeCaption = true;
            }
            column(ProviderName_HRTrainingNeeds;"HRM-Training Courses"."Provider Name")
            {
                IncludeCaption = true;
            }
            column(Code_HRTrainingNeeds;"HRM-Training Courses"."Course Code")
            {
                IncludeCaption = true;
            }
            column(StartDate_HRTrainingNeeds;"HRM-Training Courses"."Start Date")
            {
                IncludeCaption = true;
            }
            column(EndDate_HRTrainingNeeds;"HRM-Training Courses"."End Date")
            {
                IncludeCaption = true;
            }
            column(DurationUnits_HRTrainingNeeds;"HRM-Training Courses"."Duration Units")
            {
                IncludeCaption = true;
            }
            column(Duration_HRTrainingNeeds;"HRM-Training Courses".Duration)
            {
                IncludeCaption = true;
            }
            column(CostOfTraining_HRTrainingNeeds;"HRM-Training Courses"."Cost Of Training")
            {
                IncludeCaption = true;
            }
            column(Description_HRTrainingNeeds;"HRM-Training Courses"."Course Tittle")
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

            trigger OnAfterGetRecord()
            begin
                                     Ven.Get("HRM-Training Courses".Provider);
                                     VN:=Ven.Name;
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
        VN: Text[50];
        Ven: Record Vendor;
        HR_Training_NeedsCaptionLbl: label 'HR Training Needs';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Training_NeedsCaptionLbl: label 'Training Needs';
        P_O__BoxCaptionLbl: label 'P.O. Box';
        Name_of_Training_CourseCaptionLbl: label 'Name of Training Course';
        From__Date_CaptionLbl: label 'From (Date)';
        Duration_CaptionLbl: label 'Duration ';
        To__Date_CaptionLbl: label 'To (Date)';
        Cost_of_TrainingCaptionLbl: label 'Cost of Training';
        LocationCaptionLbl: label 'Location';
        ProviderCaptionLbl: label 'Provider';
        Brief_Description_of_Training_CourseCaptionLbl: label 'Brief Description of Training Course';
        Qualifications_to_be_attained_at_the_end_of_the_Training_CourseCaptionLbl: label 'Qualifications to be attained at the end of the Training Course';
}

