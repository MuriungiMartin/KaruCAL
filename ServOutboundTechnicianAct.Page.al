#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9066 "Serv Outbound Technician Act."
{
    Caption = 'Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Service Cue";

    layout
    {
        area(content)
        {
            cuegroup("Outbound Service Orders")
            {
                Caption = 'Outbound Service Orders';
                field("Service Orders - Today";"Service Orders - Today")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Service Orders";
                    ToolTip = 'Specifies the number of in-service orders that are displayed in the Service Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Service Orders - to Follow-up";"Service Orders - to Follow-up")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Service Orders";
                    ToolTip = 'Specifies the number of service orders that have been marked for follow up that are displayed in the Service Cue on the Role Center. The documents are filtered by today''s date.';
                }

                actions
                {
                    action("New Service Order")
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Service Order';
                        Image = Document;
                        RunObject = Page "Service Order";
                        RunPageMode = Create;
                    }
                    action("Service Item Worksheet")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Service Item Worksheet';
                        Image = ServiceItemWorksheet;
                        RunObject = Report "Service Item Worksheet";
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;

        SetRespCenterFilter;
        SetRange("Date Filter",WorkDate,WorkDate);
    end;
}

