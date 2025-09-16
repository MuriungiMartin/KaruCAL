#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5301 "Outlook Synch. Entity Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Outlook Synch. Entity Element";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Table No.";"Table No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the Microsoft Dynamics NAV table which corresponds to the Outlook item a collection of which is specified in the Outlook Collection field.';
                }
                field("Table Caption";"Table Caption")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the Microsoft Dynamics NAV table to synchronize. The program fills in this field when you specify a table number in the Table No. field.';
                }
                field("Table Relation";"Table Relation")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a filter expression that defines which Microsoft Dynamics NAV entries will be selected for synchronization. It is used to define relations between tables specified in the Table No. fields.';

                    trigger OnAssistEdit()
                    begin
                        CalcFields("Master Table No.");
                        if "Table No." <> 0 then begin
                          if IsNullGuid("Record GUID") then
                            "Record GUID" := CreateGuid;
                          Validate("Table Relation",OSynchSetupMgt.ShowOSynchFiltersForm("Record GUID","Table No.","Master Table No."));
                        end;
                    end;
                }
                field("Outlook Collection";"Outlook Collection")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the Outlook collection that corresponds to the set of Microsoft Dynamics NAV records selected for synchronization in the Table No. field.';
                }
                field("No. of Dependencies";"No. of Dependencies")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of dependent entities which must be synchronized. If these entities are synchronized, the synchronization process is considered to be completed successfully for the current entity. You assign these dependent entities on the Outlook Synch. Dependency table.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("Fields")
                {
                    ApplicationArea = Basic;
                    Caption = 'Fields';
                    Image = OutlookSyncFields;

                    trigger OnAction()
                    begin
                        ShowElementFields;
                    end;
                }
                action(Dependencies)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dependencies';

                    trigger OnAction()
                    begin
                        ShowDependencies;
                    end;
                }
            }
        }
    }

    var
        OSynchSetupMgt: Codeunit "Outlook Synch. Setup Mgt.";
}

