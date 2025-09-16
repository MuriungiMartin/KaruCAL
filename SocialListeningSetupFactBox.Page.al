#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 876 "Social Listening Setup FactBox"
{
    Caption = 'Social Media Insights Setup FactBox';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Social Listening Search Topic";

    layout
    {
        area(content)
        {
            field(InfoText;InfoText)
            {
                ApplicationArea = Basic;
                Caption = 'Search Topic';

                trigger OnDrillDown()
                var
                    TempSocialListeningSearchTopic: Record "Social Listening Search Topic" temporary;
                begin
                    TempSocialListeningSearchTopic := Rec;
                    TempSocialListeningSearchTopic.Insert;
                    Page.RunModal(Page::"Social Listening Search Topic",TempSocialListeningSearchTopic);

                    if TempSocialListeningSearchTopic.Find and
                       (TempSocialListeningSearchTopic."Search Topic" <> '')
                    then begin
                      Validate("Search Topic",TempSocialListeningSearchTopic."Search Topic");
                      if not Modify then
                        Insert;
                      CurrPage.Update;
                    end else
                      if Delete then
                        Init;

                    SetInfoText;

                    CurrPage.Update(false);
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetInfoText;
    end;

    var
        InfoText: Text;
        SetupRequiredTxt: label 'Setup is required';

    local procedure SetInfoText()
    begin
        if "Search Topic" = '' then
          InfoText := SetupRequiredTxt
        else
          InfoText := "Search Topic";
    end;
}

