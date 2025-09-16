#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5066 "Questionnaire - Handouts"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Questionnaire - Handouts.rdlc';
    Caption = 'Questionnaire - Handouts';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Profile Questionnaire Header";"Profile Questionnaire Header")
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code","Contact Type","Business Relation Code";
            column(ReportForNavId_1883; 1883)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(Profile_Questionnaire_Header__TABLECAPTION__________QuestionnaireFilter;TableCaption + ': ' + QuestionnaireFilter)
            {
            }
            column(PrintClassificationFields;PrintClassificationFields)
            {
            }
            column(Profile_Questionnaire_Header_Description;Description)
            {
            }
            column(Profile_Questionnaire_Header_Code;Code)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Questionnaire___HandoutsCaption;Questionnaire___HandoutsCaptionLbl)
            {
            }
            column(Including_Classification_QuestionsCaption;Including_Classification_QuestionsCaptionLbl)
            {
            }
            dataitem("Profile Questionnaire Line";"Profile Questionnaire Line")
            {
                DataItemLink = "Profile Questionnaire Code"=field(Code);
                DataItemTableView = sorting("Profile Questionnaire Code","Line No.");
                column(ReportForNavId_4858; 4858)
                {
                }
                column(Profile_Questionnaire_Line_Description;Description)
                {
                }
                column(Filter1;(Type = Type::Question) and ("Multiple Answers" = true))
                {
                }
                column(Filter2;(Type = Type::Question) and ("Multiple Answers" = true) and ("Auto Contact Classification" = false))
                {
                }
                column(Filter3;(Type = Type::Question) and ("Multiple Answers" = false))
                {
                }
                column(Filter4;(Type = Type::Question) and ("Multiple Answers" = false) and ("Auto Contact Classification" = false))
                {
                }
                column(Profile_Questionnaire_Line_Description_Control13;Description)
                {
                }
                column(Filter5;Type = Type::Answer)
                {
                }
                column(Filter6;(Type = Type::Answer) and not ClassificationQuestion)
                {
                }
                column(Profile_Questionnaire_Line_Description_Control13Caption;FieldCaption(Description))
                {
                }
                column(AnswerCaption;AnswerCaptionLbl)
                {
                }
                column(Number_of_AnswersCaption;Number_of_AnswersCaptionLbl)
                {
                }
                column(MultipleCaption;MultipleCaptionLbl)
                {
                }
                column(One_onlyCaption;One_onlyCaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Type = Type::Question then
                      ClassificationQuestion := ("Auto Contact Classification" = true);
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintClassificationFields;PrintClassificationFields)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Print Classification Fields ';
                        ToolTip = 'Specifies if you also want the report to include the questions that are answered automatically.';
                    }
                }
            }
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
        QuestionnaireFilter := "Profile Questionnaire Header".GetFilters;
    end;

    var
        QuestionnaireFilter: Text;
        PrintClassificationFields: Boolean;
        ClassificationQuestion: Boolean;
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Questionnaire___HandoutsCaptionLbl: label 'Questionnaire - Handouts';
        Including_Classification_QuestionsCaptionLbl: label 'Including Classification Questions';
        AnswerCaptionLbl: label 'Answer';
        Number_of_AnswersCaptionLbl: label 'Number of Answers';
        MultipleCaptionLbl: label 'Multiple';
        One_onlyCaptionLbl: label 'One only';


    procedure InitializeRequest(PrintClassificationFrom: Boolean)
    begin
        PrintClassificationFields := PrintClassificationFrom;
    end;
}

