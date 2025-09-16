#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5124 "Opportunity Card"
{
    Caption = 'Opportunity Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Opportunity;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the opportunity.';
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the opportunity.';
                }
                field("Contact No.";"Contact No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = ContactNoEditable;
                    ToolTip = 'Specifies the number of the contact that this opportunity is linked to.';

                    trigger OnValidate()
                    begin
                        ContactNoOnAfterValidate;
                    end;
                }
                field("Contact Name";"Contact Name")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDown = false;
                    Editable = false;
                    ToolTip = 'Specifies the name of the contact to which this opportunity is linked. The program automatically fills in this field when you have entered a number in the No. field.';
                }
                field("Contact Company Name";"Contact Company Name")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDown = false;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the name of the company of the contact person to which this opportunity is linked. The program automatically fills in this field when you have entered a number in the Contact Company No. field.';
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Basic;
                    Editable = SalespersonCodeEditable;
                    ToolTip = 'Specifies the code of the salesperson that is responsible for the opportunity.';
                }
                field("Sales Document Type";"Sales Document Type")
                {
                    ApplicationArea = Basic;
                    Editable = SalesDocumentTypeEditable;
                    Importance = Additional;
                    ToolTip = 'Specifies the type of the sales document (Quote, Order, Posted Invoice). The combination of Sales Document No. and Sales Document Type specifies which sales document is assigned to the opportunity.';
                    ValuesAllowed = " ",Quote;
                }
                field("Sales Document No.";"Sales Document No.")
                {
                    ApplicationArea = Basic;
                    Editable = SalesDocumentNoEditable;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the sales document that has been created for this opportunity.';
                }
                field("Campaign No.";"Campaign No.")
                {
                    ApplicationArea = Basic;
                    Editable = CampaignNoEditable;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the campaign to which this opportunity is linked.';
                }
                field(Priority;Priority)
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = PriorityEditable;
                    Importance = Additional;
                    ToolTip = 'Specifies the priority of the opportunity. There are three options:';
                }
                field("Sales Cycle Code";"Sales Cycle Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = SalesCycleCodeEditable;
                    ToolTip = 'Specifies the code of the sales cycle that the opportunity is linked to.';
                }
                field(Status;Status)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the status of the opportunity. There are four options:';
                }
                field(Closed;Closed)
                {
                    ApplicationArea = RelationshipMgmt;
                    Importance = Additional;
                    ToolTip = 'Specifies that the opportunity is closed.';
                }
                field("Creation Date";"Creation Date")
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the date that the opportunity was created.';
                }
                field("Date Closed";"Date Closed")
                {
                    ApplicationArea = RelationshipMgmt;
                    Importance = Additional;
                    ToolTip = 'Specifies the date the opportunity was closed.';
                }
                field("Segment No.";"Segment No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the segment (if any) that is linked to the opportunity.';
                }
            }
            part(Control25;"Opportunity Subform")
            {
                ApplicationArea = RelationshipMgmt;
                SubPageLink = "Opportunity No."=field("No.");
            }
        }
        area(factboxes)
        {
            part(Control7;"Opportunity Statistics FactBox")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Statistics';
                SubPageLink = "No."=field("No.");
            }
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Oppo&rtunity")
            {
                Caption = 'Oppo&rtunity';
                Image = Opportunity;
                action(Statistics)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Opportunity Statistics";
                    RunPageLink = "No."=field("No.");
                    ShortCutKey = 'F7';
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
                }
                action("Interaction Log E&ntries")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Interaction Log E&ntries';
                    Image = InteractionLog;
                    RunObject = Page "Interaction Log Entries";
                    RunPageLink = "Opportunity No."=field("No.");
                    RunPageView = sorting("Opportunity No.",Date);
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View a list of the interactions that you have logged, for example, when you create an interaction, print a cover sheet, a sales order, and so on.';
                }
                action("Postponed &Interactions")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Postponed &Interactions';
                    Image = PostponedInteractions;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Postponed Interactions";
                    RunPageLink = "Opportunity No."=field("No.");
                    RunPageView = sorting("Opportunity No.",Date);
                    ToolTip = 'View postponed interactions for opportunities.';
                }
                action("T&o-dos")
                {
                    ApplicationArea = Basic;
                    Caption = 'T&o-dos';
                    Image = TaskList;
                    RunObject = Page "Task List";
                    RunPageLink = "Opportunity No."=field("No."),
                                  "System To-do Type"=filter(Organizer);
                    RunPageView = sorting("Opportunity No.");
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Rlshp. Mgt. Comment Sheet";
                    RunPageLink = "Table Name"=const(Opportunity),
                                  "No."=field("No.");
                    ToolTip = 'View or add comments.';
                }
                action("Show Sales Quote")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Show Sales Quote';
                    Image = Quote;
                    ToolTip = 'Show the assigned sales quote.';

                    trigger OnAction()
                    var
                        SalesHeader: Record "Sales Header";
                    begin
                        if ("Sales Document Type" <> "sales document type"::Quote) or
                           ("Sales Document No." = '')
                        then
                          Error(Text001);

                        if SalesHeader.Get(SalesHeader."document type"::Quote,"Sales Document No.") then
                          Page.Run(Page::"Sales Quote",SalesHeader)
                        else
                          Error(Text002,"Sales Document No.");
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Activate the First Stage")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Activate First Stage';
                    Image = "Action";
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    ToolTip = 'Specify if the opportunity is to be activated. The status is set to In Progress.';
                    Visible = not Started;

                    trigger OnAction()
                    begin
                        StartActivateFirstStage;
                    end;
                }
                action(Update)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Update';
                    Image = Refresh;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Update all the actions that are related to your opportunity.';
                    Visible = Started;

                    trigger OnAction()
                    begin
                        UpdateOpportunity;
                    end;
                }
                action(Close)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Close';
                    Image = Close;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Close all the actions that are related to your opportunity.';
                    Visible = Started;

                    trigger OnAction()
                    begin
                        CloseOpportunity;
                    end;
                }
                action("Assign Sales &Quote")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Assign Sales &Quote';
                    Image = Allocate;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Assign a sales quote to an opportunity.';

                    trigger OnAction()
                    begin
                        AssignQuote;
                    end;
                }
                action("Print Details")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Print Details';
                    Image = Print;
                    ToolTip = 'View information about your sales stages, to-dos, and planned to-dos for an opportunity.';

                    trigger OnAction()
                    var
                        Opp: Record Opportunity;
                    begin
                        Opp := Rec;
                        Opp.SetRecfilter;
                        Report.Run(Report::"Opportunity - Details",true,false,Opp);
                    end;
                }
                action("Create &Interaction")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Create &Interaction';
                    Image = CreateInteraction;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Create an interaction with a specified opportunity.';

                    trigger OnAction()
                    var
                        TempSegmentLine: Record "Segment Line" temporary;
                    begin
                        TempSegmentLine.CreateInteractionFromOpp(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateEditable;
    end;

    trigger OnInit()
    begin
        ContactNoEditable := true;
        PriorityEditable := true;
        CampaignNoEditable := true;
        SalespersonCodeEditable := true;
        SalesDocumentTypeEditable := true;
        SalesDocumentNoEditable := true;
        SalesCycleCodeEditable := true;
        Started := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Creation Date" := WorkDate;
        if "Segment No." = '' then
          SetSegmentFromFilter;
        if "Contact No." = '' then
          SetContactFromFilter;
        SetDefaultSalesCycle;
    end;

    trigger OnOpenPage()
    begin
        OppNo := "No.";
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if ("No." <> OppNo) and (Status = Status::"Not Started") then
          StartActivateFirstStage;
    end;

    var
        Text001: label 'There is no sales quote assigned to this opportunity.';
        Text002: label 'Sales quote %1 doesn''t exist.';
        OppNo: Code[20];
        [InDataSet]
        SalesCycleCodeEditable: Boolean;
        [InDataSet]
        SalesDocumentNoEditable: Boolean;
        [InDataSet]
        SalesDocumentTypeEditable: Boolean;
        [InDataSet]
        SalespersonCodeEditable: Boolean;
        [InDataSet]
        CampaignNoEditable: Boolean;
        [InDataSet]
        PriorityEditable: Boolean;
        [InDataSet]
        ContactNoEditable: Boolean;
        Started: Boolean;

    local procedure UpdateEditable()
    begin
        Started := (Status <> Status::"Not Started");
        SalesCycleCodeEditable := Status = Status::"Not Started";
        SalespersonCodeEditable := Status < Status::Won;
        CampaignNoEditable := Status < Status::Won;
        PriorityEditable := Status < Status::Won;
        ContactNoEditable := Status < Status::Won;
        SalesDocumentNoEditable := Status = Status::"In Progress";
        SalesDocumentTypeEditable := Status = Status::"In Progress";
    end;

    local procedure ContactNoOnAfterValidate()
    begin
        CalcFields("Contact Name","Contact Company Name");
    end;
}

