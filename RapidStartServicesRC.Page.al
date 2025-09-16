#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9021 "RapidStart Services RC"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control2)
            {
                part(Control3;"RapidStart Services Activities")
                {
                    Caption = 'Activities';
                }
                part(Control8;"Config. Areas")
                {
                    Caption = 'Configuration Areas';
                    SubPageView = sorting("Vertical Sorting");
                }
            }
            group(Control5)
            {
                systempart(Control10;MyNotes)
                {
                }
                systempart(Control14;Links)
                {
                }
            }
        }
    }

    actions
    {
        area(embedding)
        {
            group("RapidStart Services")
            {
                Caption = 'RapidStart Services';
                action(Worksheet)
                {
                    ApplicationArea = Basic;
                    Caption = 'Worksheet';
                    RunObject = Page "Config. Worksheet";
                }
                action(Packages)
                {
                    ApplicationArea = Basic;
                    Caption = 'Packages';
                    RunObject = Page "Config. Packages";
                }
                action(Tables)
                {
                    ApplicationArea = Basic;
                    Caption = 'Tables';
                    RunObject = Page "Config. Tables";
                }
                action(Questionnaires)
                {
                    ApplicationArea = Basic;
                    Caption = 'Questionnaires';
                    RunObject = Page "Config. Questionnaire";
                }
                action(Templates)
                {
                    ApplicationArea = Basic;
                    Caption = 'Templates';
                    RunObject = Page "Config. Template List";
                }
            }
        }
        area(processing)
        {
            group("Actions")
            {
                Caption = 'Actions';
                action("RapidStart Services Wizard")
                {
                    ApplicationArea = Basic;
                    Caption = 'RapidStart Services Wizard';
                    Image = Questionaire;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Config. Wizard";
                }
                action(ConfigurationWorksheet)
                {
                    ApplicationArea = Basic;
                    Caption = 'Configuration Worksheet';
                    Ellipsis = true;
                    Image = SetupLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Config. Worksheet";
                }
                action("Complete Setup")
                {
                    ApplicationArea = Basic;
                    Caption = 'Complete Setup';
                    Image = Completed;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Configuration Completion";
                }
            }
        }
    }
}

