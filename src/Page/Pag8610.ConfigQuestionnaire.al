#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 8610 "Config. Questionnaire"
{
    ApplicationArea = Basic;
    Caption = 'Config. Questionnaire';
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Excel';
    SourceTable = "Config. Questionnaire";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a code for the configuration questionnaire that you are creating.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the description of the configuration questionnaire. You can provide a name or description of up to 50 characters, numbers, and spaces.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Questionnaire")
            {
                Caption = '&Questionnaire';
                Image = Questionaire;
                action("E&xport to Excel")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'E&xport to Excel';
                    Ellipsis = true;
                    Image = ExportToExcel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Export data in the questionnaire to Excel.';

                    trigger OnAction()
                    begin
                        TestField(Code);

                        FileName := FileMgt.SaveFileDialog(Text002,FileName,'');
                        if FileName = '' then
                          exit;

                        if QuestionnaireMgt.ExportQuestionnaireToExcel(FileName,Rec) then
                          Message(Text000);
                    end;
                }
                action("&Import from Excel")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Import from Excel';
                    Ellipsis = true;
                    Image = ImportExcel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Import information from Excel into the questionnaire.';

                    trigger OnAction()
                    begin
                        FileName := FileMgt.OpenFileDialog(Text002,FileName,'');
                        if FileName = '' then
                          exit;

                        if QuestionnaireMgt.ImportQuestionnaireFromExcel(FileName) then
                          Message(Text001);
                    end;
                }
                separator(Action9)
                {
                }
                action("&Export to XML")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Export to XML';
                    Ellipsis = true;
                    Image = Export;
                    ToolTip = 'Export information in the questionnaire to Excel.';

                    trigger OnAction()
                    begin
                        if QuestionnaireMgt.ExportQuestionnaireAsXML(FileName,Rec) then
                          Message(Text000)
                        else
                          Message(Text003);
                    end;
                }
                action("&Import from XML")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Import from XML';
                    Ellipsis = true;
                    Image = Import;
                    ToolTip = 'Import information from XML into the questionnaire.';

                    trigger OnAction()
                    begin
                        if QuestionnaireMgt.ImportQuestionnaireAsXMLFromClient then
                          Message(Text001);
                    end;
                }
                separator(Action6)
                {
                }
                action("&Update Questionnaire")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Update Questionnaire';
                    Image = Refresh;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    ToolTip = 'Fill the question list based on the fields in the table on which the question area is based.';

                    trigger OnAction()
                    begin
                        if QuestionnaireMgt.UpdateQuestionnaire(Rec) then
                          Message(Text004);
                    end;
                }
                action("&Apply Answers")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Apply Answers';
                    Image = Apply;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Implement answers in the questionnaire in the related setup fields.';

                    trigger OnAction()
                    begin
                        if QuestionnaireMgt.ApplyAnswers(Rec) then
                          Message(Text005);
                    end;
                }
            }
        }
        area(navigation)
        {
            group(Areas)
            {
                Caption = 'Areas';
                action("&Question Areas")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Question Areas';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Config. Question Areas";
                    RunPageLink = "Questionnaire Code"=field(Code);
                    ToolTip = 'View the areas that questions are grouped by.';
                }
            }
        }
    }

    var
        Text000: label 'The questionnaire has been successfully exported.';
        Text001: label 'The questionnaire has been successfully imported.';
        Text002: label 'Save as Excel workbook';
        Text003: label 'The export of the questionnaire has been canceled.';
        QuestionnaireMgt: Codeunit "Questionnaire Management";
        FileMgt: Codeunit "File Management";
        FileName: Text;
        Text004: label 'The questionnaire has been updated.';
        Text005: label 'Answers have been applied.';
}

