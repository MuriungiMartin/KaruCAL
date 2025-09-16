#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51431 "Appraisal Form"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Appraisal Form.rdlc';

    dataset
    {
        dataitem(UnknownTable61331;UnknownTable61331)
        {
            DataItemTableView = sorting("Employee No","Appraisal Type","Appraisal Period");
            RequestFilterFields = "Employee No","Appraisal Type","Appraisal Period";
            column(ReportForNavId_9714; 9714)
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
            column(Employee_Appraisals__Employee_No_;"Employee No")
            {
            }
            column(Employee_Appraisals__Appraisal_Type_;"Appraisal Type")
            {
            }
            column(Employee_Appraisals__Appraisal_Period_;"Appraisal Period")
            {
            }
            column(Employee_Appraisals__No__Supervised__Directly__;"No. Supervised (Directly)")
            {
            }
            column(Employee_Appraisals__No__Supervised__In_Directly__;"No. Supervised (In-Directly)")
            {
            }
            column(Employee__First_Name__________Employee__Middle_Name__________Employee__Last_Name_;Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name")
            {
            }
            column(Employee__Department_Code_;Employee."Department Code")
            {
            }
            column(Jobs_Grade;Jobs.Grade)
            {
            }
            column(Employee__Job_Title_;Employee."Job Title")
            {
            }
            column(Jobs_Objective;Jobs.Objective)
            {
            }
            column(Jobs__Job_Description_;Jobs."Job Description")
            {
            }
            column(Employee__Date_Of_Join_;Employee."Date Of Join")
            {
            }
            column(Employee_Appraisals__Agreement_With_Rating_;"Agreement With Rating")
            {
            }
            column(Employee_Appraisals__General_Comments_;"General Comments")
            {
            }
            column(Employee_Appraisals_Date;Date)
            {
            }
            column(Employee_AppraisalsCaption;Employee_AppraisalsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Employee_Appraisals__Employee_No_Caption;FieldCaption("Employee No"))
            {
            }
            column(Employee_Appraisals__Appraisal_Type_Caption;FieldCaption("Appraisal Type"))
            {
            }
            column(Employee_Appraisals__Appraisal_Period_Caption;FieldCaption("Appraisal Period"))
            {
            }
            column(Employee_Appraisals__No__Supervised__Directly__Caption;FieldCaption("No. Supervised (Directly)"))
            {
            }
            column(Employee_Appraisals__No__Supervised__In_Directly__Caption;FieldCaption("No. Supervised (In-Directly)"))
            {
            }
            column(NamesCaption;NamesCaptionLbl)
            {
            }
            column(DepartmentCaption;DepartmentCaptionLbl)
            {
            }
            column(Job_TitleCaption;Job_TitleCaptionLbl)
            {
            }
            column(GradeCaption;GradeCaptionLbl)
            {
            }
            column(Position_FunctionCaption;Position_FunctionCaptionLbl)
            {
            }
            column(Date_EmployedCaption;Date_EmployedCaptionLbl)
            {
            }
            column(Job_PositionCaption;Job_PositionCaptionLbl)
            {
            }
            column(Key_ResponsibilitiesCaption;Key_ResponsibilitiesCaptionLbl)
            {
            }
            column(Staff_Member_Review__Part_3___Review_of_Ratings_Assesment_By_Supervisor_Caption;Staff_Member_Review__Part_3___Review_of_Ratings_Assesment_By_Supervisor_CaptionLbl)
            {
            }
            column(Agreement_With_Rating_Caption;Agreement_With_Rating_CaptionLbl)
            {
            }
            column(General_Comments_Caption;General_Comments_CaptionLbl)
            {
            }
            column(Date_Caption;Date_CaptionLbl)
            {
            }
            column(Employee_Appraisals_Job_ID;"Job ID")
            {
            }
            dataitem(UnknownTable61302;UnknownTable61302)
            {
                DataItemLink = "Job ID"=field("Job ID");
                column(ReportForNavId_4601; 4601)
                {
                }
                column(Job_Responsiblities_Responsibility;Responsibility)
                {
                }
                column(EmptyStringCaption;EmptyStringCaptionLbl)
                {
                }
                column(Job_Responsiblities_Job_ID;"Job ID")
                {
                }
            }
            dataitem(UnknownTable61332;UnknownTable61332)
            {
                DataItemLink = "Employee No"=field("Employee No"),"Appraisal Type"=field("Appraisal Type"),"Appraisal Period"=field("Appraisal Period"),"Job ID"=field("Job ID");
                column(ReportForNavId_7277; 7277)
                {
                }
                column(Performance_Plan__Key_Responsibility_;"Key Responsibility")
                {
                }
                column(Performance_Plan__No__;"No.")
                {
                }
                column(Performance_Plan__Key_Indicators_;"Key Indicators")
                {
                }
                column(Performance_Plan__Agreed_Target_Date_;"Agreed Target Date")
                {
                }
                column(Performance_Plan_Weighting;Weighting)
                {
                }
                column(Performance_Plan__Results_Achieved_Comments_;"Results Achieved Comments")
                {
                }
                column(Performance_Plan__Score_Points_;"Score/Points")
                {
                }
                column(Perofrmance_Plan__Part_1___Agreed_Key_indicators_Caption;Perofrmance_Plan__Part_1___Agreed_Key_indicators_CaptionLbl)
                {
                }
                column(Performance_Plan__Key_Responsibility_Caption;FieldCaption("Key Responsibility"))
                {
                }
                column(Performance_Plan__No__Caption;FieldCaption("No."))
                {
                }
                column(Performance_Plan__Key_Indicators_Caption;FieldCaption("Key Indicators"))
                {
                }
                column(Performance_Plan__Agreed_Target_Date_Caption;FieldCaption("Agreed Target Date"))
                {
                }
                column(Performance_Plan_WeightingCaption;FieldCaption(Weighting))
                {
                }
                column(Performance_Plan__Results_Achieved_Comments_Caption;FieldCaption("Results Achieved Comments"))
                {
                }
                column(Score__PointsCaption;Score__PointsCaptionLbl)
                {
                }
                column(Performance_Plan_Employee_No;"Employee No")
                {
                }
                column(Performance_Plan_Appraisal_Type;"Appraisal Type")
                {
                }
                column(Performance_Plan_Appraisal_Period;"Appraisal Period")
                {
                }
                column(Performance_Plan_Job_ID;"Job ID")
                {
                }
            }
            dataitem(UnknownTable61333;UnknownTable61333)
            {
                DataItemLink = "Employee No"=field("Employee No"),"Appraisal Type"=field("Appraisal Type"),"Appraisal Period"=field("Appraisal Period"),"Job ID"=field("Job ID");
                column(ReportForNavId_7755; 7755)
                {
                }
                column(Career_Developement_Plan_Type;Type)
                {
                }
                column(Career_Developement_Plan_Description;Description)
                {
                }
                column(Career_Developement_Plan_Remarks;Remarks)
                {
                }
                column(Career_Development_Plan__Part_2___To_be_extablished_by_both_officer_and_supervisor_Caption;Career_Development_Plan__Part_2___To_be_extablished_by_both_officer_and_supervisor_CaptionLbl)
                {
                }
                column(Career_Developement_Plan_TypeCaption;FieldCaption(Type))
                {
                }
                column(Career_Developement_Plan_DescriptionCaption;FieldCaption(Description))
                {
                }
                column(Career_Developement_Plan_RemarksCaption;FieldCaption(Remarks))
                {
                }
                column(Career_Developement_Plan_Employee_No;"Employee No")
                {
                }
                column(Career_Developement_Plan_Appraisal_Type;"Appraisal Type")
                {
                }
                column(Career_Developement_Plan_Appraisal_Period;"Appraisal Period")
                {
                }
                column(Career_Developement_Plan_Job_ID;"Job ID")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                if Employee.Get("HRM-Employee Appraisals"."Employee No") then
                if Jobs.Get(Employee.Position) then
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
        Employee: Record UnknownRecord61188;
        Jobs: Record UnknownRecord61056;
        Employee_AppraisalsCaptionLbl: label 'Employee Appraisals';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        NamesCaptionLbl: label 'Names';
        DepartmentCaptionLbl: label 'Department';
        Job_TitleCaptionLbl: label 'Job Title';
        GradeCaptionLbl: label 'Grade';
        Position_FunctionCaptionLbl: label 'Position Function';
        Date_EmployedCaptionLbl: label 'Date Employed';
        Job_PositionCaptionLbl: label 'Job Position';
        Key_ResponsibilitiesCaptionLbl: label 'Key Responsibilities';
        Staff_Member_Review__Part_3___Review_of_Ratings_Assesment_By_Supervisor_CaptionLbl: label 'Staff Member Review (Part 3 - Review of Ratings/Assesment By Supervisor)';
        Agreement_With_Rating_CaptionLbl: label 'Agreement With Rating:';
        General_Comments_CaptionLbl: label 'General Comments:';
        Date_CaptionLbl: label 'Date:';
        EmptyStringCaptionLbl: label '-';
        Perofrmance_Plan__Part_1___Agreed_Key_indicators_CaptionLbl: label 'Perofrmance Plan (Part 1 - Agreed Key indicators)';
        Score__PointsCaptionLbl: label 'Score/ Points';
        Career_Development_Plan__Part_2___To_be_extablished_by_both_officer_and_supervisor_CaptionLbl: label 'Career Development Plan (Part 2 - To be extablished by both officer and supervisor)';
}

