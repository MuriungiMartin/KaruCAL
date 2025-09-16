#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5300 "Outlook Synch. Entity"
{
    Caption = 'Outlook Synch. Entity';
    PageType = ListPlus;
    SourceTable = "Outlook Synch. Entity";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
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
                field("Table No.";"Table No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the Microsoft Dynamics NAV table that is to be synchronized with an Outlook item.';

                    trigger OnValidate()
                    begin
                        TableNoOnAfterValidate;
                    end;
                }
                field("Table Caption";"Table Caption")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the Microsoft Dynamics NAV table to synchronize. The program fills in this field every time you specify a table number in the Table No. field.';
                }
                field(Condition;Condition)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the criteria for defining a set of specific entries to use in the synchronization process. This filter is applied to the table you specified in the Table No. field. For this filter type, you will only be able to define Microsoft Dynamics NAV filters of the types CONST and FILTER.';

                    trigger OnAssistEdit()
                    begin
                        Condition := CopyStr(OSynchSetupMgt.ShowOSynchFiltersForm("Record GUID","Table No.",0),1,MaxStrLen(Condition));
                    end;
                }
                field("Outlook Item";"Outlook Item")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the Outlook item that corresponds to the Microsoft Dynamics NAV table which you specified in the Table No. field.';

                    trigger OnValidate()
                    begin
                        OutlookItemOnAfterValidate;
                    end;
                }
            }
            part(SynchEntityElements;"Outlook Synch. Entity Subform")
            {
                SubPageLink = "Synch. Entity Code"=field(Code);
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

                    trigger OnAction()
                    begin
                        ShowEntityFields;
                    end;
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

    var
        OSynchSetupMgt: Codeunit "Outlook Synch. Setup Mgt.";

    local procedure TableNoOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure OutlookItemOnAfterValidate()
    begin
        CurrPage.Update;
    end;
}

