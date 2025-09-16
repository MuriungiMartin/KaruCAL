#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69154 "FLT-Daily Work Ticket List"
{
    CardPageID = "FLT-Daily Work Ticket";
    PageType = List;
    SourceTable = UnknownTable61812;
    SourceTableView = where(Status=const(Open));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Ticket No.";"Ticket No.")
                {
                    ApplicationArea = Basic;
                }
                field("Previous W.T. No.";"Previous W.T. No.")
                {
                    ApplicationArea = Basic;
                }
                field("G.K. No.";"G.K. No.")
                {
                    ApplicationArea = Basic;
                }
                field(Make;Make)
                {
                    ApplicationArea = Basic;
                }
                field(Unit;Unit)
                {
                    ApplicationArea = Basic;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field(Station;Station)
                {
                    ApplicationArea = Basic;
                }
                field("Total Milleage";"Total Milleage")
                {
                    ApplicationArea = Basic;
                }
                field("Total Fuel Cost";"Total Fuel Cost")
                {
                    ApplicationArea = Basic;
                }
                field(Ministry;Ministry)
                {
                    ApplicationArea = Basic;
                }
                field(Department;Department)
                {
                    ApplicationArea = Basic;
                }
                field("Department Name";"Department Name")
                {
                    ApplicationArea = Basic;
                }
                field("Total Fuel Consumed";"Total Fuel Consumed")
                {
                    ApplicationArea = Basic;
                }
                field("Oil Consumed";"Oil Consumed")
                {
                    ApplicationArea = Basic;
                }
                field(Month;Month)
                {
                    ApplicationArea = Basic;
                }
                field(Year;Year)
                {
                    ApplicationArea = Basic;
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(WorkTicket)
            {
                ApplicationArea = Basic;
                Caption = 'Preview WT';
                Image = PrintChecklistReport;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin

                     if "Ticket No." = '' then Error('No Record Selected.');

                    ticket.Reset;
                    ticket.SetRange(ticket."Ticket No.","Ticket No.");

                    if ticket.Find('-') then
                    Report.Run(51337,true,true,ticket);
                end;
            }
        }
    }

    var
        ticket: Record UnknownRecord61812;
}

