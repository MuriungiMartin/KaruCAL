#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 8618 "Config. Template Header"
{
    Caption = 'Config. Template Header';
    PageType = ListPlus;
    PopulateAllFields = true;
    SourceTable = "Config. Template Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code of the data template.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the data template.';
                }
                field("Table ID";"Table ID")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the ID of the table on which the data template is based.';
                }
                field("Table Name";"Table Name")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the table on which the data template is based.';
                }
            }
            part(ConfigTemplateSubform;"Config. Template Subform")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Data Template Code"=field(Code);
                SubPageView = sorting("Data Template Code","Line No.")
                              order(ascending);
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
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(CreateInstance)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Create Instance';
                    Image = New;
                    ToolTip = 'Convert your information into records in the database. This is a miniature version of the data migration process and can be useful for prototyping or treating smaller data creation tasks.';

                    trigger OnAction()
                    var
                        ConfigTemplateMgt: Codeunit "Config. Template Management";
                        RecRef: RecordRef;
                    begin
                        if "Table ID" <> 0 then begin
                          RecRef.Open("Table ID");
                          ConfigTemplateMgt.UpdateRecord(Rec,RecRef);
                          ConfirmNewInstance(RecRef);
                        end;
                    end;
                }
            }
        }
    }
}

