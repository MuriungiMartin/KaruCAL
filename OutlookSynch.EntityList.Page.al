#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5302 "Outlook Synch. Entity List"
{
    ApplicationArea = Basic;
    Caption = 'Outlook Synch. Entity List';
    CardPageID = "Outlook Synch. Entity";
    Editable = false;
    PageType = List;
    SourceTable = "Outlook Synch. Entity";
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
                    ToolTip = 'Specifies a unique identifier for each entry in the Outlook Synch. Entity table.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a short description of the synchronization entity that you create.';
                }
                field("Table Caption";"Table Caption")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the Microsoft Dynamics NAV table to synchronize. The program fills in this field every time you specify a table number in the Table No. field.';
                }
                field("Outlook Item";"Outlook Item")
                {
                    ApplicationArea = Basic;
                    Lookup = false;
                    ToolTip = 'Specifies the name of the Outlook item that corresponds to the Microsoft Dynamics NAV table which you specified in the Table No. field.';
                    Visible = false;
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
            group("S&ynch. Entity")
            {
                Caption = 'S&ynch. Entity';
                Image = OutlookSyncFields;
                action("Fields")
                {
                    ApplicationArea = Basic;
                    Caption = 'Fields';
                    Image = OutlookSyncFields;
                    RunObject = Page "Outlook Synch. Fields";
                    RunPageLink = "Synch. Entity Code"=field(Code),
                                  "Element No."=const(0);
                }
                action("Reset to Defaults")
                {
                    ApplicationArea = Basic;
                    Caption = 'Reset to Defaults';
                    Ellipsis = true;
                    Image = Restore;

                    trigger OnAction()
                    var
                        OutlookSynchSetupDefaults: Codeunit "Outlook Synch. Setup Defaults";
                    begin
                        OutlookSynchSetupDefaults.ResetEntity(Code);
                    end;
                }
                action("Register in Change Log &Setup")
                {
                    ApplicationArea = Basic;
                    Caption = 'Register in Change Log &Setup';
                    Ellipsis = true;
                    Image = ImportLog;

                    trigger OnAction()
                    var
                        OSynchEntity: Record "Outlook Synch. Entity";
                    begin
                        OSynchEntity := Rec;
                        OSynchEntity.SetRecfilter;
                        Report.Run(Report::"Outlook Synch. Change Log Set.",true,false,OSynchEntity);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        OutlookSynchSetupDefaults: Codeunit "Outlook Synch. Setup Defaults";
    begin
        OutlookSynchSetupDefaults.InsertOSynchDefaults;
    end;
}

