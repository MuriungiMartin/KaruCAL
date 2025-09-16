#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 870 "Social Listening Setup"
{
    ApplicationArea = Basic;
    Caption = 'Social Engagement Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Social Listening Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                group(Control10)
                {
                    InstructionalText = 'If you do not already have a subscription, sign up at Microsoft Social Engagement. After signing up, you will receive a Social Engagement Server URL.';
                    field(SignupLbl;SignupLbl)
                    {
                        ApplicationArea = Basic;
                        DrillDown = true;
                        Editable = false;
                        ShowCaption = false;
                        ToolTip = 'Specifies a link to the sign-up page for Microsoft Social Engagement.';

                        trigger OnDrillDown()
                        begin
                            Hyperlink("Signup URL");
                        end;
                    }
                    field("Social Listening URL";"Social Listening URL")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Social Engagement URL';
                        ToolTip = 'Specifies the URL for the Microsoft Social Engagement subscription.';
                    }
                    field("Solution ID";"Solution ID")
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                        ToolTip = 'Specifies the Solution ID assigned for Microsoft Social Engagement. This field cannot be edited.';
                    }
                }
                group(Control9)
                {
                    InstructionalText = 'I agree to the terms of the applicable Microsoft Social Engagement License or Subscription Agreement.';
                    field(TermsOfUseLbl;TermsOfUseLbl)
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                        ShowCaption = false;
                        ToolTip = 'Specifies a link to the Terms of Use for Microsoft Social Engagement.';

                        trigger OnDrillDown()
                        begin
                            Hyperlink("Terms of Use URL");
                        end;
                    }
                    field("Accept License Agreement";"Accept License Agreement")
                    {
                        ApplicationArea = Basic;
                        ToolTip = 'Specifies acceptance of the license agreement for using Microsoft Social Engagement. This field is mandatory for activating Microsoft Social Engagement.';
                    }
                }
            }
            group("Show Social Media Insights for")
            {
                Caption = 'Show Social Media Insights for';
                field("Show on Items";"Show on Items")
                {
                    ApplicationArea = Basic;
                    Caption = 'Items';
                    ToolTip = 'Specifies whether to enable Microsoft Social Engagement for items. Selecting Show on Items will enable a fact box on the Items list page and on the Item card.';
                }
                field("Show on Customers";"Show on Customers")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customers';
                    ToolTip = 'Specifies whether to enable Microsoft Social Engagement for customers. Selecting Show on Customers will enable a fact box on the Customers list page and on the Customer card.';
                }
                field("Show on Vendors";"Show on Vendors")
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendors';
                    ToolTip = 'Specifies whether to enable Microsoft Social Engagement for vendors. Selecting Show on Vendors will enable a fact box on the Vendors list page and on the Vendor card.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Users)
            {
                ApplicationArea = Basic;
                Caption = 'Users';
                Enabled = "Social Listening URL" <> '';
                Image = Users;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SocialListeningMgt: Codeunit "Social Listening Management";
                begin
                    Hyperlink(SocialListeningMgt.MSLUsersURL);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Codeunit.Run(Codeunit::"Check App. Area Only Basic");

        Reset;
        if not Get then begin
          Init;
          Insert(true);
        end;
    end;

    var
        TermsOfUseLbl: label 'Microsoft Social Engagement Terms of Use';
        SignupLbl: label 'Sign up for Microsoft Social Engagement';
}

