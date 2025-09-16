#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5105 Teams
{
    ApplicationArea = Basic;
    Caption = 'Teams';
    PageType = List;
    SourceTable = Team;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the team.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the team.';
                }
                field("Next To-do Date";"Next To-do Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date of the next to-do involving the team.';

                    trigger OnDrillDown()
                    var
                        ToDo: Record "To-do";
                    begin
                        ToDo.SetCurrentkey("Team Code",Date,Closed);
                        ToDo.SetRange("Team Code",Code);
                        ToDo.SetRange(Closed,false);
                        ToDo.SetRange("System To-do Type",ToDo."system to-do type"::Team);
                        if ToDo.FindFirst then
                          Page.Run(0,ToDo);
                    end;
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
        area(navigation)
        {
            group("&Team")
            {
                Caption = '&Team';
                Image = SalesPurchaseTeam;
                action("T&o-dos")
                {
                    ApplicationArea = Basic;
                    Caption = 'T&o-dos';
                    Image = TaskList;
                    RunObject = Page "Task List";
                    RunPageLink = "Team Code"=field(Code),
                                  "System To-do Type"=filter(Team);
                    RunPageView = sorting("Team Code");
                }
                action(Salespeople)
                {
                    ApplicationArea = Basic;
                    Caption = 'Salespeople';
                    Image = ExportSalesPerson;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Team Salespeople";
                    RunPageLink = "Team Code"=field(Code);
                    ToolTip = 'View a list of salespeople within the team.';
                }
            }
        }
        area(reporting)
        {
            action("Team To-dos")
            {
                ApplicationArea = Basic;
                Caption = 'Team To-dos';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Team - Tasks";
            }
            action("Salesperson - To-dos")
            {
                ApplicationArea = Basic;
                Caption = 'Salesperson - To-dos';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Salesperson - Tasks";
            }
            action("Salesperson - Opportunities")
            {
                ApplicationArea = Basic;
                Caption = 'Salesperson - Opportunities';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Salesperson - Opportunities";
                ToolTip = 'View information about the opportunities handled by one or several salespeople.';
            }
        }
    }
}

