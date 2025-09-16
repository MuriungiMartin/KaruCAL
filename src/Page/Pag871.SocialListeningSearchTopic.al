#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 871 "Social Listening Search Topic"
{
    Caption = 'Social Media Search Topic';
    DataCaptionExpression = GetCaption;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Social Listening Search Topic";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                group(Control5)
                {
                    InstructionalText = 'Create a search topic in Microsoft Social Engagement and paste the search topic ID or URL into the Search Topic ID field.';
                    field(SetupSearchTopicLbl;SetupSearchTopicLbl)
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                        ShowCaption = false;

                        trigger OnDrillDown()
                        begin
                            Hyperlink(SocialListeningMgt.MSLSearchItemsURL);
                        end;
                    }
                }
                field("Search Topic";"Search Topic")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Search Topic ID that refers to the search topic created in Microsoft Social Listening.';
                }
            }
        }
    }

    actions
    {
    }

    var
        SocialListeningMgt: Codeunit "Social Listening Management";
        SetupSearchTopicLbl: label 'Set up search topic.';
}

