#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9057 "Service Dispatcher Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Service Cue";

    layout
    {
        area(content)
        {
            cuegroup("Service Orders")
            {
                Caption = 'Service Orders';
                field("Service Orders - in Process";"Service Orders - in Process")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Service Orders";
                    ToolTip = 'Specifies the number of in process service orders that are displayed in the Service Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Service Orders - Finished";"Service Orders - Finished")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Service Orders";
                    ToolTip = 'Specifies the finished service orders that are displayed in the Service Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Service Orders - Inactive";"Service Orders - Inactive")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Service Orders";
                    ToolTip = 'Specifies the number of inactive service orders that are displayed in the Service Cue on the Role Center. The documents are filtered by today''s date.';
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
                    action("New Service Item")
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Service Item';
                        RunObject = Page "Service Item Card";
                        RunPageMode = Create;
                    }
                    action("Edit Dispatch Board")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Edit Dispatch Board';
                        RunObject = Page "Dispatch Board";
                    }
                    action("Edit Service Tasks")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Edit Service Tasks';
                        RunObject = Page "Service Tasks";
                    }
                }
            }
            cuegroup("Service Quotes")
            {
                Caption = 'Service Quotes';
                field("Open Service Quotes";"Open Service Quotes")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Service Quotes";
                    ToolTip = 'Specifies the number of open service quotes that are displayed in the Service Cue on the Role Center. The documents are filtered by today''s date.';
                }

                actions
                {
                    action("New Service Quote")
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Service Quote';
                        RunObject = Page "Service Quote";
                        RunPageMode = Create;
                    }
                    action(Action17)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Service Order';
                        Image = Document;
                        RunObject = Page "Service Order";
                        RunPageMode = Create;
                    }
                }
            }
            cuegroup("Service Contracts")
            {
                Caption = 'Service Contracts';
                field("Open Service Contract Quotes";"Open Service Contract Quotes")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Service Contract Quotes";
                    ToolTip = 'Specifies the number of open service contract quotes that are displayed in the Service Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Service Contracts to Expire";"Service Contracts to Expire")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Service Contracts";
                    ToolTip = 'Specifies the number of service contracts set to expire that are displayed in the Service Cue on the Role Center. The documents are filtered by today''s date.';
                }

                actions
                {
                    action("New Service Contract Quote")
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Service Contract Quote';
                        RunObject = Page "Service Contract Quote";
                        RunPageMode = Create;
                    }
                    action("New Service Contract")
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Service Contract';
                        RunObject = Page "Service Contract";
                        RunPageMode = Create;
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
        SetRange("Date Filter",0D,WorkDate);
    end;
}

