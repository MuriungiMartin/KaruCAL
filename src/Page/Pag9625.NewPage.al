#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9625 "New Page"
{
    Caption = 'New Page Setup';
    PageType = NavigatePage;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group("Choose Pattern")
            {
                Caption = 'Choose Pattern';
                Visible = ChoosePatternVisible;
                label("Step 1 of 2: Choose a page style")
                {
                    ApplicationArea = All;
                    Caption = 'Step 1 of 2: Choose a page style';
                }
                label(Control12)
                {
                    ApplicationArea = All;
                    Caption = 'Designing a page is easy. How you want to use your page is just as important as what it looks like. How are you planning to use it?';
                }
                field(PageDesignTemplates;PageDesignTemplates)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                }
                group(Control9)
                {
                    InstructionalText = 'Pick card details for managing or browsing business entities or event details. Items, customers, accounts, service charge details and suppliers are examples of details. This setup wizard will create a card details page, along with a list to manage them.';
                    Visible = PageDesignTemplates = PageDesignTemplates::"Card details";
                }
                group(Control16)
                {
                    InstructionalText = 'A Document page represents a transaction for the business. Document pages are the computerized counterpart to paper-based documents: Invoices, orders, quotes. This setup wizard will create a document page, along with a list to manage them.';
                    Visible = PageDesignTemplates = PageDesignTemplates::"Document";
                }
                group(Control17)
                {
                    InstructionalText = 'Role Center page is an entry homepage for a user or role in your business.  Role Centres  provide information about what to attend to first and prominent actions for initiating the most commonly used tasks.';
                    Visible = PageDesignTemplates = PageDesignTemplates::"Role Center";
                }
                part(Control4;"New Page Patterns List Part")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
            }
            group("Choose Source")
            {
                Caption = 'Choose Source';
                Visible = ChooseSourceVisible;
                label("Step 2 of 2: Pick your data")
                {
                    ApplicationArea = All;
                    Caption = 'Step 2 of 2: Pick your data';
                }
                label("What's the information you want to present on your page?")
                {
                    ApplicationArea = All;
                    Caption = 'What''s the information you want to present on your page?';
                }
                field(SourceTable;SourceTable)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                }
                part(Control6;"Data Source List Part")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Next)
            {
                ApplicationArea = All;
                Caption = 'Next';
                Image = NextRecord;
                InFooterBar = true;
                Visible = NextVisible;

                trigger OnAction()
                begin
                    ChoosePatternVisible := false;
                    NextVisible := false;

                    ChooseSourceVisible := true;
                    PreviousVisible := true;
                    FinishVisible := true;
                end;
            }
            action(Previous)
            {
                ApplicationArea = All;
                Caption = 'Previous';
                Image = PreviousRecord;
                InFooterBar = true;
                Visible = PreviousVisible;

                trigger OnAction()
                begin
                    ChooseSourceVisible := false;
                    PreviousVisible := false;
                    FinishVisible := false;

                    ChoosePatternVisible := true;
                    NextVisible := true;
                end;
            }
            action(Finish)
            {
                ApplicationArea = All;
                Caption = 'Finish';
                Image = Approve;
                InFooterBar = true;
                Visible = FinishVisible;

                trigger OnAction()
                begin
                    // Replace with call to created page when attached to compiler
                    Page.Run(Page::"Customer List");
                    CurrPage.Close;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        ChoosePatternVisible := true;
        NextVisible := true;
    end;

    var
        ChoosePatternVisible: Boolean;
        ChooseSourceVisible: Boolean;
        NextVisible: Boolean;
        PreviousVisible: Boolean;
        FinishVisible: Boolean;
        PageDesignTemplates: Option "Card details",Document,"Role Center";
        SourceTable: Option ,Activity,"Case",Company,Document,"Event",Invitee,"KB Article",Meeting,Opportunity,Partner,Person,Preference,Solution,Task,"User Profile";
}

