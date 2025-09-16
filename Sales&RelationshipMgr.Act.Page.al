#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9076 "Sales & Relationship Mgr. Act."
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = "Relationship Mgmt. Cue";

    layout
    {
        area(content)
        {
            cuegroup(Contacts)
            {
                Caption = 'Contacts';
                field("Contacts - Companies";"Contacts - Companies")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDownPageID = "Contact List";
                    ToolTip = 'Specifies contacts assigned to a company.';
                }
                field("Contacts - Persons";"Contacts - Persons")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDownPageID = "Contact List";
                    ToolTip = 'Specifies contact persons.';
                }
            }
            cuegroup(Opportunities)
            {
                Caption = 'Opportunities';
                field("Open Opportunities";"Open Opportunities")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDownPageID = "Opportunity List";
                    ToolTip = 'Specifies open opportunities.';
                }
                field("Opportunities Due in 7 Days";"Opportunities Due in 7 Days")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDownPageID = "Opportunity Entries";
                    Style = Favorable;
                    StyleExpr = true;
                    ToolTip = 'Specifies opportunities with a due date in seven days or more.';
                }
                field("Overdue Opportunities";"Overdue Opportunities")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDownPageID = "Opportunity Entries";
                    Style = Unfavorable;
                    StyleExpr = true;
                    ToolTip = 'Specifies opportunities that have exceeded the due date.';
                }
                field("Closed Opportunities";"Closed Opportunities")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDownPageID = "Opportunity List";
                    ToolTip = 'Specifies opportunities that have been closed.';
                }
            }
            cuegroup(Sales)
            {
                Caption = 'Sales';
                field("Open Sales Quotes";"Open Sales Quotes")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDownPageID = "Sales Quotes";
                    ToolTip = 'Specifies the number of sales quotes that are not yet converted to invoices or orders.';
                }
                field("Open Sales Orders";"Open Sales Orders")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDownPageID = "Sales Order List";
                    ToolTip = 'Specifies the number of sales orders that are not fully posted.';
                }
            }
            cuegroup(New)
            {
                Caption = 'New';
                Visible = IsWebMobile;

                actions
                {
                    action(NewContact)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'New Contact';
                        Image = TileNew;
                        RunObject = Page "Contact Card";
                        RunPageMode = Create;
                        ToolTip = 'Create a new contact.';
                    }
                    action(NewOpportunity)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'New Opportunity';
                        Image = TileNew;
                        RunObject = Page "Opportunity Card";
                        RunPageMode = Create;
                        ToolTip = 'Create a new opportunity.';
                    }
                    action(NewSegment)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'New Segment';
                        Image = TileNew;
                        RunObject = Page Segment;
                        RunPageMode = Create;
                        ToolTip = 'Create a new segment for which you manage interactions and campaigns.';
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Set Up Cues")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Set Up Cues';
                Image = Setup;
                ToolTip = 'Set up the cues (status tiles) related to the role.';

                trigger OnAction()
                var
                    CueSetup: Codeunit "Cues And KPIs";
                    CueRecordRef: RecordRef;
                begin
                    CueRecordRef.GetTable(Rec);
                    CueSetup.OpenCustomizePageForCurrentUser(CueRecordRef.Number);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        IsWebMobile := CurrentClientType in [Clienttype::Web,Clienttype::Tablet,Clienttype::Phone];
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;

        SetFilter("Due Date Filter",'<>%1&%2..%3',0D,WorkDate,WorkDate + 7);
        SetFilter("Overdue Date Filter",'<>%1&..%2',0D,WorkDate - 1);
    end;

    var
        IsWebMobile: Boolean;
}

