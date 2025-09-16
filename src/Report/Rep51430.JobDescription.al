#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51430 "Job Description"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Job Description.rdlc';

    dataset
    {
        dataitem(UnknownTable61056;UnknownTable61056)
        {
            DataItemTableView = sorting("Job ID");
            RequestFilterFields = "Job ID";
            column(ReportForNavId_4742; 4742)
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
            column(Company_Jobs__Job_ID_;"Job ID")
            {
            }
            column(Company_Jobs__Job_Description_;"Job Description")
            {
            }
            column(Company_Jobs__Occupied_Position_;"Occupied Position")
            {
            }
            column(Company_Jobs__Vacant_Posistions_;"Vacant Posistions")
            {
            }
            column(Company_Jobs__Dimension_1_;"Dimension 1")
            {
            }
            column(Company_Jobs__No_of_Position_;"No of Position")
            {
            }
            column(Company_Jobs_Objective;Objective)
            {
            }
            column(Company_Jobs__Key_Position_;"Key Position")
            {
            }
            column(Company_Jobs_Category;Category)
            {
            }
            column(Company_Jobs_Grade;Grade)
            {
            }
            column(Job_DescriptionCaption;Job_DescriptionCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Company_Jobs__Job_ID_Caption;FieldCaption("Job ID"))
            {
            }
            column(Company_Jobs__Job_Description_Caption;FieldCaption("Job Description"))
            {
            }
            column(Company_Jobs__Occupied_Position_Caption;FieldCaption("Occupied Position"))
            {
            }
            column(Company_Jobs__Vacant_Posistions_Caption;FieldCaption("Vacant Posistions"))
            {
            }
            column(Company_Jobs__Dimension_1_Caption;FieldCaption("Dimension 1"))
            {
            }
            column(Company_Jobs__No_of_Position_Caption;FieldCaption("No of Position"))
            {
            }
            column(Position_Function_Objective_Caption;Position_Function_Objective_CaptionLbl)
            {
            }
            column(Company_Jobs__Key_Position_Caption;FieldCaption("Key Position"))
            {
            }
            column(Company_Jobs_CategoryCaption;FieldCaption(Category))
            {
            }
            column(Company_Jobs_GradeCaption;FieldCaption(Grade))
            {
            }
            dataitem(UnknownTable61305;UnknownTable61305)
            {
                DataItemLink = "Job ID"=field("Job ID");
                column(ReportForNavId_6537; 6537)
                {
                }
                column(Position_Supervised_Description;Description)
                {
                }
                column(Positions_Supervised_Caption;Positions_Supervised_CaptionLbl)
                {
                }
                column(Position_Supervised_Job_ID;"Job ID")
                {
                }
                column(Position_Supervised_Position_Supervised;"Position Supervised")
                {
                }
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
                column(Key_Responsibilities_Caption;Key_Responsibilities_CaptionLbl)
                {
                }
                column(EmptyStringCaption;EmptyStringCaptionLbl)
                {
                }
                column(Job_Responsiblities_Job_ID;"Job ID")
                {
                }
            }
            dataitem(UnknownTable61059;UnknownTable61059)
            {
                DataItemLink = "Job Id"=field("Job ID");
                DataItemTableView = sorting("Job Id","Qualification Type","Qualification Code") order(ascending);
                column(ReportForNavId_9889; 9889)
                {
                }
                column(Job_Requirement__Qualification_Type_;"Qualification Type")
                {
                }
                column(Job_Requirement_Qualification;Qualification)
                {
                }
                column(Job_Specifications_Caption;Job_Specifications_CaptionLbl)
                {
                }
                column(EmptyStringCaption_Control1000000010;EmptyStringCaption_Control1000000010Lbl)
                {
                }
                column(Job_Requirement_Job_Id;"Job Id")
                {
                }
                column(Job_Requirement_Qualification_Code;"Qualification Code")
                {
                }

                trigger OnPreDataItem()
                begin
                    LastFieldNo := FieldNo("Qualification Type");
                end;
            }
            dataitem(UnknownTable61304;UnknownTable61304)
            {
                DataItemLink = "Job ID"=field("Job ID");
                column(ReportForNavId_2166; 2166)
                {
                }
                column(Job_Working_Relationships_Type;Type)
                {
                }
                column(Job_Working_Relationships_Relationship;Relationship)
                {
                }
                column(Working_Relationships_Caption;Working_Relationships_CaptionLbl)
                {
                }
                column(EmptyStringCaption_Control1000000016;EmptyStringCaption_Control1000000016Lbl)
                {
                }
                column(Job_Working_Relationships_Job_ID;"Job ID")
                {
                }
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

    var
        LastFieldNo: Integer;
        Job_DescriptionCaptionLbl: label 'Job Description';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Position_Function_Objective_CaptionLbl: label 'Position Function/Objective:';
        Positions_Supervised_CaptionLbl: label 'Positions Supervised:';
        Key_Responsibilities_CaptionLbl: label 'Key Responsibilities:';
        EmptyStringCaptionLbl: label '-';
        Job_Specifications_CaptionLbl: label 'Job Specifications:';
        EmptyStringCaption_Control1000000010Lbl: label '-';
        Working_Relationships_CaptionLbl: label 'Working Relationships:';
        EmptyStringCaption_Control1000000016Lbl: label '-';
}

