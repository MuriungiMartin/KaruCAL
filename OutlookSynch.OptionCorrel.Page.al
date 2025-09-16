#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5307 "Outlook Synch. Option Correl."
{
    AutoSplitKey = true;
    Caption = 'Outlook Synch. Option Correl.';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Outlook Synch. Option Correl.";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Outlook Value";"Outlook Value")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Outlook property.';
                }
                field(GetFieldValue;GetFieldValue)
                {
                    ApplicationArea = Basic;
                    Caption = 'Field Value';
                    Lookup = true;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        OutlookSynchSetupMgt: Codeunit "Outlook Synch. Setup Mgt.";
                        LookupRecRef: RecordRef;
                        LookupFieldRef: FieldRef;
                        OptionID: Integer;
                    begin
                        LookupRecRef.Open("Table No.",true);
                        LookupFieldRef := LookupRecRef.Field("Field No.");

                        OptionID := OutlookSynchSetupMgt.ShowOptionsLookup(LookupFieldRef.OptionCaption);

                        if OptionID > 0 then
                          Validate("Option No.",OptionID - 1);

                        LookupRecRef.Close;
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
    }
}

